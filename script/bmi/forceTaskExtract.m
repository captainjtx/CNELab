%%
clc
clear
annoName='trial_end.txt';
defaultSynchNames={'Sound','Synch','Trigger'};
synchName=[];

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
%==========================================================================

cds=CommonDataStructure;

[FileName,FilePath]=uigetfile({'*.medf;*.cds'},'select the related neuro task file',pwd);

if ~FileName
    return
end

cds.load(fullfile(FilePath,FileName));

sampleRate=cds.DataInfo.SampleRate;
%%
tmp=find(ts==0);
force=force(tmp(end):end);
behvTimeStampSE=ts(tmp(end):end);
neuroTimeStampSE=;
force=interp1(behvTimeStampSE,force,neuroTimeStampSE,'pchip');
cds=CommonDataStructrue;
cds.Data=force;
cds.save