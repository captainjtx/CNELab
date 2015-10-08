%%
% sig_chan={'C27','C28','C29','C15','C17','C30','C3','C5','C4'};

sig_chan={'C111','C63','C110','C73','C61','C109','C97','C85'};

tfw=bsp.TFMapWin;
t=tfw.tfmat_t;
f=tfw.tfmat_f;
tfmat=0;
for i=1:length(tfw.tfmat_channame)
    if ismember(tfw.tfmat_channame{i},sig_chan)
        tfmat=tfmat+10.^(tfw.tfmat{i}/10);
    end
end

tfmat=10*log10(tfmat/length(sig_chan));
tfmat = TF_Smooth(tfmat,'gaussian',[5,3]);

figure
imagesc(t-1.5,f,tfmat,[-10,10])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
set(gca,'fontsize',20)
axis xy
colorbar('fontsize',22,'Ticks',[-8,-4,0,4,8])
colormap jet
hold on
plot([-3,3],[8,8],'-.k','linewidth',1)
hold on
plot([-3,3],[32,32],'-.k','linewidth',1);
hold on
plot([-3,3],[60,60],'-.k','linewidth',1);
hold on
plot([-3,3],[200,200],'-.k','linewidth',1);

% xlim([-1.5,1.5])

set(gca,'ytick',[8,32,60,200])
set(gcf,'color','white')

 export_fig(gcf,'-png','-nocrop','-opengl','-r300','s2_close');