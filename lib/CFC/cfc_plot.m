function cfc_plot(pacmat,sw_pacmat, ph_freq_vec, amp_freq_vec,smooth_row, smooth_col)

smooth_kernel = fspecial('gaussian',[smooth_row smooth_col],1.5); % for smoothing

% m1 = interp2(abs(pacmat),2,'cubic');
% m2 = interp3(sw_pacmat,2,'cubic');
m1 = abs(pacmat);
m2 = sw_pacmat;
m3 = (m1-squeeze(mean(m2)))./squeeze(std(m2)); %normalization
m4 = interp2(m3,2,'cubic'); % interpolate to make it look nicer
m4 = imfilter(m4,smooth_kernel,'symmetric'); %smoothing
imagesc(ph_freq_vec,amp_freq_vec,m4);
axis xy;