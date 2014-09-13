function infoControlPanel(obj,parent,position)
obj.InfoPanel=uipanel(parent,'units','normalized','position',position);

InfoPanel1=uipanel(obj.InfoPanel,'units','normalized','position',[0,0,0.6,1]);
InfoPanel2=uipanel(obj.InfoPanel,'units','normalized','position',[0.6,0,0.4,1]);

s1=['Data: ','1',' ; ',...
    'SR: ','-',' ; ',...
    'Chan: ','-'];

s2=['Gain: ','-',' ; ',...
    'Value: ','-'];

s3=['Time: ','-',':','-',':','-',...
    ' -- ','-','%'];

s4=['FL: ','-',' , ',...
    'FH: ','-','  ;  ',...
    'FN1: ','-',' , ',...
    'FN2: ','-','  ;  ',...
    'FCUM:','-'];

obj.TxtInfo1=uicontrol(InfoPanel1,'Style','text','units','normalized',...
    'position',[0,0.5,1,0.5],'HorizontalAlignment','Left','String',s1);

obj.TxtInfo2=uicontrol(InfoPanel1,'Style','text','units','normalized',...
    'position',[0,0,1,0.5],'HorizontalAlignment','Left','String',s4);

obj.TxtInfo3=uicontrol(InfoPanel2,'Style','text','units','normalized',...
    'position',[0,0.5,1,0.5],'HorizontalAlignment','Left','String',s3);

obj.TxtInfo4=uicontrol(InfoPanel2,'Style','text','units','normalized',...
    'position',[0,0,1,0.5],'HorizontalAlignment','Left','String',s2);
end