electrode=load('/Users/tengi/Desktop/Projects/data/Turkey/s1/electrode.mat');
for i=9:8:49
    new_coor=electrode.coor(strcmp(['C',num2str(65+(i-9)/8*7),'_S'],electrode.channame),:)+...
        electrode.coor(strcmp(['C',num2str(65+(i-9)/8*7+7),'_S'],electrode.channame),:)-...
        electrode.coor(strcmp(['C',num2str(i+1),'_L'],electrode.channame),:);
    new_norm=electrode.norm(strcmp(['C',num2str(65+(i-9)/8*7),'_S'],electrode.channame),:)+...
        electrode.norm(strcmp(['C',num2str(65+(i-9)/8*7+7),'_S'],electrode.channame),:)-...
        electrode.norm(strcmp(['C',num2str(i+1),'_L'],electrode.channame),:);
    new_radius=1.6;
    new_thickness=0.4;
    new_color=[218,165,31]/255;
    new_channame=['C',num2str(i),'_L'];
    
    electrode.coor=cat(1,electrode.coor,new_coor);
    electrode.norm=cat(1,electrode.norm,new_norm);
    electrode.radius=cat(1,electrode.radius(:),new_radius);
    electrode.thickness=cat(1,electrode.thickness(:),new_thickness);
    electrode.color=cat(1,electrode.color,new_color);
    
    electrode.channame=cat(1,electrode.channame(:),new_channame);
end

for i=2:7
    new_coor=electrode.coor(strcmp(['C',num2str(65+i-2),'_S'],electrode.channame),:)+...
        electrode.coor(strcmp(['C',num2str(65+i-1),'_S'],electrode.channame),:)-...
        electrode.coor(strcmp(['C',num2str(10+i-2),'_L'],electrode.channame),:);
    new_norm=electrode.norm(strcmp(['C',num2str(65+i-2),'_S'],electrode.channame),:)+...
        electrode.norm(strcmp(['C',num2str(65+i-1),'_S'],electrode.channame),:)-...
        electrode.norm(strcmp(['C',num2str(10+i-2),'_L'],electrode.channame),:);
    new_radius=1.6;
    new_thickness=0.4;
    new_color=[218,165,31]/255;
    new_channame=['C',num2str(i),'_L'];
    
    electrode.coor=cat(1,electrode.coor,new_coor);
    electrode.norm=cat(1,electrode.norm,new_norm);
    electrode.radius=cat(1,electrode.radius(:),new_radius);
    electrode.thickness=cat(1,electrode.thickness(:),new_thickness);
    electrode.color=cat(1,electrode.color,new_color);
    
    electrode.channame=cat(1,electrode.channame(:),new_channame);
end

for i=58:63
    new_coor=electrode.coor(strcmp(['C',num2str(107+i-58),'_S'],electrode.channame),:)+...
        electrode.coor(strcmp(['C',num2str(107+i-57),'_S'],electrode.channame),:)-...
        electrode.coor(strcmp(['C',num2str(50+i-58),'_L'],electrode.channame),:);
    new_norm=electrode.norm(strcmp(['C',num2str(107+i-58),'_S'],electrode.channame),:)+...
        electrode.norm(strcmp(['C',num2str(107+i-57),'_S'],electrode.channame),:)-...
        electrode.norm(strcmp(['C',num2str(50+i-58),'_L'],electrode.channame),:);
    new_radius=1.6;
    new_thickness=0.4;
    new_color=[218,165,31]/255;
    new_channame=['C',num2str(i),'_L'];
    
    electrode.coor=cat(1,electrode.coor,new_coor);
    electrode.norm=cat(1,electrode.norm,new_norm);
    electrode.radius=cat(1,electrode.radius(:),new_radius);
    electrode.thickness=cat(1,electrode.thickness(:),new_thickness);
    electrode.color=cat(1,electrode.color,new_color);
    
    electrode.channame=cat(1,electrode.channame(:),new_channame);
end

