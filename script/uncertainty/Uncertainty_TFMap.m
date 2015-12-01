clc
clear

pid=[1,2,3,4,5,10];
mdir='/Users/tengi/Desktop/Projects/data/uncertainty/Analysis/01-07-2015';
state={'MedicineOff','MedicineOn'};

BipolarLFPNames={'LFP1-2','LFP2-3','LFP3-4'};
Alignments={'Target','Go','Exit'};

for pt=1:length(pid)
    for s=1:length(state)
        listings=dir([mdir,'/Pt',num2str(pid(pt)),' ',state{s},'*.mat']);
        
        ave_tfmap=cell(3,4);
        for i=1:3
            for j=1:4
                ave_tfmap{i,j}=0;
            end
        end
        
        num=0;
        for l=1:length(listings)
            tfmat=load(fullfile(mdir,listings(l).name),'-mat');
            
            for i=1:3
                for j=1:4
                    ave_tfmap{i,j}=ave_tfmap{i,j}+tfmat.map{i,j}*tfmat.trialNum{1,1};
                end
            end
            
            num=num+tfmat.trialNum{1,1};
        end
        
        
        figure('Name',['Pt', num2str(pid(pt)),' ',state{s}],...
            'Position',[0,0,800,540]);
        
        
        for i=1:3
            
            for j=1:3
                axes('Units','Pixels','Position',[140+(j-1)*210,180*(3-i)+20,180,140]);zs h
                t=tfmat.t{i,j};
                f=tfmat.f{i,j};
                [SMOOTHED] = TF_Smooth(ave_tfmap{i,j}./repmat(ave_tfmap{i,4},1,size(ave_tfmap{i,j},2)),'gaussian',[4,10]);
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
            
            plot(f,20*log10(ave_tfmap{i,4}/num),'-r');
            t=title('Baseline');
            set(t,'FontSize',10);
            xlim([f(1) 100]);
            %             xlabel('Frequency (Hz)')
            ylim([-60 10]);
            %             ylabel('dB')
            camroll(90)
        end
%         print('-depsc','-tiff','-r300',[get(gcf,'Name')])
%         print(gcf,'-dformat',[get(gcf,'Name'),'.png'])
%         close(gcf)
    end
end