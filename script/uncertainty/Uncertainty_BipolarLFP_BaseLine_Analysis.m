%This script calculate the Bipolar LFP of Baseline
%By Tianxiao Jiang
clc
clear

segDir='/Users/tengi/Desktop/Projects/data/uncertainty/Analysis/2014-09-19/BipolarLFP_BaseLine_Segments.mat';
infoDir='/Users/tengi/Desktop/Projects/data/uncertainty/Analysis/2014-09-01/TrialsInfo.mat';

txtFileDir='/Users/tengi/Desktop/Projects/data/uncertainty/Analysis/2015-12-08/freq_val.csv';

outputdir='/Users/tengi/Desktop/Projects/data/uncertainty/Analysis/2015-12-08';

segs=load(segDir);
BipolarLFP_BaseLine=segs.PreTrialSegs;

info=load(infoDir);
TrialInfo=info.TrialInfo;

%Compute the TF Map
pt=unique(TrialInfo.Patient);

fs=512;
fh=250;

wd=512;
ov=256;
nfft=1024;

lfpbp1=[];
lfpbp2=[];
lfpbp3=[];

BipolarLFPNames={'LFP Bipolar1','LFP Bipolar2','LFP Bipolar3'};
State={'MedicineOff','MedicineOn'};
for i=1:size(BipolarLFP_BaseLine,3)
    BipolarLFP_BaseLine(:,:,i)=detrend(BipolarLFP_BaseLine(:,:,i));
end

fid=fopen(txtFileDir,'w');
fprintf(fid,'Pt,Med,Session,Chan,');  
flag=true;
for i=1:length(pt)
    %pt_i medicine off
    figure('Name',['Pt',num2str(pt(i))],'Position',[0,0,1200,600])
    for j=1:size(BipolarLFP_BaseLine,3)
        
        indpt=TrialInfo.Patient==pt(i);
        ss=sort(unique(TrialInfo.Session(indpt)));
        for ses=1:length(ss)
            prdg=[];
            indpt_ses=(TrialInfo.Session==ss(ses))&indpt;
            subplot(length(BipolarLFPNames),length(ss)+1,(j-1)*(length(ss)+1)+ses+1)
            st={};
            
            for s=1:length(State)
                
                
                ind1=indpt_ses&(strcmpi(TrialInfo.State,State{s}));
                if ~any(ind1)
                    continue
                end
                bldata=BipolarLFP_BaseLine(:,ind1,:);
                
                pxx=0;
                for m=1:size(bldata,2)
                    tmp=pwelch(bldata(:,m,j),wd,ov,nfft);
                    tmp=abs(tmp);
                    pxx=pxx+tmp;
                end
                
                pxx=pxx/size(bldata,2);
                prdg=cat(2,prdg,reshape(pxx,length(pxx),1));
                st=cat(1,st,State{s});
            end
            
            n=round(size(prdg,1)/(fs/2)*fh);
            f=linspace(0,fh,n);
            
            if flag
                for vali=1:length(f)-1
                    fprintf(fid,'%f,',f(vali));
                end
                fprintf(fid,'%f\n',f(end));
                flag=false;
            end
            
            for txti=1:size(prdg,2)
                info=['Pt',num2str(pt(i)),',',BipolarLFPNames{j},',','Session',num2str(ss(ses)),',',st{txti},'\n'];
                fprintf(fid,'%d,%s,%d,%d,',pt(i),st{txti}(9:end),ss(ses),j);
                
                for vali=1:length(f)-1
                    fprintf(fid,'%e,',prdg(vali,txti));
                end
                fprintf(fid,'%e\n',prdg(end,txti));
                
%                 dlmwrite(txtFileDir,[f;prdg(1:n,txti)'],'delimiter',',','-append');
            end
            
            plot(f'*ones(1,size(prdg,2)),prdg(1:n,:));
            
            
            xlabel('Frequency(Hz)')
            ylabel('Magnitude');
            title(['Session  ',num2str(ss(ses))]);
            legend(st{:})
            
            
        end
        st={};
        ave_prdg=[];
        for s=1:length(State)
            ind1=indpt&(strcmpi(TrialInfo.State,State{s}));
            bldata=BipolarLFP_BaseLine(:,ind1,:);
            
            pxx=0;
            for m=1:size(bldata,2)
                tmp=pwelch(bldata(:,m,j),wd,ov,nfft);
                tmp=abs(tmp);
                pxx=pxx+tmp;
            end
            
            pxx=pxx/size(bldata,2);
            ave_prdg=cat(2,ave_prdg,reshape(pxx,length(pxx),1));
            st=cat(1,st,State{s});
        end
        subplot(length(BipolarLFPNames),length(ss)+1,(j-1)*(length(ss)+1)+1)
        
        n=round(size(ave_prdg,1)/(fs/2)*fh);
        f=linspace(0,fh,n);
        plot(f'*ones(1,size(ave_prdg,2)),20*log10(ave_prdg(1:n,:)));
        xlabel('Frequency(Hz)')
        ylabel('Log Power');
        title([BipolarLFPNames{j}]);
        legend(st{:})
    end
    export_fig(gcf,['-','png'],'-nocrop','-opengl','-r300',fullfile(outputdir,get(gcf,'Name')));
    %     saveas(gcf,[get(gcf,'Name'),'.png'])
        close(gcf)
    
end

fclose(fid);

