function LoadElectrode( obj )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
[filename,pathname]=uigetfile({'*.mat;*.txt','Data format (*.mat)'},'Please select electrode file');
fpath=[pathname filename];
if ~filename
    return;
end
dat=load(fpath);
obj.electrode=dat.electrode_information;
for i=1:length(obj.electrode)
    obj.curr_elec.side=patch('faces',obj.electrode(i).side.Faces,...
        'vertices',obj.electrode(i).side.Vertices,...
        'facecolor',obj.electrode(i).col,'edgecolor','none');
    obj.curr_elec.top=patch('faces',obj.electrode(i).top.Faces,...
        'vertices',obj.electrode(i).top.Vertices,...
        'facecolor',obj.electrode(i).col,'edgecolor','none');
    if ~isempty(obj.electrode(i).stick)
        obj.curr_elec.stick=patch('faces',obj.electrode(i).stick.Faces,...
            'vertices',obj.electrode(i).stick.Vertices,...
            'facecolor',[0 0 0],'edgecolor','none','facealpha',0.3);
    else
        obj.curr_elec.stick=[];
    end
end

obj.elec_no=length(obj.electrode);
obj.elec_index=obj.elec_no;
for i=1:obj.elec_no
    list{i}=strcat('Electrode',' ',num2str(i));
end
%set(obj.elec_list,'string',list,'enable','on','value',obj.elec_index);
ele_id=obj.elec_index;
obj.curr_coor=obj.electrode(ele_id).coor;
obj.color=obj.electrode(ele_id).col;
x=obj.curr_coor(:,1);y=obj.curr_coor(:,2);z=obj.curr_coor(:,3);
try
    set(obj.label,'position',[x(1)-3 y(1)-3 z(1)+3],'visible','on');
catch
    obj.label=text(x(1)-3,y(1)-3,z(1)+3,'C1','fontsize',12,'color',[0 0 0]) ;
end
obj.self_center=mean(obj.curr_coor);
obj.position_bak.side=get(obj.curr_elec.side,'vertices');
obj.position_bak.top=get(obj.curr_elec.top,'vertices');
try
    obj.position_bak.stick=get(obj.curr_elec.stick,'vertices');
catch
    obj.position_bak.stick=[];
end
obj.position_bak.coor=obj.curr_coor;

end

