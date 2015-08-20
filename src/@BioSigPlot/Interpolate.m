function Interpolate(obj)
%INTERPOLATE Summary of this function goes here
%   Detailed explanation goes here

[data,chanNames,dataset,channel,sample,evts,groupnames,pos]=get_selected_data(obj);

if length(chanNames)>1
    msgbox('More than one channel selected!','Interpolate','error');
    return
end

allChanNames=obj.MontageChanNames{dataset};
chanpos=obj.Montage{dataset}(obj.MontageRef(dataset)).position;

height=400;
width=500;

h=figure('Name','Interpolation','units','pixels','position',[150,150,width,height],'MenuBar','None',...
    'NumberTitle','off');

chanind=~isnan(chanpos(:,1))&~isnan(chanpos(:,2));
allChanNames=allChanNames(chanind);
chanpos=chanpos(chanind,:);
            
chanpos(:,1)=chanpos(:,1)-min(chanpos(:,1));
chanpos(:,2)=chanpos(:,2)-min(chanpos(:,2));


dx=abs(pdist2(chanpos(:,1),chanpos(:,1)));
dx=min(dx(dx~=0));
if isempty(dx)
    dx=1;
end

dy=abs(pdist2(chanpos(:,2),chanpos(:,2)));
dy=min(dy(dy~=0));
if isempty(dy)
    dy=1;
end
chanpos(:,1)=chanpos(:,1)+dx/2;
chanpos(:,2)=chanpos(:,2)+dy*0.6;

x_len=max(chanpos(:,1))+dx/2;
y_len=max(chanpos(:,2))+dy*0.6;

if x_len>y_len
    height=round(width/x_len*y_len);
else
    width=round(height/y_len*x_len);
end
set(h,'position',[150,150,width,height])
chanpos(:,1)=chanpos(:,1)/x_len;
chanpos(:,2)=chanpos(:,2)/y_len;

a=axes('units','normalized','position',[0,0,1,1],'Visible','off','parent',h,...
    'xlimmode','manual','ylimmode','manual');

% set(a,'XLim',[0,1]);
% set(a,'YLim',[0,1]);

col=max(1,round(chanpos(:,1)*width));
row=max(1,round(chanpos(:,2)*height));

r=10;

background=uint8(ones(height,width,3)*255);
shapeInserter = vision.ShapeInserter('Shape','Circles','BorderColor','Custom','CustomBorderColor',[0,0,0]);
circles=[];
for i=1:length(allChanNames)
    circles = cat(1,circles,int32([col(i) row(i) r]));
%     viscircles(a,[col(i)/width,row(i)/height],r,'EdgeColor','k');
end

I = step(shapeInserter, background, circles);
imshow(I);

end