for i=16:8:56
    new_coor=electrode.coor(strcmp(['C',num2str(71+(i-16)/8*7),'_S'],electrode.channame),:)+...
        electrode.coor(strcmp(['C',num2str(71+(i-16)/8*7+7),'_S'],electrode.channame),:)-...
        electrode.coor(strcmp(['C',num2str(i-1),'_L'],electrode.channame),:);
    new_norm=electrode.norm(strcmp(['C',num2str(71+(i-16)/8*7),'_S'],electrode.channame),:)+...
        electrode.norm(strcmp(['C',num2str(71+(i-16)/8*7+7),'_S'],electrode.channame),:)-...
        electrode.norm(strcmp(['C',num2str(i-1),'_L'],electrode.channame),:);
    new_radius=1.6;
    new_thickness=0.4;
    new_color=[218,165,31]/255;
    new_channame=['C',num2str(i),'_L'];
    
    electrode.coor=cat(1,electrode.coor,new_coor);
    electrode.norm=cat(1,electrode.norm,new_norm);
    electrode.radius=cat(1,electrode.radius(:),new_radius);
    electrode.thickness=cat(1,electrode.thickness(:),new_thickness);
    electrode.color=cat(1,electrode.color,new_color);
    
    electrode.channame=cat(1,electrode.channame(:),new_channame);
end
%%
new_coor=-electrode.coor(strcmp('C10_L',electrode.channame),:)+2*electrode.coor(strcmp('C65_S',electrode.channame),:);
new_norm=-electrode.norm(strcmp('C10_L',electrode.channame),:)+2*electrode.norm(strcmp('C65_S',electrode.channame),:);
new_radius=1.6;
new_thickness=0.4;
new_color=[218,165,31]/255;
new_channame='C1_L';
    
electrode.coor=cat(1,electrode.coor,new_coor);
electrode.norm=cat(1,electrode.norm,new_norm);
electrode.radius=cat(1,electrode.radius(:),new_radius);
electrode.thickness=cat(1,electrode.thickness(:),new_thickness);
electrode.color=cat(1,electrode.color,new_color);
electrode.channame=cat(1,electrode.channame(:),new_channame);
%%
new_coor=-electrode.coor(strcmp('C50_L',electrode.channame),:)+2*electrode.coor(strcmp('C107_S',electrode.channame),:);
new_norm=-electrode.norm(strcmp('C50_L',electrode.channame),:)+2*electrode.norm(strcmp('C107_S',electrode.channame),:);
new_radius=1.6;
new_thickness=0.4;
new_color=[218,165,31]/255;
new_channame='C57_L';
    
electrode.coor=cat(1,electrode.coor,new_coor);
electrode.norm=cat(1,electrode.norm,new_norm);
electrode.radius=cat(1,electrode.radius(:),new_radius);
electrode.thickness=cat(1,electrode.thickness(:),new_thickness);
electrode.color=cat(1,electrode.color,new_color);

electrode.channame=cat(1,electrode.channame(:),new_channame);
%%
new_coor=-electrode.coor(strcmp('C55_L',electrode.channame),:)+2*electrode.coor(strcmp('C113_S',electrode.channame),:);
new_norm=-electrode.norm(strcmp('C55_L',electrode.channame),:)+2*electrode.norm(strcmp('C113_S',electrode.channame),:);
new_radius=1.6;
new_thickness=0.4;
new_color=[218,165,31]/255;
new_channame='C64_L';
    
electrode.coor=cat(1,electrode.coor,new_coor);
electrode.norm=cat(1,electrode.norm,new_norm);
electrode.radius=cat(1,electrode.radius(:),new_radius);
electrode.thickness=cat(1,electrode.thickness(:),new_thickness);
electrode.color=cat(1,electrode.color,new_color);

electrode.channame=cat(1,electrode.channame(:),new_channame);
%%
new_coor=-electrode.coor(strcmp('C15_L',electrode.channame),:)+2*electrode.coor(strcmp('C71_S',electrode.channame),:);
new_norm=-electrode.norm(strcmp('C15_L',electrode.channame),:)+2*electrode.norm(strcmp('C71_S',electrode.channame),:);
new_radius=1.6;
new_thickness=0.4;
new_color=[218,165,31]/255;
new_channame='C8_L';
    
electrode.coor=cat(1,electrode.coor,new_coor);
electrode.norm=cat(1,electrode.norm,new_norm);
electrode.radius=cat(1,electrode.radius(:),new_radius);
electrode.thickness=cat(1,electrode.thickness(:),new_thickness);
electrode.color=cat(1,electrode.color,new_color);

electrode.channame=cat(1,electrode.channame(:),new_channame);

save('/Users/tengi/Desktop/Projects/data/Turkey/s1/electrode1.mat','-struct','electrode')
    