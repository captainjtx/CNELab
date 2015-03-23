function MnuFigurePosition(obj)

prompt={'X Coordinate (pixel): ','Y Coordinate (pixel): ',...
    'Width (pixel): ','Height (pixel): '};

pos=get(obj.Fig,'Position');
def={num2str(pos(1)),num2str(pos(2)),num2str(pos(3)),num2str(pos(4))};

title='Set Figure Position';

answer=inputdlg(prompt,title,1,def);

for i=1:length(answer)
    tmp=str2double(answer{i});
    if isempty(tmp)||isnan(tmp)
        tmp=pos(i);
    end
    
    pos(i)=tmp;
end

oldpos=get(obj.Fig,'Position');

if ~all(oldpos==pos)
    set(obj.Fig,'Position',pos);
end
end