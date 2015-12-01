clc
clear

Pindexs=[1 2 3 4 5 6 10];

BehvInfo_PatientIndex=[];
BehvInfo_State=[];
BehvInfo_Session=[];
BehvInfo_Trial=[];
BehvInfo_FirstCue=[];
BehvInfo_SecondCue=[];
BehvInfo_ThirdCue=[];
BehvInfo_Target=[];
BehvInfo_CenterHoldTime=[];
BehvInfo_TargetFillTime=[];
BehvInfo_MoveOnsetTime=[];
BehvInfo_EnterTargetTime=[];
BehvInfo_ErrorCode=[];

States={'MedicineOff','MedicineOn'};
Patients={'Dennis Walsh',...
    'William Yetzer',...
    'Nyle Wollenhaupt',...
    'Richard Riedasch',...
    'Ilona Kolos',...
    'Raymond Vandeveer',...
    'Boris Star'};
for i=1:7
    Pindex=Pindexs(i);
    
    
    Drc=sprintf('/Users/tengi/Desktop/Projects/data/uncertainty/BehvData/%s',Patients{i});
    for s=1:2
        State=States{s};
        for k=1:3
            flnm=sprintf('%s/%s%d_Uncertainty1.bin',Drc,State,k);
            bd=BinaryReadWdbs(flnm);
            if isempty(bd)
                continue;
            end
            Tr=size(bd,2);
            tmp_PatientIndex=Pindex*ones(Tr,1);
            tmp_State=cell(Tr,1);
            [tmp_State{:}]=deal(State);
            tmp_Session=k*ones(Tr,1);
            
            tmp_Trial=[];
            tmp_FirstCue=[];
            tmp_SecondCue=[];
            tmp_ThirdCue=[];
            tmp_Target=[];
            tmp_CenterHoldTime=[];
            tmp_TargetFillTime=[];
            tmp_MoveOnsetTime=[];
            tmp_EnterTargetTime=[];
            tmp_ErrorCode=[];
            
            for t=1:Tr
                tmp_Trial=cat(1,tmp_Trial,bd(t).behv.r(1));
                tmp_FirstCue=cat(1,tmp_FirstCue,bd(t).behv.r(11));
                tmp_SecondCue=cat(1,tmp_SecondCue,bd(t).behv.r(12));
                tmp_ThirdCue=cat(1,tmp_ThirdCue,bd(t).behv.r(13));
                tmp_Target=cat(1,tmp_Target,bd(t).behv.r(14));
                tmp_CenterHoldTime=cat(1,tmp_CenterHoldTime,bd(t).behv.r(4));
                tmp_TargetFillTime=cat(1,tmp_TargetFillTime,bd(t).behv.r(6));
                tmp_MoveOnsetTime=cat(1,tmp_MoveOnsetTime,bd(t).behv.r(7));
                tmp_EnterTargetTime=cat(1,tmp_EnterTargetTime,bd(t).behv.r(8));
                tmp_ErrorCode=cat(1,tmp_ErrorCode,bd(t).behv.r(2));
            end
            
            [C,ia,ic] = unique(tmp_Trial);
            BehvInfo_PatientIndex=cat(1,BehvInfo_PatientIndex,tmp_PatientIndex(ia));
            BehvInfo_Session=cat(1,BehvInfo_Session,tmp_Session(ia));
            BehvInfo_State=cat(1,BehvInfo_State,tmp_State(ia));
            BehvInfo_Trial=cat(1,BehvInfo_Trial,tmp_Trial(ia));
            BehvInfo_FirstCue=cat(1,BehvInfo_FirstCue,tmp_FirstCue(ia));
            BehvInfo_SecondCue=cat(1,BehvInfo_SecondCue,tmp_SecondCue(ia));
            BehvInfo_ThirdCue=cat(1,BehvInfo_ThirdCue,tmp_ThirdCue(ia));
            BehvInfo_Target=cat(1,BehvInfo_Target,tmp_Target(ia));
            BehvInfo_CenterHoldTime=cat(1,BehvInfo_CenterHoldTime,tmp_CenterHoldTime(ia));
            BehvInfo_TargetFillTime=cat(1,BehvInfo_TargetFillTime,tmp_TargetFillTime(ia));
            BehvInfo_MoveOnsetTime=cat(1,BehvInfo_MoveOnsetTime,tmp_MoveOnsetTime(ia));
            BehvInfo_EnterTargetTime=cat(1,BehvInfo_EnterTargetTime,tmp_EnterTargetTime(ia));
            BehvInfo_ErrorCode=cat(1,BehvInfo_ErrorCode,tmp_ErrorCode(ia));
        end
    end
