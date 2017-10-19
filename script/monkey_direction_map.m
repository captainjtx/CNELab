title = 'Average EP CueOnset Aligned';
step = 2; %step in sample
framerate = 20; %frames per second
res_ppi = 150; % resolution ppi
colbar = true; %add colorbar
contact = true; %plot contact
cmin=-40; %scale
cmax=40;
%video output 
video_name = '/Users/tengi/Desktop/Projects/data/Monkey/H564_Average_EP_CueOnset_Aligned.mp4';
profile = 'MPEG-4';
video_quality = 100;
%% get data
data_file = '/Users/tengi/Desktop/Projects/data/Monkey/H564_Average_EP_CueOnset_Aligned.mat';
% bad_channel = [4, 9, 21, 30];
bad_channel = [21];
mat = load(data_file);
fs = 1000;
sig = mat.ep;

sig_pm = sig(:, [1:20,22:64]);
sig_pmd = sig(:, 65:end);

i_start = 1; %start and end in samples
i_end = size(sig, 1); 
% timestamps = linspace(-0.5, 1, size(sig, 1));
timestamps = mat.ts;
%% compute grid layout
grid_width = 300;
grid_height = 300;
chanpos_file = '/Users/tengi/Desktop/Projects/data/Monkey/H564_Electrode_Positions_CNELab.csv';
[channelname,pos_x,pos_y,radius] = ReadPosition(chanpos_file);

chan_num = cellfun(@str2num,channelname);
pm_ind = chan_num>0 & chan_num<65 & chan_num ~= 21;
pmd_ind = chan_num>64;
chanpos_pm = [pos_x(pm_ind), pos_y(pm_ind), radius(pm_ind)];
channame_pm = channelname(pm_ind);
chanpos_pmd = [pos_x(pmd_ind), pos_y(pmd_ind), radius(pmd_ind)];
channame_pmd = channelname(pmd_ind);

[chanpos_pm(:,1),chanpos_pm(:,2),chanpos_pm(:,3),~,~] = ...
    get_relative_chanpos(chanpos_pm(:, 1),chanpos_pm(:, 2),chanpos_pm(:, 3),grid_width,grid_height);

[chanpos_pmd(:,1),chanpos_pmd(:,2),chanpos_pmd(:,3),~,~] = ...
    get_relative_chanpos(chanpos_pmd(:, 1),chanpos_pmd(:, 2),chanpos_pmd(:, 3),grid_width,grid_height);

%%
%plot pm
fig = figure('position',[100,100, 600, 320]);

uicontrol('parent',fig,'style','text','units','normalized','position',[0,0.92,1,0.08],...
    'string',title,'horizontalalignment','center','fontunits', 'normalized', 'fontsize', 0.8);

imgp = uipanel('parent', fig, 'units', 'normalized', 'position', [0 0 1 0.9], 'bordertype', 'none');
axe_pm = axes('units','normalized','position',[0.02, 0.1, 0.4, 0.8],'Visible','off','parent',imgp,'xlimmode','manual','ylimmode','manual');
uicontrol('parent',imgp,'style','text','units','normalized','position',[0.15,0.9,0.1,0.1],...
    'string','M1','horizontalalignment','center','fontunits', 'normalized', 'fontsize', 0.5);
axe_pmd = axes('units','normalized','position',[0.45, 0.1, 0.4, 0.8],'Visible','off','parent',imgp,'xlimmode','manual','ylimmode','manual');
uicontrol('parent',imgp,'style','text','units','normalized','position',[0.6,0.9,0.1,0.1],...
    'string','PMd','horizontalalignment','center','fontunits', 'normalized', 'fontsize', 0.5);

time_text = uicontrol('Parent', imgp, 'units', 'normalized', 'position', [0.4, 0.01, 0.2, 0.08], 'style', 'text', 'fontunits', 'normalized', 'fontsize', 0.8);

colorbar('Location', 'manual', 'position', [0.9, 0.1, 0.03, 0.8] ,'fontsize', 15, 'ticks', linspace(cmin, cmax, 5));
set(axe_pmd, 'position', [0.45, 0.1, 0.4, 0.8]);
%%
writerObj = VideoWriter(video_name,profile);
writerObj.FrameRate = framerate;
writerObj.Quality=video_quality;
open(writerObj);
            
for ind = i_start:step:i_end
    plot_map(axe_pm, sig_pm(ind,:), chanpos_pm, cmin, cmax, contact, grid_height, grid_width);
    plot_map(axe_pmd, sig_pmd(ind,:), chanpos_pmd, cmin, cmax, contact, grid_height, grid_width);
    set(time_text, 'String', ['Time: ',num2str(timestamps(ind),'%-5.3f'),' s']);
    drawnow
    F = im2frame(export_fig(fig, '-nocrop',['-r',num2str(res_ppi)]));
    writeVideo(writerObj,F);
end

close(writerObj);

function plot_map(axe, mapv, chanpos, cmin, cmax, contact, grid_height, grid_width)
extrap = 'none';
smooth_row = 2; %smooth kernel
smooth_col = 2;
ratio = 1;
%%
[x,y]=meshgrid((1:grid_width)/grid_width,(1:grid_height)/grid_height);
F= scatteredInterpolant(chanpos(:, 1), chanpos(:,2), mapv(:), 'natural', extrap);
mapvq=F(x,y);
mapvq = smooth2a(mapvq, smooth_row, smooth_col);
imagehandle=findobj(axe,'Tag','ImageMap');
if isempty(imagehandle)
    imagesc('CData',mapvq,'Parent',axe,'Tag','ImageMap', 'AlphaData', ~isnan(mapvq));
    set(axe,'XLim',[1,size(mapvq,2)]);
    set(axe,'YLim',[1,size(mapvq,1)]);
    set(axe,'CLim',[cmin cmax]);
    set(axe,'YDir','reverse','FontSize',round(15*ratio));
    if contact
        plot_contact(axe,[],chanpos(:,1),chanpos(:,2),chanpos(:,3), grid_height, grid_width,[]);
    end
    colormap(axe, jet)
    
else
    set(imagehandle,'CData',single(mapvq),'visible','on');
    set(imagehandle, 'AlphaData', ~isnan(mapvq))
end
end
