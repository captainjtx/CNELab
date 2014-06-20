clc;
Pindexs=[1 2 3 4 5 6 10];

outputdir='/Users/tengi/Desktop/Projects/BMI/data/Uncertainty/BehvData';
% matfiledir='/Users/tengi/Desktop/Projects/BMI/data/Uncertainty/NeuroData';

% matfiles=dir(matfiledir);

for i=1:7
    Pindex=Pindexs(i);
    Patients={'Dennis Walsh',...
        'William Yetzer',...
        'Nyle Wollenhaupt',...
        'Richard Riedasch',...
        'Ilona Kolos',...
        'Raymond Vandeveer',...
        'Boris Star'};
    
    Drc=sprintf('/Users/tengi/Desktop/Projects/BMI/data/Uncertainty/BehvData/%s',Patients{i});
    
    fprintf('Processing %s\n',sprintf('%s/Pt%d_Error_Code.txt',Drc,Pindex));
    
    fp=fopen(sprintf('%s/Pt%d_Uncertainty_Error_Code.txt',outputdir,Pindex),'w+t');
    fp2=fopen(sprintf('%s/Pt%d_Uncertainty_Cursor_Position.txt',outputdir,Pindex),'w+t');
%     fp1=fopen(sprintf('%s/Pt%d_Uncertainty_Trigger_Codes.txt',outputdir,Pindex),'w+t');
    
    
    State='MedicineOff';
    for k=1:3
        flnm=sprintf('%s/%s%d_Uncertainty1.bin',Drc,State,k);
        bd=BinaryReadWdbs(flnm);
        if isempty(bd)
            continue;
        end
        Tr=size(bd,2);
        
        
%         matfilename=strcat('Pt',num2str(Pindex),'_LFPII_PD_PostOR_',State,'_',num2str(k),'_Uncertainty');
%         
%         for f=1:length(matfiles)
%             if ~isempty(regexp(matfiles(f).name,matfilename,'once'))
%                 matfilename=matfiles(f).name;
%             end
%         end
%         
%         task=load(fullfile(matfiledir,matfilename),'-mat');
        for t=1:Tr
            % Patient State Session Trial FirstCue SecondCue ThirdCue Target ErrorCode
            fprintf(fp,'Pt%d %3s %d %2d %3d %3d %3d %3d %2d\n',Pindex, State, k, bd(t).behv.r(1), bd(t).behv.r(11), bd(t).behv.r(12), bd(t).behv.r(13), bd(t).behv.r(14), bd(t).behv.r(2));
            %fprintf('Pt%2d %3s %d %2d %3d %3d %3d %3d %2d\n',Pindex, State, k, bd(t).behv.r(1), bd(t).behv.r(11), bd(t).behv.r(12), bd(t).behv.r(13), bd(t).behv.r(14), bd(t).behv.r(2));
            
            pV=Pindex*ones(size(bd(t).posx.d));
            sV=repmat(State,length(bd(t).posx.d),1);
            kV=k*ones(size(bd(t).posx.d));
            tV=t*ones(size(bd(t).posx.d));
            eV=bd(t).behv.r(2)*ones(size(bd(t).posx.d)); % Error Vector
            dV=bd(t).behv.r(14)*ones(size(bd(t).posx.d)); % Direction Vector
            % Patient State Session Trial PosX PosY Target ErrorCode
            F=[num2cell(pV); cellstr(sV)'; num2cell([kV; tV; bd(t).posx.d; bd(t).posy.d; dV; eV] )];
            %fprintf('Pt%d %12s %d %2d %3d %3d %2d %2d\n',F{:});
            fprintf(fp2,'Pt%d %12s %d %2d %3d %3d %2d %2d\n',F{:});
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
        
        
%         matfilename=strcat('Pt',num2str(Pindex),'_LFPII_PD_PostOR_',State,'_',num2str(k),'_Uncertainty');
%         
%         for f=1:length(matfiles)
%             if ~isempty(regexp(matfiles(f).name,matfilename,'once'))
%                 matfilename=matfiles(f).name;
%             end
%         end
%         
%         task=load(fullfile(matfiledir,matfilename),'-mat');
        
        for t=1:Tr
            % Patient State Session Trial FirstCue SecondCue ThirdCue Target ErrorCode
            fprintf(fp,'Pt%d %3s %d %2d %3d %3d %3d %3d %2d\n',Pindex, State, k, bd(t).behv.r(1), bd(t).behv.r(11), bd(t).behv.r(12), bd(t).behv.r(13), bd(t).behv.r(14), bd(t).behv.r(2));
            %fprintf('Pt%2d %3s %d %2d %3d %3d %3d %3d %2d\n',Pindex, State, k, bd(t).behv.r(1), bd(t).behv.r(11), bd(t).behv.r(12), bd(t).behv.r(13), bd(t).behv.r(14), bd(t).behv.r(2));
            
            pV=Pindex*ones(size(bd(t).posx.d));
            sV=repmat(State,length(bd(t).posx.d),1);
            kV=k*ones(size(bd(t).posx.d));
            tV=t*ones(size(bd(t).posx.d));
            eV=bd(t).behv.r(2)*ones(size(bd(t).posx.d)); % Error Vector
            dV=bd(t).behv.r(14)*ones(size(bd(t).posx.d)); % Direction Vector
            % Patient State Session Trial PosX PosY Target ErrorCode
            F=[num2cell(pV); cellstr(sV)'; num2cell([kV; tV; bd(t).posx.d; bd(t).posy.d; dV; eV] )];
            %fprintf('Pt%d %12s %d %2d %3d %3d %2d %2d\n',F{:});
            fprintf(fp2,'Pt%d %12s %d %2d %3d %3d %2d %2d\n',F{:});
            % Patient State Session Trial CenterHold ShowTarget FillTarget MoveToTarget TargetEnter TrialEnd Angle1 Angle2 Angle3 TargetAngle  ErrorCode
%             fprintf(fp1,'Pt%d %3s %d %2d %8d ', Pindex, State, k, bd(t).behv.r(1), task.data.triggerCodes(t,:)');
%             fprintf(fp1,'\n');
        end
        
    end
    
    fclose(fp);
    fclose(fp1);
    fclose(fp2);
end