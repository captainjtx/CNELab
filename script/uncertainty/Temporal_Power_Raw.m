%This script will calculate the temporal-power plots of uncertainty tasks
%Written by Tianxiao Jiang
clc
clear

pid=[1,2,3,4,5,10];
mdir='/Users/tengi/Desktop/Projects/data/uncertainty/Analysis/2015-01-18/data';
% mdir=['./'];
state={'MedicineOff','MedicineOn'};

BipolarLFPNames={'LFP1-2','LFP2-3','LFP3-4'};

fs=512;

wd=128;
ov=120;

% fl=13;
% fh=30;

fl=40;
fh=90;

% fl=1;
% fh=7;


col={'k','r'};

for pt=1:length(pid)
    figure('Name',['Pt', num2str(pid(pt))],...
        'Position',[0,0,700,540]);
    
    for i=1:3
        for j=1:2
            axe_h(i,j)=axes('Units','Pixels','Position',[50+350*(j-1),180*(3-i)+20,250,140]);
        end
    end
    
    for s=1:length(state)
        for target=1:2
            listings=dir([mdir,'/Pt',num2str(pid(pt)),' ',state{s},'*TargetNum',num2str(target),'.mat']);
            
            num=0;
            ave_tfmap=cell(3,1);
            base_tfmap=cell(3,1);
            for i=1:3
                ave_tfmap{i}=0;
                base_tfmap{i}=0;
            end
            t=[];
            f=[];
            for l=1:length(listings)
                tfmat=load(fullfile(mdir,listings(l).name),'-mat');
                
                for i=1:3
                    for j=1:size(tfmat.baseline{i},2)
                        [tf,f,t]=tfmap(tfmat.task{i}(:,j),fs,wd,ov);
                        [btf,bf,bt]=tfmap(tfmat.baseline{i}(:,j),fs,wd,ov);
                        
                        ave_tfmap{i}=ave_tfmap{i}+tf;
                        base_tfmap{i}=base_tfmap{i}+btf;
                    end
                end
                
                num=num+size(tfmat.baseline{1},2);
            end
            
            for i=1:3
                ave_tfmap{i}=ave_tfmap{i}/num;
                base_tfmap{i}=base_tfmap{i}/num;
                
                ave_tfmap{i}=mean(ave_tfmap{i}((f>=fl)&(f<=fh),:),1);
                base_tfmap{i}=mean(base_tfmap{i}((f>=fl)&(f<=fh),:),1);
                
                ave_tfmap{i}=ave_tfmap{i}/mean(base_tfmap{i});
                
            end
            
            t=t-1;
            for i=1:3
                axes(axe_h(i,s))
                
                
                plot(t,ave_tfmap{i},col{target});
                hold on
                
                xlim([t(1),t(end)])
                tt=title([BipolarLFPNames{i},' ',state{s}]);
                set(tt,'FontSize',10);
                %                 xlabel('Time')
                ylabel('Average Power Ratio')
            end
        end
    end
    
    y_lim=-inf;
    
    for i=1:3
        for s=1:2
            y_lim=max(max(abs(get(axe_h(i,s),'YLim')-1)),y_lim);
        end
    end
    
    for i=1:3
        for s=1:2
            axes(axe_h(i,s))
            ylim([1-y_lim,1+y_lim]);
            
            y=get(gca,'YLim');
            plot([0,0],y,'-.g');
            legend({'One target','Two targets'},'Location','southeast')
        end
    end
    
end