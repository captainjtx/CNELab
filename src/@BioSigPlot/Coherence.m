function Coherence(obj,src)

[data,channame,dataset,channel,sample,~,~,~]=get_selected_data(obj);

if length(channel)~=2
    errordlg('Must select two channels !');
    return
end

figure('Name',['mscohere( ',channame{1},' , ',channame{2},' )']);

window=hamming(round(obj.SRate/2)); %default to divide into 8 subsections
noverlap=round(obj.SRate/4);
nfft=[];
fs=obj.SRate;

switch src
    case obj.MenuCohereRaw
        
        t=sample/obj.SRate;%ms
        
        subplot(3,1,1)
        plot(t,data(:,1));
        axis tight
        xlabel('Time (s)');
        title(channame{1})
        
        subplot(3,1,2)
        plot(t,data(:,2));
        axis tight
        xlabel('Time (s)');
        title(channame{2})
        
        subplot(3,1,3)
        
        [Cxy,F] = mscohere(data(:,1),data(:,2),window,noverlap,nfft,fs);
        
        plot(F,Cxy);
        
        ylim([0,1]);
      
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');
        
        title('Coherence');
        
    case obj.MenuCohereEnv
        
        t=sample/obj.SRate;%ms
        
        subplot(3,1,1)
        env1=abs(hilbert(data(:,1)));
        plot(t,data(:,1));
        hold on
        plot(t,[-1;1]*env1','r','LineWidth',2)
        axis tight
        xlabel('Time (s)');
        title(channame{1})
        
        subplot(3,1,2)
        env2=abs(hilbert(data(:,2)));
        plot(t,data(:,2));
        hold on
        plot(t,[-1;1]*env2','r','LineWidth',2)
        axis tight
        xlabel('Time (s)');
        title(channame{2})
        
        subplot(3,1,3)
        
        [Cxy,F] = mscohere(env1,env2,window,noverlap,nfft,fs);
        
        plot(F,Cxy);
        
        axis tight
        
        ylim([0,1]);
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');
        
        title('Coherence');
end

end

