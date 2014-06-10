function run()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
cds=CommonDataStructure();

cds.import();

bsp=BioSigPlot({cds.Data.Data' cds.Data.Data'});

%**************************************************************************
if isempty(cds.Montage.SampleRate)||(cds.Montage.SampleRate==0)
    fs=1;
else
    fs=cds.Montage.SampleRate;
end

bsp.SRate=fs;
%==========================================================================
%**************************************************************************
if ~isempty(cds.Data.TimeStamps)
    startTime=cds.Data.TimeStamps(1);
else
    startTime=0;
end

if ~isempty(cds.Data.Annotations)
    evts=cds.Data.Annotations;
    evts(:,1)=num2cell(cell2mat(evts(:,1))-startTime);
else
    evts=[];
end

bsp.Evts=evts;
%==========================================================================

assignin('base','bsp',bsp);

end

