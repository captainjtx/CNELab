%Compute the averaged time-frequency map
%Writtne by Tianxiao Jiang
%Go aligned

clc
clear

pid=[1,2,3,4,5,10];

mdir='/Users/tengi/Desktop/Projects/data/uncertainty/Analysis/01-23-2015/data';

state={'MedicineOff','MedicineOn'};
%pt, channel, 
off=[1,2;...
     2,1;...
     3,2;...
     4,2;...
     5,2;...
     10,1];
 
 on=[1,3;...
     2,1;...
     3,2;...
     4,1;...
     5,2;...
     10,3]; 
 
 chan_sel{1}=off;
 chan_sel{2}=on;

BipolarLFPNames={'LFP1-2','LFP2-3','LFP3-4'};

fs=512;

wd=128;
ov=120;

base_start=1;
base_len=1;

task_start=2;
task_len=4;

for s=1:length(state)
    figure('Name',state{s},'Position',[0,0,400,300]);
    listings=dir([mdir,'/*',state{s},'*.mat']);
    ave_tfmap=0;
    base_tfmap=0;
    for l=1:length(listings)
        start_ind=regexp(listings(l).name,' ');
        pt=str2double(listings(l).name(3:start_ind-1));
        
        tfmat=load(fullfile(mdir,listings(l).name),'-mat');
        for i=1:3
            if i~=chan_sel{s}(chan_sel{s}(:,1)==pt,2)
                continue
            end
            for j=1:size(tfmat.baseline{i},2)
                [tf,f,t]=tfmap(tfmat.task{i}(:,j),fs,wd,ov);
                [btf,bf,bt]=tfmap(tfmat.baseline{i}(:,j),fs,wd,ov);
                
                ave_tfmap=ave_tfmap+tf;
                base_tfmap=base_tfmap+btf;
            end
        end
    end
    
    ave_tfmap=ave_tfmap./repmat(mean(base_tfmap,2),1,size(ave_tfmap,2));
    
    [SMOOTHED] = cnelab_TF_Smooth(ave_tfmap,'gaussian',[4,10]);
    t=t-1;
    imagesc(t,f,20*log10(SMOOTHED),[-6 6]);
    %                 ylabel('Frequency(Hz)')
    ylim([f(1),100])
    xlim([t(1),t(end)])
    colormap(jet);
    axis xy;
%     set(gca,'ytick',[])
    colorbar
end
