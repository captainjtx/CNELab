%maximum foce is defined as the maximum force after 3 seconds of onset
% decode force level / force trend
Squeeze = load('/Users/tengi/Desktop/Projects/data/China/force/S2/squeeze.mat','-mat');
%%
data = Squeeze.data;
fs = Squeeze.fs;
force = squeeze(Squeeze.data(:, strcmpi(Squeeze.channame,'force'), :));
emg = squeeze(Squeeze.data(:, strcmpi(Squeeze.channame,'Bipolar EMG'), :));

chans = cell(120,1);
for i=1:120
    chans{i} = ['C', num2str(i)]; 
end

CHi = ismember(Squeeze.channame, chans);
data = data(:, CHi, :);

[b1, a1]=butter(2,[60 200]/(fs/2));
[b2, a2] = butter(2, 0.01/(fs/2),'high');
[b3, a3] = butter(2, 30/(fs/2), 'high');
[b4, a4] = butter(2, [8, 32]/(fs/2));

fdata = data;
for i=1:size(data,3)
    fdata(:,:,i)=filter_symmetric(b1, a1, data(:,:,i),[],0,'iir');
end
force = filter_symmetric(b2, a2, force, [], 0, 'iir');
emg = filter_symmetric(b3, a3, emg, [], 0, 'iir');
%%
baseline_start = 0;
baseline_end = 0.5;

move_start = Squeeze.ms_before/1000-0.25;
move_end = Squeeze.ms_before/1000+0.75;

baseline = max(round(baseline_start*fs:baseline_end*fs),1);
move = max(round(move_start*fs:move_end*fs),1);

X = fdata(baseline, :, :);
Y = fdata(move, :, :);
CHi = 1:size(X, 2);
[W,Lmd,CSP,cx,cy]=csp_weights(Y, X, CHi, 1, max(force(move, :),1)-mean(force(baseline,:),1));

%%
vec = W(:, end); %pca vector corresponds to maximize HFB variance

proj = zeros(size(fdata,1),size(fdata,3));

for i=1:size(fdata, 3)
    proj(:,i) = squeeze(fdata(:,:,i))*vec;
    proj(:,i) = proj(:,i).^2;%energy
end

base = mean(mean(proj(baseline,:),2),1);


force_base = mean(mean(force(baseline, :), 1), 2);
normalized_force = force-force_base;
normalized_force = 20*normalized_force / max(max(normalized_force));

normalized_emg = 10*emg/max(max(emg))-10;

normalized_proj = proj/base;
normalized_proj = 20*normalized_proj/max(max(normalized_proj));
%proj = 10*log10(proj/base);

t = linspace(-Squeeze.ms_before, Squeeze.ms_after, size(proj,1));
%%
figure('name', 'S2')
col = ceil(sqrt(size(proj,2)));
row = ceil(size(proj, 2)/col);
for r = 1:row
    for c = 1:col
        ind = (r-1)*col+c;
        if ind <= size(proj,2)
            subplot(row,col,ind)
            line('XData',t, 'YData',normalized_proj(:, ind),'Color','k');
            hold on
            line('XData',t, 'YData',normalized_force(:, ind),'Color','b');
            hold on
            line('XData',t, 'YData', normalized_emg(:, ind), 'Color', 'r');
            
            xlim([min(t), max(t)]);
            ylim([-20,20]);
        end
    end
end
