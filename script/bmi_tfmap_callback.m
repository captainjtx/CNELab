function bmi_tfmap_callback(data,WndIx,Ch,fs)
%[b,a]=butter(2,[16]/fs*2,'high');
[tf,t,f]=stft(data(WndIx(1):WndIx(2),Ch),256,fs,128,1,0);
figure;
imagesc(t,f,20*log10(tf+eps),[-25 5]);
axis xy;



end

