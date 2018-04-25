%%

%s1
% sig_chan={'C27_L'};
sig_chan={'C74_S','C27_L','C11_L'};
% sig_chan={'C3','C4','C15','C16','C17','C18','C19','C29','C30','C42','C5',...
%     'C6','C7','C28','C31','C43','C40','C41','C27','C1','C2','C32','C8','C20',...
%     'C33','C52','C53','C55'};

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
tfmat = cnelab_TF_Smooth(tfmat,'gaussian',[10,10]);

figure
imagesc(t-1.5,f,tfmat,[-8,8])
ylim([0,800]);
xlabel('Time (s)')
ylabel('Frequency (Hz)')
set(gca,'fontsize',20)
axis xy
colorbar('fontsize',30,'ticks',[-8,-4,0,4,8])
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
