function h=colormap_popup(varargin)
cmapList = {'Gray','Bone', 'Copper','Jet', 'HSV', 'Hot', 'Cool', 'Spring', 'Summer', 'Autumn', ...
    'Winter', 'Pink', 'Lines'}';
varargin=cat(2,varargin,{'style','popup','String',cmapList,'FontName','Courier','BackgroundColor','w'});

h=uicontrol(varargin{:});
allLength = cellfun(@numel,cmapList);
maxLength = max(allLength);
cmapHTML = [];
for i = 1:numel(cmapList)
    arrow = [repmat('-',1,maxLength-allLength(i)+1) '>'];
    cmapFun = str2func(['@(x) ' lower(cmapList{i}) '(x)']);
    cData = cmapFun(16);
    curHTML = ['<html>' cmapList{i} '<font color="#FFFFFF">' arrow '</font>'];
    for j = 1:16
        HEX = rgb2hex(cData(j,:));
        curHTML = [curHTML '<font bgcolor="' HEX '" color="' HEX '">_</font>'];
    end
    curHTML = [curHTML '</html>'];
    cmapHTML = [cmapHTML; {curHTML}];
end

set(h,'String',cmapHTML);
set(h,'UserData',cmapList);
end