function BuildToolbar( obj )
import src.java.PushButton;
import src.java.TogButton;

obj.Toolbar=uitoolbar(obj.fig);
drawnow
obj.JToolbar=get(get(obj.Toolbar,'JavaContainer'),'ComponentPeer');
d=obj.JToolbar(1).getPreferredSize();
btn_d=javaObjectEDT(java.awt.Dimension());
btn_d.width=d.height;
btn_d.height=d.height;
col=obj.JToolbar(1).getBackground();

obj.IconLightOn=javaObjectEDT(javax.swing.ImageIcon([obj.cnelab_path,'/db/icon/light.png']));
obj.IconLightOff=javaObjectEDT(javax.swing.ImageIcon([obj.cnelab_path,'/db/icon/nolight.png']));

obj.JRecenter=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/recenter.png'],btn_d,char('Recenter'),col));
set(handle(obj.JRecenter,'CallbackProperties'),'MousePressedCallback',@(h,e) RecenterCallback(obj));
obj.JToolbar(1).add(obj.JRecenter);

obj.JLight=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/nolight.png'],btn_d,char('Light off'),col));
set(handle(obj.JLight,'CallbackProperties'),'MousePressedCallback',@(h,e) LightOffCallback(obj));
obj.JToolbar(1).add(obj.JLight);

obj.JCanvasColor=javaObjectEDT(PushButton([obj.cnelab_path,'/db/icon/bg_color.png'],btn_d,char('Canvas color'),col));
set(handle(obj.JCanvasColor,'CallbackProperties'),'MousePressedCallback',@(src,evt) ChangeCanvasColor(obj));
obj.JToolbar(1).add(obj.JCanvasColor);

obj.JToolbar(1).addSeparator();

obj.JTogNewElectrode=javaObjectEDT(TogButton([obj.cnelab_path,'/db/icon/evts.png'],btn_d,char('New electrode (ctrl i)'),col));
set(handle(obj.JTogNewElectrode,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeMouseMode(obj,1));
obj.JToolbar(1).add(obj.JTogNewElectrode);
obj.JToolbar(1).addSeparator();

obj.JToolbar(1).repaint;
obj.JToolbar(1).revalidate;
end
