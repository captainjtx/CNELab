%%

m=1;
smw=bsp.SpatialMapWin;

event=smw.tfmat(m).event;
% lag_mat=smw.tfmat(m).max_lag;
xcorr_mat=smw.tfmat(m).corr_matrix;


disp_xcorr_mat=xcorr_mat;
for i=1:size(xcorr_mat,1)
    disp_xcorr_mat(i,i)=0;
end

xcorr=reshape(disp_xcorr_mat,numel(disp_xcorr_mat),1);
count=0;
t=0:0.01:1;
connect_num=zeros(size(t));
for th=1:length(t)
    count=count+1;
    connect_num(count)=sum(sum(disp_xcorr_mat>t(th)))/2;
end
figure('name',event)
plot(t,connect_num);

threshold=smw.corr_win.multi_pos_t;

for i=1:length(threshold)
    hold on
    plot([cnelab_threshold(i),cnelab_threshold(i)],[0,connect_num(t==cnelab_threshold(i))],'-.*r');
end
fpos=get(gcf,'position');
set(gcf,'position',[fpos(1),fpos(2),fpos(3),fpos(4)/2]);
set(gca,'fontsize',12)

xlim([0,1]);
ylim([0,7000]);
% ylim([0,120*119/2])
% axis tight
xlabel('Threshold');
ylabel('Number of connections');
set(gcf,'color','white')
% camroll(90)
export_fig(gcf,'-png','-nocrop','-opengl','-r300',sprintf('s2_%s_con',event));
