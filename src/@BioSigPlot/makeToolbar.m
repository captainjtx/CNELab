function makeToolbar(obj)
import src.java.PushButton;
import src.java.TogButton;
import src.java.ToolbarSpinner;
import javax.swing.ButtonGroup;
import javax.swing.SpinnerNumberModel;
import javax.swing.JComponent;
import javax.swing.JLabel;

d=obj.JToolbar.getPreferredSize();
btn_d=java.awt.Dimension();
btn_d.width=d.height;
btn_d.height=d.height;

spinner_d=java.awt.Dimension();
spinner_d.width=d.height*2.5;
spinner_d.height=d.height;

col=obj.JToolbar.getBackground();
%montage
obj.JTogMontage=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/Raw.png'],btn_d,char('Raw montage'),col));
set(handle(obj.JTogMontage,'CallbackProperties'),'MousePressedCallback',@(h,e) resetMontage(obj));
obj.JToolbar.add(obj.JTogMontage);

obj.JTogComAve=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/common.png'],btn_d,char('Mean reference'),col));
set(handle(obj.JTogComAve,'CallbackProperties'),'MousePressedCallback',@(h,e) resetMontage(obj,2));
obj.JToolbar.add(obj.JTogComAve);

%view

obj.IconPlay=javaObjectEDT(javax.swing.ImageIcon([obj.cnelab_path,'/db/icon/play.png']));
obj.IconPause=javaObjectEDT(javax.swing.ImageIcon([obj.cnelab_path,'/db/icon/pause.png']));

obj.JToolbar.addSeparator();