end

BehvInfo.PatientIndex=BehvInfo_PatientIndex;
BehvInfo.State=BehvInfo_State;
BehvInfo.Session=BehvInfo_Session;
BehvInfo.Trial=BehvInfo_Trial;
BehvInfo.FirstCue=BehvInfo_FirstCue;
BehvInfo.SecondCue=BehvInfo_SecondCue;
BehvInfo.ThirdCue=BehvInfo_ThirdCue;
BehvInfo.Target=BehvInfo_Target;
BehvInfo.CenterHoldTime=BehvInfo_CenterHoldTime;
BehvInfo.TargetFillTime=BehvInfo_TargetFillTime;
BehvInfo.MoveOnsetTime=BehvInfo_MoveOnsetTime;
BehvInfo.EnterTargetTime=BehvInfo_EnterTargetTime;
BehvInfo.ErrorCode=BehvInfo_ErrorCode;

fp1=fopen('Uncertainty_Behv_TriggerCodes.txt','w+t');

Hdr='Patient State Session Trial FirstCue SecondCue ThirdCue Target CenterHold FillTarget MoveToTarget TargetEnter ErrorCode\n';
fprintf(fp1,Hdr);
for i=1:length(BehvInfo.PatientIndex)
    fprintf(fp1,'%d,%s,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n',...
                BehvInfo.PatientIndex(i),...
                BehvInfo.State{i},...
                BehvInfo.Session(i),...
                BehvInfo.Trial(i),...
                BehvInfo.FirstCue(i),...
                BehvInfo.SecondCue(i),...
                BehvInfo.ThirdCue(i),...
                BehvInfo.Target(i),...
                BehvInfo.CenterHoldTime(i),...
                BehvInfo.TargetFillTime(i),...
                BehvInfo.MoveOnsetTime(i),...
                BehvInfo.EnterTargetTime(i),...
                BehvInfo.ErrorCode(i));
end
fclose(fp1);
save('BehvInfo.mat','-struct','BehvInfo');


%Elimate Tremor Trials
Fdir='/Users/tengi/Desktop/Projects/data/uncertainty/NeuroData';
list=dir(Fdir);

count=1;
for i=1:length(list)
    [pathstr, name, ext] = fileparts(list(i).name);
    if ~strcmpi(ext,'.mat')
        continue
    end
    
    cds=load(fullfile(Fdir,name));
    trigger(count).name=name;
    
    triggercode=cds.data.triggerCodes;
    
    %time difference between center hold and target show should be around 3
    %seconds
    fs=cds.montage.SampleRate;
    ind=(triggercode(:,2)-triggercode(:,1))/fs<2.8;
    %remove diff time of center hold and show cue < 2.8
    triggercode(ind,:)=[];
    
    triggercode=sortrows(triggercode,1);
    
    
    %Remove the following trigger
    if strcmpi(name,'Pt1_LFPII_PD_PostOR_MedicineOff_2_Uncertainty_LeftSTN')
        triggercode(26,:)=[];
    elseif strcmpi(name,'Pt5_LFPII_PD_PostOR_MedicineOff_2_Uncertainty_RightSTN')
        triggercode(34,:)=[];
    elseif strcmpi(name,'Pt5_LFPII_PD_PostOR_MedicineOff_3_Uncertainty_RightSTN')
        triggercode(3,:)=[];
    end
    
    trigger(count).triggercode=triggercode;
    trigger(count).fs=fs;
    
    count=count+1;
end


pt=[1 2 3 4 5 6 10];
states={'Off','On'};

mismatchThreshold=100;

clc

%Save Neuro trigger as txt
fp=fopen('Uncertainty_TriggerCodes.txt','w+t');

Hdr='Patient State Session Trial CenterHold ShowTarget FillTarget MoveToTarget TargetEnter TrialEnd Angle1 Angle2 Angle3 TargetAngle ErrorCode';
fprintf(fp,'%s\n',Hdr);

