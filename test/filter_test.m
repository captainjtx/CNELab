clc
b={{1,1},{1,1},{1,1},{1,1}};
a={{1,2},{1,2},{1,2},{1,2}};
data=rand(100000,4);
fdata=UnixMultiThreadedFilter(b,a,data);
