%Average the TFMap of Single Multiple target analysis
%Written by Jiang Tianxiao
clc
clear

pid=[1,2,3,4,5,10];
mdir='/Users/tengi/Desktop/Projects/data/uncertainty/Analysis/2015-01-07';
state={'MedicineOff','MedicineOn'};

BipolarLFPNames={'LFP1-2','LFP2-3','LFP3-4'};
Alignments={'Target','Go','Exit'};

% fl=13;
% fh=30;

% fl=40;
% fh=90;

fl=1;
fh=7;

col={'k','r'};
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
        
        figure('Name',['Pt', num2str(pid(pt)),' ',state{s}],...
            'Position',[0,0,800,540]);
        
        
        for i=1:3
            for j=1:3
                axe_h(i,j)=axes('Units','Pixels','Position',[140+(j-1)*210,180*(3-i)+20,180,140]);
            end
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
            
            
            for i=1:3
                for j=1:3
                    axes(axe_h(i,j))
                    
                    t=tfmat.t{i,j};
                    f=tfmat.f{i,j};
                    relative_tfmat = (ave_tfmap{i,j}/num)./(repmat(ave_tfmap{i,4},1,size(ave_tfmap{i,j},2))/bnum);
                    
                    plot(t,20*log10(mean(relative_tfmat(f>=fl&f<=fh,:),1)),col{target});
                    hold on
                    
                    xlim([t(1),t(end)]);
                    
                end
                
                axes('Units','Pixels','Position',[20,180*(3-i)+20,80,140])
                plot(f,20*log10(ave_tfmap{i,4}/bnum),'b');
                t=title('Baseline');
                set(t,'FontSize',10);
                xlim([f(1) 100]);
                %             xlabel('Frequency (Hz)')
                ylim([-60 10]);
                %             ylabel('dB')
                camroll(90)
            end
            
        end
        
        max_y=-inf;
        for i=1:3
            for j=1:3
                max_y=max(max_y,max(abs(get(axe_h(i,j),'ylim'))));
            end
        end
        
        for i=1:3
            for j=1:3
                
                axes(axe_h(i,j));
                legend('1','2');
                
                ylim([-5,5]);
                
                y_lim=get(gca,'ylim');
                
                plot([0,0],ylim,'-.m');
                t=title([BipolarLFPNames{i},' ',Alignments{j}]);
                set(t,'FontSize',10);
            end
        end
    end
end