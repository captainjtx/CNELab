function makeToolbar(obj)
d=obj.JToolbar(1).getPreferredSize();
btn_d=java.awt.Dimension();
btn_d.width=d.height;
btn_d.height=d.height;

%montage

obj.JTogMontage=javaObjectEDT(javax.swing.JButton());
obj.JTogMontage.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/Raw.png']));
obj.JTogMontage.setIcon(icon);
obj.JTogMontage.setOpaque(true);
obj.JTogMontage.setMinimumSize(btn_d);
obj.JTogMontage.setMaximumSize(btn_d);
obj.JTogMontage.setToolTipText('Raw montage');
set(handle(obj.JTogMontage,'CallbackProperties'),'MousePressedCallback',@(h,e) resetMontage(obj));
set(handle(obj.JTogMontage,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JTogMontage));
set(handle(obj.JTogMontage,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JTogMontage));

obj.JToolbar(1).add(obj.JTogMontage);

obj.JTogComAve=javaObjectEDT(javax.swing.JButton());
obj.JTogComAve.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/common.png']));
obj.JTogComAve.setIcon(icon);
obj.JTogComAve.setOpaque(true);
obj.JTogComAve.setMinimumSize(btn_d);
obj.JTogComAve.setMaximumSize(btn_d);
obj.JTogComAve.setToolTipText('Mean reference');
set(handle(obj.JTogComAve,'CallbackProperties'),'MousePressedCallback',@(h,e) resetMontage(obj,2));
set(handle(obj.JTogComAve,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JTogComAve));
set(handle(obj.JTogComAve,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JTogComAve));

obj.JToolbar(1).add(obj.JTogComAve);

%view

obj.IconPlay=javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/play.png']));
obj.IconPause=javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/pause.png']));

obj.JToolbar(1).addSeparator();

obj.JBtnSwitchData=javaObjectEDT(javax.swing.JButton());
obj.JBtnSwitchData.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/switch.png']));
obj.JBtnSwitchData.setIcon(icon);
obj.JBtnSwitchData.setOpaque(true);
obj.JBtnSwitchData.setMinimumSize(btn_d);
obj.JBtnSwitchData.setMaximumSize(btn_d);
obj.JBtnSwitchData.setToolTipText('Next data');
set(handle(obj.JBtnSwitchData,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeData(obj,[]));
set(handle(obj.JBtnSwitchData,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JBtnSwitchData));
set(handle(obj.JBtnSwitchData,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JBtnSwitchData));

obj.JToolbar(1).add(obj.JBtnSwitchData);

obj.JTogHorizontal=javaObjectEDT(javax.swing.JToggleButton());
obj.JTogHorizontal.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/horizontal.png']));
obj.JTogHorizontal.setIcon(icon);
obj.JTogHorizontal.setOpaque(true);
obj.JTogHorizontal.setMinimumSize(btn_d);
obj.JTogHorizontal.setMaximumSize(btn_d);
obj.JTogHorizontal.setToolTipText('Horizontal alignment');
set(handle(obj.JTogHorizontal,'CallbackProperties'),'MousePressedCallback',@(h,e) set(obj,'DataView','Horizontal'));
set(handle(obj.JTogHorizontal,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JTogHorizontal));
set(handle(obj.JTogHorizontal,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JTogHorizontal));

obj.JToolbar(1).add(obj.JTogHorizontal);

obj.JTogVertical=javaObjectEDT(javax.swing.JToggleButton());
obj.JTogVertical.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/vertical.png']));
obj.JTogVertical.setIcon(icon);
obj.JTogVertical.setOpaque(true);
obj.JTogVertical.setMinimumSize(btn_d);
obj.JTogVertical.setMaximumSize(btn_d);
obj.JTogVertical.setToolTipText('Vertical alignment');
set(handle(obj.JTogVertical,'CallbackProperties'),'MousePressedCallback',@(h,e) set(obj,'DataView','Vertical'));
set(handle(obj.JTogVertical,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JTogVertical));
set(handle(obj.JTogVertical,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JTogVertical));

obj.JToolbar(1).add(obj.JTogVertical);

obj.JToolbar(1).addSeparator();

obj.JBtnPlaySlower=javaObjectEDT(javax.swing.JButton());
obj.JBtnPlaySlower.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/slower.png']));
obj.JBtnPlaySlower.setIcon(icon);
obj.JBtnPlaySlower.setOpaque(true);
obj.JBtnPlaySlower.setMinimumSize(btn_d);
obj.JBtnPlaySlower.setMaximumSize(btn_d);
obj.JBtnPlaySlower.setToolTipText('Slower');
set(handle(obj.JBtnPlaySlower,'CallbackProperties'),'MousePressedCallback',@(h,e) PlaySlower(obj));
set(handle(obj.JBtnPlaySlower,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JBtnPlaySlower));
set(handle(obj.JBtnPlaySlower,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JBtnPlaySlower));

obj.JToolbar(1).add(obj.JBtnPlaySlower);

obj.JTogPlay=javaObjectEDT(javax.swing.JButton());
obj.JTogPlay.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));

