clc
clear

Pindexs=[1 2 3 4 5 6 10];

outputdir='/Users/tengi/Desktop/Projects/data/uncertainty/BehvData';
% matfiledir='/Users/tengi/Desktop/Projects/BMI/data/Uncertainty/NeuroData';

% matfiles=dir(matfiledir);

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

for i=1:7
    Pindex=Pindexs(i);
    Patients={'Dennis Walsh',...
        'William Yetzer',...
        'Nyle Wollenhaupt',...
        'Richard Riedasch',...
        'Ilona Kolos',...
        'Raymond Vandeveer',...
        'Boris Star'};
    
    Drc=sprintf('/Users/tengi/Desktop/Projects/data/uncertainty/BehvData/%s',Patients{i});
    
    %     fprintf('Processing %s\n',sprintf('%s/Pt%d_Error_Code.txt',Drc,Pindex));
    
    %     fp=fopen(sprintf('%s/Pt%d_Uncertainty_Error_Code.txt',outputdir,Pindex),'w+t');
    %
    %     fp1=fopen(sprintf('%s/Pt%d_Uncertainty_Behv_Trigger.txt',outputdir,Pindex),'w+t');
    %     fp2=fopen(sprintf('%s/Pt%d_Uncertainty_Cursor_Position.txt',outputdir,Pindex),'w+t');
    %     fp1=fopen(sprintf('%s/Pt%d_Uncertainty_Trigger_Codes.txt',outputdir,Pindex),'w+t');
    State='MedicineOff';
    for k=1:3
        flnm=sprintf('%s/%s%d_Uncertainty1.bin',Drc,State,k);
        bd=BinaryReadWdbs(flnm);
        if isempty(bd)
            continue;
        end
        Tr=size(bd,2);
        BehvInfo_PatientIndex=cat(1,BehvInfo_PatientIndex,Pindex*ones(Tr,1));
        tmp=cell(Tr,1);
        [tmp{:}]=deal(State);
        BehvInfo_State=cat(1,BehvInfo_State,tmp);
        BehvInfo_Session=cat(1,BehvInfo_Session,k*ones(Tr,1));
        
        for t=1:Tr
            BehvInfo_Trial=cat(1,BehvInfo_Trial,bd(t).behv.r(1));
            BehvInfo_FirstCue=cat(1,BehvInfo_FirstCue,bd(t).behv.r(11));
            BehvInfo_SecondCue=cat(1,BehvInfo_SecondCue,bd(t).behv.r(12));
            BehvInfo_ThirdCue=cat(1,BehvInfo_ThirdCue,bd(t).behv.r(13));
            BehvInfo_Target=cat(1,BehvInfo_Target,bd(t).behv.r(14));
            BehvInfo_CenterHoldTime=cat(1,BehvInfo_CenterHoldTime,bd(t).behv.r(4));
            BehvInfo_TargetFillTime=cat(1,BehvInfo_TargetFillTime,bd(t).behv.r(6));
            BehvInfo_MoveOnsetTime=cat(1,BehvInfo_MoveOnsetTime,bd(t).behv.r(7));
            BehvInfo_EnterTargetTime=cat(1,BehvInfo_EnterTargetTime,bd(t).behv.r(8));
            BehvInfo_ErrorCode=cat(1,BehvInfo_ErrorCode,bd(t).behv.r(2));
            
            % Patient State Session Trial FirstCue SecondCue ThirdCue Target ErrorCode
            %             fprintf(fp,'Pt%d %3s %d %2d %3d %3d %3d %3d %2d\n',Pindex, State, k, bd(t).behv.r(1), bd(t).behv.r(11), bd(t).behv.r(12), bd(t).behv.r(13), bd(t).behv.r(14), bd(t).behv.r(2));
            %             %fprintf('Pt%2d %3s %d %2d %3d %3d %3d %3d %2d\n',Pindex, State, k, bd(t).behv.r(1), bd(t).behv.r(11), bd(t).behv.r(12), bd(t).behv.r(13), bd(t).behv.r(14), bd(t).behv.r(2));
            %
            %             pV=Pindex*ones(size(bd(t).posx.d));
            %             sV=repmat(State,length(bd(t).posx.d),1);
            %             kV=k*ones(size(bd(t).posx.d));
            %             tV=t*ones(size(bd(t).posx.d));
            %             eV=bd(t).behv.r(2)*ones(size(bd(t).posx.d)); % Error Vector
            %             dV=bd(t).behv.r(14)*ones(size(bd(t).posx.d)); % Direction Vector
            %             %milliseconds
            %             time_center_hold=bd(t).behv.r(4);
            %             time_analog_coll_start=bd(t).behv.r(5);
            %             time_target_on=bd(t).behv.r(6);
            %             time_move_onset=bd(t).behv.r(7);
            %             time_enter_target=bd(t).behv.r(8);
            % %             time_reward=bd(t).behv.r(9);
            %             % Patient State Session Trial Center_Hold_Time Analog_Coll_Time
            %             % Target_On_Time Move_Onset_Time Enter_Target_Time ErrorCode
            %             fprintf(fp1,'Pt%d %3s %d %2d %d %d %d %d %d %2d\n',Pindex,State,k,bd(t).behv.r(1),time_center_hold,time_analog_coll_start,time_target_on,time_move_onset,time_enter_target,bd(t).behv.r(2));
            %             % Patient State Session Trial PosX PosY Target ErrorCode
            %             F=[num2cell(pV); cellstr(sV)'; num2cell([kV; tV; bd(t).posx.d; bd(t).posy.d; dV; eV] )];
            %             %fprintf('Pt%d %12s %d %2d %3d %3d %2d %2d\n',F{:});
            %             fprintf(fp2,'Pt%d %12s %d %2d %3d %3d %2d %2d\n',F{:});
            % Patient State Session Trial CenterHold ShowTarget FillTarget MoveToTarget TargetEnter TrialEnd Angle1 Angle2 Angle3 TargetAngle  ErrorCode
            %             fprintf(fp1,'Pt%d %3s %d %2d %8d ', Pindex, State, k, bd(t).behv.r(1), task.data.triggerCodes(t,:)');
            %             fprintf(fp1,'\n');
            
            
            
        end
        
    end
    
    State='MedicineOn';
    for k=1:3
        flnm=sprintf('%s/%s%d_Uncertainty1.bin',Drc,State,k);
        bd=BinaryReadWdbs(flnm);
        if isempty(bd)
            continue;
        end
        Tr=size(bd,2);
        
        BehvInfo_PatientIndex=cat(1,BehvInfo_PatientIndex,Pindex*ones(Tr,1));
        tmp=cell(Tr,1);
        [tmp{:}]=deal(State);
        BehvInfo_State=cat(1,BehvInfo_State,tmp);
        BehvInfo_Session=cat(1,BehvInfo_Session,k*ones(Tr,1));
        
        for t=1:Tr
            
            BehvInfo_Trial=cat(1,BehvInfo_Trial,bd(t).behv.r(1));
            BehvInfo_FirstCue=cat(1,BehvInfo_FirstCue,bd(t).behv.r(11));
            BehvInfo_SecondCue=cat(1,BehvInfo_SecondCue,bd(t).behv.r(12));
            BehvInfo_ThirdCue=cat(1,BehvInfo_ThirdCue,bd(t).behv.r(13));
            BehvInfo_Target=cat(1,BehvInfo_Target,bd(t).behv.r(14));
            BehvInfo_CenterHoldTime=cat(1,BehvInfo_CenterHoldTime,bd(t).behv.r(4));
            BehvInfo_TargetFillTime=cat(1,BehvInfo_TargetFillTime,bd(t).behv.r(6));
            BehvInfo_MoveOnsetTime=cat(1,BehvInfo_MoveOnsetTime,bd(t).behv.r(7));
            BehvInfo_EnterTargetTime=cat(1,BehvInfo_EnterTargetTime,bd(t).behv.r(8));
            BehvInfo_ErrorCode=cat(1,BehvInfo_ErrorCode,bd(t).behv.r(2));
            %             % Patient State Session Trial FirstCue SecondCue ThirdCue Target ErrorCode
            %             fprintf(fp,'Pt%d %3s %d %2d %3d %3d %3d %3d %2d\n',Pindex, State, k, bd(t).behv.r(1), bd(t).behv.r(11), bd(t).behv.r(12), bd(t).behv.r(13), bd(t).behv.r(14), bd(t).behv.r(2));
            %             %fprintf('Pt%2d %3s %d %2d %3d %3d %3d %3d %2d\n',Pindex, State, k, bd(t).behv.r(1), bd(t).behv.r(11), bd(t).behv.r(12), bd(t).behv.r(13), bd(t).behv.r(14), bd(t).behv.r(2));
            %             time_center_hold=bd(t).behv.r(4);
            %             time_analog_coll_start=bd(t).behv.r(5);
            %             time_target_on=bd(t).behv.r(6);
            %             time_move_onset=bd(t).behv.r(7);
            %             time_enter_target=bd(t).behv.r(8);
            % %             time_reward=bd(t).behv.r(9);
            %             % Patient State Session Trial Center_Hold_Time Analog_Coll_Time
            %             % Target_On_Time Move_Onset_Time Enter_Target_Time ErrorCode
            %             fprintf(fp1,'Pt%d %3s %d %2d %d %d %d %d %d %2d\n',Pindex,State,k,bd(t).behv.r(1),time_center_hold,time_analog_coll_start,time_target_on,time_move_onset,time_enter_target,bd(t).behv.r(2));
            %
            %             pV=Pindex*ones(size(bd(t).posx.d));
            %             sV=repmat(State,length(bd(t).posx.d),1);
            %             kV=k*ones(size(bd(t).posx.d));
            %             tV=t*ones(size(bd(t).posx.d));
            %             eV=bd(t).behv.r(2)*ones(size(bd(t).posx.d)); % Error Vector
            %             dV=bd(t).behv.r(14)*ones(size(bd(t).posx.d)); % Direction Vector
            %             % Patient State Session Trial PosX PosY Target ErrorCode
            %             F=[num2cell(pV); cellstr(sV)'; num2cell([kV; tV; bd(t).posx.d; bd(t).posy.d; dV; eV] )];
            %             %fprintf('Pt%d %12s %d %2d %3d %3d %2d %2d\n',F{:});
            %             fprintf(fp2,'Pt%d %12s %d %2d %3d %3d %2d %2d\n',F{:});
            % Patient State Session Trial CenterHold ShowTarget FillTarget MoveToTarget TargetEnter TrialEnd Angle1 Angle2 Angle3 TargetAngle  ErrorCode
            %             fprintf(fp1,'Pt%d %3s %d %2d %8d ', Pindex, State, k, bd(t).behv.r(1), task.data.triggerCodes(t,:)');
            %             fprintf(fp1,'\n');
        end
        
    end
    %
    %     fclose(fp);
    % %     fclose(fp1);
    %     fclose(fp2);
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

save('BehvInfo.mat','-struct','BehvInfo');