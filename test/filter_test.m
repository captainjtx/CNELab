clc
b={{1,1},{1,1},{1,1},{1,1}};
a={{1,2},{1,2},{1,2},{1,2}};
data=rand(1000,4);
fdata=WinMultiThreadedFilter(b,a,data);
