clear
clc

% patient by patient statistics
outputFilePath='/Users/tengi/Desktop/Projects/BMI/data/Uncertainty/Analysis/TimeDiff';

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
        e=file.data.triggerCodes(:,nErrorCode);
        Error=cat(1,Error,e);
        
        %target number
        nAngle1=strmatch('Angle1',triggerNames);
        nAngle2=strmatch('Angle2',triggerNames);
        nAngle3=strmatch('Angle3',triggerNames);
        
        angle1=file.data.triggerCodes(:,nAngle1);
        tn1=(angle1~=-1)&(angle1~=0);
        
        angle2=file.data.triggerCodes(:,nAngle2);
        tn2=(angle2~=-1)&(angle2~=0);
        
        angle3=file.data.triggerCodes(:,nAngle3);
        tn3=(angle3~=-1)&(angle3~=0);
        
        TargetNum=cat(1,TargetNum,tn1+tn2+tn3);
        
        %reation time
        nFillTarget=strmatch('FillTarget',triggerNames);
        nMoveToTarget=strmatch('MoveToTarget',triggerNames);
        dt=file.data.triggerCodes(:,nMoveToTarget)-file.data.triggerCodes(:,nFillTarget);
        
        ReactionDT=cat(1,ReactionDT,dt);
        
        %action time
        nTargetEnter=strmatch('TargetEnter',triggerNames);
        dt=file.data.triggerCodes(:,nTargetEnter)-file.data.triggerCodes(:,nMoveToTarget);
        
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


