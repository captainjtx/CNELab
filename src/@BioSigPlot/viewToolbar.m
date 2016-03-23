function viewToolbar(obj)
d=obj.JToolbar(1).getPreferredSize();
btn_width=d.height;

obj.IconPlay=javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/play.png']));
obj.IconPause=javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/pause.png']));

obj.BtnSwitchData=uipushtool(obj.Toolbar,'CData',imread('switch.png'),'TooltipString','Next Data','separator','on',...
    'ClickedCallback',@(src,evt) ChangeData(obj,src,[]));

obj.TogHorizontal=uitoggletool(obj.Toolbar,'CData',imread('horizontal.bmp'),...
    'TooltipString','Horizontal',...
    'ClickedCallback',@(src,evt) set(obj,'DataView','Horizontal'));

obj.TogVertical=uitoggletool(obj.Toolbar,'CData',imread('vertical.bmp'),...
    'TooltipString','Vertical','ClickedCallback',@(src,evt) set(obj,'DataView','Vertical'));
drawnow

obj.JToolbar(1).addSeparator();

obj.JBtnPlaySlower=javaObjectEDT(javax.swing.JButton());
obj.JBtnPlaySlower.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/slower.png']));
obj.JBtnPlaySlower.setIcon(icon);
obj.JBtnPlaySlower.setOpaque(false);
d=obj.JBtnPlaySlower.getPreferredSize();
d.width=btn_width;
obj.JBtnPlaySlower.setMinimumSize(d);
obj.JBtnPlaySlower.setMaximumSize(d);
obj.JBtnPlaySlower.setToolTipText('Slower');
set(handle(obj.JBtnPlaySlower,'CallbackProperties'),'MousePressedCallback',@(h,e) PlaySlower(obj));

obj.JToolbar(1).add(obj.JBtnPlaySlower);

obj.JTogPlay=javaObjectEDT(javax.swing.JButton());
obj.JTogPlay.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));

obj.JTogPlay.setIcon(obj.IconPlay);
obj.JTogPlay.setOpaque(false);
d=obj.JTogPlay.getPreferredSize();
d.width=btn_width;
obj.JTogPlay.setMinimumSize(d);
obj.JTogPlay.setMaximumSize(d);
obj.JTogPlay.setToolTipText('Start');
set(handle(obj.JTogPlay,'CallbackProperties'),'MousePressedCallback',@(h,e) StartPlay(obj));

obj.JToolbar(1).add(obj.JTogPlay);

obj.JBtnPlayFaster=javaObjectEDT(javax.swing.JButton());
obj.JBtnPlayFaster.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/faster.png']));
obj.JBtnPlayFaster.setIcon(icon);
obj.JBtnPlayFaster.setOpaque(false);
d=obj.JBtnPlayFaster.getPreferredSize();
d.width=btn_width;
obj.JBtnPlayFaster.setMinimumSize(d);
obj.JBtnPlayFaster.setMaximumSize(d);
obj.JBtnPlayFaster.setToolTipText('Faster');
set(handle(obj.JBtnPlayFaster,'CallbackProperties'),'MousePressedCallback',@(h,e) PlayFaster(obj));

obj.JToolbar(1).add(obj.JBtnPlayFaster);

obj.JTogVideo=javaObjectEDT(javax.swing.JButton());
obj.JTogVideo.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/video.png']));
obj.JTogVideo.setIcon(icon);
obj.JTogVideo.setOpaque(false);
d=obj.JTogVideo.getPreferredSize();
d.width=btn_width;
obj.JTogVideo.setMinimumSize(d);
obj.JTogVideo.setMaximumSize(d);
obj.JTogVideo.setToolTipText('Video');
set(handle(obj.JTogVideo,'CallbackProperties'),'MousePressedCallback',@(h,e) WinVideoFcn(obj));

obj.JToolbar(1).add(obj.JTogVideo);



end