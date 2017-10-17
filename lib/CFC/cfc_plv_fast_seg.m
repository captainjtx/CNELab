% fast but incorrect
function [pacmat, sw_pacmat] = cfc_plv_fast_seg(sig_ph,sig_amp, Fs, ph_freq_vec, amp_freq_vec,BW_ph, BW_amp, surr_num)
% [pacmat, sw_pacmat] = cfc_plv(sig_amp,sig_mod, Fs, ph_freq_vec, amp_freq_vec,BW, surr_num)
% sig_amp and sig_mod are segmented data structures of same length

xbins = length(ph_freq_vec);
ybins = length(amp_freq_vec);
seg_num = length(sig_amp);

amp_filt_signals=cell(ybins,1);

for ii = 1:ybins
    [b,a] = butter(2,[amp_freq_vec(ii)-BW_amp amp_freq_vec(ii)+BW_amp]/(0.5*Fs)); % Band-pass filtering of high frequency components
    
    % filter and concatenate different segments
    env=[];
    for ind=1:seg_num
        dt=sig_amp{ind};
        env=[env; abs(hilbert(filtfilt(b,a,dt)))]; % Extract the envelope
    end
    amp_filt_signals{ii} = angle(hilbert(detrend(env,'constant')));
end

ph_filt_signals=cell(xbins,1);
% For the low band +-1Hz band width
for ii = 1:xbins
    [b,a] = butter(2,[ph_freq_vec(ii)-BW_ph ph_freq_vec(ii)+BW_ph]/(0.5*Fs)); %Band-pass filtering of slow frequency component
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
        pacmat(jj,ii) = (mean(exp(1i.*(ph_filt_signals{ii}-amp_filt_signals{jj}))));
    end
end

sw_pacmat=zeros(surr_num,ybins,xbins);
for ss=1:surr_num
    fprintf('Surrogate Num:%d\n',ss);
    
    for ii = 1:xbins
        for jj = 1:ybins
            sw1 = random_block_swap(amp_filt_signals{jj},Fs,1);
            sw2 = random_block_swap(ph_filt_signals{ii},Fs,1);
            sw_pacmat(ss,jj,ii) =  abs(mean(exp(1i.*(sw2-sw1))));
        end
    end
end