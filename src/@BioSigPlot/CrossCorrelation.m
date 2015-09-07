function CrossCorrelation(obj,src)

[data,channame,dataset,channel,sample,~,~,~]=get_selected_data(obj);

if length(channel)~=2
    errordlg('Must select two channels !');
    return
end

figure('Name',['xcorr( ',channame{1},' , ',channame{2},' )']);

switch src
    case obj.MenuCrossCorrRaw
        
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
        [r,lag]=xcorr(data(:,1),data(:,2),'coef');
        
        lag=lag/obj.SRate*1000;%ms
        
        plot(lag,r);
        axis tight
        xlabel('Lag (ms)');
        
        title('Cross Correlation Coefficient');
        
    case obj.MenuCrossCorrEnv
        
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
        
        
        [r,lag]=xcorr(detrend(env1),detrend(env2),'coef');
        
        lag=lag/obj.SRate*1000;%ms
        
        plot(lag,r);
        
%         skew=skewness(r);   
        weight_mean=lag*r/sum(r);
        
        hold on
        
        plot([weight_mean,weight_mean],[0,1],'-.r');
        
        axis tight
        xlabel('Lag (ms)');
        title(['Cross Correlation Coefficient']);
end

end

