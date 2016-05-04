fig=figure('position',[100,100,600,400]);
axes(fig,'units','normalized','position',[0.12,0.15,0.75,0.75])
H={};
%%
obj=bsp.SpatialMapWin;

col={'b','r'};
freq={};
freq{1}=[8,32];
freq{2}=[60,200];

f=1;

erdchan=obj.erd_chan;
erschan=obj.ers_chan;
for k=1
    %k th event
    tf=obj.tfmat(k);
    
    fi=(tf.f>=freq{f}(1))&(tf.f<=freq{f}(2));
    
    pow_curve=[];
    
    if f==1
        ch=find(erdchan{k});
    else
        ch=find(erschan{k});
    end
    
%     ch=1:length(tf.trial_mat);
    for t=1:size(tf.data,3)
        %t th trial
        pow_val=[];
        for i=1:length(ch)
            %i th channel
            event_mat=tf.trial_mat{ch(i)};
            
            val=mean(event_mat{t}(fi,:),1);
            pow_val=cat(1,pow_val,val);
        end
%         for ti=1:size(pow_val,2)
%             mean_val(ti)=mean(pow_val(pow_val(:,ti)>1,ti));
%         end
        pow_curve=cat(1,pow_curve,mean(pow_val,1));
        
    end
        
    hold on;
    figure(fig)
    
    H{f}=shadedErrorBar(tf.t*1000,10*log10(mean(pow_curve,1)),std(10*log10(pow_curve),0,1),col{f},1);
    set(H{f}.mainLine,'linewidth',3);
end
%%
axis tight
ylim([-10,10])
a=gca;
a.FontSize=20;

hold on

plot(a.XLim,[0,0],'--k','linewidth',3);
ylabel('dB')
xlabel('Time (ms)')
plot([0,0],a.YLim,':k','linewidth',3);

grid on

ylabel('ERD/ERS (dB)');
set(gcf,'color','white');

text(50,8.5,'Onset','FontSize',20)

title('S2 Close')
%%
%add finger positions
hold on
trial=Close;
yyaxis right
a.YColor=[0,0,0];

fdata=squeeze(mean(trial.data(:,ismember(trial.channame,{'Finger 2','Finger 3','Finger 4','Finger 5'}),:),2));

fdata=fdata-mean(mean(fdata(1:400,:)));

% for i=1:size(fdata,2)
%     fdata(:,i)=fdata(:,i)-mean(fdata(1:400,i));
% end

try
    delete(finger.mainLine)
    delete(finger.patch)
    delete(finger.edge)
catch
end

finger=shadedErrorBar(linspace(-1500,1500,size(fdata,1)),mean(fdata,2),std(fdata,0,2),{'-','Color',[0.4660,0.6740,0.1880]},1);
set(finger.mainLine,'linewidth',3);

% ylabel('Finger (mV)','rot',-90)
xlim([-1250,1250])

legend([H{2}.mainLine,H{1}.mainLine,finger.mainLine],'HFB ERS','LFB ERD','Finger','Location','northwest');

% t=uicontrol('parent',fig,'style','text','string','S1 Close','units','normalized','position',[0.4,0.9,0.2,0.1],'fontsize',20,'background','w');
% uistack(t,'bottom');