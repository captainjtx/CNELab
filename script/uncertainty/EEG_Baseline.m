txtFile='/Users/tengi/Desktop/Projects/data/uncertainty/Analysis/2016-02-25/eeg_baseline_info.csv';
powFile='/Users/tengi/Desktop/Projects/data/uncertainty/Analysis/2016-02-25/eeg_baseline_pow.csv';

file_dir='/Users/tengi/Desktop/Projects/data/uncertainty/Analysis/2016-02-25';
info=readtable(txtFile);
pow=csvread(powFile);

f=pow(1,:);
pow=pow(2:end,:);

pid=unique(info.Pt);
eeg={'C3','C4','O1','O2','P3','P4','F3','F4'};
%%


for i=1:length(pid)
    figure('position',[0,0,1200,800]);
    
    pind=info.Pt==pid(i);
    
    s=unique(info.Session(pind));
    
    for ci=1:length(eeg)
        for si=1:length(s)
            subplot(length(eeg),length(s),(ci-1)*length(s)+si);
            
            ind=pind&strcmpi(info.Med,'MedicineOn')&info.Session==s(si)&strcmpi(info.Chan,eeg{ci});
            if sum(ind)
                fpow=mean(pow(ind,:),1);
                plot(f,fpow);
                hold on
            end
            
            ind=pind&strcmpi(info.Med,'MedicineOff')&info.Session==s(si)&strcmpi(info.Chan,eeg{ci});
            if sum(ind)
                fpow=mean(pow(ind,:),1);
                plot(f,fpow)
            end
            axis tight
            
            title([eeg{ci},' ','Session ',num2str(s(si))]);
            
            legend({'On','Off'});
            xlim([0,100]);
            
%             xlabel('Frequency Hz');
%             ylabel('Power');
        end
    end
    export_fig(gcf,'-png','-r300',fullfile(file_dir,['Pt',num2str(pid(i))]));
    close(gcf);
    
end