function [pacmat, shf_pacmat_final] = cfc_plv_seg(sig_ph,sig_amp, Fs, ph_freq_vec, amp_freq_vec,BW_ph, BW_amp, surr_num)

xbins = length(ph_freq_vec);
ybins = length(amp_freq_vec);
seg_num = length(sig_amp);

amp_filt_signals=cell(ybins,1);
for jj = 1:ybins
    [b,a] = butter(3,[amp_freq_vec(jj)-BW_amp amp_freq_vec(jj)+BW_amp]/(0.5*Fs)); % Band-pass filtering of high frequency components
    % filter and concatenate different segments
    env=[];
    for ind=1:seg_num
        dt=sig_amp{ind};
        env=[env; abs(hilbert(filtfilt(b,a,dt)))]; % Extract the envelope
    end
    amp_filt_signals{jj} = env;
end

ph_filt_signals=cell(xbins,1);
for ii = 1:xbins
    [b,a] = butter(3,[ph_freq_vec(ii)-BW_ph ph_freq_vec(ii)+BW_ph]/(0.5*Fs)); %Band-pass filtering of slow frequency component
    % filter and concatenate different segment
    phs=[];
    for ind=1:seg_num
        dt=sig_ph{ind};
        phs=[phs; angle(hilbert(filtfilt(b,a,dt)))]; % Extract the phase
    end
    ph_filt_signals{ii} = phs; 
end

pacmat = zeros(ybins,xbins);
for ii = 1:xbins
    for jj = 1:ybins
        [b,a] = butter(3,[ph_freq_vec(ii)-BW_ph ph_freq_vec(ii)+BW_ph]/(0.5*Fs));   %Band-pass filtering of slow frequency component
        ph_high = angle(hilbert(filtfilt(b,a,amp_filt_signals{jj})));     %Extract the phase
        pacmat(jj,ii) = (mean(exp(1i.*(ph_filt_signals{ii}-ph_high))));
    end
end

shf_pacmat_final = ones(surr_num,ybins,xbins);
% for ss = 1:surr_num % surrogate analysis
%     fprintf('Surrogate Num:%d\n',ss);
% 
%     for jj = 1:ybins;
%         for ii = 1:xbins
% 
%             ph = random_block_swap(ph_filt_signals{ii},Fs,1);
% 
%             [b,a] = butter(3,[ph_freq_vec(ii)-BW_ph ph_freq_vec(ii)+BW_ph]/(0.5*Fs));   %Band-pass filtering of slow frequency component
%             ph_high = angle(hilbert(filtfilt(b,a,amp_filt_signals{jj}(1:length(ph)))));                        %Extract the phase      
%             shf_pacmat_final(ss,jj,ii) = abs(mean(exp(1i.*(ph'-ph_high))));
%         end
%     end
% end
end





