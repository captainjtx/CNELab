#include <mex.h>
#include <iostream>
#include <list>
#include "FilterParameter.h"

#include <pthread.h>
using namespace std;

#include "tools.h"

//global variable
pthread_mutex_t chan_mutex;
// pthread_mutex_t cout_mutex;

pthread_attr_t attr;

const mxArray *b;
const mxArray *a;

unsigned int threadNum;

list<FilterParameter*>* filterConfig;

void *threadfunc(void *arg) {
    void **args=(void **) arg;
    
    double* data=(double*)args[0];
    int sample=*((int* )args[1]);
    int padding=*((int* )args[2]);
    int* chancount=(int*)args[3];
    
    int chan=*((int* )args[4]);
    
    double* output=(double*)args[5];
    
    double* y=new double [sample+2*padding];
    double* ry=new double [sample+2*padding];
    double* x=new double [sample+padding];

    int ichan;
    
    int ib_n;
    int ia_n;
    double* ia_e;
    double* ib_e;
    
    pthread_mutex_lock(&chan_mutex);
    ichan=++(*chancount);//atomic
    pthread_mutex_unlock(&chan_mutex);
    
    while(ichan<chan)
    {
//         pthread_mutex_lock(&cout_mutex);
//         cout<<"Cmpute "<<ichan<<endl;
//         pthread_mutex_unlock(&cout_mutex);
        
        for(int k=0;k<padding;++k)
        {
            x[k]=0;
        }
        for(int k=padding;k<sample+padding;++k)
        {
            x[k]=data[ichan*sample+k-padding];
        }
        
        for(list<FilterParameter*>::iterator it=filterConfig[ichan].begin();it!=filterConfig[ichan].end();++it)
        {
//             pthread_mutex_lock(&cout_mutex);
//             cout<<"Iterate "<<ichan<<endl;
//             pthread_mutex_unlock(&cout_mutex);
            
            ia_e=(*it)->a;
            ib_e=(*it)->b;
            ia_n=(*it)->na;
            ib_n=(*it)->nb;
            
            for(int k=0;k<sample+2*padding;++k)
            {
                y[k]=0;
            }
            
//             pthread_mutex_lock(&cout_mutex);
//             cout<<"Filter forward chan: "<<ichan<<endl;
//             pthread_mutex_unlock(&cout_mutex);
            
            //filter forward
            for (int j=padding;j<sample+padding;++j)
            {
                for(int m=0;m<ib_n;++m)
                {
                    y[j]+=ib_e[m]*x[j-m];
                }
                for(int m=1;m<ia_n;++m)
                {
                    y[j]-=ia_e[m]*y[j-m];
                }
                y[j]/=ia_e[0];
            }
            
//             pthread_mutex_lock(&cout_mutex);
//             cout<<"Filter backward chan: "<<ichan<<endl;
//             pthread_mutex_unlock(&cout_mutex);
            
            //filter backward
            for(int k=0;k<sample+2*padding;++k)
            {
                ry[k]=y[sample+2*padding-1-k];
            }
            
            for(int k=0;k<sample+2*padding;++k)
            {
                y[k]=0;
            }
            
            for (int j=padding;j<sample+padding;++j)
            {
                for(int m=0;m<ib_n;++m)
                {
                    y[j]+=ib_e[m]*ry[j-m];
                }
                for(int m=1;m<ia_n;++m)
                {
                    y[j]-=ia_e[m]*y[j-m];
                }
                y[j]/=ia_e[0];
            }
            
//             pthread_mutex_lock(&cout_mutex);
//             cout<<"Copy chan: "<<ichan<<endl;
//             pthread_mutex_unlock(&cout_mutex);
            
            for(int k=0;k<padding;++k)
            {
                x[k]=0;
            }
            for(int k=padding;k<sample+padding;++k)
            {
                x[k]=y[sample+2*padding-1-k];
            }
        }
        
        for (int j=padding;j<sample+padding;++j)
        {
            output[ichan*sample+j-padding]=y[sample+2*padding-1-j];
        }
        
//         pthread_mutex_lock(&cout_mutex);
//         cout<<"Next chan: "<<ichan<<endl;
//         pthread_mutex_unlock(&cout_mutex);
            
        pthread_mutex_lock(&chan_mutex);
        ichan=++(*chancount);//atomic
        pthread_mutex_unlock(&chan_mutex);
    }
    delete[] y;
    delete[] ry;
    delete[] x;
    
//     pthread_mutex_lock(&cout_mutex);
//     cout<<"Thread complete"<<endl;
//     pthread_mutex_unlock(&cout_mutex);
    
    pthread_exit( NULL );
}

