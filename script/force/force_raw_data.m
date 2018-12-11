clear
clc

a = gca;

set(gcf, 'position', [0,0,900,520])
set(a, 'color', 'w')
set(a, 'linewidth', 1)
set(a, 'position', [25, 55, 810, 460], 'FontSize', 15, 'FontWeight', 'Bold');
xlabel('Time (second)')

xl = xlim;
xlim([xl(1) xl(2)-0.5*2400])

ts = findobj(gcf, 'type', 'text');
ls = findobj(gcf, 'type', 'line');
set(ts, 'fontsize', 17, 'fontweight', 'bold');

p = get(a.XLabel, 'Position');
set(a.XLabel, 'Position', [p(1), -0.5321, -1])

grid on

xt = get(gca, 'XTick');
xb = cell(length(xt), 1);
for i = 1:length(xt)
    xb{i} = num2str(xt(i)/2400+10, '%3.1f');
end
set(gca, 'XTickLabel', xb);

for i = 1:length(ts)
    pos = get(ts(i), 'Position');
    unit = get(ts(i), 'unit');
    if pos(1) < 0.035 && strcmpi(unit, 'normalized')
        set(ts(i), 'Position', [0.01, pos(2), pos(3)]);
        if (strcmpi(get(ts(i), 'String'), 'Force'))
            set(ts(i), 'color', [0.8500 0.3300 0.1000])
        end
    elseif pos(1) > 0.9 && strcmpi(unit, 'normalized') && pos(2) > 0.1
        set(ts(i), 'Position', [1.04, pos(2), pos(3)], 'color', 'k', 'fontsize', 14);
        str = get(ts(i), 'String');
        if pos(2) < 0.2
            n = str2double(str) / 16.8328;
            set(ts(i),'String', [num2str(n, '%3.1f'), ' kg']);
        else
            n = str2double(str);
            if n > 1000
                n = n/1000;
                set(ts(i),'String', [num2str(n, '%1.2f'), ' mV']);
            else
                set(ts(i),'String', [str, ' uV']);
            end
            
        end 
    elseif pos(2) < 0.01 && strcmpi(unit, 'normalized')
        delete(ts(i))
        % set(ts(i), 'Position', [pos(1), -0.05, pos(3)], 'color', 'k', 'fontsize', 13, 'HorizontalAlignment', 'center');
    end
end

for i = 1:length(ls)
    xd = get(ls(i), 'XData');
    yd = get(ls(i), 'YData');
    if strcmpi(get(ls(i), 'linestyle'), '-.')
        delete(ls(i))
    elseif xd(1) == xd(2)
        set(ls(i), 'linewidth', 1);
    elseif min(yd) < 1 && max(yd) < 2
        set(ls(i), 'linewidth', 3, 'Color', [0.8500 0.3300 0.1000]);
    elseif min(yd) < 1.8 && max(yd) < 3.2
        % EMG
        ym = mean(yd);
        env = envelope(yd,512,'rms');
        hold on
        plot(xd, env, '-r', 'linewidth', 2)
    elseif max(yd) > 3 
        set(ls(i), 'color', 'k');
    end
end
%%
pid = 'P4';
out_filename = sprintf('E:\\Google Drive\\Force Paper\\pics\\raw\\%s', pid);

export_fig(gcf, '-png', '-opengl', '-nocrop', '-r300', [out_filename, '.png'])
saveas(gcf, [out_filename, '.fig'])
