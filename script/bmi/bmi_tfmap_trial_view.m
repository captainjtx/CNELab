clc
clear

%user defined region=======================================================
%get segments seconds before onset and after onset
% Hand open close
% SBefore=2;
% SAfter=2;
% TMin=0;

% Finger
% SBefore=1;
% SAfter=1.5;
% TMin=0;

%Abduction
SBefore=1.5;
SAfter=1.5;
TMin=1;
%Rest
% SBefore=0;
% SAfter=30;
% TMin=0;

%exclude bad\syn\noisy channels if any
%var channels stores clean channel index

%120 Channel, Chinese******************************************************
%Yaqiang Sun
% badChannels={'C21','C33','C34','C46','C58','C82','C94','C106','C109',...
%     'ECG+','ECG-','EMG+','EMG-','Synch','C126','C127','C128'};
% badChannels={'ECG Bipolar','EMG Bipolar','Synch'};
% Li Ma
%badChannels for Handopenclose
% badChannels={'C27','C64','C75','C76','C100',...
%     'ECG+','ECG-','EMG+','EMG-','Sound','C126','C127','C128'};
%badChannels for AbductionAdduction
% badChannels={'ECG+','ECG-','EMG+','EMG-','Sound','C126','C127','C128'};

% badChannels={'Trigger','Acceleration X','Acceleration Y', 'Acceleration Z','Roll','Pitch'};

%Xu Yun
% badChannels={'C37','C3','C4','C5','C15','C16','C2','C27','C28','C6',...
%     'ECG+','ECG-','EMG+','EMG-','Sound','C126','C127','C128','C41','C10','C11',...
%     'C78','C9'};

%113 Channel, Turkey*******************************************************
%S1
badChannels={'Bipolar ECG','Bipolar EMG','Ref',...
             'C20_L','C21_L','C22_L','C27_L','C28_L','C32_L','C44_L','C47_L','C48_L','C51_L','C57_L'};

%==========================================================================
%movemnt type
% Hand open close
% movements={'Open','Close'};
% movements={'Relax'};

% Finger
% movements={'F1 start','F2 start','F3 start','F4 start','F5 start'};
% movements={'Rest start'};

%Abduction
% movements={'Abd','Add'};
%if movements is 2*n, will extract the segments between the first row and
%second row
% movements={'Rest Start';'Rest End'};
%Rest
% movements={'Rest Start'};

movements={'Close'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[segments,fs,channelnames,channelindex]=bmi_segment_extract(SBefore,SAfter,TMin,badChannels,movements);

baseline=[];

wd=round(fs/3);
ov=round(wd*0.9);
lc=1;
hc=200;

%movements

for m=1:length(movements)
    h=figure('name',movements{m});
    ax_back = axes('Position',[0 0 1 1],'Visible','off');
    
    figname=movements{m};
    data=segments.(movements{m});
    for n=1:size(data,3)
        set(h,'Name',[figname,'  Trial: ' ,num2str(n)])
        for i=1:length(channelnames)
            
            %             subplot(10,12,str2double(channelnames{i}(2:end)))
            
            
            [row,col,nrow,ncol,xmargin,ymargin]=get_grid_row_col(channelnames{i},113);
            
            axes(ax_back)
            dw=(1-xmargin)/ncol-xmargin;
            dh=(1-ymargin)/nrow-ymargin;
            x=xmargin+(col-1)/ncol*(1-xmargin);
            y=1-(ymargin+(row-1)/nrow*(1-ymargin))-dh;
            text(x+dw/2,y+dh+0.01,channelnames{i},'FontSize',8,'HorizontalAlignment','center','Interpreter','none');
            
            axes('Position',[x,y,dw,dh]);
            
            [tf,f,t]=tfmap(data(:,i,n),fs,wd,ov,lc,hc);
            
            if ~isempty(baseline)
                [rtf,rf,rt]=tfmap(baseline(:,i),fs,wd,ov,lc,hc);
                rf=mean(rtf,2);
            else
                refNum=round(size(tf,2)/4);
                rf=mean(tf(:,1:refNum),2);
            end
            
            relativeTFMap=tf./repmat(rf+0.01,1,size(tf,2));
            
            imagesc(t,f,10*log10(relativeTFMap),[-10 10]);
            
            colormap(jet);
            axis xy;
            axis off;
        end
        
        pause
        
    end
end


