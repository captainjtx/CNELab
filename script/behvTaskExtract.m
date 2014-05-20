function behvTaskExtract()
%This function convert the behv data into standard task file format
%Workflow:
%1................synchronize the behv data with neuro data
%2................extract the task file according to neuro annotations

%user defined region=======================================================
%study name
studyName='HandRelexionExtension';

neuroSynchName='Sound'; %synch channel name in neuro task file

%==========================================================================


[FileName,FilePath]=uigetfile('*.mat','select the related neuro task file');

neuroTask=load(fullfile(FilePath,FileName));

annotations=neuroTask.annotations;

sampleRate=neuroTask.data.info{1}.sampleRate;

for i=1:length(neuroTask.data.info)
    if strcmpi(neuroTask.data.info{i}.name,neuroSynchName)
        synch=neuroTask.data.dataMat{i};        
    end
end

stamp=neuroTask.data.info{1}.stamp;

[behvMat,channelNames,videoStartTime]=behvSynch(synch,stamp,sampleRate);

for i=1:size(behvMat,1)
    task.data.dataMat{i}=behvMat(i,:);
    task.data.info{i}.sampleRate=sampleRate;
    task.data.info{i}.unit=[];
    task.data.info{i}.name=channelNames{i};
    task.data.info{i}.stamp=[];
end
task.data.info{1}.stamp=stamp;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

task.info.patientName=neuroTask.info.patientName;
task.info.studyName=studyName;
task.info.location=[];
task.info.device='Lenovo';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

task.info.video.startTime=videoStartTime;

[FileName,FilePath]=uiputfile('*.mat','save your behv task file','task.mat');
save(fullfile(FilePath,FileName),'-struct','task');

end




