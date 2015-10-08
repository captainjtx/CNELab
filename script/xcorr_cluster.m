%%
m=2;
smw=bsp.SpatialMapWin;

event=smw.tfmat(m).event;
lag_mat=smw.tfmat(m).max_lag;
xcorr_mat=smw.tfmat(m).xcorr_matrix;

figure('name',event)
disp_xcorr_mat=xcorr_mat;
for i=1:size(xcorr_mat,1)
    disp_xcorr_mat(i,i)=0;
end

subplot(2,1,1);
histogram(reshape(disp_xcorr_mat,[numel(disp_xcorr_mat),1]))
xlim([-1,1])
xlabel('Cross Correlation Coefficient');
title('Histogram of Cross Correaltion Coefficient')
set(gca,'fontsize',12)

subplot(2,1,2)
histogram(lag_mat);
xlabel('Lags (sample)');
title('Histogram of Lags')
set(gca,'fontsize',12)
% xlim([-5,5])
% export_fig(gcf,'-png','-nocrop','-opengl','-r300',sprintf('s1_%s_hist',event));

%%
m=1;
cutoff=0.23;

smw=bsp.SpatialMapWin;
channel=smw.tfmat(m).channel;

event=smw.tfmat(m).event;
xcorr_mat=smw.tfmat(m).xcorr_matrix;
chanpos=[smw.pos_x,smw.pos_y,smw.radius];

dist=[];

for i=1:size(xcorr_mat,1)
    for j=i+1:size(xcorr_mat,2)
        %assigning dissimilarity vector
        dist((i-1)/2*(size(xcorr_mat,1)*2-i)+j-i)=1-abs(xcorr_mat(i,j));
    end
end
% leafnumber=size(xcorr_mat,2);
leafnumber=length(channel);
z=linkage(dist,'complete');

figure('position',[0,0,500,650]);

axes('position',[0.1,0.75,0.88,0.24])


[~,~,outperm]=dendrogram(z,leafnumber,'ColorThreshold',cutoff);
hold on
plot([-1,1000],[cutoff,cutoff],'-.r')
set(gcf,'color','white');
set(gca,'fontsize',12)

ax=gca;

ax.XTickLabel(2:5:end,:)=0;
ax.XTickLabel(3:5:end,:)=0;
ax.XTickLabel(4:5:end,:)=0;
ax.XTickLabel(5:5:end,:)=0;
ax.YTick=sort(unique([0.2,0.4,0.6,cutoff]));
tklabel=ax.XTickLabel(1:5:end,:);

% tklabel=ax.XTickLabel;

for i=1:size(tklabel,1)
    ind=channel(str2double(tklabel(i,:)));
    
    chr=num2str(ind);
    
    for j=1:length(chr)
        tklabel(i,end-j+1)=chr(end-j+1);
    end
end

ax.XTickLabel(1:5:end,:)=tklabel;
% ax.XTickLabel=tklabel;
ylabel('Complete Linkage','fontsize',12);

% ylabel('Channel Index')
% ax.XTickLabel(5:5:end,:)=str2double(ax.XTickLabel(5:5:end,:));
ax.XTickLabelRotation=-90;
ax.XTickLabel=[];

% f=gcf;
% fpos=f.Position;
% f.Position=[fpos(1),fpos(2),round(fpos(3)),round(fpos(4)/2)];
% export_fig(gcf,'-png','-nocrop','-opengl','-r300',sprintf('s1_%s_tree',event))

% set(gca,'fontsize',4);
clst=cluster(z,'cutoff',cutoff,'criterion','distance');
% clst=cluster(z,'cutoff',1.154);

axe=findobj(bsp.SpatialMapWin.SpatialMapFig(m),'-regexp','Tag','SpatialMapAxes');
delete(findobj(axe,'tag','cluster'))
plot_cluster(axe,smw.all_chan_pos(:,1),smw.all_chan_pos(:,2),smw.all_chan_pos(:,3),smw.height,smw.width,[],...
                                    ~ismember(smw.all_chan_pos,chanpos,'rows'),clst,smw.threshold)
                                
reorder_xcorr_mat=xcorr_mat;
for i=1:size(xcorr_mat,1)
    for j=1:size(xcorr_mat,2)
        reorder_xcorr_mat(i,j)=xcorr_mat(outperm(i),outperm(j));
    end
end

axes('position',[0.1,0.02,0.88,0.72])
imagesc(1:length(channel),1:length(channel),reorder_xcorr_mat,[-1,1])


% set(gca,'xlim',[1,length(channel)])
% set(gca,'ylim',[1,length(channel)])

xlabel('Channel Index')
ylabel('Channel Index')
colormap jet

% colorbar('fontsize',25)
colorbar('southoutside','fontsize',18)
% set(gca,'fontsize',12)
% set(gca,'clim',[-1,1]);
ax=gca;

ax.XTick=1:5:length(channel);
ax.YTick=1:5:length(channel);

tklabel=ax.XTickLabel;
% tklabel=ax.XTickLabel;
% ax.YTickLabel=[];
% outperm=fliplr(outperm);
for i=size(tklabel,1):-1:1
    
    ind=channel(outperm(str2double(tklabel(i,:))));
    
    chr=num2str(ind);
    
    tklabel{i}=chr;
end

ax.XTickLabel=tklabel;

ax.YTickLabel=tklabel;

ax.XTickLabelRotation=-90;

ax.FontSize=12;

% set(gca,'xaxisLocation','top')

set(gcf,'color','white')
% export_fig(gcf,'-png','-nocrop','-opengl','-r300',sprintf('s1_%s_xcorr',event));
% figure
%%