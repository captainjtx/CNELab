function plot_contact(axe,col,row,r,h,w,channames,varargin)
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
erdr=r(erdchan);

erscol=col(erschan);
ersrow=row(erschan);
ersr=r(erschan);

col=col(~erdchan&~erschan);
row=row(~erdchan&~erschan);
r=r(~erdchan&~erschan);

if ~isempty(channames)
    all_channames=channames;
else
    all_channames=[];
end

background=uint8(ones(h,w,3)*255);
shapeInserter = vision.ShapeInserter('Shape','Circles','BorderColor','Custom',...
    'CustomBorderColor',[0,0,0],'LineWidth',1.2,'Antialiasing',true);
circles =int32([col, row, r]);

I = step(shapeInserter, background, circles);

if ~isempty(badcol)
    shapeInserter = vision.ShapeInserter('Shape','Circles','BorderColor','Custom',...
        'CustomBorderColor',[100,100,100],'LineWidth',1.2,'Antialiasing',true);
    circles=int32([badcol,badrow,badr]);
    
    I = step(shapeInserter, I, circles);
    
end

alpha=pi/4;

if ~isempty(erdcol)
    shapeInserter = vision.ShapeInserter('Shape','Polygons','BorderColor','Custom',...
        'CustomBorderColor',[0,0,0],'LineWidth',1.2,'Antialiasing',true);
    triangles=zeros(0,6);
    
    for i=1:length(erdcol)
        triangles=cat(1,triangles,...
            int32([erdcol(i),                erdrow(i)+erdr(i),...
            erdcol(i)+cos(alpha)*erdr(i),   erdrow(i)-sin(alpha)*erdr(i),...
            erdcol(i)-cos(alpha)*erdr(i),   erdrow(i)-sin(alpha)*erdr(i)]));
    end
    
    I = step(shapeInserter, I, triangles);
    
end

if ~isempty(erscol)
    shapeInserter = vision.ShapeInserter('Shape','Polygons','BorderColor','Custom',...
        'CustomBorderColor',[0,0,0],'LineWidth',1.2,'Antialiasing',true);
    triangles=zeros(0,6);
    
    for i=1:length(erscol)
        triangles=cat(1,triangles,...
            int32([erscol(i),                ersrow(i)-ersr(i),...
            erscol(i)+cos(alpha)*ersr(i),   ersrow(i)+sin(alpha)*ersr(i),...
            erscol(i)-cos(alpha)*ersr(i),   ersrow(i)+sin(alpha)*ersr(i)]));
    end
    
    I = step(shapeInserter, I, triangles);
    
end
                        
hold on

imgh=image(I,'parent',axe);
A=rgb2gray(I);

set(imgh,'AlphaData',255-A);
set(imgh,'Tag','contact');


for i=1:length(all_channames)
    if badchan(i)
        c=[0.5,0.5,0.5];
    else
        c=[0,0,0];
    end
    text(all_col(i),all_row(i)-10,all_channames{i},...
    'fontsize',8,'horizontalalignment','center','parent',axe,'interpreter','none','tag','names','color',c);
end

drawnow


end

