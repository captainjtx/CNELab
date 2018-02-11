clear
clc
title = 'PMd Go Aligned';
step = 1; %step in sample
framerate = 15; %frames per second
res_ppi = 150; % resolution ppi
colbar = true; %add colorbar
contact = true; %plot contact
cmin=-5; %scale
cmax=5;
%video output 
video_name = 'H564_8-32_Go_PMd.mp4';
profile = 'MPEG-4';
video_quality = 100;
%% get data
data_file = 'H564_8-32_Go.mat';
% bad_channel = [4, 9, 21, 30];
bad_channel_m1 = [4, 9, 21, 30];
bad_channel_pmd = [67, 101];
mat = load(data_file);
fs = 1000;
sig = mat.data;
sig_pm_ind = setdiff(1:64, bad_channel_m1);
sig_pmd_ind = setdiff(65:128, bad_channel_pmd);

i_start = 1; %start and end in samples
i_end = length(mat.ts); 
% timestamps = linspace(-0.5, 1, size(sig, 1));
timestamps = mat.ts;

% Figure positions for each direction.
%0
Pos(1,:)=[.75 .40 .2 .2];
%45
Pos(2,:)=[.65 .65 .2 .2];
%90
Pos(3,:)=[.40 .75 .2 .2];
%135
Pos(4,:)=[.15 .65 .2 .2];
%180
Pos(5,:)=[.05 .40 .2 .2];
%215
Pos(6,:)=[.15 .15 .2 .2];
%270
Pos(7,:)=[.40 .05 .2 .2];
%315
Pos(8,:)=[.65 .15 .2 .2];

%% compute grid layout
grid_width = 300;
grid_height = 300;
chanpos_file = 'H564_Electrode_Positions_CNELab.csv';
[channelname,pos_x,pos_y,radius] = ReadPosition(chanpos_file);

chan_num = cellfun(@str2num,channelname);
pm_ind = chan_num>0 & chan_num<65 & ~ismember(chan_num, bad_channel_m1);
pmd_ind = chan_num>64 & ~ismember(chan_num, bad_channel_pmd);
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
fig = figure('position',[100,100, 630, 600]);

uicontrol('parent',fig,'style','text','units','normalized','position',[0,0.96,1,0.04],...
    'string',title,'horizontalalignment','center','fontunits', 'normalized', 'fontsize', 0.7);

for drc = 1:8
    uicontrol('parent',fig,'style','text','units','normalized',...
        'position',[Pos(drc,1)+Pos(drc,3)/2-0.02, Pos(drc,2)+Pos(drc,4)-0.025, 0.04, 0.04 ],...
    'string',num2str(sig(drc).direc),'horizontalalignment','center','fontunits', 'normalized', 'fontsize', 0.5);
    axe_pm(drc) = axes('units','normalized','position',Pos(drc, :),'Visible','off','parent',fig,'xlimmode','manual','ylimmode','manual');
end

time_text = uicontrol('Parent', fig, 'units', 'normalized', 'position', [0.4, 0.005, 0.2, 0.04], 'style', 'text', 'fontunits', 'normalized', 'fontsize', 0.6);

colorbar('Location', 'manual', 'position', [0.93, 0.85, 0.03, 0.1] ,'fontsize', 10, 'ticks', linspace(cmin, cmax, 5));
set(axe_pm(1), 'position', Pos(1, :));
%%
writerObj = VideoWriter(video_name,profile);
writerObj.FrameRate = framerate;
writerObj.Quality=video_quality;
open(writerObj);
            
for ind = i_start:step:i_end
    for drc = 1:8
        plot_map(axe_pm(drc), sig(drc).ep(ind,sig_pmd_ind), chanpos_pmd, cmin, cmax, contact, grid_height, grid_width);
    end
    drawnow
    set(time_text, 'String', ['Time: ',num2str(timestamps(ind),'%-5.3f'),' s']);
    
    F = im2frame(export_fig(fig, '-nocrop',['-r',num2str(res_ppi)]));
    writeVideo(writerObj,F);
end

close(writerObj);