void mexFunction(int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
{
    try
    {
        //the optimal thread number is cpu core number
        threadNum=getNumberOfCores();
    }
    catch (int e)
    {
        //if can not determine core number, using default 8
        threadNum=8;
    }
    
    double* output;
    double* data;
    int nb;
    int na;
    int chan;
    int sample;
    int padding=0;
    void *args[6];
    int chancount[1];
    
    mxArray *ib;
    mxArray *ib_f;
    mxArray *ia;
    mxArray *ia_f;
    int ib_n;
    int ia_n;
    
    pthread_t threads[threadNum];
    pthread_mutex_init(&chan_mutex,NULL);
//     pthread_mutex_init(&cout_mutex,NULL);
    
    pthread_attr_init(&attr);
    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
    
    void* status;
    
    if (nrhs != 3) {
        mexErrMsgIdAndTxt("MATLAB:Filter:nargin",
                "Requires three input arguments.");
    } else if (nlhs != 1) {
        mexErrMsgIdAndTxt("MATLAB:Filter:nargout",
                "Requires one output argument.");
    }
    
    b = prhs[0];
    a = prhs[1];
    data=mxGetPr(prhs[2]);
    
    const mwSize* bdim = mxGetDimensions(b);
    mwSize bdim_n= mxGetNumberOfDimensions(b);
    
    if (bdim_n != 2) {
        mexErrMsgIdAndTxt("MATLAB:Filter:nargin",
                "Wrong dimension of b");
    }
    else
    {
        nb=MAX(bdim[0],bdim[1]);
    }
    
    const mwSize* adim = mxGetDimensions(a);
    mwSize adim_n= mxGetNumberOfDimensions(a);
    
    
    if (adim_n != 2) {
        mexErrMsgIdAndTxt("MATLAB:Filter:nargin",
                "Wrong dimension of a");
    }
    else
    {
        na=MAX(adim[0],adim[1]);
        
    }
    
    const mwSize* datadim = mxGetDimensions(prhs[2]);
    mwSize datadim_n=mxGetNumberOfDimensions(prhs[2]);
    
    if (datadim_n != 2) {
        mexErrMsgIdAndTxt("MATLAB:Filter:nargin",
                "Wrong dimension of data");
    }
    else
    {
        chan=datadim[1];
        sample=datadim[0];
    }
    
    
    if (na!=nb||na!=chan||nb!=chan)
    {
        mexErrMsgIdAndTxt("MATLAB:Filter:nargin",
                "Unequal number of channels between b,a and size(data,2)");
    }
    else
    {
        plhs[0]=mxCreateDoubleMatrix(sample,chan,mxREAL);
        output=mxGetPr(plhs[0]);
    }
    //mxGetCell cannot be accessed inside thread in windows, maybe not threadsafe
    //So we define our own data structure...
    //Every list contains a series of filters
    
    filterConfig=new list<FilterParameter*>[chan];
    
    //initialize output with input data
//     for(int i=0;i<chan*sample;++i)
//     {
//         output[i]=data[i];
//     }
    
    for(int i=0;i<chan;++i)
    {
        ib= mxGetCell(b,i);
        ia= mxGetCell(a,i);
        
        const mwSize* tmp = mxGetDimensions(ib);
        int fnum=MAX(tmp[0],tmp[1]);
        
//         cout<<fnum<<" filters in chan "<<i<<endl;
        for(int f=0;f<fnum;++f)
        {
            ib_f=mxGetCell(ib,f);
            ia_f=mxGetCell(ia,f);
            
            const int* ib_dim=mxGetDimensions(ib_f);
            ib_n=MAX(ib_dim[0],ib_dim[1]);
            
            const int* ia_dim=mxGetDimensions(ia_f);
            ia_n=MAX(ia_dim[0],ia_dim[1]);
            
            FilterParameter* new_fp=new FilterParameter(ib_n,ia_n,mxGetPr(ib_f),mxGetPr(ia_f));
            
            filterConfig[i].push_back(new_fp);
            
            padding=MAX(padding,ib_n);
            padding=MAX(padding,ia_n);
        }
    }
//     cout<<x_padding<<" "<<y_padding;
    *chancount=-1;
    
    for (int i=0;i<threadNum;++i)
    {
        args[0]=data;
        args[1]=&sample;
        args[2]=&padding;
        args[3]=chancount;
        args[4]=&chan;
        args[5]=output;
        
        int rc = pthread_create(&threads[i],&attr,threadfunc,args);
        if (rc)
        {
            mexErrMsgIdAndTxt("MATLAB:Filter:pthread_create",
                    "Unable to create thread");
            return;
        }
    }
    
    pthread_attr_destroy(&attr);
    
    /* Wait on the other threads */
    for(int i=0; i<threadNum; i++)
    {
        pthread_join(threads[i], &status);
    }
    
    //Strangly block the function from return.
    //pthread_exit(NULL);
//     cout<<"Desctruction of threads"<<endl;
    
    pthread_mutex_destroy(&chan_mutex);
//     pthread_mutex_destroy(&cout_mutex);
    
//     cout<<"Desctruction of filterConfig"<<endl;
    //desctruction of filterConfig
    for(int i=0;i<chan;++i)
    {
        for (list<FilterParameter*>::iterator it=filterConfig[i].begin(); it!=filterConfig[i].end();++it)
        {
            delete *it;
//             filterConfig[i].erase(it);
        }
        filterConfig[i].clear();
    }
    delete[] filterConfig;
    return;
}
