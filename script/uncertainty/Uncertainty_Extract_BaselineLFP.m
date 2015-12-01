%This script will extract Baseline LFP activity
%By Tianxiao Jiang
clc
clear

Pt1_Montage_Dir='/Users/tengi/Desktop/Projects/CNELab/db/montage/Pt1_Uncertainty_Bipolar.mtg';
Pt234_Montage_Dir='/Users/tengi/Desktop/Projects/CNELab/db/montage/Pt234_Uncertainty_Bipolar.mtg';
Pt5_Montage_Dir='/Users/tengi/Desktop/Projects/CNELab/db/montage/Pt5_Uncertainty_Bipolar.mtg';
Pt10_Montage_Dir='/Users/tengi/Desktop/Projects/CNELab/db/montage/Pt10_Uncertainty_Bipolar.mtg';

neuroData='/Users/tengi/Desktop/Projects/data/uncertainty/NeuroData';

triggerDir='/Users/tengi/Desktop/Projects/data/uncertainty/Analysis/db/Uncertainty_TriggerCodes.txt';

listings=dir([neuroData,'/*.mat']);

tfID=fopen(triggerDir);
%Read the file header
%Patient State Session Trial CenterHold ShowTarget FillTarget MoveToTarget TargetEnter TrialEnd Angle1 Angle2 Angle3 TargetAngle ErrorCode
columnNames=textscan(tfID,'%s',15,'delimiter',' ');
columnData=textscan(tfID,'%d%s%d%d%d%d%d%d%d%d%d%d%d%d%d','delimiter',',');

fclose(tfID);

BipolarLFPNames={'LFP Bipolar1','LFP Bipolar2','LFP Bipolar3'};
BpInd=zeros(1,length(BipolarLFPNames));

%3s before cue onset
ColInd=[];

fs=512;
segSample=1*fs;

PreTrialSegs=zeros(segSample,length(columnData{1}),length(BipolarLFPNames));

for i=1:length(listings)
    ocds=load(fullfile(neuroData,listings(i).name),'-mat');
    
    fnameInfo=textscan(listings(i).name(1:end-4),'Pt%dLFPII_PD_PostOR_%s%dUncertainty_%s',...
        'delimiter','_');
    %fnameInfo:
    %1, Patient ID
    %2, Medicine State
    %3, Session
    %4, Right/Left STN
    
    %compute the bipolar derivation of Accelerometer
    
    switch fnameInfo{1}
        case 1
            montage_dir=Pt1_Montage_Dir;
        case 5
            montage_dir=Pt5_Montage_Dir;
        case 10
            montage_dir=Pt10_Montage_Dir;
        otherwise
            montage_dir=Pt234_Montage_Dir;
    end
    [montage_channames,mat,group_name]=parseMontage(ReadYaml(Pt1_Montage_Dir),ocds.montage.ChannelNames);
    for j=1:length(BipolarLFPNames)
        BpInd(j)=find(strcmpi(montage_channames,BipolarLFPNames{j}));
    end
    BpData=ocds.data.data*mat(BpInd,:)';
    
    textCol=find((columnData{1}==fnameInfo{1})&strcmpi(columnData{2},fnameInfo{2})&(columnData{3}==fnameInfo{3}));
    
    for m=1:length(textCol)
        for n=1:length(BipolarLFPNames)
            PreTrialSegs(:,length(ColInd)+m,n)=BpData(columnData{6}(textCol(m))-segSample+1:columnData{6}(textCol(m)),n);
        end
    end
    
    ColInd=[ColInd;textCol];
end


