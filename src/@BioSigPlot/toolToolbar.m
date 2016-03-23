
function toolToolbar(obj)
d=obj.JToolbar(1).getPreferredSize();
btn_width=d.height;

obj.JToolbar(1).addSeparator();

obj.JBtnWidthIncrease=javaObjectEDT(javax.swing.JButton());
obj.JBtnWidthIncrease.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/time_increase.png']));
obj.JBtnWidthIncrease.setIcon(icon);
obj.JBtnWidthIncrease.setOpaque(false);
d=obj.JBtnWidthIncrease.getPreferredSize();
d.width=btn_width;
obj.JBtnWidthIncrease.setMinimumSize(d);
obj.JBtnWidthIncrease.setMaximumSize(d);
obj.JBtnWidthIncrease.setToolTipText('Increase time');
set(handle(obj.JBtnWidthIncrease,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeDuration(obj,1));

obj.JToolbar(1).add(obj.JBtnWidthIncrease);

obj.JBtnWidthDecrease=javaObjectEDT(javax.swing.JButton());
obj.JBtnWidthDecrease.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/time_decrease.png']));
obj.JBtnWidthDecrease.setIcon(icon);
obj.JBtnWidthDecrease.setOpaque(false);
d=obj.JBtnWidthDecrease.getPreferredSize();
d.width=btn_width;
obj.JBtnWidthDecrease.setMinimumSize(d);
obj.JBtnWidthDecrease.setMaximumSize(d);
obj.JBtnWidthDecrease.setToolTipText('Decrease time');
set(handle(obj.JBtnWidthDecrease,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeDuration(obj,-1));

obj.JToolbar(1).add(obj.JBtnWidthDecrease);

obj.JBtnHeightIncrease=javaObjectEDT(javax.swing.JButton());
obj.JBtnHeightIncrease.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/chan_increase.png']));
obj.JBtnHeightIncrease.setIcon(icon);
obj.JBtnHeightIncrease.setOpaque(false);
d=obj.JBtnHeightIncrease.getPreferredSize();
d.width=btn_width;
obj.JBtnHeightIncrease.setMinimumSize(d);
obj.JBtnHeightIncrease.setMaximumSize(d);
obj.JBtnHeightIncrease.setToolTipText('Increase channel');
set(handle(obj.JBtnHeightIncrease,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeChan(obj,1));

obj.JToolbar(1).add(obj.JBtnHeightIncrease);

obj.JBtnHeightDecrease=javaObjectEDT(javax.swing.JButton());
obj.JBtnHeightDecrease.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/chan_decrease.png']));
obj.JBtnHeightDecrease.setIcon(icon);
obj.JBtnHeightDecrease.setOpaque(false);
d=obj.JBtnHeightDecrease.getPreferredSize();
d.width=btn_width;
obj.JBtnHeightDecrease.setMinimumSize(d);
obj.JBtnHeightDecrease.setMaximumSize(d);
obj.JBtnHeightDecrease.setToolTipText('Decrease channel');
set(handle(obj.JBtnHeightDecrease,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeChan(obj,-1));

obj.JToolbar(1).add(obj.JBtnHeightDecrease);
obj.JToolbar(1).addSeparator();

obj.JBtnGainIncrease=javaObjectEDT(javax.swing.JButton());
obj.JBtnGainIncrease.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/zoom_in.png']));
obj.JBtnGainIncrease.setIcon(icon);
obj.JBtnGainIncrease.setOpaque(false);

d=obj.JBtnGainIncrease.getPreferredSize();
d.width=btn_width;
obj.JBtnGainIncrease.setMinimumSize(d);
obj.JBtnGainIncrease.setMaximumSize(d);

obj.JBtnGainIncrease.setToolTipText('Increase gain (ctrl =)');
set(handle(obj.JBtnGainIncrease,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeGain(obj,1));


obj.JToolbar(1).add(obj.JBtnGainIncrease);

obj.JBtnGainDecrease=javaObjectEDT(javax.swing.JButton());
obj.JBtnGainDecrease.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/zoom_out.png']));
obj.JBtnGainDecrease.setIcon(icon);
obj.JBtnGainDecrease.setOpaque(false);
d=obj.JBtnGainDecrease.getPreferredSize();
d.width=btn_width;
obj.JBtnGainDecrease.setMinimumSize(d);
obj.JBtnGainDecrease.setMaximumSize(d);
obj.JBtnGainDecrease.setToolTipText('Decrease gain (ctrl -)');
set(handle(obj.JBtnGainDecrease,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeGain(obj,-1));

obj.JToolbar(1).add(obj.JBtnGainDecrease);

obj.JBtnAutoScale=javaObjectEDT(javax.swing.JButton());
obj.JBtnAutoScale.setBorder(javax.swing.border.EmptyBorder(0,0,0,0));
icon = javaObjectEDT(javax.swing.ImageIcon([char(globalVar.CNELAB_PATH),'/db/icon/auto_scale.png']));
obj.JBtnAutoScale.setIcon(icon);
obj.JBtnAutoScale.setOpaque(false);
d=obj.JBtnAutoScale.getPreferredSize();
d.width=btn_width;
obj.JBtnAutoScale.setMinimumSize(d);
obj.JBtnAutoScale.setMaximumSize(d);
obj.JBtnAutoScale.setToolTipText('Auto scale');
set(handle(obj.JBtnAutoScale,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeGain(obj,0));

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