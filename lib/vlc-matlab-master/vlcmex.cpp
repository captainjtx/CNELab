#include "vlcmex.h"

bool check_args(int nrhs, int m, int n)
{
    if (nrhs > n) {
        mexErrMsgIdAndTxt(("VLC:"
                           + string(mexFunctionName())
                           + ":tooManyArgs").c_str(),
                          "Too many arguments: %d for %d", nrhs, n);
        return false;
    } else if (nrhs < m) {
        mexErrMsgIdAndTxt(("VLC:"
                           + string(mexFunctionName())
                           + ":tooFewArgs").c_str(),
                          "Not enough arguments: %d for %d", nrhs, m);
        return false;
    }
    return true;
}

bool check_args(int nrhs, int n)
{
    return check_args(nrhs, n, n);
}

string arr2str(const mxArray *arr)
{
    if (mxGetM(arr) != 1) {
        mexErrMsgIdAndTxt(("VLC:"
                           + string(mexFunctionName())
                           + ":inputWrongShape").c_str(), 
                          "Input string must be a row vector.");
        return "";
    }

    char *str = (char*)mxCalloc(mxGetN(arr)+1, sizeof(char));
    if (mxGetString(arr, str, mxGetN(arr)+1)) {
        mexWarnMsgIdAndTxt(("VLC:"
                           + string(mexFunctionName())
                           + ":stringError").c_str(),
                          "Error extracting filename argument.");
    }
    string s = str;
    mxFree(str);
    return s;
}

void* unpack_pointer_INTERNAL(const mxArray *arr)
{
    return *((void**)(mxGetPr(arr)));
}

void pack_pointer_INTERNAL(mxArray **arr, void *p)
{
    *arr = mxCreateDoubleMatrix(1, 1, mxREAL);
    *((void**)(mxGetPr(*arr))) = p;
}

void pack_number_INTERNAL(mxArray **arr, double d)
{
    *arr = mxCreateDoubleMatrix(1, 1, mxREAL);
    mxGetPr(*arr)[0] = d;
}

void pack_number_INTERNAL(mxArray **arr, vector<double> vd)
{
    *arr = mxCreateDoubleMatrix(1, vd.size(), mxREAL);
    for (int i = 0; i < vd.size(); ++i) {
        mxGetPr(*arr)[i] = vd[i];
    }
}

