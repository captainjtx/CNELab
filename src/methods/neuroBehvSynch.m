function [behvMat,videoStartTime,videoTimeFrame]=neuroBehvSynch(neuroSynch,neuroTimeStamp,...
    sampleRate,behvMat,behvSynch,behvTimeStamp,behvVideoTimeFrame,impulseStart,startEdge,impulseEnd,endEdge)
%This function synchronize the behavior data w.r.t the timestamp of neuro-system

%synch: synch signal from neuro-system
%sampling frequency of neuro system needs to be consistent (no jitter)



%Synchronization impulse number to start
if nargin<=7
    impulseStart=1;
    startEdge='rise';
    
    impulseEnd=1;
    endEdge='fall';
elseif nargin==9
    impulseEnd=1;
    endEdge='fall';
end

%cutoff frequency for highpass filter of synch signal from neuro-system
fc=5;
%order of the butter filter
order=2;

%threshould value to get a digital signal from envlope
thresh_neuro_coe=80;
thresh_behv_coe=25;

%debug variable

% sampleRate=500;

behvSynch=detrend(behvSynch);

%high pass the synch signal from neuro-system
[b,a]=butter(order,fc/sampleRate*2,'high');
synch_f=filter_symmetric(b,a,neuroSynch,sampleRate,0,'iir');

%digitalize synch signal from neuro-system*********************************
neuroEnv=abs(hilbert(synch_f));
thresh_neuro=thresh_neuro_coe*median(neuroEnv);
neuroDenv=neuroEnv>thresh_neuro;
neuroDiffenv=diff(neuroDenv);
%==========================================================================
%digitalize synch signal from behv-system**********************************
behvEnv=abs(hilbert(behvSynch));
thresh_behv=thresh_behv_coe*median(behvEnv);
behvDenv=behvEnv>thresh_behv;
behvDiffenv=diff(behvDenv);
%==========================================================================
%GUI for auto thresholding check*******************************************
figure
flag=1;
while(flag)
    subplot(2,1,1)
    plot(neuroTimeStamp,synch_f,'b');
    xlabel('s')
    title('neuro system')
    hold on
    plot(neuroTimeStamp,neuroEnv,'r');
    hold on
    plot([neuroTimeStamp(1) neuroTimeStamp(length(neuroEnv))],[thresh_neuro thresh_neuro],'-m');
    hold off
    
    subplot(2,1,2)
    plot(behvTimeStamp,behvSynch,'b');
    xlabel('s');
    title('behv system')
    hold on
    plot(behvTimeStamp,behvEnv,'r');
    hold on
    plot([behvTimeStamp(1) behvTimeStamp(length(behvEnv))],[thresh_behv thresh_behv],'-m');
    hold off
    
    cprintf('Yellow','[GUI]\n')
    cprintf('SystemCommands','Do you think it is good to continue ? [Y/N]\n');
    s=input('','s');
    
    if strcmpi(s,'y')
        break
    end
          
    prompt = {'Multiple of the envelope of neuro synch median:',...
              'Multiple of the envelope of behv synch median:'};
    dlg_title = 'ok continue cancel-break';
    num_lines = 1;
    def = {num2str(thresh_neuro_coe),num2str(thresh_behv_coe)};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    
    if ~isempty(answer)
        
        thresh_neuro_coe=str2double(answer{1});
        thresh_neuro=thresh_neuro_coe*median(neuroEnv);
        neuroDiffenv=diff(neuroEnv>thresh_neuro);
        
        thresh_behv_coe=str2double(answer{2});
        thresh_behv=thresh_behv_coe*median(behvEnv);
        behvDiffenv=diff(behvEnv>thresh_behv);
    else
        break
    end
end

