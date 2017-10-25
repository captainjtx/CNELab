fig=figure('position',[100,100,600,400]);
axes(fig,'units','normalized','position',[0.12,0.15,0.75,0.75])
H=[];
%%
obj=bsp.TFMapWin;

col={'b','r'};
freq={};
freq{1}=[8,32];
freq{2}=[60,200];

for f=1:length(freq)
    fi=(obj.tfmat_f>=freq{f}(1))&(obj.tfmat_f<=freq{f}(2));
    
    pow_curve=[];
    
    %     ch=1:length(tf.trial_mat);
    pow_val=[];
    for i=1:length(obj.tfmat)
        val=mean(10.^(obj.tfmat{i}(fi,:)/10),1);
        pow_val=cat(1,pow_val,val);
    end
    %         for ti=1:size(pow_val,2)
    %             mean_val(ti)=mean(pow_val(pow_val(:,ti)>1,ti));
    %         end
    pow_curve=cat(1,pow_curve,mean(pow_val,1));
    
    hold on;
    figure(fig)
    
    H(f)=plot(obj.tfmat_t*1000,10*log10(mean(pow_curve,1)),'Color',col{f},'LineWidth',7);
end
%%
axis tight
ylim([-12,12])
a=gca;
a.FontSize=20;

hold on

plot(a.XLim,[0,0],'--k','linewidth',5);
% ylabel('dB')
% xlabel('Time (ms)')
plot([0,0],a.YLim,':k','linewidth',5);

grid on

% ylabel('ERD/ERS (dB)');
set(gcf,'color','white');

% text(50,8.5,'Onset','FontSize',20)

%%
%add finger positions
hold on

yyaxis right
a.YColor=[0,0,0];

trial= Squeeze;
fdata=squeeze(trial.data(:,ismember(trial.channame,{'Force'}), :));

fdata=fdata-mean(mean(fdata(1:400,:)));% change to fdata(end-400:end, :) for offset

% for i=1:size(fdata,2)
%     fdata(:,i)=fdata(:,i)-mean(fdata(1:400,i));
% end

finger=plot(linspace(-1500,1500,size(fdata,1)),mean(fdata, 2),'Color',[0.5,0.8,0.1],'linestyle',':');
set(finger,'linewidth',5);

% ylabel('Finger (mV)','rot',-90)
xlim([min(obj.tfmat_t*1000),max(obj.tfmat_t*1000)])
a.FontSize=26;
a.FontWeight='bold';
a.LineWidth=5;
% ylim([-30,30])
% t=uicontrol('parent',fig,'style','text','string','S1 Close','units','normalized','position',[0.4,0.9,0.2,0.1],'fontsize',20,'background','w');
% uistack(t,'bottom');