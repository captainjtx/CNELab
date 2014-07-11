clc
clear

[FileName,FilePath]=uigetfile('*.mat','select uncertainty neuro data','uncertainty.mat');

if ~FileName
    return
end

cds=load(fullfile(FilePath,FileName),'-mat');

triggerNames=cds.patientInfo.TriggerNames;

triggerCodes=cds.data.triggerCodes;

