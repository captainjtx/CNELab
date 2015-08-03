order=3;
fs=2000;
for i=1:19
    f=50*i;
    [b,a]=butter(order,[f-2,f+2]/(fs/2),'stop');
    iir(i).a=a;
    iir(i).b=b;
    iir(i).desc=['IIR_Notch_50_Harmonics_2000Hz_' num2str(f-2) '_' num2str(f+2)];
end