clc
clear

%%
mdir='/Users/tengi/Desktop/Projects/data/uncertainty/NeuroData/tmp';

files=dir(mdir);
%ipsilateral versus contralateral

ip_tfmap=[];
con_tfmap=[];

wd=256;
ov=250;

n=0;

weight=zeros(10,1);
pid=[];

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
        mref=dat(:,ismember(channames,{'C3','C4','O1','O2','P3','P4','F3','F4'}),:);
        
        for s=1:size(dat,3)
            dat(:,:,s)=dat(:,:,s)-mean(mref(:,:,s),2)*ones(1,size(dat,2));
        end
        c3=ismember(channames,'O1');
        c4=ismember(channames,'O2');

        n=n+1;
        nref=[1,cds.fs];
        
        weight(fnameInfo{1})=weight(fnameInfo{1})+1;
        
        if strcmpi(fnameInfo{4},'LeftSTN')
            [tf,f,t]=tfpower(squeeze(dat(:,c3,:)),[],cds.fs,wd,ov,nref);
            
            ip_tfmap=cat(3,ip_tfmap,tf);
            
            [tf,f,t]=tfpower(squeeze(dat(:,c4,:)),[],cds.fs,wd,ov,nref);
            
            con_tfmap=cat(3,con_tfmap,tf);
        else
            [tf,f,t]=tfpower(squeeze(dat(:,c4,:)),[],cds.fs,wd,ov,nref);
            ip_tfmap=cat(3,ip_tfmap,tf);
            
            [tf,f,t]=tfpower(squeeze(dat(:,c3,:)),[],cds.fs,wd,ov,nref);
            con_tfmap=cat(3,con_tfmap,tf);
        end
        
        pid(size(ip_tfmap,3))=fnameInfo{1};
    end
end
ip=0;
con=0;
for i=1:size(ip_tfmap,3)
    ip=ip_tfmap(:,:,i)/weight(pid(i))+ip;
    con=con_tfmap(:,:,i)/weight(pid(i))+con;
end

ip=ip/length(find(weight));
con=con/length(find(weight));
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