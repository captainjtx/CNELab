#include <mex.h>
#include <iostream>
#include <windows.h>
#include <list>
#include "FilterParameter.h"
using namespace std;

#include "tools.h"

HANDLE chanMutex;

list<FilterParameter*>* filterConfig;

DWORD WINAPI threadfunc(void *arg) {
    void **args=(void **) arg;

    int sample=*((int* )args[0]);
    int padding=*((int* )args[1]);
    int* chancount=(int*)args[2];
    int chan=*((int* )args[3]);
    double* output=(double*)args[4];
    
    double* y=new double[sample+2*padding];
    double* ry=new double [sample+2*padding];
    double* x=new double [sample+padding];
    
    int ichan;
   
    int ib_n;
    int ia_n;
    double* ia_e;
    double* ib_e;
    
    DWORD dwWaitResult;
    
    dwWaitResult = WaitForSingleObject(
            chanMutex,    // handle to mutex
            INFINITE);  // no time-out interval
    switch (dwWaitResult)
    {
        // The thread got ownership of the mutex
        case WAIT_OBJECT_0:
            __try {
                ichan=++(*chancount);
            }
            
            __finally {
                // Release ownership of the mutex object
                if (! ReleaseMutex(chanMutex))
                {
                    // Handle error.
                }
            }
            break;
            // The thread got ownership of an abandoned mutex
            // The database is in an indeterminate state
        case WAIT_ABANDONED:
            return 1;
    }
    while ( ichan<chan )
    {   
        for(list<FilterParameter*>::iterator it=filterConfig[ichan].begin();it!=filterConfig[ichan].end();++it)
        {
            ia_e=(*it)->a;
            ib_e=(*it)->b;
            ia_n=(*it)->na;
            ib_n=(*it)->nb;
            
            memset(x,0,sizeof(double)*padding);
            
            memcpy(x+padding,output+ichan*sample,sizeof(double)*sample);
            
            memset(y,0,sizeof(double)*(sample+2*padding));
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
            //filter backward
            for(int k=0;k<sample+2*padding;++k)
            {
                ry[k]=y[sample+2*padding-1-k];
            }
            
            memset(y,0,sizeof(double)*(sample+2*padding));
            
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
            for (int j=padding;j<sample+padding;++j)
            {
                output[ichan*sample+j-padding]=y[sample+2*padding-1-j];
            }
        }
        
        dwWaitResult = WaitForSingleObject(
                chanMutex,    // handle to mutex
                INFINITE);  // no time-out interval
        switch (dwWaitResult)
        {
            // The thread got ownership of the mutex
            case WAIT_OBJECT_0:
                __try {
                    ichan=++(*chancount);
                }
                
                __finally {
                    // Release ownership of the mutex object
                    if (! ReleaseMutex(chanMutex))
                    {
                        // Handle error.
                    }
                }
                break;
                // The thread got ownership of an abandoned mutex
                // The database is in an indeterminate state
            case WAIT_ABANDONED:
                return 1;
        }
    }
    delete[] y;
    delete[] ry;
    delete[] x;
//     printf("Thread Complete \n");
    return 0;
}