obj.JTogPlay.setIcon(obj.IconPlay);
obj.JTogPlay.setOpaque(true);
obj.JTogPlay.setMinimumSize(btn_d);
obj.JTogPlay.setMaximumSize(btn_d);
obj.JTogPlay.setToolTipText('Start');
set(handle(obj.JTogPlay,'CallbackProperties'),'MousePressedCallback',@(h,e) StartPlay(obj));
set(handle(obj.JTogPlay,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JTogPlay));
set(handle(obj.JTogPlay,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JTogPlay));

obj.JToolbar(1).add(obj.JTogPlay);

obj.JBtnPlayFaster=javaObjectEDT(javax.swing.JButton());
obj.JBtnPlayFaster.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/faster.png']));
obj.JBtnPlayFaster.setIcon(icon);
obj.JBtnPlayFaster.setOpaque(true);
obj.JBtnPlayFaster.setMinimumSize(btn_d);
obj.JBtnPlayFaster.setMaximumSize(btn_d);
obj.JBtnPlayFaster.setToolTipText('Faster');
set(handle(obj.JBtnPlayFaster,'CallbackProperties'),'MousePressedCallback',@(h,e) PlayFaster(obj));
set(handle(obj.JBtnPlayFaster,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JBtnPlayFaster));
set(handle(obj.JBtnPlayFaster,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JBtnPlayFaster));

obj.JToolbar(1).add(obj.JBtnPlayFaster);

obj.JTogVideo=javaObjectEDT(javax.swing.JButton());
obj.JTogVideo.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/video.png']));
obj.JTogVideo.setIcon(icon);
obj.JTogVideo.setOpaque(true);
obj.JTogVideo.setMinimumSize(btn_d);
obj.JTogVideo.setMaximumSize(btn_d);
obj.JTogVideo.setToolTipText('Video');
set(handle(obj.JTogVideo,'CallbackProperties'),'MousePressedCallback',@(h,e) WinVideoFcn(obj));
set(handle(obj.JTogVideo,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JTogVideo));
set(handle(obj.JTogVideo,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JTogVideo));

obj.JToolbar(1).add(obj.JTogVideo);

%tool

obj.JToolbar(1).addSeparator();