for i=1:length(pt)
    
    for session=1:3
        
        for s=1:2
            state=states{s};
            
            behvInd=BehvInfo.PatientIndex==pt(i)&strcmpi(BehvInfo.State,['Medicine' state])&BehvInfo.Session==session;
            
            if ~any(behvInd)
                continue
            end
            
            
            %Time difference between Target onset and Center Hold
            Behv_HoldTime=BehvInfo.TargetFillTime(behvInd)-BehvInfo.CenterHoldTime(behvInd);
            %Reaction Time
            Behv_ReactionTime=BehvInfo.MoveOnsetTime(behvInd)-BehvInfo.TargetFillTime(behvInd);
            %Movement Time
            Behv_MovementTime=BehvInfo.EnterTargetTime(behvInd)-BehvInfo.MoveOnsetTime(behvInd);
            
            
            for j=1:length(trigger)
                if ~isempty(regexp(trigger(j).name,['Pt' num2str(pt(i)) '_' 'LFPII_PD_PostOR_Medicine' state '_' num2str(session)],'ONCE'))
                    triggercode=trigger(j).triggercode;
                    
                    for t=1:size(triggercode,1)
                        fprintf(fp,'%d,%s,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n',pt(i),['Medicine' state],session,t,...
                            triggercode(t,1),...
                            triggercode(t,2),...
                            triggercode(t,3),...
                            triggercode(t,4),...
                            triggercode(t,5),...
                            triggercode(t,6),...
                            triggercode(t,7),...
                            triggercode(t,8),...
                            triggercode(t,9),...
                            triggercode(t,10),...
                            triggercode(t,11));
                    end
                    
                    if (size(triggercode,1)~=max(BehvInfo.Trial(behvInd)))
                        cprintf('Errors',['\nTrial number mismatch between neuro and behv!\n' trigger(j).name]);
                        continue
                    end
                    
                    fs=trigger(j).fs;
                    Neuro_HoldTime=(triggercode(:,3)-triggercode(:,1))/fs*1000;
                    Neuro_ReactionTime=(triggercode(:,4)-triggercode(:,3))/fs*1000;
                    Neuro_MovementTime=(triggercode(:,5)-triggercode(:,4))/fs*1000;
                    
                    
                    
                    shift1=Neuro_HoldTime-Behv_HoldTime;
                    mis1=abs(shift1)>mismatchThreshold;
                    shift2=Neuro_ReactionTime-Behv_ReactionTime;
                    mis2=abs(shift2)>mismatchThreshold;
                    shift3=Neuro_MovementTime-Behv_MovementTime;
                    mis3=abs(shift3)>mismatchThreshold;
                    errorcode=BehvInfo.ErrorCode(behvInd);
                    
                    mis=mis1|mis2|mis3;
                    mis=mis&errorcode==0;
                    if any(mis)
                        cprintf('Text',['\n' trigger(j).name '\n' ]);
                        cprintf('Text','\nBehv-Trial: CenterHold: TargetFill: MoveOnset: TargetEnter: ErrorCode:\n');
                        
                        format 'shortG'
                        behv_t1=BehvInfo.CenterHoldTime(behvInd);
                        behv_t2=BehvInfo.TargetFillTime(behvInd);
                        behv_t3=BehvInfo.MoveOnsetTime(behvInd);
                        behv_t4=BehvInfo.EnterTargetTime(behvInd);
                        
                        
                        start=triggercode(:,1)/fs*1000;
                        neuro_t1=start-start;
                        neuro_t2=triggercode(:,3)/fs*1000;
                        neuro_t2=neuro_t2-start;
                        neuro_t3=triggercode(:,4)/fs*1000;
                        neuro_t3=neuro_t3-start;
                        neuro_t4=triggercode(:,5)/fs*1000;
                        neuro_t4=neuro_t4-start;
                        
                        disp([find(mis),...
                            behv_t1(mis),...
                            behv_t2(mis),...
                            behv_t3(mis),...
                            behv_t4(mis),...
                            errorcode(mis)]);
                        cprintf('Text','\nNeuro-Trial: CenterHold: TaretFill: MoveOnset: TaretEnter: ErrorCode:\n');
                        format 'shortG'
                        disp([find(mis),...
                            neuro_t1(mis),...
                            neuro_t2(mis),...
                            neuro_t3(mis),...
                            neuro_t4(mis),...
                            errorcode(mis)]);
                        
                        
                        cprintf('Text','\nTrial: dTargetFill: dReaction: dMove: \n');
                        format 'shortG'
                        disp([find(mis),...
                            behv_t2(mis)-neuro_t2(mis),...
                            behv_t3(mis)-behv_t2(mis)-neuro_t3(mis)+neuro_t2(mis),...
                            behv_t4(mis)-behv_t3(mis)-neuro_t4(mis)+neuro_t3(mis)])
                        
                    end
                    
                end
                
            end
            
        end
    end
end

fclose(fp);


