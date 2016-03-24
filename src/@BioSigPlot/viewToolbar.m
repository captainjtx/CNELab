function viewToolbar(obj)
d=obj.JToolbar(1).getPreferredSize();
btn_width=d.height;

obj.IconPlay=javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/play.png']));
obj.IconPause=javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/pause.png']));

obj.JToolbar(1).addSeparator();

obj.JBtnSwitchData=javaObjectEDT(javax.swing.JButton());
obj.JBtnSwitchData.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/switch.png']));
obj.JBtnSwitchData.setIcon(icon);
obj.JBtnSwitchData.setOpaque(false);
d=obj.JBtnSwitchData.getPreferredSize();
d.width=btn_width;
obj.JBtnSwitchData.setMinimumSize(d);
obj.JBtnSwitchData.setMaximumSize(d);
obj.JBtnSwitchData.setToolTipText('Next data');
set(handle(obj.JBtnSwitchData,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeData(obj,[]));

obj.JToolbar(1).add(obj.JBtnSwitchData);

obj.JTogHorizontal=javaObjectEDT(javax.swing.JToggleButton());
obj.JTogHorizontal.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/horizontal.png']));
obj.JTogHorizontal.setIcon(icon);
obj.JTogHorizontal.setOpaque(true);
d=obj.JTogHorizontal.getPreferredSize();
d.width=btn_width;
obj.JTogHorizontal.setMinimumSize(d);
obj.JTogHorizontal.setMaximumSize(d);
obj.JTogHorizontal.setToolTipText('Horizontal alignment');
set(handle(obj.JTogHorizontal,'CallbackProperties'),'MousePressedCallback',@(h,e) set(obj,'DataView','Horizontal'));

obj.JToolbar(1).add(obj.JTogHorizontal);

obj.JTogVertical=javaObjectEDT(javax.swing.JToggleButton());
obj.JTogVertical.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/vertical.png']));
obj.JTogVertical.setIcon(icon);
obj.JTogVertical.setOpaque(true);
d=obj.JTogVertical.getPreferredSize();
d.width=btn_width;
obj.JTogVertical.setMinimumSize(d);
obj.JTogVertical.setMaximumSize(d);
obj.JTogVertical.setToolTipText('Vertical alignment');
set(handle(obj.JTogVertical,'CallbackProperties'),'MousePressedCallback',@(h,e) set(obj,'DataView','Vertical'));

obj.JToolbar(1).add(obj.JTogVertical);

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