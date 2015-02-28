function [tfm,f,t]=bsp_tfmap(fig,eeg,fs,wd,ov,s,channames,freq,unit)

nf=2^nextpow2(wd);
win=hanning(wd);
% win=gausswin(wd,2.5);
tfm=0;

for i=1:size(eeg,2)
    
    
    [tf,f,t]=spectrogram(eeg(:,i),win,ov,nf,fs);
    tf=abs(tf);
    tfm=tfm+tf;
    if nargout==0
        if ishandle(fig)
            figure(fig);
            
            subplot(2,1,1)
            plot(eeg(:,i));
            xlim([0 length(eeg(:,i))]);
            title({channames{i};'Press any key to coninue'});
            
            subplot(2,1,2)
            if strcmpi(unit,'dB')
                imagesc(t,f,10*log10(tf));
            else
                imagesc(t,f,tf);
            end
            set(gca,'Tag','TFMapAxes','YLim',freq);
            if ~isempty(s)
                set(gca,'CLim',s);
            end
            xlabel('Time');
            ylabel('Frequency');
            axis xy;
            colormap(jet);
            pause
        end
    end
    
end

tfm=tfm/size(eeg,2);
if nargout==0
    if ishandle(fig)
        clf(fig)
        figure(fig)
        if strcmpi(unit,'dB')
            imagesc(t,f,10*log10(tfm));
        else
            imagesc(t,f,tfm);
        end
        
        set(gca,'Tag','TFMapAxes','YLim',freq);
        if ~isempty(s)
            set(gca,'CLim',s);
        end
        xlabel('Time');
        ylabel('Frequency');
        axis xy;
        colormap(jet);
        colorbar;
    end
end


end