obj.JBtnSwitchData=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/switch.png'],btn_d,char('Next data'),col));
set(handle(obj.JBtnSwitchData,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeData(obj,[]));
obj.JToolbar.add(obj.JBtnSwitchData);

obj.JTogHorizontal=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/horizontal.png'],btn_d,char('Horizontal Alignment'),col));
set(handle(obj.JTogHorizontal,'CallbackProperties'),'MousePressedCallback',@(h,e) set(obj,'DataView','Horizontal'));
obj.JToolbar.add(obj.JTogHorizontal);

obj.JTogVertical=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/vertical.png'],btn_d,char('Vertical Alignment'),col));
set(handle(obj.JTogVertical,'CallbackProperties'),'MousePressedCallback',@(h,e) set(obj,'DataView','Vertical'));
obj.JToolbar.add(obj.JTogVertical);

obj.JToolbar.addSeparator();
obj.JBtnPlaySlower=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/slower.png'],btn_d,char('Slower'),col));
set(handle(obj.JBtnPlaySlower,'CallbackProperties'),'MousePressedCallback',@(h,e) PlaySlower(obj));
obj.JToolbar.add(obj.JBtnPlaySlower);

obj.JTogPlay=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/play.png'],btn_d,char('Start'),col));
set(handle(obj.JTogPlay,'CallbackProperties'),'MousePressedCallback',@(h,e) StartPlay(obj));
obj.JToolbar.add(obj.JTogPlay);

obj.JBtnPlayFaster=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/faster.png'],btn_d,char('Faster'),col));
set(handle(obj.JBtnPlayFaster,'CallbackProperties'),'MousePressedCallback',@(h,e) PlayFaster(obj));
obj.JToolbar.add(obj.JBtnPlayFaster);

obj.JTogVideo=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/video.png'],btn_d,char('Video'),col));
set(handle(obj.JTogVideo,'CallbackProperties'),'MousePressedCallback',@(h,e) WinVideoFcn(obj));
obj.JToolbar.add(obj.JTogVideo);

%tool
obj.JToolbar.addSeparator();

label = javaObjectEDT(JLabel('Chan '));
obj.JToolbar.add(label);

model = javaObjectEDT(SpinnerNumberModel(max(obj.ChanNumber),1,max(obj.ChanNumber),1));  
obj.JChannelNumberSpinner =javaObjectEDT(ToolbarSpinner(model));
    
obj.JToolbar.add(obj.JChannelNumberSpinner);

obj.JChannelNumberSpinner.setMaximumSize(spinner_d);
obj.JChannelNumberSpinner.setMinimumSize(spinner_d);
obj.JChannelNumberSpinner.setPreferredSize(spinner_d);
% obj.JChannelNumberSpinner.getEditor().getTextField().setColumns(1);
set(handle(obj.JChannelNumberSpinner,'CallbackProperties'),'StateChangedCallback',@(h,e) ChannelNumberSpinnerCallback(obj));

label = javaObjectEDT(JLabel(' Win (s) '));
obj.JToolbar.add(label);

model = javaObjectEDT(SpinnerNumberModel(obj.WinLength,0,obj.TotalTime,obj.WinLength/15));  
obj.JWindowTimeSpinner =javaObjectEDT(ToolbarSpinner(model));

% tf = obj.JWindowTimeSpinner.getEditor().getTextField();
% tf.setFocusable(false);
    
obj.JToolbar.add(obj.JWindowTimeSpinner);

obj.JWindowTimeSpinner.setMaximumSize(spinner_d);
obj.JWindowTimeSpinner.setMinimumSize(spinner_d);
obj.JWindowTimeSpinner.setPreferredSize(spinner_d);
% obj.JChannelNumberSpinner.getEditor().getTextField().setColumns(1);
set(handle(obj.JWindowTimeSpinner,'CallbackProperties'),'StateChangedCallback',@(h,e) WindowTimeSpinnerCallback(obj));

label = javaObjectEDT(JLabel(' Sen '));
obj.JToolbar.add(label);

model = javaObjectEDT(SpinnerNumberModel(java.lang.Double(1),java.lang.Double(0),[],java.lang.Double(10)));  
obj.JSensitivitySpinner =javaObjectEDT(ToolbarSpinner(model));
    
obj.JToolbar.add(obj.JSensitivitySpinner);

obj.JSensitivitySpinner.setMaximumSize(spinner_d);
obj.JSensitivitySpinner.setMinimumSize(spinner_d);
obj.JSensitivitySpinner.setPreferredSize(spinner_d);
% obj.JChannelNumberSpinner.getEditor().getTextField().setColumns(1);
set(handle(obj.JSensitivitySpinner,'CallbackProperties'),'StateChangedCallback',@(h,e) SensitivitySpinnerCallback(obj));

obj.JToolbar.addSeparator();

obj.JBtnGainIncrease=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/zoom_in.png'],btn_d,char('Increase gain (ctrl =)'),col));
set(handle(obj.JBtnGainIncrease,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeGain(obj,1));
obj.JToolbar.add(obj.JBtnGainIncrease);

obj.JBtnGainDecrease=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/zoom_out.png'],btn_d,char('Decrease gain (ctrl -)'),col));
set(handle(obj.JBtnGainDecrease,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeGain(obj,-1));
obj.JToolbar.add(obj.JBtnGainDecrease);

obj.JBtnAutoScale=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/auto.png'],btn_d,char('Auto gain'),col));
set(handle(obj.JBtnAutoScale,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeGain(obj,0));
obj.JToolbar.add(obj.JBtnAutoScale);

obj.JToolbar.addSeparator();

obj.JBtnMaskChannel=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/mask.png'],btn_d,char('Mask channel'),col));
set(handle(obj.JBtnMaskChannel,'CallbackProperties'),'MousePressedCallback',@(h,e) MaskChannel(obj,0));
obj.JToolbar.add(obj.JBtnMaskChannel);

obj.JBtnUnMaskChannel=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/unmask.png'],btn_d,char('Unmask channel'),col));
set(handle(obj.JBtnUnMaskChannel,'CallbackProperties'),'MousePressedCallback',@(h,e) MaskChannel(obj,1));
obj.JToolbar.add(obj.JBtnUnMaskChannel);

obj.JToolbar.addSeparator();

obj.JTogNavigation=javaObjectEDT(TogButton([obj.cnelab_path,'/db/icon/arrow.png'],btn_d,char('Navigation'),col));
set(handle(obj.JTogNavigation,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeMouseMode(obj,0));
obj.JToolbar.add(obj.JTogNavigation);

obj.JToolbar.addSeparator();
obj.JTogSelection=javaObjectEDT(TogButton([obj.cnelab_path,'/db/icon/select.png'],btn_d,char('Selection'),col));
set(handle(obj.JTogSelection,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeMouseMode(obj,2));
obj.JToolbar.add(obj.JTogSelection);

obj.JBtnSelectWin=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/select_win.png'],btn_d,char('Select window'),col));
set(handle(obj.JBtnSelectWin,'CallbackProperties'),'MousePressedCallback',@(h,e) SelectCurrentWindow(obj));
obj.JToolbar.add(obj.JBtnSelectWin);

obj.JToolbar.addSeparator();

obj.JTogMeasurer=javaObjectEDT(TogButton([obj.cnelab_path,'/db/icon/measurer.png'],btn_d,char('Amplitude measurer'),col));
set(handle(obj.JTogMeasurer,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeMouseMode(obj,1));
obj.JToolbar.add(obj.JTogMeasurer);

obj.JToolbar.addSeparator();

obj.JTogAnnotate=javaObjectEDT(TogButton([obj.cnelab_path,'/db/icon/evts.png'],btn_d,char('Annotate (ctrl i)'),col));
set(handle(obj.JTogAnnotate,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeMouseMode(obj,3));
obj.JToolbar.add(obj.JTogAnnotate);

obj.JToolbar.addSeparator();

obj.JBtnPSD=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/psd.png'],btn_d,char('Power Spectrum Density'),col));
set(handle(obj.JBtnPSD,'CallbackProperties'),'MousePressedCallback',@(h,e) obj.PSDWin.ComputeCallback());
obj.JToolbar.add(obj.JBtnPSD);

obj.JToolbar.addSeparator();

obj.JBtnTFMap=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/tfmap.png'],btn_d,char('Time-Frequency Map'),col));
set(handle(obj.JBtnTFMap,'CallbackProperties'),'MousePressedCallback',@(h,e) obj.TFMapWin.ComputeCallback());
obj.JToolbar.add(obj.JBtnTFMap);

obj.JToolbar.addSeparator();

obj.JBtnPCA=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/pca.png'],btn_d,char('Principle Component Analysis'),col));
set(handle(obj.JBtnPCA,'CallbackProperties'),'MousePressedCallback',@(h,e) SPF_Analysis(obj,'pca'));
obj.JToolbar.add(obj.JBtnPCA);

obj.JToolbar.addSeparator();

obj.JBtnICA=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/ica.png'],btn_d,char('Independent Component Analysis'),col));
set(handle(obj.JBtnICA,'CallbackProperties'),'MousePressedCallback',@(h,e) SPF_Analysis(obj,'ica'));
obj.JToolbar.add(obj.JBtnICA);

obj.JToolbar.addSeparator();

obj.JBtnPlayAsSound=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/sound.png'],btn_d,char('Play As Audio'),col));
set(handle(obj.JBtnPlayAsSound,'CallbackProperties'),'MousePressedCallback',@(h,e) PlayDataAsSound(obj));
obj.JToolbar.add(obj.JBtnPlayAsSound);


group=javaObjectEDT(ButtonGroup());
group.add(obj.JTogMeasurer);
group.add(obj.JTogAnnotate);
group.add(obj.JTogSelection);
group.add(obj.JTogNavigation);

obj.JToolbar.repaint;
obj.JToolbar.revalidate;
end


