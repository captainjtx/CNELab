function LoadElectrode( obj )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[filename,pathname]=uigetfile({'*.mat;*.txt','Data format (*.mat)'},'Please select electrode file');
fpath=[pathname filename];
if ~filename
    return;
end

if obj.mapObj.isKey(fpath)
    errordlg('Already loaded !');
    return
end

obj.electrode=load(fpath,'-mat');

mapval.id='electrode';

for i=1:size(obj.electrode.coor,1)
    userdat.ind=i;
    userdat.select=false;
    
    [faces,vertices] = createContact3D(obj.electrode.coor(i,:),obj.electrode.coor(i,:),obj.electrode.radius(i),obj.electrode.thickness(i));
    
    mapval.handles(i)=patch('faces',faces,'vertices',vertices,...
        'facecolor',obj.electrode.color(i,:),'edgecolor','none','UserData',userdat,...
        'ButtonDownFcn',@(src,evt) ClickOnElectrode(obj,src),'facelighting','gouraud');
end

obj.JFileLoadTree.addElectrode(fpath,true);
obj.mapObj(fpath)=mapval;
material dull;
end

function ClickOnElectrode(obj,src)
dat=get(src,'UserData');

if dat.select
    set(src,'facecolor',obj.electrode.color(dat.ind,:));
    dat.select=false;
else
    set(src,'facecolor','g');
    dat.select=true;
end

set(src,'UserData',dat);
end

