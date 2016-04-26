function plot_contact(axe,mapv,col,row,r,h,w,channames,varargin)
%channames is optional
col=round(col*w);
row=round(row*h);
r=round(r*w);

all_col=col;
all_row=row;

badchan=zeros(size(col));
erdchan=[];
erschan=[];

switch length(varargin)
    case 1
        badchan=varargin{1};
    case 2
        badchan=varargin{1};
        erdchan=varargin{2};
    case 3
        badchan=varargin{1};
        erdchan=varargin{2};
        erschan=varargin{3};
end

%*bad channels
badchan=logical(badchan);

badcol=col(badchan);
badrow=row(badchan);
badr=r(badchan);

col=col(~badchan);
row=row(~badchan);
r=r(~badchan);
% %**********************************
if isempty(erdchan)
    erdchan=zeros(size(col));
end
erdchan=logical(erdchan);

if isempty(erschan)
    erschan=zeros(size(col));
end
erschan=logical(erschan);
%**********************************
% erdchan=erdchan(~badchan);
% erschan=erschan(~badchan);

erdcol=col(erdchan);
erdrow=row(erdchan);
% erdr=r(erdchan);
erdr=ones(size(erdchan))*max(r)*1.5;

erscol=col(erschan);
ersrow=row(erschan);
% ersr=r(erschan);
ersr=ones(size(erschan))*max(r)*1.5;

col=col(~erdchan&~erschan);
row=row(~erdchan&~erschan);
r=r(~erdchan&~erschan);

if ~isempty(channames)
    all_channames=channames;
else
    all_channames=[];
end

background=uint8(ones(h,w,3)*255);

circles =[col, row, r];

cmap=colormap(axe);
cmap=round(cmap*255);
cl=get(axe,'CLim');

clevel=linspace(cl(1),cl(2),size(cmap,1));

cmapv=zeros(length(mapv),3);
for i=1:length(mapv)
    [~,index] = min(abs(clevel-mapv(i)));
    cmapv(i,:)=cmap(index,:);
end

if isempty(mapv)
    I = insertShape(background,'Circle',circles,'Color',[0,0,0],'LineWidth',1);
else
    I = insertShape(background,'FilledCircle',circles,'Color',cmapv(~erdchan&~erschan,:),'LineWidth',1);
end

if ~isempty(badcol)
    circles=[badcol,badrow,badr];
    I = insertShape(I,'Circle',circles,'Color',[100,100,100],'LineWidth',1);
end

alpha=pi/4;

[az,el] = view(axe);
rotation_m=[cosd(-az),-sind(-az);sind(-az),cosd(-az)];

if ~isempty(erdcol)
    
    triangles=zeros(0,6);
    
    for i=1:length(erdcol)
        
        offset1=[0;erdr(i)];
        offset1=rotation_m*offset1;
        
        offset2=[cos(alpha)*erdr(i);-sin(alpha)*erdr(i)];
        offset2=rotation_m*offset2;
        
        offset3=[-cos(alpha)*erdr(i);-sin(alpha)*erdr(i)];
        offset3=rotation_m*offset3;
    
        triangles=cat(1,triangles,...
            int32([erdcol(i)+offset1(1),                erdrow(i)+offset1(2),...
            erdcol(i)+offset2(1),   erdrow(i)+offset2(2),...
            erdcol(i)+offset3(1),   erdrow(i)+offset3(2)]));
    end
    
    if isempty(mapv)
        I = insertShape(I,'Polygon',triangles,'Color',[0,0,0],'LineWidth',1);
    else
        I = insertShape(I,'FilledPolygon',triangles,'Color',cmapv(erdchan,:),'LineWidth',1);
    end
    
end

if ~isempty(erscol)
    
    triangles=zeros(0,6);
    
    for i=1:length(erscol)
        offset1=[0;-ersr(i)];
        offset1=rotation_m*offset1;
        
        offset2=[cos(alpha)*ersr(i);sin(alpha)*ersr(i)];
        offset2=rotation_m*offset2;
        
        offset3=[-cos(alpha)*ersr(i);sin(alpha)*ersr(i)];
        offset3=rotation_m*offset3;
    
        triangles=cat(1,triangles,...
            int32([erscol(i)+offset1(1),                ersrow(i)+offset1(2),...
            erscol(i)+offset2(1),   ersrow(i)+offset2(2),...
            erscol(i)+offset3(1),   ersrow(i)+offset3(2)]));
    end
    
    if isempty(mapv)
        I = insertShape(I,'Polygon',triangles,'Color',[0,0,0],'LineWidth',1);
    else
        I = insertShape(I,'FilledPolygon',triangles,'Color',cmapv(erschan,:),'LineWidth',1);
    end
end
                        
hold on

imgh=image(I,'parent',axe);
A=rgb2gray(I);

if isempty(mapv)
    set(imgh,'AlphaData',255-A);
else
%     alpha=ones(size(A));
%     alpha(A==255)=0;
%     set(imgh,'AlphaData',alpha);
end
set(imgh,'Tag','contact');

%keep channel name above the contact
%rotation matrix
%[cos(a)    -sin(a)]
%[sin(a)     cos(a)]

offset=[0;-10];
offset=rotation_m*offset;
for i=1:length(all_channames)
    if badchan(i)
        c=[0.5,0.5,0.5];
    else
        c=[0,0,0];
    end
    text(all_col(i)+offset(1),all_row(i)+offset(2),all_channames{i},...
    'fontsize',8,'horizontalalignment','center','parent',axe,'interpreter','none','tag','names','color',c);
end

drawnow


end

