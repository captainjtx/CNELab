#include <math.h>
#include <matrix.h>
#include <mex.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <iostream>
#include <process.h>
#include <windows.h>

using namespace std;

#ifdef _WIN32
#include <windows.h>
#elif MACOS
#include <sys/param.h>
#include <sys/sysctl.h>
#else
#include <unistd.h>
#endif
 
int getNumberOfCores() {
#ifdef WIN32
    SYSTEM_INFO sysinfo;
    GetSystemInfo(&sysinfo);
    return sysinfo.dwNumberOfProcessors;
#elif MACOS
    int nm[2];
    size_t len = 4;
    uint32_t count;
 
    nm[0] = CTL_HW; nm[1] = HW_AVAILCPU;
    sysctl(nm, 2, &count, &len, NULL, 0);
 
    if(count < 1) {
    nm[1] = HW_NCPU;
    sysctl(nm, 2, &count, &len, NULL, 0);
    if(count < 1) { count = 1; }
    }
    return count;
#else
    return sysconf(_SC_NPROCESSORS_ONLN);
#endif
}

#define MIN(a, b) (((a) < (b)) ? (a) : (b))
#define MAX(a, b) (((a) > (b)) ? (a) : (b))


const mxArray* b;
const mxArray* a;
HANDLE chanMutex; 

unsigned __stdcall threadfunc(void *arg) {
    void **args=(void **) arg;
    
    double* data=(double*)args[0];
    int sample=*((int* )args[1]);
    int padding=*((int* )args[2]);
    int* chancount=(int*)args[3];
    int chan=*((int* )args[4]);
    double* output=(double*)args[5];
    
    double* y=(double*) mxCalloc(sample+2*padding,sizeof(double));
    double* ry=(double*) mxCalloc(sample+2*padding,sizeof(double));
    double* x=(double*) mxCalloc(sample+padding,sizeof(double));
    
    int ichan;
   
    int ib_n;
    int ia_n;
            
    DWORD dwWaitResult;
    ichan=++(*chancount);
    
    while ( ichan<chan )
    {
//         dwWaitResult = WaitForSingleObject(
//                 chanMutex,    // handle to mutex
//                 INFINITE);  // no time-out interval
//          switch (dwWaitResult) 
//         {
//             // The thread got ownership of the mutex
//             case WAIT_OBJECT_0: 
//                 __try { 
//                     ichan=++(*chancount);
//                 } 
// 
//                 __finally { 
//                     // Release ownership of the mutex object
//                     if (! ReleaseMutex(chanMutex)) 
//                     { 
//                         // Handle error.
//                     } 
//                 } 
//                 break; 
//             // The thread got ownership of an abandoned mutex
//             // The database is in an indeterminate state
//             case WAIT_ABANDONED: 
//                 return 1; 
//         }
        ichan=++(*chancount);
        
        cout<<"Channel "<<ichan<<endl;
        for(int k=padding;k<sample+padding;++k)
        {
            x[k]=data[ichan*sample+k-padding];
        }
        
        for(int k=0;k<sample+2*padding;++k)
        {
            y[k]=0;
        }
        
        mxArray* ib = mxGetCell(b,ichan);
        mxArray* ia = mxGetCell(a,ichan);
        
        double* ib_e=mxGetPr(ib);
        double* ia_e=mxGetPr(ia);
        
        const int* ib_dim=mxGetDimensions(ib);
        ib_n=MAX(ib_dim[0],ib_dim[1]);
        
        const int* ia_dim=mxGetDimensions(ia);
        ia_n=MAX(ia_dim[0],ia_dim[1]);
        
        
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
        for(int k=0;k<sample+padding;++k)
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
        
        for (int j=padding;j<sample+padding;++j)
        {
            output[ichan*sample+j-padding]=y[sample+2*padding-1-j];
        }
    }
    mxFree(y);
    mxFree(ry);
    mxFree(x);
    _endthreadex( 0 );
    return 0;
}

void mexFunction(int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
{
    mxArray *ib;
    mxArray *ia;
    
    void *args[6];
    int chancount[1];
    
    int padding=0;
    
    int threadNum;
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
    
    cout<<"number of core: "<<threadNum<<endl;
    
    HANDLE* hThread=new HANDLE[threadNum];
    unsigned* threadID=new unsigned[threadNum];
    
    chanMutex = CreateMutex(
            NULL,              // default security attributes
            FALSE,             // initially not owned
            NULL);             // unnamed mutex

    cout<<"Mutex created !"<<endl;
    if (nrhs != 3) {
        mexErrMsgIdAndTxt("MATLAB:FastFilter:nargin",
                "FastFilter requires three input arguments.");
    } else if (nlhs != 1) {
        mexErrMsgIdAndTxt("MATLAB:mexcpp:nargout",
                "FastFilter requires one output argument.");
    }
    const mxArray *b;
    const mxArray *a;
    double* data;
    
    b = prhs[0];
    a = prhs[1];
    data=mxGetPr(prhs[2]);
    
    int nb;
    int na;
    
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
    
    for (int ichan=0; ichan<chan; ichan++) {
        ib = mxGetCell(b,ichan);
        ia = mxGetCell(a,ichan);
        
        const int* ib_dim=mxGetDimensions(ib);
        int ib_n=MAX(ib_dim[0],ib_dim[1]);
        
        const int* ia_dim=mxGetDimensions(ia);
        int ia_n=MAX(ia_dim[0],ia_dim[1]);
        
        padding=MAX(padding,ib_n);
        padding=MAX(padding,ia_n);
    }

    *chancount=-1;
    
    for (int i=0;i<threadNum;++i)
    {
        args[0]=data;
        args[1]=&sample;
        args[2]=&padding;
        args[3]=chancount;
        args[4]=&chan;
        args[5]=output;
        
        hThread[i] = (HANDLE)_beginthreadex( NULL, 0, &threadfunc, args, 0, &threadID[i] );
        cout<<"create thread "<<i<<endl;
    }
    for(int i=0;i<threadNum;i++) {
        WaitForSingleObject( hThread[i], INFINITE );
        CloseHandle( hThread[i] );
        cout<<"thread wait"<<i<<endl;
    }
    CloseHandle(chanMutex);
    delete[] hThread;
    delete[] threadID;
    
    return;
}
