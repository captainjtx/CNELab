%%
% sig_chan={'C27','C28','C29','C15','C17','C30','C3','C5','C4'};

sig_chan={'C26_L','C27_L','C17_L','C18_L','C19_L','C20_L','C9_L','C10_L','C11_L'};
% sig_chan={'C80_S','C81_S','C72_S','C73_S','C74_S','C86_S','C87_S'};

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
imagesc(t-1.5,f,tfmat,[-6,6])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
set(gca,'fontsize',20)
axis xy
colorbar('fontsize',22)
colormap jet
% hold on
% plot([-3,3],[8,8],'-.k','linewidth',1)
% hold on
% plot([-3,3],[32,32],'-.k','linewidth',1);
% hold on
% plot([-3,3],[60,60],'-.k','linewidth',1);
% hold on
% plot([-3,3],[200,200],'-.k','linewidth',1);

% xlim([-1.5,1.5])

% set(gca,'ytick',[8,32,60,200])
set(gcf,'color','white')

 export_fig(gcf,'-png','-nocrop','-opengl','-r300','s2_close');