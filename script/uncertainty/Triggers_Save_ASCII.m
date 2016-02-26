clear;
clc;

Study='LFPII';
Experiment='PostOR';
Task='Uncertainty';
NoSbj=6;

MainDrc=uigetdir(matlabroot,'Select the folder of the Mat files');
if ~MainDrc
    return
end

sinfo = matnametxt(MainDrc , Study, Experiment, 2);

Drc=MainDrc;

fp=fopen(sprintf('%s\\Uncertainty_Trigger Codes.txt',Drc),'w+t');
Hdr='Patient State Session Trial CenterHold ShowTarget FillTarget MoveToTarget TargetEnter TrialEnd Angle1 Angle2 Angle3 TargetAngle  ErrorCode';
fprintf(fp,'%s\n',Hdr);

Pix={'1','2','3','4','5','10'};

MedicineState='MedicineOff';

Ix=         strcmpi({sinfo.Experiment},Experiment) & ...
            strcmpi({sinfo.Study},Study) & ...
            ismember({sinfo.PatientIndex},Pix) & ...
            strcmpi({sinfo.Task},Task) & ...
            strcmpi({sinfo.MedicineState},MedicineState);
K=find(Ix);

for k=1:length(K)
    load(fullfile(MainDrc,sinfo(K(k)).FileName));
    fprintf('%s\n',sinfo(K(k)).FileName);
    Tr=size(data.triggerCodes,1);
    for t=1:Tr
        % Patient State Session Trial CenterHold ShowTarget FillTarget MoveToTarget TargetEnter TrialEnd Angle1 Angle2 Angle3 TargetAngle  ErrorCode
        fprintf(fp,'Pt%d %11s %d %2d ', patientInfo.Index, MedicineState, patientInfo.StateIndex, t);
        fprintf(fp,'%8d', data.triggerCodes(t,:));
        fprintf(fp,'\n');
    end
end


MedicineState='MedicineON';

Ix=strcmpi({sinfo.Experiment},Experiment) & strcmpi({sinfo.Study},Study) & ismember({sinfo.PatientIndex},Pix) & strcmpi({sinfo.Task},Task) & strcmpi({sinfo.MedicineState},MedicineState);
K=find(Ix);

for k=1:length(K)
    load(fullfile(MainDrc,sinfo(K(k)).FileName));
    fprintf('%s\n',sinfo(K(k)).FileName);
    Tr=size(data.triggerCodes,1);
    for t=1:Tr
        % Patient State Session Trial CenterHold ShowTarget FillTarget MoveToTarget TargetEnter TrialEnd Angle1 Angle2 Angle3 TargetAngle  ErrorCode
        fprintf(fp,'Pt%d %11s %d %2d ', patientInfo.Index, MedicineState, patientInfo.StateIndex, t);
        fprintf(fp,'%8d', data.triggerCodes(t,:));
        fprintf(fp,'\n');
    end
end

fclose(fp);
