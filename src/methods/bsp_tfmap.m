function [tfm,f,t]=bsp_tfmap(fig,eeg,baseline,fs,wd,ov,s,nref,channames,freq,unit)
%return the power
nf=2^nextpow2(wd);
win=hanning(wd);
% win=gausswin(wd,2.5);
tfm=0;

for i=1:size(eeg,2)
    
    
    [s,f,t,tf]=spectrogram(eeg(:,i),win,ov,nf,fs);
    %s is stft, tf is power
    
    tf=abs(tf);
    
    if ~isempty(baseline)
        bdata=squeeze(baseline(:,i,:));
        rtf=0;
        for b=1:size(bdata,2)
            [rs,rf,rt,tmp_rtf]=spectrogram(bdata(:,b),win,ov,nf,fs);
            rtf=rtf+tmp_rtf;
        end
        rtf=rtf/size(bdata,2);
        rf=mean(abs(rtf),2);
        tf=tf./repmat(rf,1,size(tf,2));
    elseif ~isempty(nref)
        rf=mean(tf(:,(t>=(nref(1)/fs))&(t<=(nref(2)/fs))),2);
        tf=tf./repmat(rf,1,size(tf,2));
    end
    tfm=tfm+tf;
    if nargout<3
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



