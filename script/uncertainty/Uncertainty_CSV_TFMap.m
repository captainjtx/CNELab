%This script will generate CSV files with the following format:
%Pt, Med_Status(Off=0, On=1), Number of Targets,
%0.5s Before Target, 0.5s After Target,
%0.5s Before Go, 0.5s Centered on Exit
%%
pid=[1,2,3,4,5,10];
mdir='/Users/tengi/Desktop/Projects/data/uncertainty/Analysis/2015-01-07';
state={'MedicineOff','MedicineOn'};

BipolarLFPNames={'LFP1-2','LFP2-3','LFP3-4'};
Alignments={'Target','Go','Exit'};

fl=[1,13,40];
fh=[7,30,90];

fname='uncertainty_ave_power.csv';

fid=fopen(fname,'w+');

%Pt, Med_Status(Off=0, On=1), Number of Targets,
%0.5s Before Target(Delta,Beta,Gamma), 0.5s After Target(Delta,Beta,Gamma)
%0.5s Before Go(Delta,Beta,Gamma), 0.5s After Exit(Delta, Beta, Gamma)

fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s',...
    'Pt','Med','Targets',...
    'delta_before_target','beta_before_target','gamma_before_target',...
    'delta_after_target','beta_after_target','gamma_after_target',...
    'delta_before_go','beta_before_go','gamma_before_go',...
    'delta_exit_centered','beta_exit_centered','gamma_exit_centered');

%%
count=0;
for pt=1:length(pid)
    for s=1:length(state)
        
        listings=dir([mdir,'/Pt',num2str(pid(pt)),' ',state{s},'*.mat']);
        ave_tfmap=cell(3,4);
        
        for i=1:3
            ave_tfmap{i,4}=0;
        end
        
        bnum=0;
        for l=1:length(listings)
            tfmat=load(fullfile(mdir,listings(l).name),'-mat');
            
            for i=1:3
                ave_tfmap{i,4}=ave_tfmap{i,4}+tfmat.map{i,4}*tfmat.trialNum{1,1};
            end
            
            bnum=bnum+tfmat.trialNum{1,1};
        end
        
        for target=1:2
            listings=dir([mdir,'/Pt',num2str(pid(pt)),' ',state{s},'*TargetNum',num2str(target),'.mat']);
            
            for i=1:3
                for j=1:3
                    ave_tfmap{i,j}=0; 
                end
            end
            
            num=0;
            for l=1:length(listings)
                tfmat=load(fullfile(mdir,listings(l).name),'-mat');
                
                for i=1:3
                    for j=1:3
                        ave_tfmap{i,j}=ave_tfmap{i,j}+tfmat.map{i,j}*tfmat.trialNum{1,1};
                    end
                end
                num=num+tfmat.trialNum{1,1};
            end
            count=count+1;
            fprintf(fid,'\n%d,%d,%d',pid(pt),s-1,target);
            for j=1:3
                switch j
                    case 1
                        tmin=[-0.9,0];
                        tmax=[-0.4,0.5];
                    case 2
                        tmin=-0.5;
                        tmax=0;
                    case 3
                        tmin=-0.25;
                        tmax=0.25;
                end
                
                for ite1=1:length(tmin)
                    for fi=1:length(fl)
                        relative_tfmat=0;
                        t1=tmin(ite1);
                        t2=tmax(ite1);
                        for i=1:3
                            t=tfmat.t{i,j};
                            f=tfmat.f{i,j};
                            tmp =(ave_tfmap{i,j}/num)./(repmat(ave_tfmap{i,4},1,size(ave_tfmap{i,j},2))/bnum);
                            
                            relative_tfmat=relative_tfmat+mean(mean(20*log10(tmp(f>=fl(fi)&f<=fh(fi),(t>=t1)&(t<=t2)))));
                        end
                        fprintf(fid,',%6.4f',relative_tfmat/3);
                    end
                end
                
                
            end
            
        end
    end
end