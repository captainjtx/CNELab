%%

%s1
% sig_chan={'C27_L'};
sig_chan={'C74_S','C27_L','C11_L'};

%s2
% sig_chan={'C23_L'};
% sig_chan={'C85_S','C84_S','C76_S','C91_S','C92_S','C23_L'};


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
tfmat = TF_Smooth(tfmat,'gaussian',[100,100]);

figure
imagesc(t-1.5,f,tfmat,[-6,6])
ylim([0,1000]);
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

[pathstr,~,~]=fileparts(bsp.FileNames{1});

 export_fig(gcf,'-png','-nocrop','-opengl','-r300',[pathstr,'/ave']);