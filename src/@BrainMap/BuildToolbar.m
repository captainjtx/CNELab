function BuildToolbar( obj )
import src.java.TButton;

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


obj.JRecenter=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/recenter.png'],btn_d,char('Recenter'),col));
set(handle(obj.JRecenter,'CallbackProperties'),'MousePressedCallback',@(h,e) RecenterCallback(obj));
obj.JToolbar(1).add(obj.JRecenter);

obj.JLight=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/nolight.png'],btn_d,char('Light off'),col));
set(handle(obj.JLight,'CallbackProperties'),'MousePressedCallback',@(h,e) LightOffCallback(obj));
obj.JToolbar(1).add(obj.JLight);

obj.JCanvasColor=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/bg_color.png'],btn_d,char('Canvas color'),col));
set(handle(obj.JCanvasColor,'CallbackProperties'),'MousePressedCallback',@(src,evt) ChangeCanvasColor(obj));
obj.JToolbar(1).add(obj.JCanvasColor);

obj.JToolbar(1).repaint;
obj.JToolbar(1).revalidate;
end
