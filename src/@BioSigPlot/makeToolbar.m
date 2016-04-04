function makeToolbar(obj)
d=obj.JToolbar(1).getPreferredSize();
btn_d=java.awt.Dimension();
btn_d.width=d.height;
btn_d.height=d.height;
col=obj.JToolbar(1).getBackground();
%montage

obj.JTogMontage=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/Raw.png'],btn_d,char('Raw montage'),col));
set(handle(obj.JTogMontage,'CallbackProperties'),'MousePressedCallback',@(h,e) resetMontage(obj));
obj.JToolbar(1).add(obj.JTogMontage);

obj.JTogComAve=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/common.png'],btn_d,char('Mean reference'),col));
set(handle(obj.JTogComAve,'CallbackProperties'),'MousePressedCallback',@(h,e) resetMontage(obj,2));
obj.JToolbar(1).add(obj.JTogComAve);

%view

obj.IconPlay=javaObjectEDT(javax.swing.ImageIcon([obj.cnelab_path,'/db/icon/play.png']));
obj.IconPause=javaObjectEDT(javax.swing.ImageIcon([obj.cnelab_path,'/db/icon/pause.png']));

obj.JToolbar(1).addSeparator();

obj.JBtnSwitchData=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/switch.png'],btn_d,char('Next data'),col));
set(handle(obj.JBtnSwitchData,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeData(obj,[]));
obj.JToolbar(1).add(obj.JBtnSwitchData);

obj.JTogHorizontal=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/horizontal.png'],btn_d,char('Horizontal Alignment'),col));
set(handle(obj.JTogHorizontal,'CallbackProperties'),'MousePressedCallback',@(h,e) set(obj,'DataView','Horizontal'));
obj.JToolbar(1).add(obj.JTogHorizontal);

obj.JTogVertical=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/vertical.png'],btn_d,char('Vertical Alignment'),col));
set(handle(obj.JTogVertical,'CallbackProperties'),'MousePressedCallback',@(h,e) set(obj,'DataView','Vertical'));
obj.JToolbar(1).add(obj.JTogVertical);

obj.JToolbar(1).addSeparator();

obj.JBtnPlaySlower=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/slower.png'],btn_d,char('Slower'),col));
set(handle(obj.JBtnPlaySlower,'CallbackProperties'),'MousePressedCallback',@(h,e) PlaySlower(obj));
obj.JToolbar(1).add(obj.JBtnPlaySlower);

obj.JTogPlay=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/play.png'],btn_d,char('Start'),col));
set(handle(obj.JTogPlay,'CallbackProperties'),'MousePressedCallback',@(h,e) StartPlay(obj));
obj.JToolbar(1).add(obj.JTogPlay);

obj.JBtnPlayFaster=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/faster.png'],btn_d,char('Faster'),col));
set(handle(obj.JBtnPlayFaster,'CallbackProperties'),'MousePressedCallback',@(h,e) PlayFaster(obj));
obj.JToolbar(1).add(obj.JBtnPlayFaster);

obj.JTogVideo=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/video.png'],btn_d,char('Video'),col));
set(handle(obj.JTogVideo,'CallbackProperties'),'MousePressedCallback',@(h,e) WinVideoFcn(obj));
obj.JToolbar(1).add(obj.JTogVideo);

%tool
obj.JToolbar(1).addSeparator();

obj.JBtnWidthIncrease=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/time_increase.png'],btn_d,char('Increase time'),col));
set(handle(obj.JBtnWidthIncrease,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeDuration(obj,1));
obj.JToolbar(1).add(obj.JBtnWidthIncrease);

obj.JBtnWidthDecrease=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/time_decrease.png'],btn_d,char('Decrease time'),col));
set(handle(obj.JBtnWidthDecrease,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeDuration(obj,-1));
obj.JToolbar(1).add(obj.JBtnWidthDecrease);

obj.JBtnHeightIncrease=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/chan_increase.png'],btn_d,char('Increase chan'),col));
set(handle(obj.JBtnHeightIncrease,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeChan(obj,1));
obj.JToolbar(1).add(obj.JBtnHeightIncrease);

obj.JBtnHeightDecrease=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/chan_decrease.png'],btn_d,char('Decrease chan'),col));
set(handle(obj.JBtnHeightDecrease,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeChan(obj,-1));
obj.JToolbar(1).add(obj.JBtnHeightDecrease);

obj.JToolbar(1).addSeparator();

obj.JBtnGainIncrease=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/zoom_in.png'],btn_d,char('Increase gain (ctrl =)'),col));
set(handle(obj.JBtnGainIncrease,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeGain(obj,1));
obj.JToolbar(1).add(obj.JBtnGainIncrease);

obj.JBtnGainDecrease=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/zoom_out.png'],btn_d,char('Decrease gain (ctrl -)'),col));
set(handle(obj.JBtnGainDecrease,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeGain(obj,-1));
obj.JToolbar(1).add(obj.JBtnGainDecrease);

obj.JBtnAutoScale=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/auto.png'],btn_d,char('Auto gain'),col));
set(handle(obj.JBtnAutoScale,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeGain(obj,0));
obj.JToolbar(1).add(obj.JBtnAutoScale);

obj.JToolbar(1).addSeparator();

obj.JBtnMaskChannel=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/mask.png'],btn_d,char('Mask channel'),col));
set(handle(obj.JBtnMaskChannel,'CallbackProperties'),'MousePressedCallback',@(h,e) MaskChannel(obj,0));
obj.JToolbar(1).add(obj.JBtnMaskChannel);

obj.JBtnUnMaskChannel=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/unmask.png'],btn_d,char('Unmask channel'),col));
set(handle(obj.JBtnUnMaskChannel,'CallbackProperties'),'MousePressedCallback',@(h,e) MaskChannel(obj,1));
obj.JToolbar(1).add(obj.JBtnUnMaskChannel);

obj.JToolbar(1).addSeparator();

obj.JTogSelection=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/select.png'],btn_d,char('Selection'),col));
set(handle(obj.JTogSelection,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeMouseMode(obj,2));
obj.JToolbar(1).add(obj.JTogSelection);

obj.JBtnSelectWin=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/select_win.png'],btn_d,char('Select window'),col));
set(handle(obj.JBtnSelectWin,'CallbackProperties'),'MousePressedCallback',@(h,e) SelectCurrentWindow(obj));
obj.JToolbar(1).add(obj.JBtnSelectWin);

obj.JToolbar(1).addSeparator();

obj.JTogMeasurer=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/measurer.png'],btn_d,char('Amplitude measurer'),col));
set(handle(obj.JTogMeasurer,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeMouseMode(obj,1));
obj.JToolbar(1).add(obj.JTogMeasurer);

obj.JToolbar(1).addSeparator();

obj.JTogAnnotate=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/evts.png'],btn_d,char('Annotate (ctrl i)'),col));
set(handle(obj.JTogAnnotate,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeMouseMode(obj,3));
obj.JToolbar(1).add(obj.JTogAnnotate);

obj.JToolbar(1).addSeparator();

obj.JBtnPSD=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/psd.png'],btn_d,char('Power Spectrum Density'),col));
set(handle(obj.JBtnPSD,'CallbackProperties'),'MousePressedCallback',@(h,e) obj.PSDWin.ComputeCallback());
obj.JToolbar(1).add(obj.JBtnPSD);

obj.JToolbar(1).addSeparator();

obj.JBtnTFMap=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/tfmap.png'],btn_d,char('Time-Frequency Map'),col));
set(handle(obj.JBtnTFMap,'CallbackProperties'),'MousePressedCallback',@(h,e) obj.TFMapWin.ComputeCallback());
obj.JToolbar(1).add(obj.JBtnTFMap);

obj.JToolbar(1).addSeparator();

obj.JBtnPCA=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/pca.png'],btn_d,char('Principle Component Analysis'),col));
set(handle(obj.JBtnPCA,'CallbackProperties'),'MousePressedCallback',@(h,e) SPF_Analysis(obj,'pca'));
obj.JToolbar(1).add(obj.JBtnPCA);

obj.JToolbar(1).addSeparator();

obj.JBtnICA=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/ica.png'],btn_d,char('Independent Component Analysis'),col));
set(handle(obj.JBtnICA,'CallbackProperties'),'MousePressedCallback',@(h,e) SPF_Analysis(obj,'ica'));
obj.JToolbar(1).add(obj.JBtnICA);


obj.JToolbar(1).repaint;
obj.JToolbar(1).revalidate;
end


