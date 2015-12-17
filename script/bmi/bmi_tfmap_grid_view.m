clc
clear

%user defined region=======================================================
%get segments seconds before onset and after onset
% Hand open close
% SBefore=2;
% SAfter=2;
% TMin=0;

% Finger
SBefore=1;
SAfter=1.5;
TMin=0;

%Abduction
% SBefore=1.5;
% SAfter=1.5;
% TMin=1;
%Rest
% SBefore=0;
% SAfter=30;
% TMin=0;

%exclude bad\syn\noisy channels if any
%var channels stores clean channel index

%Yaqiang Sun
% badChannels={'ECG Bipolar','EMG Bipolar','Synch'};
% Li Ma
%badChannels for Handopenclose
badChannels={'C27','C64','C75','C76','C100','ECG Bipolar','EMG Bipolar','Synch','Bipolar ECG','Bipolar EMG','Trigger'};
grid_id=120;
%badChannels for AbductionAdduction
% badChannels={'ECG Bipolar','EMG Bipolar','Synch','C126','C127','C128'};
% badChannels={'Trigger','Acceleration X','Acceleration Y', 'Acceleration Z','Roll','Pitch'};

%Xu Yun
% badChannels={'C37','C3','C4','C5','C15','C16','C2','C27','C28','C6',...
%     'ECG Bipolar','EMG Bipolar','Synch','C41','C10','C11','C78','C9'};

% badChannels={'ECG Bipolar','Bipolar ECG','Sound','Synch','EMG Bipolar','Bipolar EMG','C126','C127','C128','EMG+','EMG-','ECG+','ECG-'...
%     'C37','C2','C3','C4','C5','C6','C10','C11','C15','C16','C29','C41','C78'};
% grid_id=120;

%113 Channel, Turkey*******************************************************
%S1
% badChannels={'Bipolar ECG','Bipolar EMG','Ref',...
%              'C20_L','C21_L','C22_L','C26_L','C28_L','C27_L','C29_L','C30_L','C31_L','C32_L','C33_L',...
%              'C44_L','C47_L','C48_L','C51_L','C57_L'};
%  grid_id=113;

%S2
% badChannels={'Bipolar ECG','Bipolar EMG','Ref',...
%              'C18_L','C20_L','C41_L','C42_L','C49_L','C50_L','C57_L','C58_L','C59_L',...
%              'C65_S','C93_S','C94_S','C100_S','C107_S','C113_S','C101_S','C108_S'};
%==========================================================================
%movemnt type
% Hand open close
movements={'Open','Close'};
rest_start={};
rest_end={};

% Finger

% movements={'F1','F2','F3'};
% rest_start='Rest start';
% rest_end='Rest end';


%Abduction
% movements={'Abd','Add'};
% rest_start={};
% rest_end={};

% movements={'Close'};
% rest_start={};
% rest_end={};

% movements={'Wrist'};
% movements={'Abd'};
% movements={'Add'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[segments,fs,channelnames,channelindex,baseline]=bmi_segment_extract(SBefore,SAfter,TMin,badChannels,movements,rest_start,rest_end);


%For hand open close
baseline_time=[0,0.5];
%For abduction adduction
% baseline_time=[0.5,1];

%Sun Yaqiang
% ave_channels={'C109','C66','C77','C76'};

%Li Ma
%Abd_Add
% ave_channels={'C2','C3','C4','C17','C18','C19','C39'};
%for handopenclose
% ave_channels={'C2','C3','C4','C5','C13','C14','C15','C16','C17','C18'...
%     'C17','C25','C26','C27','C28','C29','C30','C41','C42','C43','C44'...
%     'C37','C38','C39','C50','C51','C53'};

% Xu Yun
% ave_channels={'C25','C38','C39','C49','C50','C51','C61','C62','C63','C64',...
%     'C73','C74','C75','C85','C86','C97','C98','C109','C110','C111'};

% rname='/Users/tengi/Desktop/Projects/data/BMI/fingers/Xuyun/rest.mat';
% rest=load(rname);
% baseline=rest.data2;

ave_channels={};

wd=round(fs/3);
ov=round(wd*0.9);
lc=1;
hc=1000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tmp_data=squeeze(segments.(movements{1})(:,1,:));
[tf,f,time]=tfmap(tmp_data,fs,wd,ov,lc,hc);
base_rf=zeros(length(f),length(channelindex));

if isempty(baseline)
    for m=1:length(movements)
        for i=1:length(channelindex)
            data=squeeze(segments.(movements{m})(:,i,:));
            [tf,f,time]=tfmap(data,fs,wd,ov,lc,hc);
            
            rf=mean(tf(:,time>baseline_time(1)&time<baseline_time(2)),2);
            base_rf(:,i)=base_rf(:,i)+rf;
        end
    end
    base_rf=base_rf/length(movements);
end

%%
%movements
for m=1:length(movements)
    ave_tfmap=0;
    figure('name',movements{m});
    ax_back = axes('Position',[0 0 1 1],'Visible','off');
    set(ax_back,'XLim',[0,1]);
    set(ax_back,'YLim',[0,1]);
    
    count=0;
    for i=1:length(channelindex)
        
        if any(strcmpi(channelnames{i},badChannels))
            continue
        end
        
        
        [row,col,nrow,ncol,xmargin,ymargin]=get_grid_row_col(channelnames{i},grid_id);
        
        axes(ax_back)
        dw=(1-xmargin)/ncol-xmargin;
        dh=(1-ymargin)/nrow-ymargin;
        x=xmargin+(col-1)/ncol*(1-xmargin);
        y=1-(ymargin+(row-1)/nrow*(1-ymargin))-dh;
        
        text(x+dw/2,y+dh+0.01,channelnames{i},'FontSize',8,'HorizontalAlignment','center','Interpreter','none');
        
        axes('Position',[x,y,dw,dh]);
        
        data=squeeze(segments.(movements{m})(:,i,:));
        
        [tf,f,time]=tfmap(data,fs,wd,ov,lc,hc);
        
        if ~isempty(baseline)
            [rtf,rf,rt]=tfmap(baseline(:,i),fs,wd,ov,lc,hc);
            rf=mean(rtf,2);
        else
            rf=base_rf(:,i);
        end
        
        relativeTFMap=tf./repmat(rf,1,size(tf,2));
        
        imagesc(time,f,20*log10(relativeTFMap),[-6,6]);
        
        colormap(jet);
        axis xy;
        axis off;
        
        
        if isempty(ave_channels)||any(strcmpi(channelnames{i},ave_channels))
            ave_tfmap=ave_tfmap+relativeTFMap;
            count=count+1;
        end
        
    end
    ave_tfmap=ave_tfmap/count;
    figure('Name',movements{m})
    [SMOOTHED] = TF_Smooth(ave_tfmap,'gaussian',[10,10]);
    imagesc(time-SBefore,f,20*log10(SMOOTHED),[-8 8]);
    set(gca,'YLim',[3 220]);
    
    set(gcf,'Position',[0,0,380,250]);
    colormap(jet)
    colorbar
    hold on
    plot([-3,3],[8,8],'-.k','linewidth',1)
    hold on 
    plot([-3,3],[32,32],'-.k','linewidth',1);
    hold on
    plot([-3,3],[60,60],'-.k','linewidth',1);
    hold on
    plot([-3,3],[200,200],'-.k','linewidth',1);
%     hold on
%     plot([0,0],[0,500],':k','linewidth',1);
    axis xy;
    set(gca,'ytick',[8,32,60,200])
    ylabel('Frequency (Hz)')
    xlabel('Time (s)')
    
end
