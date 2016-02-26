%This script will compute LFP TFMap activity
%By Tianxiao Jiang
clc
clear

Pt1_Montage_Dir='/Users/tengi/cnelab/db/montage/Pt1_Uncertainty_Bipolar.csv';
Pt234_Montage_Dir='/Users/tengi/cnelab/db/montage/Pt234_Uncertainty_Bipolar.csv';
Pt5_Montage_Dir='/Users/tengi/cnelab/db/montage/Pt5_Uncertainty_Bipolar.csv';
Pt10_Montage_Dir='/Users/tengi/cnelab/db/montage/Pt10_Uncertainty_Bipolar.csv';

neuroData='/Users/tengi/Desktop/Projects/data/uncertainty/NeuroData';

listings=dir([neuroData,'/*.mat']);


BipolarLFPNames={'LFP Bipolar1','LFP Bipolar2','LFP Bipolar3'};
BpInd=zeros(1,length(BipolarLFPNames));

fs=512;


Alignments={'Baseline','Target','Go','Exit'};

fl=[1,13,40];
fh=[7,30,90];



%Pt, Med_Status(Off=0, On=1), Number of Targets,
%0.5s Before Target(Delta,Beta,Gamma), 0.5s After Target(Delta,Beta,Gamma)
%0.5s Before Go(Delta,Beta,Gamma), 0.5s After Exit(Delta, Beta, Gamma)


for fb=1:length(fl)
    
    switch fb
        case 1
            fname='uncertainty_delta_power.csv';
            fid=fopen(fname,'w+');
            fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s',...
                'Pt','Med','Session','Trial','Chan','Targets',...
                'delta_before_target',...
                'delta_after_target',...
                'delta_before_go',...
                'delta_exit_centered');
        case 2
            fname='uncertainty_beta_power.csv';
            fid=fopen(fname,'w+');
            fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s',...
                'Pt','Med','Session','Trial','Chan','Targets',...
                'beta_before_target',...
                'beta_after_target',...
                'beta_before_go',...
                'beta_exit_centered');
        case 3
            fname='uncertainty_gamma_power.csv';
            fid=fopen(fname,'w+');
            
            fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s',...
                'Pt','Med','Session','Trial','Chan','Targets',...
                'gamma_before_target',...
                'gamma_after_target',...
                'gamma_before_go',...
                'gamma_exit_centered');
    end
    
    [b,a]=butter(3,[fl(fb),fh(fb)]/(fs/2));
    
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
        BpData=filtfilt(b,a,BpData);
        
        fdata=[];
        
        for target=1:2
            
            switch target
                case 1
                    targetind=ocds.data.triggerCodes(:,8)==-1;
                case 2
                    targetind=ocds.data.triggerCodes(:,8)>0;
            end
            
            fdata(target).trial=find(targetind);
            
            for alg=1:length(Alignments)
                
                Alignment=Alignments{alg};
                if strcmp(Alignment,'Baseline')
                    WL=fs*1;
                    WR=0;
                    alignInd=ocds.data.triggerCodes(:,2);
                elseif strcmp(Alignment, 'Target')
                    %         WL=128; % Around 1ec for the Pre CUE
                    WL=0*fs;
                    %         WR=256; %Around 1sec
                    WR=0.5*fs; %1.125sec
                    alignInd=ocds.data.triggerCodes(:,2);
                    
                elseif strcmp(Alignment, 'Go')
                    alignInd=ocds.data.triggerCodes(:,3);
                    %         WL=1 sec
                    WL=fs*0.5;
                    %         WR=.625 msec
                    WR=fs*0;
                elseif strcmp(Alignment, 'Exit')
                    alignInd=ocds.data.triggerCodes(:,4);
                    %         WL=.625 msec
                    WL=fs*.25;
                    %         WR= .625sec
                    WR=fs*.25;
                end
                
                alignInd=alignInd(targetind);
                WL=round(WL);
                WR=round(WR);
                
                data=getaligneddata(BpData,alignInd,[-WL,WR]);
                fdata(target).(Alignment)=squeeze(data);
            end
        end
        
        for target=1:2
            for n=1:length(BipolarLFPNames)
                for m=1:length(fdata(target).trial)
                    %patient+state+session+no error
                    %Remove the noisy trial #41 of patient 3 off session 1
                    
                    if (fnameInfo{1}==3&&strcmpi(fnameInfo{2}{:},'MedicineOff')&&fnameInfo{3}==1&&fdata(target).trial(m)==41)
                        continue
                    end
                    %Pt,Med,Session,Trial,Chan,Target
                    fprintf(fid,'\n%d,%s,%d,%d,%d,%d',fnameInfo{1},fnameInfo{2}{:}(9:end),fnameInfo{3},fdata(target).trial(m),n,target);
                    
                    for alg=1:length(Alignments)
                        
                        Alignment=Alignments{alg};
                        tmp=fdata(target).(Alignment);
                        
                        tmp=squeeze(tmp(:,n,:));
                        tmp=mean(tmp.^2,1);
                        
                        fprintf(fid,',%1.15f',tmp(m));
                    end
                end
            end
        end
    end
    
    fclose(fid);
end
