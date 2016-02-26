function uncertainty_time_stat()

% patient by patient statistics
outputFilePath='/Users/tengi/Desktop/Projects/data/uncertainty/Analysis/07-28-2014';

cprintf('Magenta','Enter the subject index:\n')
s=input('','s');

n=str2double(s);

[offReactionDT,offActionDT,offTargetNum]=getDT('off',n);

[onReactionDT,onActionDT,onTargetNum]=getDT('on',n);

figure('Name','Reaction Time');

x=[1,2,6,7];
y=[mean(onReactionDT(onTargetNum==1)),...
    mean(onReactionDT(onTargetNum==2)),...
    mean(offReactionDT(offTargetNum==1)),...
    mean(offReactionDT(offTargetNum==2))];

e=[std(onReactionDT(onTargetNum==1)),...
    std(onReactionDT(onTargetNum==2)),...
    std(offReactionDT(offTargetNum==1)),...
    std(offReactionDT(offTargetNum==2))];

errorbar(x,y,e,'r*');
title(['Reaction time of subject ' num2str(n)])

set(gca,'xticklabel',{'1 (ON)','2 (ON)',...
    '1 (OFF)','2 (OFF)'});
set(gca,'xtick',x);
set(gca,'xlim',[0.5,7.5]);

ylabel('Time (S)');
export_fig(fullfile(outputFilePath,['pt' num2str(n) '-reaction']),'-png')

figure('Name','Action Time');

y=[mean(onActionDT(onTargetNum==1)),...
    mean(onActionDT(onTargetNum==2)),...
    mean(offActionDT(offTargetNum==1)),...
    mean(offActionDT(offTargetNum==2))];

e=[std(onActionDT(onTargetNum==1)),...
    std(onActionDT(onTargetNum==2)),...
    std(offActionDT(offTargetNum==1)),...
    std(offActionDT(offTargetNum==2))];

errorbar(x,y,e,'r*');
title(['Movement time of subject ' num2str(n)])
set(gca,'xticklabel',{'1 (ON)','2 (ON)',...
    '1 (OFF)','2 (OFF)'});
set(gca,'xtick',[1,2,6,7]);
set(gca,'xlim',[0.5,7.5]);

ylabel('Time (S)');

export_fig(fullfile(outputFilePath,['pt' num2str(n) '-move']),'-png')
end

function [ReactionDT,ActionDT,TargetNum]=getDT(state,n)
count=1;
ReactionDT=[];
ActionDT=[];
Error=[];
TargetNum=[];


while(1)
    cprintf('Cyan',['Please select subject ' num2str(n) ' s' ' medicine ' state ' file\n']);
    [FileName,FilePath]=uigetfile('*.mat',['select the medicine ' state ' files'],'MultiSelect','on');
    
    if iscell(FileName)
        
        if isempty(FileName)
            return
        end
    else
        if ~FileName
            return
        else
            FileName={FileName};
        end
    end
    for i=1:length(FileName)
        count=count+1;
        file=load(fullfile(FilePath,FileName{i}),'-mat');
        triggerNames=file.patientInfo.TriggerNames;
        %error code
        nErrorCode=strmatch('ErrorCode',triggerNames);
        
        triggercode=file.data.triggerCodes;
        
        %time difference between center hold and target show should be around 3
        %seconds
        fs=file.montage.SampleRate;
        ind=(triggercode(:,2)-triggercode(:,1))/fs<2.8;
        %remove diff time of center hold and show cue < 2.8
        triggercode(ind,:)=[];
        
        triggercode=sortrows(triggercode,1);
        
        
        %Remove the following trigger
        if strcmpi(FileName{i},'Pt1_LFPII_PD_PostOR_MedicineOff_2_Uncertainty_LeftSTN')
            triggercode(26,:)=[];
        elseif strcmpi(FileName{i},'Pt5_LFPII_PD_PostOR_MedicineOff_2_Uncertainty_RightSTN')
            triggercode(34,:)=[];
        elseif strcmpi(FileName{i},'Pt5_LFPII_PD_PostOR_MedicineOff_3_Uncertainty_RightSTN')
            triggercode(3,:)=[];
        end
        
        e=triggercode(:,nErrorCode);
        Error=cat(1,Error,e);
        
        %target number
        nAngle1=strmatch('Angle1',triggerNames);
        nAngle2=strmatch('Angle2',triggerNames);
        nAngle3=strmatch('Angle3',triggerNames);
        
        angle1=triggercode(:,nAngle1);
        tn1=(angle1~=-1)&(angle1~=0);
        
        angle2=triggercode(:,nAngle2);
        tn2=(angle2~=-1)&(angle2~=0);
        
        angle3=triggercode(:,nAngle3);
        tn3=(angle3~=-1)&(angle3~=0);
        
        TargetNum=cat(1,TargetNum,tn1+tn2+tn3);
        
        %reation time
        nFillTarget=strmatch('FillTarget',triggerNames);
        nMoveToTarget=strmatch('MoveToTarget',triggerNames);
        dt=triggercode(:,nMoveToTarget)-triggercode(:,nFillTarget);
        
        ReactionDT=cat(1,ReactionDT,dt);
        
        %action time
        nTargetEnter=strmatch('TargetEnter',triggerNames);
        dt=triggercode(:,nTargetEnter)-triggercode(:,nMoveToTarget);
        
        ActionDT=cat(1,ActionDT,dt);
        
        
    end
    
    
    cprintf('Magenta','Do you want to continue ? [Y/N]\n')
    
    s=input('','s');
    if strcmpi(s,'n')
        break
    end
    
end

TargetNum=TargetNum(Error==0);
ReactionDT=ReactionDT(Error==0);
ActionDT=ActionDT(Error==0);

ReactionDT=ReactionDT/file.montage.SampleRate;
ActionDT=ActionDT/file.montage.SampleRate;
end

