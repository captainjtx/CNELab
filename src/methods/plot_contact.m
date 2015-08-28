function plot_contact(axe,col,row,r,h,w,channames,badchan)
%channames is optional
col=round(col*w);
row=round(row*h);
r=round(r*w);
if ~isempty(badchan)
    
    badcol=col(badchan);
    badrow=row(badchan);
    badr=r(badchan);
    
    col=col(~badchan);
    row=row(~badchan);
    r=r(~badchan);
    if ~isempty(channames)
        channames=channames(~badchan);
    end
end

background=uint8(ones(h,w,3)*255);
shapeInserter = vision.ShapeInserter('Shape','Circles','BorderColor','Custom',...
    'CustomBorderColor',[0,0,0],'LineWidth',1,'Antialiasing',true);
circles =int32([col, row, r]);

I = step(shapeInserter, background, circles);

if ~isempty(badchan)
    shapeInserter = vision.ShapeInserter('Shape','Circles','BorderColor','Custom',...
        'CustomBorderColor',[100,100,100],'LineWidth',1,'Antialiasing',true);
    circles=int32([badcol,badrow,badr]);
    
    I = step(shapeInserter, I, circles);
end

hold on

imgh=image(I,'parent',axe);
A=rgb2gray(I);

set(imgh,'AlphaData',255-A);
set(imgh,'Tag','contact');

for i=1:length(channames)
    text(col(i),row(i)-10,channames{i},...
    'fontsize',8,'horizontalalignment','center','parent',axe,'interpreter','none');
end



end

