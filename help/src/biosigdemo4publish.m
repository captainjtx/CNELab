%% BioSigPlot demonstration
%Example with raw EEG and AFOP filtered EEG

%%  Plot Signals
load filterdemo
a=BioSigPlot({data fdata},'srate',250,'Montage','1020system19','video','videodemo.avi');
snapnow

%%  Define Events to plot on BioSigPlot
a.Evts={10 'Electrode';64 'Muscle';86 'Muscle';110,'End HVT';144 'Smile'};
snapnow

%%  Change the Montage to Mean Reference Montage (Note that the second dataset is already Mean referenced)
a.MontageRef=2;
snapnow

%%  Move through Time
a.Time=40;
snapnow

%%  Change to Horizontal View
a.DataView='Horizontal';
snapnow

%%  Change Scales of the 2 Datasets
a.Spacing=100;
snapnow

%%  Change Scales on the second dataset only
a.Spacing(2)=200;
snapnow

%%  Change the scale of the third electrod on dataset 1 (2nd Montage ie Mean Reference)
a.Montage{1}(2).mat(3,:)=a.Montage{1}(2).mat(3,:)/10;
snapnow