obj.JBtnWidthIncrease=javaObjectEDT(javax.swing.JButton());
obj.JBtnWidthIncrease.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/time_increase.png']));
obj.JBtnWidthIncrease.setIcon(icon);
obj.JBtnWidthIncrease.setOpaque(true);
obj.JBtnWidthIncrease.setMinimumSize(btn_d);
obj.JBtnWidthIncrease.setMaximumSize(btn_d);
obj.JBtnWidthIncrease.setToolTipText('Increase time');
set(handle(obj.JBtnWidthIncrease,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeDuration(obj,1));
set(handle(obj.JBtnWidthIncrease,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JBtnWidthIncrease));
set(handle(obj.JBtnWidthIncrease,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JBtnWidthIncrease));

obj.JToolbar(1).add(obj.JBtnWidthIncrease);

obj.JBtnWidthDecrease=javaObjectEDT(javax.swing.JButton());
obj.JBtnWidthDecrease.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/time_decrease.png']));
obj.JBtnWidthDecrease.setIcon(icon);
obj.JBtnWidthDecrease.setOpaque(true);
obj.JBtnWidthDecrease.setMinimumSize(btn_d);
obj.JBtnWidthDecrease.setMaximumSize(btn_d);
obj.JBtnWidthDecrease.setToolTipText('Decrease time');
set(handle(obj.JBtnWidthDecrease,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeDuration(obj,-1));
set(handle(obj.JBtnWidthDecrease,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JBtnWidthDecrease));
set(handle(obj.JBtnWidthDecrease,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JBtnWidthDecrease));

obj.JToolbar(1).add(obj.JBtnWidthDecrease);

obj.JBtnHeightIncrease=javaObjectEDT(javax.swing.JButton());
obj.JBtnHeightIncrease.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/chan_increase.png']));
obj.JBtnHeightIncrease.setIcon(icon);
obj.JBtnHeightIncrease.setOpaque(true);
obj.JBtnHeightIncrease.setMinimumSize(btn_d);
obj.JBtnHeightIncrease.setMaximumSize(btn_d);
obj.JBtnHeightIncrease.setToolTipText('Increase channel');
set(handle(obj.JBtnHeightIncrease,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeChan(obj,1));
set(handle(obj.JBtnHeightIncrease,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JBtnHeightIncrease));
set(handle(obj.JBtnHeightIncrease,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JBtnHeightIncrease));

obj.JToolbar(1).add(obj.JBtnHeightIncrease);

obj.JBtnHeightDecrease=javaObjectEDT(javax.swing.JButton());
obj.JBtnHeightDecrease.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/chan_decrease.png']));
obj.JBtnHeightDecrease.setIcon(icon);
obj.JBtnHeightDecrease.setOpaque(true);
obj.JBtnHeightDecrease.setMinimumSize(btn_d);
obj.JBtnHeightDecrease.setMaximumSize(btn_d);
obj.JBtnHeightDecrease.setToolTipText('Decrease channel');
set(handle(obj.JBtnHeightDecrease,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeChan(obj,-1));
set(handle(obj.JBtnHeightDecrease,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JBtnHeightDecrease));
set(handle(obj.JBtnHeightDecrease,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JBtnHeightDecrease));

obj.JToolbar(1).add(obj.JBtnHeightDecrease);
obj.JToolbar(1).addSeparator();

obj.JBtnGainIncrease=javaObjectEDT(javax.swing.JButton());
obj.JBtnGainIncrease.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/zoom_in.png']));
obj.JBtnGainIncrease.setIcon(icon);
obj.JBtnGainIncrease.setOpaque(true);
obj.JBtnGainIncrease.setMinimumSize(btn_d);
obj.JBtnGainIncrease.setMaximumSize(btn_d);

obj.JBtnGainIncrease.setToolTipText('Increase gain (ctrl =)');
set(handle(obj.JBtnGainIncrease,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeGain(obj,1));
set(handle(obj.JBtnGainIncrease,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JBtnGainIncrease));
set(handle(obj.JBtnGainIncrease,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JBtnGainIncrease));


obj.JToolbar(1).add(obj.JBtnGainIncrease);

obj.JBtnGainDecrease=javaObjectEDT(javax.swing.JButton());
obj.JBtnGainDecrease.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/zoom_out.png']));
obj.JBtnGainDecrease.setIcon(icon);
obj.JBtnGainDecrease.setOpaque(true);
obj.JBtnGainDecrease.setMinimumSize(btn_d);
obj.JBtnGainDecrease.setMaximumSize(btn_d);
obj.JBtnGainDecrease.setToolTipText('Decrease gain (ctrl -)');
set(handle(obj.JBtnGainDecrease,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeGain(obj,-1));
set(handle(obj.JBtnGainDecrease,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JBtnGainDecrease));
set(handle(obj.JBtnGainDecrease,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JBtnGainDecrease));

obj.JToolbar(1).add(obj.JBtnGainDecrease);

obj.JBtnAutoScale=javaObjectEDT(javax.swing.JButton());
obj.JBtnAutoScale.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/auto_scale.png']));
obj.JBtnAutoScale.setIcon(icon);
obj.JBtnAutoScale.setOpaque(true);
obj.JBtnAutoScale.setMinimumSize(btn_d);
obj.JBtnAutoScale.setMaximumSize(btn_d);
obj.JBtnAutoScale.setToolTipText('Auto scale');
set(handle(obj.JBtnAutoScale,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeGain(obj,0));
set(handle(obj.JBtnAutoScale,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JBtnAutoScale));
set(handle(obj.JBtnAutoScale,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JBtnAutoScale));

obj.JToolbar(1).add(obj.JBtnAutoScale);

obj.BtnMaskChannel=uipushtool(obj.Toolbar,'CData',imread('mask.png'),'TooltipString','Mask channel','separator','on',...
    'ClickedCallback',@(src,evt) maskChannel(obj,src));
obj.BtnUnMaskChannel=uipushtool(obj.Toolbar,'CData',imread('unmask.png'),'TooltipString','UnMask Channel',...
    'ClickedCallback',@(src,evt) maskChannel(obj,src));

obj.TogSelection=uitoggletool(obj.Toolbar,'CData',imread('select.bmp'),'TooltipString','Selection','separator','on',...
    'ClickedCallback',@(src,evt) ChangeMouseMode(obj,src));

obj.BtnSelectWin=uipushtool(obj.Toolbar,'CData',imread('select_win.bmp'),'TooltipString','Select current window',...
    'ClickedCallback',@(src,evt) SelectCurrentWindow(obj,src));

obj.TogMeasurer=uitoggletool(obj.Toolbar,'CData',imread('measurer.bmp'),'TooltipString','Measure of each channels','separator','on',...
    'ClickedCallback',@(src,evt) ChangeMouseMode(obj,src));

obj.TogAnnotate=uitoggletool(obj.Toolbar,'CData',imread('evts.bmp'),'TooltipString','Insert events(ctrl i)','separator','on',...
    'ClickedCallback',@(src,evt) ChangeMouseMode(obj,src));
obj.BtnPSD=uipushtool(obj.Toolbar,'CData',imread('psd.png'),'TooltipString','Power Spectrum Density','separator','on',...
    'ClickedCallback',@(src,evt) obj.PSDWin.ComputeCallback());
obj.BtnTFMap=uipushtool(obj.Toolbar,'CData',imread('tfmap.bmp'),'TooltipString','Time-Frequency Map',...
    'ClickedCallback',@(src,evt) obj.TFMapWin.ComputeCallback());

obj.BtnPCA=uitoggletool(obj.Toolbar,'CData',imread('pca.png'),'TooltipString','Principle Component Analysis',...
    'ClickedCallback',@(src,evt) SPF_Analysis(obj,src));
obj.BtnICA=uitoggletool(obj.Toolbar,'CData',imread('ica.png'),'TooltipString','Independent Component Analysis',...
    'ClickedCallback',@(src,evt) SPF_Analysis(obj,src));
drawnow


end

function BtnEnter(obj,jb)
border=javax.swing.BorderFactory.createMatteBorder(1,1,1,1,java.awt.Color(0.8,0.8,0.8));

jb.setBorder(border);
jb.setBackground(java.awt.Color(0.98,0.98,0.98));
end

function BtnExit(obj,jb)
jb.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
col=obj.JToolbar(1).getBackground();
jb.setBackground(col);
end

