clc
clear

%%
mdir='/Users/tengi/Desktop/Projects/data/uncertainty/NeuroData/tmp';

txtFile='/Users/tengi/Desktop/Projects/data/uncertainty/Analysis/2016-02-01/eeg_baseline.csv';

files=dir(mdir);
%ipsilateral versus contralateral

ip_tfmap=[];
con_tfmap=[];

wd=256;
ov=250;

n=0;

order=2;
fl=0.5;

fs=512;

[b,a]=butter(order,fl/(fs/2),'high');

fid=fopen(txtFile,'w');
fprintf(fid,'Pt,Med,Session,Chan,LeftRight');
flag=true;

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
        for t=1:size(dat,3)
            dat(:,:,i)=filter_symmetric(b,a,dat(:,:,i),fs,0,'iir');
        end
        
        mref=dat(:,ismember(channames,{'C3','C4','O1','O2','P3','P4','F3','F4'}),:);
        
        %mean referenced***************************************************
        for s=1:size(dat,3)
            dat(:,:,s)=dat(:,:,s)-mean(mref(:,:,s),2)*ones(1,size(dat,2));
        end
        %******************************************************************
        
        n=n+1;
        nref=[1,cds.fs];
        
        for t=1:size(dat,3)
            for c=1:size(dat,2)
                [tf,f,~]=tfpower(dat(:,c,t),[],cds.fs,wd,ov,[]);
                
                if flag
                    for fi=1:length(f)-1
                        fprintf(fid,'%f,',f(fi));
                    end
                    fprintf(fid,'%f\n',f(end));
                    flag=false;
                end
            end
        end
    end
end

%%
figure('position',[100,100,800,300])
subplot(1,2,1)
imagesc(t-1,f,TF_Smooth(10*log10(ip),'gaussian',[8,8]),[-2,2]);
colormap jet
title('Ipsilateral O1/O2')
axis xy
xlabel('Time(s)')
ylabel('Frequency(Hz)')
ylim([0,48])
set(gca,'fontsize',20);
colorbar

subplot(1,2,2)
imagesc(t-1,f,TF_Smooth(10*log10(con),'gaussian',[8,8]),[-2,2]);
title('Contralateral O1/O2');
colormap jet
axis xy
xlabel('Time(s)')
ylabel('Frequency(Hz)')
ylim([0,48]);

set(gca,'fontsize',20);
set(gcf,'color','w');
colorbar