void mexFunction(int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
{
    mxArray *ib;
    mxArray *ia;
    mxArray* ib_f;
    mxArray* ia_f;
    size_t ib_n;
    size_t ia_n;
    void *args[6];
    int chancount[1];
    
    size_t padding=0;
    
    int threadNum=8;
    double* data;
    
    size_t nb;
    size_t na;
    
    const mxArray* b;
    const mxArray* a;
    try
    {
        //the optimal thread number is cpu core number
        threadNum=getNumberOfCores();
//         printf("Number of Cores Found\n");
    }
    catch (int e)
    {
        //if can not determine core number, using default 8
        threadNum=8;
//         printf("Number of Cores not found\n");
    }
    
//     printf("Number of thread: %d\n",threadNum);
    
    
    HANDLE* hThread=new HANDLE[threadNum];
    DWORD* threadID=new DWORD[threadNum];
    
    chanMutex = CreateMutex(
            NULL,              // default security attributes
            FALSE,             // initially not owned
            NULL);             // unnamed mutex

//     cout<<"Mutex created !"<<endl;
    if (nrhs != 3) {
        mexErrMsgIdAndTxt("MATLAB:FastFilter:nargin",
                "FastFilter requires three input arguments.");
    } else if (nlhs != 1) {
        mexErrMsgIdAndTxt("MATLAB:mexcpp:nargout",
                "FastFilter requires one output argument.");
    }
    
    b = prhs[0];
    a = prhs[1];
    data=mxGetPr(prhs[2]);
    
    const mwSize* bdim = mxGetDimensions(b);
    mwSize bdim_n= mxGetNumberOfDimensions(b);
    
    if (bdim_n != 2) {
        mexErrMsgIdAndTxt("MATLAB:FastFilter:nargin",
                "Wrong dimension of b");
    }
    else
    {
        nb=MAX(bdim[0],bdim[1]);
    }
    
    const mwSize* adim = mxGetDimensions(a);
    mwSize adim_n= mxGetNumberOfDimensions(a);
    
    
    if (adim_n != 2) {
        mexErrMsgIdAndTxt("MATLAB:FastFilter:nargin",
                "Wrong dimension of a");
    }
    else
    {
        na=MAX(adim[0],adim[1]);
        
    }
    
    int chan;
    int sample;
    const mwSize* datadim = mxGetDimensions(prhs[2]);
    mwSize datadim_n=mxGetNumberOfDimensions(prhs[2]);
    
    if (datadim_n != 2) {
        mexErrMsgIdAndTxt("MATLAB:FastFilter:nargin",
                "Wrong dimension of data");
    }
    else
    {
        chan=datadim[1];
        sample=datadim[0];
    }
    
    
    double* output;
    if (na!=nb||na!=chan||nb!=chan)
    {
        mexErrMsgIdAndTxt("MATLAB:FastFilter:nargin",
                "Unequal number of channels between b,a and size(data,2)");
    }
    else
    {
        plhs[0]=mxCreateDoubleMatrix(sample,chan,mxREAL);
        output=mxGetPr(plhs[0]);
    }
    
    //mxGetCell cannot be accessed inside thread in windows, maybe not threadsafe
    //So we define our own data structure...
//     printf("New List\n");
    filterConfig=new list<FilterParameter*>[chan];
    FilterParameter* new_fp;
    //initialize output with input data
    memcpy(output,data,sizeof(double)*chan*sample);
    for(int i=0;i<chan;++i)
    {
        ib= mxGetCell(b,i);
        ia= mxGetCell(a,i);
        
        const mwSize* tmp = mxGetDimensions(ib);
        size_t fnum=MAX(tmp[0],tmp[1]);
        
//         cout<<fnum<<" filters in chan "<<i<<endl;
        for(int f=0;f<fnum;++f)
        {
            ib_f=mxGetCell(ib,f);
            ia_f=mxGetCell(ia,f);
            
            const size_t* ib_dim=mxGetDimensions(ib_f);
            ib_n=MAX(ib_dim[0],ib_dim[1]);
            
            const size_t* ia_dim=mxGetDimensions(ia_f);
            ia_n=MAX(ia_dim[0],ia_dim[1]);
            
            new_fp=new FilterParameter(ib_n,ia_n,mxGetPr(ib_f),mxGetPr(ia_f));
            
            filterConfig[i].push_back(new_fp);
            
            padding=MAX(padding,ib_n);
            padding=MAX(padding,ia_n);
        }
    }

    *chancount=-1;
    
    for (int i=0;i<threadNum;++i)
    {
        args[0]=&sample;
        args[1]=&padding;
        args[2]=chancount;
        args[3]=&chan;
        args[4]=output;
        
        hThread[i] = CreateThread( NULL, 0, threadfunc, args, 0, &threadID[i] );
//         printf("create thread \n");
    }
    WaitForMultipleObjects(threadNum,hThread,TRUE,INFINITE);
    
    for(int i=0;i<threadNum;++i)
    {
        CloseHandle(hThread[i]);
    }
    CloseHandle(chanMutex);
    delete[] hThread;
    delete[] threadID;
    
//     printf("destroy filterConfig\n");
    for(int i=0;i<chan;++i)
    {
//         printf("Delete Chan %d\n",i);
        for (list<FilterParameter*>::iterator it=filterConfig[i].begin(); it!=filterConfig[i].end();++it)
        {
//             printf("Delete it\n");
            delete *it;
//             filterConfig[i].erase(it);
        }
        filterConfig[i].clear();
    }
//     printf("filterConfig destroied\n");
    delete[] filterConfig;
//     printf("filterConfig deleted\n");
    return;
}
