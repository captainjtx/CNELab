#include <math.h>
#include <matrix.h>
#include <mex.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <iostream>

using namespace std;

void mexFunction(int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
{
    /* Check for proper number of arguments */
    
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
        nb=max(bdim[0],bdim[1]);
    }
    
    const mwSize* adim = mxGetDimensions(a);
    mwSize adim_n= mxGetNumberOfDimensions(a);
    
    
    if (adim_n != 2) {
        mexErrMsgIdAndTxt("MATLAB:FastFilter:nargin",
                "Wrong dimension of a");
    } 
    else
    {
        na=max(adim[0],adim[1]);
        
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
    
    
    mxArray *ib;
    mxArray *ia;
    
    int padding=0;
    for (int ichan=0; ichan<chan; ichan++) {
        ib = mxGetCell(b,ichan);
        ia = mxGetCell(a,ichan);
        
        const int* ib_dim=mxGetDimensions(ib);
        int ib_n=max(ib_dim[0],ib_dim[1]);
        
        const int* ia_dim=mxGetDimensions(ia);
        int ia_n=max(ia_dim[0],ia_dim[1]);
        
        padding=max(padding,ib_n);
        padding=max(padding,ia_n);
    }
//     cout<<x_padding<<" "<<y_padding;
    
    double* y=(double*) mxCalloc(sample+2*padding,sizeof(double));
    double* ry=(double*) mxCalloc(sample+2*padding,sizeof(double));
    double* x=(double*) mxCalloc(sample+padding,sizeof(double));
    

    for (int ichan=0; ichan<chan; ++ichan) {
        
        
        for(int k=padding;k<sample+padding;++k)
        {
            x[k]=data[ichan*sample+k-padding];
        }
        //symmetric extend
        for(int k=0;k<padding;++k)
        {
            x[k]=x[2*padding-1-k];
        }
        
        for(int k=0;k<sample+2*padding;++k)
        {
            y[k]=0;
        }
        
        ib = mxGetCell(b,ichan);
        ia = mxGetCell(a,ichan);
        
        double* ib_e=mxGetPr(ib);
        double* ia_e=mxGetPr(ia);
        
        const int* ib_dim=mxGetDimensions(ib);
        int ib_n=max(ib_dim[0],ib_dim[1]);
        
        const int* ia_dim=mxGetDimensions(ia);
        int ia_n=max(ia_dim[0],ia_dim[1]);
        
        
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
        
        //symmetric extend
        for(int k=0;k<padding;++k)
        {
            ry[k]=ry[2*padding-1-k];
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
    return;
}
