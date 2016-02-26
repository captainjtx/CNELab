clc
clear

%%
mdir='/Users/tengi/Desktop/Projects/data/uncertainty/NeuroData';

txtFile='/Users/tengi/Desktop/Projects/data/uncertainty/Analysis/2016-02-25/eeg_baseline_info.csv';
powFile='/Users/tengi/Desktop/Projects/data/uncertainty/Analysis/2016-02-25/eeg_baseline_pow.csv';

files=dir(mdir);
%ipsilateral versus contralateral

ip_tfmap=[];
con_tfmap=[];

wd=512;
ov=500;

n=0;

order=2;
fl=0.5;

fs=512;

[b,a]=butter(order,fl/(fs/2),'high');

fid=fopen(txtFile,'w');

powid=fopen(powFile,'w');

fprintf(fid,'Pt,Med,Session,LeftRight,Chan\n');
flag=true;

eeg={'C3','C4','O1','O2','P3','P4','F3','F4'};
for i=1:length(files)
    [~,~,ext]=fileparts(files(i).name);
    if strcmp(ext,'.cds')
        fnameInfo=textscan(files(i).name(1:end-4),'Pt%dLFPII_PD_PostOR_%s%dUncertainty_%s',...
            'delimiter','_');
        %fnameInfo:
        %1, Patient ID
        %2, Medicine State
        %3, Session
        %4, Right/Left STN
        
        cds=CommonDataStructure.Load(fullfile(mdir,files(i).name));
        [dat,channames]=cds.get_trials('cue',1,1);
        dat=double(dat);
        
        dat=dat(:,ismember(channames,eeg),:);
        
        for t=1:size(dat,3)
            dat(:,:,t)=filter_symmetric(b,a,dat(:,:,t),fs,0,'iir');
        end
        
        %mean referenced***************************************************
        for s=1:size(dat,3)
            dat(:,:,s)=dat(:,:,s)-mean(dat(:,:,s),2)*ones(1,size(dat,2));
        end
        %******************************************************************
        
        for t=1:size(dat,3)
            for c=1:size(dat,2)
                [tf,f,time]=tfpower(dat(:,c,t),[],cds.fs,wd,ov,[]);
                
                if flag
                    for fi=1:length(f)-1
                        fprintf(powid,'%d,',f(fi));
                    end
                    fprintf(powid,'%d\n',f(end));
                    flag=false;
                end
                
                fprintf(fid ,'%d,%s,%d,%s,%s\n',fnameInfo{1},fnameInfo{2}{:},fnameInfo{3},fnameInfo{4}{:},eeg{c});
                for fi=1:length(f)-1
                    fprintf(powid,'%e,',mean(tf(fi,time>=0&time<1)));
                end
                fprintf(powid,'%e',mean(tf(length(f),time>=0&time<1)));
                fprintf(powid,'\n');
            end
        end
    end
end
fclose(fid);
fclose(powid);

%%