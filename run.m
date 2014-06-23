function run()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
cprintf('Magenta','Welcome to SuperViewer(CNEL Beta 0.1)!\n');

cds=[];
while(1)
    
    
    tmp=CommonDataStructure.multiImport();
    if ~isempty(tmp)
        cds=[cds,tmp];
    end
    
    cprintf('Comments','Do you want to select more dataset?[Y/N]\n')
    s=input('','s');
    if strcmpi(s,'n')
        break;
    end
end
if isempty(cds)
    return;
end

fs=cds{1}.Data.SampleRate;

for i=2:length(cds)
    
    if cds{i}.Data.SampleRate~=cds{i-1}.Data.SampleRate
        fs=1;
        cprintf('Error',['Sampling frequency in data set ' num2str(i-1) ' and ' num2str(i) ' is not the same!']);
    else
        fs=cds{i}.Data.SampleRate;
    end
    
end

data=cell(1,length(cds));
for i=1:length(cds)
    data{i}=cds{i}.Data.Data';
end
bsp=BioSigPlot(data);

%**************************************************************************
if isempty(fs)||(fs==0)
    fs=1;
end

bsp.SRate=fs;
%==========================================================================
%**************************************************************************
ChanNames=cell(1,length(cds));
for i=1:length(cds)
    if ~isempty(cds{i}.Montage.ChannelNames)
        ChanNames{i}=cds{i}.Montage.ChannelNames;
    else
        ChanNames{i}=[];
    end
end
bsp.ChanNames=ChanNames;

%==========================================================================
%**************************************************************************
startTime=0;
for i=1:length(cds)
    if ~isempty(cds{i}.Data.TimeStamps)
        startTime=cds{i}.Data.TimeStamps(1);
        break;
    end
end
evts=[];
for i=1:length(cds)
    if ~isempty(cds{i}.Data.Annotations)
        evts=cat(1,evts,cds{i}.Data.Annotations);
        evts(:,1)=num2cell(cell2mat(evts(:,1))-startTime);
    else
        evts=[];
    end
end

bsp.Evts=evts;
%==========================================================================
%**************************************************************************
VideoStartTime=0;
VideoTimeFrame=[];

for i=1:length(cds)
    if ~isempty(cds{i}.Data.Video.StartTime)
        VideoStartTime=cds{i}.Data.Video.StartTime;
    end
    
    if ~isempty(cds{i}.Data.Video.TimeFrame)
        VideoTimeFrame=cds{i}.Data.Video.TimeFrame;
    end
end

bsp.VideoStartTime=VideoStartTime;
bsp.VideoTimeFrame=VideoTimeFrame;
%==========================================================================
%**************************************************************************
Units=cell(length(cds),1);
for i=1:length(cds)
    if iscell(cds{i}.Data.Units)
        if length(cds{i}.Data.Units)==size(cds{i}.Data.Data,2)
            Units{i}=cds{i}.Data.Units;
        end
    elseif ischar(cds{i}.Data.Units)
        Units{i}=cell(1,size(cds{i}.Data.Data,2));
        [Units{i}{:}]=deal(cds{i}.Data.Units);     
    end
end

bsp.Units=Units;

%==========================================================================
assignin('base','bsp',bsp);

end

