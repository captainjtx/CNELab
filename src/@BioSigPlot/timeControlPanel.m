function timeControlPanel(obj,parent,position)
import src.java.TButton;
btn_d=javaObjectEDT(java.awt.Dimension());
obj.TimePanel=uipanel(parent,'units','normalized','position',position);

position = getpixelposition(obj.TimePanel);
btn_d.width=position(3)*0.09;
btn_d.height=position(4)*0.8;

col=get(obj.TimePanel,'BackgroundColor');
col=javaObjectEDT(java.awt.Color(col(1),col(2),col(3)));

obj.JBtnStart=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/start.png'],btn_d,char('start'),col));
set(handle(obj.JBtnStart,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeTime(obj,-10));

[jh,gh]=javacomponent(obj.JBtnStart,[0.02,0.1,0.09,0.8],obj.TimePanel);
set(gh,'Units','Norm','Position',[0.02,0.1,0.09,0.8]);

obj.JBtnPrevPage=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/prev_page.png'],btn_d,char('previous page (shift + left)'),col));
set(handle(obj.JBtnPrevPage,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeTime(obj,-2));

[jh,gh]=javacomponent(obj.JBtnPrevPage,[0.15,0.1,0.09,0.8],obj.TimePanel);
set(gh,'Units','Norm','Position',[0.15,0.1,0.09,0.8]);

obj.JBtnPrevSec=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/prev_sec.png'],btn_d,char('backward (ctrl + left)'),col));
set(handle(obj.JBtnPrevSec,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeTime(obj,-1));

[jh,gh]=javacomponent(obj.JBtnPrevSec,[0.25,0.1,0.09,0.8],obj.TimePanel);
set(gh,'Units','Norm','Position',[0.25,0.1,0.09,0.8]);

obj.EdtTime=uicontrol(obj.TimePanel,'Style','edit','String',0,'units','normalized',...
    'position',[.35 0.1 .3 .8],'BackgroundColor',[1 1 1],'Callback',@(src,evt) ChangeTime(obj,src),...
    'TooltipString','page start time');

obj.JBtnNextSec=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/next_sec.png'],btn_d,char('forward (ctrl + right)'),col));
set(handle(obj.JBtnNextSec,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeTime(obj,1));

[jh,gh]=javacomponent(obj.JBtnNextSec,[0.66,0.1,0.09,0.8],obj.TimePanel);
set(gh,'Units','Norm','Position',[0.66,0.1,0.09,0.8]);

obj.JBtnNextPage=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/next_page.png'],btn_d,char('next page (shift + right)'),col));
set(handle(obj.JBtnNextPage,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeTime(obj,2));

[jh,gh]=javacomponent(obj.JBtnNextPage,[0.76,0.1,0.09,0.8],obj.TimePanel);
set(gh,'Units','Norm','Position',[0.76,0.1,0.09,0.8]);

obj.JBtnEnd=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/end.png'],btn_d,char('end'),col));
set(handle(obj.JBtnEnd,'CallbackProperties'),'MousePressedCallback',@(h,e) ChangeTime(obj,10));

[jh,gh]=javacomponent(obj.JBtnEnd,[0.87,0.1,0.09,0.8],obj.TimePanel);
set(gh,'Units','Norm','Position',[0.87,0.1,0.09,0.8]);
end