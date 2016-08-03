//filter parameters
class FilterParameter{
public:
    double* b;
    double* a;
    //lenght of b and a
    int nb;
    int na;
public:
    FilterParameter(int bn,int an) : b(new double[bn]), a(new double[an]), nb(bn), na(an)
    {}
    FilterParameter(int bn,int an, double* x, double* y) : b(new double[bn]), a(new double[an]), nb(bn), na(an)
    {
        for(int i=0;i<na;++i)
        {
            a[i]=y[i];
        }
        for(int i=0;i<nb;++i)
        {
            b[i]=x[i];
        }
    }
    ~FilterParameter()
    {
        delete[] b;
        delete[] a;
        b=NULL;
        a=NULL;
    }
};
