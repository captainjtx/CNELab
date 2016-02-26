%This script will compute LFP TFMap activity
%By Tianxiao Jiang
clc
clear

Pt1_Montage_Dir='/Users/tengi/cnelab/db/montage/Pt1_Uncertainty_Bipolar.csv';
Pt234_Montage_Dir='/Users/tengi/cnelab/db/montage/Pt234_Uncertainty_Bipolar.csv';
Pt5_Montage_Dir='/Users/tengi/cnelab/db/montage/Pt5_Uncertainty_Bipolar.csv';
Pt10_Montage_Dir='/Users/tengi/cnelab/db/montage/Pt10_Uncertainty_Bipolar.csv';

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

bL=0*fs;
bLen=0.5*fs;

wd=128;
ov=124;

Alignments={'Target','Go','Exit'};

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
    [montage_channames,mat,group_name]=parseMontage(ReadMontage(Pt1_Montage_Dir),ocds.montage.ChannelNames);
    for j=1:length(BipolarLFPNames)
        BpInd(j)=find(strcmpi(montage_channames,BipolarLFPNames{j}));
    end
    BpData=ocds.data.data*mat(BpInd,:)';
    
    %patient+state+session+no erroe
    %Remove the noisy trial #41 of patient 3 off session 1
    if fnameInfo{1}==3&&fnameInfo{3}==1&&strcmpi(fnameInfo{2}{:},'medicineoff')
        textCol=find((columnData{1}==fnameInfo{1})&strcmpi(columnData{2},fnameInfo{2})&(columnData{3}==fnameInfo{3})&(columnData{end}==0)&(columnData{4}~=41));
    else
        textCol=find((columnData{1}==fnameInfo{1})&strcmpi(columnData{2},fnameInfo{2})&(columnData{3}==fnameInfo{3})&(columnData{end}==0));
    end
    
    if isempty(textCol)
        continue
    end
    
    for n=1:length(BipolarLFPNames)
        
        base_p=0;
        for m=1:length(textCol)
            tmp=BpData(columnData{6}(textCol(m))-bL-bLen:columnData{6}(textCol(m))-bL,n);
            [tf,f,t]=tfmap(tmp,fs,wd,ov);
            base_p=base_p+mean(tf,2);
        end
        base_p=base_p/length(textCol);
        
        for alg=1:length(Alignments)
            Alignment=Alignments{alg};
            
            if strcmp(Alignment, 'Target')
                Trigger_Indx=6;
                %         WL=128; % Around 1ec for the Pre CUE
                WL=fs*1.125;
                %         WR=256; %Around 1sec
                WR=fs*1.125; %1.125sec
                
            elseif strcmp(Alignment, 'Go')
                Trigger_Indx=7;
                %         WL=1 sec
                WL=fs*1.125;
                %         WR=.625 msec
                WR=fs*.625;
            elseif strcmp(Alignment, 'Exit')
                Trigger_Indx=8;
                %         WL=.625 msec
                WL=fs*.625;
                %         WR= .625sec
                WR=fs*.625;
            end
            WL=round(WL);
            WR=round(WR);
            
            ActiveMap=0;
            for m=1:length(textCol)
                tmp=BpData(columnData{Trigger_Indx}(textCol(m))-WL:columnData{Trigger_Indx}(textCol(m))+WR,n);
                [tf,f,t]=tfmap(tmp,fs,wd,ov);
                ActiveMap=ActiveMap+tf;
            end
            ActiveMap=ActiveMap/length(textCol);
            
            tfmat.map{n,Trigger_Indx-5}=ActiveMap;
            tfmat.trialNum{n,Trigger_Indx-5}=length(textCol);
            tfmat.t{n,Trigger_Indx-5}=t-WL/fs;
            tfmat.f{n,Trigger_Indx-5}=f;
            tfmat.map{n,4}=base_p;
        end
    end
    
    save(['Pt', num2str(fnameInfo{1}),' ',fnameInfo{2}{:},' Session',num2str(fnameInfo{3})],'-struct','tfmat');
%     saveas(gcf,[get(gcf,'Name'),'.png']);

    close(gcf)
end