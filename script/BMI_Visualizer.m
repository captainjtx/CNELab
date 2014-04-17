clear;
close all;

Study='BMI';
Experiment='task';

SaveGraphic ='n'; %'y' = yes, no otherwise
ReviewMode  ='d'; %'s' = save and display data, 'd': only display the data

[MatFileName,MatFilePath]=uigetfile('*.mat','Select the case mat file');

close all
delete(findobj(0,'type','figure'));

task     = load(fullfile(MatFilePath,MatFileName));

data        = task.data;
annotations = task.annotations;
fs          = data.info{1}.sampleRate;

PatientName = task.info.patientName;
ttl=PatientName;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% channel display selection================================================

chanIndex=1:60;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%butterworth high pass filter, remove dc component
for i=1:length(chanIndex)
    dataDisp(:,chanIndex(i))=data.dataMat{chanIndex(i)};
    eloc{i}=data.info{i}.name;
end
order=2;
fl=0.5;
fh=220;
[b,a]=butter(order,[fl fh]*2/fs,'bandpass');
dataDisp=filter_symmetric(b,a,dataDisp,fs,0,'iir');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ChanColor=cell(1,length(chanIndex));

for i=1:length(ChanColor)
    ChanColor{i}='k';
end

eloc = struct('labels',eloc);

winrej=[];

eeginput = struct('srate',fs,'eloc_file',eloc,'color',{ChanColor}, 'spacing',.25,...
    'winlength', 5,'position',[10 40 1320 670],'winrej',winrej);
eeginput.closecallback   = 'uiresume(gcbf); set(gcbf,''Visible'',''off'')';
if any(ReviewMode == 'sd')
    eeginput.analysischannel = 3;
    eeginput.plotdatacb = @hfo_plotdata_callback;
    eeginput.tfmapcb = @bmi_tfmap_callback;
    % Insert annotations
    ua = annotations.index';
 
    eeginput.events = struct('type',annotations.text,'latency',num2cell(ua),'duration',0);
    
    % Set the reject field to 1 if REJECT button is pressed
    eeginput.winalpha = 0.3;
    eeginput.winrej = winrej;
    eeginput.wincolor = [0.8 0.5 0.7];
    
    hfig = eegplot_bmi(dataDisp',eeginput);
    eegplot_bmi('title',ttl);
    uiwait(hfig);
    
    data.artifact=[];
    data.reject=0;
else
%     dataDisp=dataDisp(2*fs+1:end-2*fs,:);
    hfig = eegplot_bmi(dataDisp',eeginput);
    eegplot_bmi('title',ttl);
    uiwait(hfig);
end
if SaveGraphic == 'y'
    eegplot_bmi('noui');
    print('-dpng','-r300', fullfile(MatFilePath,'Figures',ttl));
end

close all;
eeginput = get(hfig,'UserData');
delete(hfig);
if eeginput.children
    delete(eeginput.children);
end