function BuildToolbar( obj )
obj.Toolbar=uitoolbar(obj.fig);
drawnow
obj.JToolbar=get(get(obj.Toolbar,'JavaContainer'),'ComponentPeer');
d=obj.JToolbar(1).getPreferredSize();
btn_d=javaObjectEDT(java.awt.Dimension());
btn_d.width=d.height;
btn_d.height=d.height;
col=obj.JToolbar(1).getBackground();


obj.JRecenter=javaObjectEDT(TButton([char(globalVar.CNELAB_PATH),'/db/icon/recenter.png'],btn_d,char('Recenter'),col));
set(handle(obj.JRecenter,'CallbackProperties'),'MousePressedCallback',@(h,e) RecenterCallback(obj));
obj.JToolbar(1).add(obj.JRecenter);

obj.JToolbar(1).addSeparator();


obj.JToolbar(1).repaint;
obj.JToolbar(1).revalidate;
end
