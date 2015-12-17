clc
clear

[FileName,FilePath]=uigetfile('*.edf','select a edf file');

[head,signalHead,signalCell]=blockEdfLoad(fullfile(FilePath,FileName));

datamat=zeros(length(signalCell{1}),length(signalCell));
for i=1:length(signalCell)
    datamat(:,i)=signalCell{i};
end

data.datamat=datamat;
info.record_date=head.recording_startdate;
info.record_time=head.recording_starttime;
info.patient_id=head.patient_id;

for i=1:channum
    channelnames{i}=signalHead(i).signal_labels;
    units{i}=signalHead(i).physical_dimension;
end

info.units=units;

montage.channelnames=channelnames;

other.head=head;
other.signalHead=signalHead;

task.montage=montage;
task.data=data;
task.info=info;
task.other=other;

uisave('task','edfdata.mat');

