clear;

Study='LFPII';
Experiment='PostOR';
Task='Uncertainty';
NoSbj=6;

MainDrc=['E:\Parkinson_LFP\MatlabData\' Study '\' Experiment  ];
cd([MainDrc '\Matfiles\']);
sinfo = matnametxt('..' , Study, Experiment, 2);

Drc='E:\\Parkinson_LFP\\MatlabData\\LFPII\\PostOR\\';
fp=fopen(sprintf('%s\\Uncertainty_Trigger Codes.txt',Drc),'w+t');
Hdr='Patient State Session Trial CenterHold ShowTarget FillTarget MoveToTarget TargetEnter TrialEnd Angle1 Angle2 Angle3 TargetAngle  ErrorCode';
fprintf(fp,'%s\n',Hdr);

MedicineState='MedicineOff';
Pix=cellstr(num2str([1:NoSbj]'));
Ix=strcmpi({sinfo.Experiment},Experiment) & strcmpi({sinfo.Study},Study) & ismember({sinfo.PatientIndex},Pix) & strcmpi({sinfo.Task},Task) & strcmpi({sinfo.MedicineState},MedicineState);
K=find(Ix);

for k=1:length(K)
    load(sinfo(K(k)).FileName);
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
Pix=cellstr(num2str([1:NoSbj]'));
Ix=strcmpi({sinfo.Experiment},Experiment) & strcmpi({sinfo.Study},Study) & ismember({sinfo.PatientIndex},Pix) & strcmpi({sinfo.Task},Task) & strcmpi({sinfo.MedicineState},MedicineState);
K=find(Ix);

for k=1:length(K)
    load(sinfo(K(k)).FileName);
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
