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
bLen=1*fs;

wd=128;
ov=124;

Alignments={'Target','Go','Exit'};

fl=[1,13,40];
fh=[7,30,90];

fname='uncertainty_raw_power.csv';

fid=fopen(fname,'w+');

%Pt, Med_Status(Off=0, On=1), Number of Targets,
%0.5s Before Target(Delta,Beta,Gamma), 0.5s After Target(Delta,Beta,Gamma)
%0.5s Before Go(Delta,Beta,Gamma), 0.5s After Exit(Delta, Beta, Gamma)

fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s',...
    'Pt','Med','Targets',...
    'delta_before_target','beta_before_target','gamma_before_target',...
    'delta_after_target','beta_after_target','gamma_after_target',...
    'delta_before_go','beta_before_go','gamma_before_go',...
    'delta_exit_centered','beta_exit_centered','gamma_exit_centered');

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
    
    %patient+state+session+no error
    %Remove the noisy trial #41 of patient 3 off session 1
    if fnameInfo{1}==3&&fnameInfo{3}==1&&strcmpi(fnameInfo{2}{:},'medicineoff')
        textInd=(columnData{1}==fnameInfo{1})&strcmpi(columnData{2},fnameInfo{2})&...
            (columnData{3}==fnameInfo{3})&(columnData{end}==0)&(columnData{4}~=41);
    else
        textInd=(columnData{1}==fnameInfo{1})&strcmpi(columnData{2},fnameInfo{2})&...
            (columnData{3}==fnameInfo{3})&(columnData{end}==0);
    end
    
    baseCol=find(textInd);
    if isempty(baseCol)
        continue
    end
    
    for target=1:2
        fprintf(fid,'\n%d,%s,%d',fnameInfo{1},fnameInfo{2}{:},target);
        for alg=1:length(Alignments)
            Alignment=Alignments{alg};
            
            if strcmp(Alignment, 'Target')
                Trigger_Indx=6;
                %         WL=128; % Around 1ec for the Pre CUE
                WL=[fs*1,0*fs];
                %         WR=256; %Around 1sec
                WR=[fs*0,0.5*fs]; %1.125sec
                
            elseif strcmp(Alignment, 'Go')
                Trigger_Indx=7;
                %         WL=1 sec
                WL=fs*0.5;
                %         WR=.625 msec
                WR=fs*0;
            elseif strcmp(Alignment, 'Exit')
                Trigger_Indx=8;
                %         WL=.625 msec
                WL=fs*.25;
                %         WR= .625sec
                WR=fs*.25;
            end
            WL=round(WL);
            WR=round(WR);
            
            for ifn=1:length(WL)
                for fb=1:length(fl)
                    relativePowerAve=0;
                    for n=1:length(BipolarLFPNames)
                        
                        base_p=0;
                        for m=1:length(baseCol)
                            tmp=BpData(columnData{6}(baseCol(m))-bL-bLen:columnData{6}(baseCol(m))-bL,n);
                            
                            [Pxx,F] = periodogram(tmp,hamming(length(tmp)),length(tmp),fs);
                            base_p = bandpower(Pxx,F,[fl(fb) fh(fb)],'psd')+base_p;
                        end
                        
                        base_p=base_p/length(baseCol);
                        
                        
                        targetind=(columnData{11}~=-1)+(columnData{12}~=-1)+(columnData{13}~=-1);
                        
                        targetind=(targetind==target);
                        
                        textCol=find(textInd&targetind);
                        
                        
                        if isempty(textCol)
                            continue
                        end
                        relativePower=0;
                        for m=1:length(textCol)
                            tmp=BpData(columnData{Trigger_Indx}(textCol(m))-WL(ifn):columnData{Trigger_Indx}(textCol(m))+WR(ifn),n);
                            [Pxx,F] = periodogram(tmp,hamming(length(tmp)),length(tmp),fs);
                            relativePower = bandpower(Pxx,F,[fl(fb) fh(fb)],'psd')+relativePower;
                        end
                        
                        relativePower=relativePower/length(textCol)/base_p;
                        
                        relativePowerAve=relativePowerAve+relativePower;
                        
                    end
                    relativePowerAve=10*log10(relativePowerAve/3);
                    fprintf(fid,',%6.4f',relativePowerAve);
                end
                
            end
        end
        
    end
end
fclose(fid);