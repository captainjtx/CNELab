function plot_contact(axe,col,row,r,h,w,channames)
%channames is optional
background=uint8(ones(h,w,3)*255);
shapeInserter = vision.ShapeInserter('Shape','Circles','BorderColor','Custom','CustomBorderColor',[0,0,0],'LineWidth',1);
circles=[];

col=round(col*w);
row=round(row*h);
r=round(r*w);
for i=1:length(col)
    circles = cat(1,circles,int32([col(i) row(i) r(i)]));
%     viscircles(a,[col(i)/width,row(i)/height],r,'EdgeColor','k');
end

I = step(shapeInserter, background, circles);

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

