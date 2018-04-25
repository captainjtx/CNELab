%Average the TFMap of Single Multiple target analysis
%Written by Jiang Tianxiao
clc
clear

pid=[1,2,3,4,5,10];
mdir='/Users/tengi/Desktop/Projects/data/uncertainty/Analysis/2015-01-07';
state={'MedicineOff','MedicineOn'};

BipolarLFPNames={'LFP1-2','LFP2-3','LFP3-4'};
Alignments={'Target','Go','Exit'};

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
            
            
            figure('Name',['Pt', num2str(pid(pt)),' ',state{s},' T',num2str(target)],...
                'Position',[0,0,800,540]);
            
            for i=1:3
                for j=1:3
                    axes('Units','Pixels','Position',[140+(j-1)*210,180*(3-i)+20,180,140]);
                    t=tfmat.t{i,j};
                    f=tfmat.f{i,j};
                    [SMOOTHED] = cnelab_TF_Smooth((ave_tfmap{i,j}/num)./(repmat(ave_tfmap{i,4},1,size(ave_tfmap{i,j},2))/bnum),'gaussian',[4,10]);
                    imagesc(t,f,20*log10(SMOOTHED),[-10 10]);
                    %                 ylabel('Frequency(Hz)')
                    ylim([f(1),100])
                    t=title([BipolarLFPNames{i},' ',Alignments{j}]);
                    set(t,'FontSize',10);
                    colormap(jet);
                    axis xy;
                    set(gca,'ytick',[])
                    
                    a=gca;
                    pos=get(a,'Position');
                    if j==3
                        cb=colorbar('Units','Pixels');
                        cbpos=get(cb,'Position');
                        set(a,'Position',pos);
                        set(cb,'Position',[pos(1)+pos(3)+10,pos(2),cbpos(3),cbpos(4)])
                    end
                end
                
                axes('Units','Pixels','Position',[20,180*(3-i)+20,80,140])
                
                plot(f,20*log10(ave_tfmap{i,4}/bnum),'-r');
                t=title('Baseline');
                set(t,'FontSize',10);
                xlim([f(1) 100]);
                %             xlabel('Frequency (Hz)')
                ylim([-60 10]);
                %             ylabel('dB')
                camroll(90)
            end
        end
    end
end
