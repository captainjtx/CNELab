fname = 'H564_60-200_Go.mat';
mat = load(fname, '-mat');

gcf = figure();
w = 5;
t = 0.4;
[~, ind] = min(abs(mat.ts-t));

dir = 0:45:315;
for c = 1:128
    pow = zeros(8, 1);
    for i = 1:8
        pow(i) = mean(mat.data(i).ep(ind-w:ind+w, c), 1);
        
        pow2(i) = mean(mat.data(i).ep(ind, c), 1);
    end
    plot(dir, pow, 'o-');
    hold on
    plot(dir, pow2, 'o-r');
     
    ylim([-0.5, 2.5]);
    title(['Channel ', num2str(c)]);
    xlabel('Direction in degree')
    ylabel('Power (dB)')
    pause
    clf
end