%==========================================================================
%GUI for timestamp shift check*********************************************
figure
flag=1;
while(flag)
    %get the start point of synch signal from neuro-system*********************
    riseInd=find(neuroDiffenv==1)+1;
    fallInd=find(neuroDiffenv==-1)+1;
    
    switch startEdge
        case 'rise'
            start_neuro=riseInd(impulseStart);
        case 'fall'
            start_neuro=fallInd(impulseStart);
        otherwise
            start_neuro=riseInd(impulseStart);
    end
    
    %==========================================================================
    %get the end point of synch signal from neuro-system***********************
    switch endEdge
        case 'rise'
            end_neuro=riseInd(end+1-impulseEnd);
        case 'fall'
            end_neuro=fallInd(end+1-impulseEnd);
        otherwise
            end_neuro=fallInd(end+1-impulseEnd);
    end
    %==========================================================================
    %get the start point of synch signal from behv-system**********************
    
    riseInd=find(behvDiffenv==1)+1;
    fallInd=find(behvDiffenv==-1)+1;
    
    switch startEdge
        case 'rise'
            start_behv=riseInd(impulseStart);
        case 'fall'
            start_behv=fallInd(impulseStart);
        otherwise
            start_behv=riseInd(impulseStart);
                
    end
    %==========================================================================
    %get the end point of synch signal from behv-system************************
    switch endEdge
        case 'rise'
            end_behv=riseInd(end+1-impulseEnd);
        case 'fall'
            end_behv=fallInd(end+1-impulseEnd);
        otherwise
            end_behv=fallInd(end+1-impulseEnd);
    end
    %==========================================================================
    
    behvMatMiddle=behvMat(:,start_behv:end_behv);
    %interpolate the behavior data according to neuro-system from start to end
    
    behvTimeStampSE=behvTimeStamp(start_behv:end_behv)-behvTimeStamp(start_behv);
    
    neuroTimeStampSE=neuroTimeStamp(start_neuro:end_neuro)-neuroTimeStamp(start_neuro);
    subplot(2,1,1)
    neuro_diff=neuroDiffenv(start_neuro-1:end_neuro-1);
    
    behv_diff=behvDiffenv(start_behv-1:end_behv-1);
    %======================================================================
    %visualization*********************************************************
    plot(neuroTimeStampSE,neuro_diff,'b',behvTimeStampSE,behv_diff,'r');
    title('digital rising and falling edge of impulse train before interpolation');
    legend({'neuro pulse','behv pulse'});
    
    deltaTimeStamp=neuroTimeStampSE(find(neuro_diff>0))-behvTimeStampSE(find(behv_diff>0));
    
    subplot(2,1,2)
    plot(deltaTimeStamp);
    
    ylabel('s');
    
    ylim([-0.2 0.2]);
    title('Timestamp difference at rising edge of pulse train before interpolation')
    
    cprintf('Yellow','[GUI]\n')
    cprintf('SystemCommands','Do you think it is good to continue ? [Y/N]\n');
    
    s=input('','s');
    
    if strcmpi(s,'y')
        break
    end
        
    
    prompt = {'Index of the starting impulse counted forward',...
              'Starting edge (rise/fall)',...
              'Index of the ending impulse counted backward',...
              'Ending edge (rise/fall)'};
    
    dlg_title = 'ok-continue cancel-break';
    num_lines = 1;
    def = {num2str(impulseStart),...
           startEdge,...
           num2str(impulseEnd),...
           endEdge};
    
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    
    if ~isempty(answer)
        impulseStart=str2double(answer{1});
        startEdge=answer{2};
        impulseEnd=str2double(answer{3});
        endEdge=answer{4};
    else
        break
    end
end
%==========================================================================
% interpolate the data*****************************************************
interpBehvMatMiddle=interp1(behvTimeStampSE,behvMatMiddle',neuroTimeStampSE);

%==========================================================================
chanNum=size(interpBehvMatMiddle,2);
behvMat=cat(2,zeros(chanNum,start_neuro-1),interpBehvMatMiddle',zeros(chanNum,length(neuroSynch)-end_neuro));


videoStartIndex=find(behvVideoTimeFrame(:,2)==1);

videoTimeFrame(:,1)=behvTimeStamp(1:size(behvVideoTimeFrame,1));
videoTimeFrame(:,2)=behvVideoTimeFrame(:,2);

videoStartTime=videoTimeFrame(videoStartIndex(1),1);

%behv task time shift according to neuro timestamp after zero padding
shiftTime=neuroTimeStamp(start_neuro)-behvTimeStamp(start_behv);

%Assuming the task started at time 0 (in consistent with bioSigPlot)
%The corresponding time for the start of the video

videoTimeFrame(:,1)=videoTimeFrame(:,1)-videoStartTime;

[frames,iframe,j]=unique(videoTimeFrame(:,2));

videoTimeFrame=videoTimeFrame(iframe,:);

ind=find(videoTimeFrame(:,2)>0);
videoTimeFrame=videoTimeFrame(ind,:);

videoTimeFrame(:,2)=1:size(videoTimeFrame,1);

videoStartTime=videoStartTime+shiftTime;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

