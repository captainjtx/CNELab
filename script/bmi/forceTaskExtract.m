%%
clc
clear
annoName='trial_end.txt';
defaultSynchNames={'Sound','Synch','Trigger'};
synchName=[];
behv_fs=200;

impulseStart=1;
startEdge='fall';

%%
%==========================================================================

cds=CommonDataStructure;

[FileName,FilePath]=uigetfile({'*.medf;*.cds'},'select the related neuro task file',pwd);

if ~FileName
    return
end

cds.load(fullfile(FilePath,FileName));

sampleRate=cds.DataInfo.SampleRate;

[FileName,FilePath]=uigetfile('*.mat','select the original behavior data file',pwd);
if ~FileName
    return
end
behv=load(fullfile(FilePath,FileName),'-mat');
%GUI for synch channel name of neuro system********************************
while (1)
    synch=[];
    for i=1:length(cds.Montage.ChannelNames)
        if isempty(synchName)
            if ismember(cds.Montage.ChannelNames{i},defaultSynchNames)
                synch=cds.Data(:,i);
            end
        else
            if strcmpi(cds.Montage.ChannelNames{i},synchName)
                synch=cds.Data(:,i);
            end
        end
    end
    
    if isempty(synch)
        cprintf('Errors','[Error]\n')
        cprintf('Errors','Cannot find synch channel in neuro task file. Please check the channel name.\n')
        cprintf('SystemCommands','Do you want to change the name of the synch channel ?[Y/N]\n')
        s=input('','s');
        
        if strcmpi(s,'n')
            return
        else
            
            prompt = {'Name of the synch channel in neuro-system'};
            dlg_title = 'ok-continue cancel-break';
            num_lines = 1;
            def = {'synch'};
            
            answer = inputdlg(prompt,dlg_title,num_lines,def);
            if ~isempty(answer)
                synchName=answer{1};
            else
                return
            end
        end
    else
        break
    end
end
synch=double(synch);
%==========================================================================
%GUI for auto thresholding check*******************************************
figure
flag=1;
%cutoff frequency for highpass filter of synch signal from neuro-system
fc=5;
%order of the butter filter
order=2;
%threshould value to get a digital signal from envlope
thresh_neuro_coe=80;
%high pass the synch signal from neuro-system
[b,a]=butter(order,fc/sampleRate*2,'high');
synch_f=cnelab_cnelab_cnelab_cnelab_cnelab_cnelab_filter_symmetric(b,a,synch,sampleRate,0,'iir');
neuroTimeStamp=linspace(0,length(synch_f)/sampleRate,length(synch_f));
%digitalize synch signal from neuro-system*********************************
neuroEnv=abs(hilbert(synch_f));
thresh_neuro=thresh_neuro_coe*median(neuroEnv);
neuroDenv=neuroEnv>thresh_neuro;
neuroDiffenv=diff(neuroDenv);
while(flag)
    plot(neuroTimeStamp,synch_f,'b');
    xlabel('s')
    title('neuro system')
    hold on
    plot(neuroTimeStamp,neuroEnv,'r');
    hold on
    plot([neuroTimeStamp(1) neuroTimeStamp(length(neuroEnv))],[thresh_neuro thresh_neuro],'-m');
    hold off
    
    cprintf('Yellow','\n[GUI]\n')
    cprintf('SystemCommands',['\nNeuro threshould: ',num2str(thresh_neuro),...
        '\n\nDo you think it is good to continue ? [Y/N]\n']);
    s=input('','s');
    
    if strcmpi(s,'y')
        break
    end
          
    prompt = {'Multiple of the envelope of neuro synch median:'};
    dlg_title = 'ok continue cancel-break';
    num_lines = 1;
    def = {num2str(thresh_neuro_coe)};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    
    if ~isempty(answer)
        thresh_neuro_coe=str2double(answer{1});
        thresh_neuro=thresh_neuro_coe*median(neuroEnv);
        neuroDiffenv=diff(neuroEnv>thresh_neuro);
    else
        break
    end
end

%get the start point of synch signal from behv-system**********************

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

%%
fd=fopen(annoName,'w');
trials=behv.trials;
ts=[];
force=[];


for i=1:length(trials)
    ts=cat(1,ts,trials(i).Time(:));
    force=cat(1,force,trials(i).Data(:));
    fprintf(fd,'%f,%s\n',trials(i).Events(end-2),'e');
end
fclose(fd);

%%
tmp=find(ts==0);

force=force(tmp(end):end);
behvTimeStampSE=ts(tmp(end):end);

neuroTimeStampSE=linspace(0,behvTimeStampSE(end),round(length(force)*sampleRate/behv_fs));

force=interp1(behvTimeStampSE,force(:),neuroTimeStampSE,'pchip');

force=cat(1,ones(start_neuro,1)*mean(force(1:sampleRate)),force(:),ones(length(synch)-length(force)-start_neuro,1)*mean(force(end-sampleRate:end)));


cds=CommonDataStructure;
cds.Data=force;
cds.Montage.ChannelNames={'Force'};
cds.fs=sampleRate;
cds.DataInfo.TimeStamps=linspace(0,length(force)/sampleRate,length(force));
cds.save
