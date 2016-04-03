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
obj.JTogMontage.setFocusable(false);
obj.JToolbar(1).add(obj.JTogMontage);

% [jbtn,hbtn]=javacomponent(obj.JTogMontage,[0,0,1,1],obj.Toolbar);
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
obj.JTogComAve.setFocusable(false);

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
obj.JBtnSwitchData.setFocusable(false);

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
obj.JTogHorizontal.setFocusable(false);

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
obj.JTogVertical.setFocusable(false);

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
obj.JBtnPlaySlower.setFocusable(false);

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
obj.JTogPlay.setFocusable(false);

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
obj.JBtnPlayFaster.setFocusable(false);

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
obj.JTogVideo.setFocusable(false);

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
obj.JBtnWidthIncrease.setFocusable(false);

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
obj.JBtnWidthDecrease.setFocusable(false);

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
obj.JBtnHeightIncrease.setFocusable(false);

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
obj.JBtnHeightDecrease.setFocusable(false);

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
obj.JBtnGainIncrease.setFocusable(false);

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
obj.JBtnGainDecrease.setFocusable(false);

obj.JToolbar(1).add(obj.JBtnGainDecrease);

obj.JBtnAutoScale=javaObjectEDT(javax.swing.JButton());
obj.JBtnAutoScale.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/auto.png']));
obj.JBtnAutoScale.setIcon(icon);
obj.JBtnAutoScale.setOpaque(true);
obj.JBtnAutoScale.setMinimumSize(btn_d);
obj.JBtnAutoScale.setMaximumSize(btn_d);
obj.JBtnAutoScale.setToolTipText('Auto scale');
set(handle(obj.JBtnAutoScale,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeGain(obj,0));
set(handle(obj.JBtnAutoScale,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JBtnAutoScale));
set(handle(obj.JBtnAutoScale,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JBtnAutoScale));
obj.JBtnAutoScale.setFocusable(false);

obj.JToolbar(1).add(obj.JBtnAutoScale);
obj.JToolbar(1).addSeparator();

obj.JBtnMaskChannel=javaObjectEDT(javax.swing.JButton());
obj.JBtnMaskChannel.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/mask.png']));
obj.JBtnMaskChannel.setIcon(icon);
obj.JBtnMaskChannel.setOpaque(true);
obj.JBtnMaskChannel.setMinimumSize(btn_d);
obj.JBtnMaskChannel.setMaximumSize(btn_d);
obj.JBtnMaskChannel.setToolTipText('Mask channel');
set(handle(obj.JBtnMaskChannel,'CallbackProperties'),'MousePressedCallback',@(h,e) maskChannel(obj,0));
set(handle(obj.JBtnMaskChannel,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JBtnMaskChannel));
set(handle(obj.JBtnMaskChannel,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JBtnMaskChannel));
obj.JBtnMaskChannel.setFocusable(false);

obj.JToolbar(1).add(obj.JBtnMaskChannel);

obj.JBtnUnMaskChannel=javaObjectEDT(javax.swing.JButton());
obj.JBtnUnMaskChannel.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/unmask.png']));
obj.JBtnUnMaskChannel.setIcon(icon);
obj.JBtnUnMaskChannel.setOpaque(true);
obj.JBtnUnMaskChannel.setMinimumSize(btn_d);
obj.JBtnUnMaskChannel.setMaximumSize(btn_d);
obj.JBtnUnMaskChannel.setToolTipText('Unmask channel');
set(handle(obj.JBtnUnMaskChannel,'CallbackProperties'),'MousePressedCallback',@(h,e) maskChannel(obj,1));
set(handle(obj.JBtnUnMaskChannel,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JBtnUnMaskChannel));
set(handle(obj.JBtnUnMaskChannel,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JBtnUnMaskChannel));
obj.JBtnUnMaskChannel.setFocusable(false);

obj.JToolbar(1).add(obj.JBtnUnMaskChannel);

obj.JToolbar(1).addSeparator();

obj.JTogSelection=javaObjectEDT(javax.swing.JToggleButton());
obj.JTogSelection.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/select.png']));
obj.JTogSelection.setIcon(icon);
obj.JTogSelection.setOpaque(true);
obj.JTogSelection.setMinimumSize(btn_d);
obj.JTogSelection.setMaximumSize(btn_d);
obj.JTogSelection.setToolTipText('Selection');
set(handle(obj.JTogSelection,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeMouseMode(obj,2));
set(handle(obj.JTogSelection,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JTogSelection));
set(handle(obj.JTogSelection,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JTogSelection));
obj.JTogSelection.setFocusable(false);

obj.JToolbar(1).add(obj.JTogSelection);

obj.JBtnSelectWin=javaObjectEDT(javax.swing.JButton());
obj.JBtnSelectWin.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/select_win.png']));
obj.JBtnSelectWin.setIcon(icon);
obj.JBtnSelectWin.setOpaque(true);
obj.JBtnSelectWin.setMinimumSize(btn_d);
obj.JBtnSelectWin.setMaximumSize(btn_d);
obj.JBtnSelectWin.setToolTipText('Select window');
set(handle(obj.JBtnSelectWin,'CallbackProperties'),'MousePressedCallback',@(h,e) SelectCurrentWindow(obj));
set(handle(obj.JBtnSelectWin,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JBtnSelectWin));
set(handle(obj.JBtnSelectWin,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JBtnSelectWin));
obj.JBtnSelectWin.setFocusable(false);

obj.JToolbar(1).add(obj.JBtnSelectWin);

obj.JToolbar(1).addSeparator();
obj.JTogMeasurer=javaObjectEDT(javax.swing.JToggleButton());
obj.JTogMeasurer.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/measurer.png']));
obj.JTogMeasurer.setIcon(icon);
obj.JTogMeasurer.setOpaque(true);
obj.JTogMeasurer.setMinimumSize(btn_d);
obj.JTogMeasurer.setMaximumSize(btn_d);
obj.JTogMeasurer.setToolTipText('Amplitude measurer');
set(handle(obj.JTogMeasurer,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeMouseMode(obj,1));
set(handle(obj.JTogMeasurer,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JTogMeasurer));
set(handle(obj.JTogMeasurer,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JTogMeasurer));
obj.JTogMeasurer.setFocusable(false);

obj.JToolbar(1).add(obj.JTogMeasurer);

obj.JToolbar(1).addSeparator();
obj.JTogAnnotate=javaObjectEDT(javax.swing.JToggleButton());
obj.JTogAnnotate.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/evts.png']));
obj.JTogAnnotate.setIcon(icon);
obj.JTogAnnotate.setOpaque(true);
obj.JTogAnnotate.setMinimumSize(btn_d);
obj.JTogAnnotate.setMaximumSize(btn_d);
obj.JTogAnnotate.setToolTipText('Annotate (ctrl i)');
set(handle(obj.JTogAnnotate,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeMouseMode(obj,3));
set(handle(obj.JTogAnnotate,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JTogAnnotate));
set(handle(obj.JTogAnnotate,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JTogAnnotate));
obj.JTogAnnotate.setFocusable(false);

obj.JToolbar(1).add(obj.JTogAnnotate);

obj.JToolbar(1).addSeparator();
obj.JBtnPSD=javaObjectEDT(javax.swing.JButton());
obj.JBtnPSD.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/psd.png']));
obj.JBtnPSD.setIcon(icon);
obj.JBtnPSD.setOpaque(true);
obj.JBtnPSD.setMinimumSize(btn_d);
obj.JBtnPSD.setMaximumSize(btn_d);
obj.JBtnPSD.setToolTipText('Power Spectrum Density');
set(handle(obj.JBtnPSD,'CallbackProperties'),'MousePressedCallback',@(h,e) obj.PSDWin.ComputeCallback());
set(handle(obj.JBtnPSD,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JBtnPSD));
set(handle(obj.JBtnPSD,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JBtnPSD));
obj.JBtnPSD.setFocusable(false);

obj.JToolbar(1).add(obj.JBtnPSD);

obj.JBtnTFMap=javaObjectEDT(javax.swing.JButton());
obj.JBtnTFMap.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/tfmap.png']));
obj.JBtnTFMap.setIcon(icon);
obj.JBtnTFMap.setOpaque(true);
obj.JBtnTFMap.setMinimumSize(btn_d);
obj.JBtnTFMap.setMaximumSize(btn_d);
obj.JBtnTFMap.setToolTipText('Time-Frequency Map');
set(handle(obj.JBtnTFMap,'CallbackProperties'),'MousePressedCallback',@(h,e) obj.TFMapWin.ComputeCallback());
set(handle(obj.JBtnTFMap,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JBtnTFMap));
set(handle(obj.JBtnTFMap,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JBtnTFMap));
obj.JBtnTFMap.setFocusable(false);

obj.JToolbar(1).add(obj.JBtnTFMap);

obj.JToolbar(1).addSeparator();

obj.JBtnPCA=javaObjectEDT(javax.swing.JButton());
obj.JBtnPCA.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/pca.png']));
obj.JBtnPCA.setIcon(icon);
obj.JBtnPCA.setOpaque(true);
obj.JBtnPCA.setMinimumSize(btn_d);
obj.JBtnPCA.setMaximumSize(btn_d);
obj.JBtnPCA.setToolTipText('PCA');
set(handle(obj.JBtnPCA,'CallbackProperties'),'MousePressedCallback',@(h,e) SPF_Analysis(obj,'pca'));
set(handle(obj.JBtnPCA,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JBtnPCA));
set(handle(obj.JBtnPCA,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JBtnPCA));
obj.JBtnPCA.setFocusable(false);

obj.JToolbar(1).add(obj.JBtnPCA);

obj.JBtnICA=javaObjectEDT(javax.swing.JButton());
obj.JBtnICA.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/ica.png']));
obj.JBtnICA.setIcon(icon);
obj.JBtnICA.setOpaque(true);
obj.JBtnICA.setMinimumSize(btn_d);
obj.JBtnICA.setMaximumSize(btn_d);
obj.JBtnICA.setToolTipText('ICA');
set(handle(obj.JBtnICA,'CallbackProperties'),'MousePressedCallback',@(h,e) SPF_Analysis(obj,'ica'));
set(handle(obj.JBtnICA,'CallbackProperties'),'MouseEnteredCallback',@(h,e) BtnEnter(obj,obj.JBtnICA));
set(handle(obj.JBtnICA,'CallbackProperties'),'MouseExitedCallback',@(h,e) BtnExit(obj,obj.JBtnICA));
obj.JBtnICA.setFocusable(false);

obj.JToolbar(1).add(obj.JBtnICA);

obj.JToolbar(1).repaint;
obj.JToolbar(1).revalidate;
end

function BtnEnter(obj,jb)
border=javax.swing.BorderFactory.createMatteBorder(1,1,1,1,java.awt.Color(0.8,0.8,0.8));

jb.setBorder(border);
jb.setBackground(java.awt.Color(0.99,0.99,0.99));
end

function BtnExit(obj,jb)
jb.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
col=obj.JToolbar(1).getBackground();
jb.setBackground(col);
end

