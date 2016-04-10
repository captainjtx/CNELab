function BuildIOBar( obj )
import src.java.TButton;
position = getpixelposition(obj.toolbtnpane);
col=get(obj.toolbtnpane,'BackgroundColor');
btn_d=javaObjectEDT(java.awt.Dimension());
btn_d.width=position(4);
btn_d.height=position(4);
col=javaObjectEDT(java.awt.Color(col(1),col(2),col(3)));

obj.IconLoadSurface=javaObjectEDT(javax.swing.ImageIcon([obj.cnelab_path,'/db/icon/load_surf.png']));
obj.IconDeleteSurface=javaObjectEDT(javax.swing.ImageIcon([obj.cnelab_path,'/db/icon/delete_surf.png']));
obj.IconNewSurface=javaObjectEDT(javax.swing.ImageIcon([obj.cnelab_path,'/db/icon/new_surf.png']));
obj.IconSaveSurface=javaObjectEDT(javax.swing.ImageIcon([obj.cnelab_path,'/db/icon/save_surf.png']));

obj.IconLoadVolume=javaObjectEDT(javax.swing.ImageIcon([obj.cnelab_path,'/db/icon/load_vol.png']));
obj.IconDeleteVolume=javaObjectEDT(javax.swing.ImageIcon([obj.cnelab_path,'/db/icon/delete_vol.png']));
obj.IconNewVolume=javaObjectEDT(javax.swing.ImageIcon([obj.cnelab_path,'/db/icon/new_vol.png']));
obj.IconSaveVolume=javaObjectEDT(javax.swing.ImageIcon([obj.cnelab_path,'/db/icon/save_vol.png']));

obj.IconLoadElectrode=javaObjectEDT(javax.swing.ImageIcon([obj.cnelab_path,'/db/icon/load_electrode.png']));
obj.IconDeleteElectrode=javaObjectEDT(javax.swing.ImageIcon([obj.cnelab_path,'/db/icon/delete_electrode.png']));
obj.IconNewElectrode=javaObjectEDT(javax.swing.ImageIcon([obj.cnelab_path,'/db/icon/new_electrode.png']));
obj.IconSaveElectrode=javaObjectEDT(javax.swing.ImageIcon([obj.cnelab_path,'/db/icon/save_electrode.png']));

%             obj.JNewBtn=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/new.png'],btn_d,char('Recenter'),col));
%             set(handle(obj.JRecenter,'CallbackProperties'),'MousePressedCallback',@(h,e) RecenterCallback(obj));


width=position(4)/position(3);

obj.JLoadBtn=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/load_vol.png'],btn_d,char('Load volume'),col));
set(handle(obj.JLoadBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) LoadVolume(obj));

[jh,gh]=javacomponent(obj.JLoadBtn,[0,0,1,1],obj.toolbtnpane);
set(gh,'Units','Norm','Position',[0,0,width,1]);

obj.JDeleteBtn=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/delete_vol.png'],btn_d,char('Delete volume'),col));
set(handle(obj.JDeleteBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) DeleteVolume(obj));

[jh,gh]=javacomponent(obj.JDeleteBtn,[0,0,1,1],obj.toolbtnpane);
set(gh,'Units','Norm','Position',[width,0,width,1]);

obj.JNewBtn=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/new_vol.png'],btn_d,char('New volume'),col));
set(handle(obj.JNewBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) NewVolume(obj));

[jh,gh]=javacomponent(obj.JNewBtn,[0,0,1,1],obj.toolbtnpane);
set(gh,'Units','Norm','Position',[width*2,0,width,1]);

obj.JSaveBtn=javaObjectEDT(TButton([obj.cnelab_path,'/db/icon/save_vol.png'],btn_d,char('Save volume'),col));
set(handle(obj.JSaveBtn,'CallbackProperties'),'MousePressedCallback',@(h,e) SaveVolume(obj));

[jh,gh]=javacomponent(obj.JSaveBtn,[0,0,1,1],obj.toolbtnpane);
set(gh,'Units','Norm','Position',[width*3,0,width,1]);


end

