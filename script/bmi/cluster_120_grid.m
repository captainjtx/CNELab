function [maxp,minp]=cluster_120_grid(axe,clst,val,ind,dw,dh)
%Gauss interpolation of 120 grid

%length(val)=length(ind)
%ind contains the related channel index
%The length of ind is no larger than 120 and is the subset of [1:120]

%======================================================================

if nargin<4
    dw=30;
    dh=30;
end
if isempty(dw)
    dw=30;
end
if isempty(dh)
    dh=30;
end

width=12*dw;
height=10*dh;

%gaussian kernel for interpolation / electrode
sigma=0.5;
%transform into pixel
sigma=round(sigma*(dw+dh)/2);

% fig=figure('Position',[0,0,width,height]);

powermap=zeros(height,width);

coordinates=zeros(length(ind),3);
for i=1:length(ind)
    coordinates(i,1)=dw*rem(ind(i)-1,12)+dw/2;
    coordinates(i,2)=dh*floor((ind(i)-1)/12)+dh/2;
    coordinates(i,3)=val(i);
end

%**********************************************************************
%Interatively update the coordinates to fill the most surrounded missing channel using 4-neighbour estimation.
chin=ind;
while 1
    
    missingchannel=[];
    missingweight=[];
    
    for c=1:120
        if ~any(c==chin)
            missingchannel=cat(1,missingchannel,c);
        end
    end
    
    if isempty(missingchannel)
        break
    end
    
    nb=cell(1,length(missingchannel));
    for n=1:length(missingchannel)
        c=missingchannel(n);
        col=rem(c-1,12)+1;
        row=floor((c-1)/12)+1;
        
        neighbour=[row,col-1;row,col+1;row-1,col;row+1,col];
        
        w=0;
        nb_tmp=[];
        for t=1:4
            if neighbour(t,1)>0&&neighbour(t,1)<11&&neighbour(t,2)>0&&neighbour(t,2)<13
                cn=(neighbour(t,1)-1)*12+neighbour(t,2);
                if any(cn==chin)
                    w=w+1;
                    nb_tmp=cat(1,nb_tmp,cn);
                end
            end
        end
        nb{n}=nb_tmp;
        missingweight=cat(1,missingweight,w);
    end
    
    [C,I]=max(missingweight);
    
    c=missingchannel(I);
    
    val=0;
    for n=1:C
        val=val+coordinates(nb{I}(n)==chin,3);
    end
    coordinates=cat(1,coordinates,[dw*rem(c-1,12)+dw/2,dh*floor((c-1)/12)+dh/2,val/C]);
    
    chin(end+1)=c;
end

%Using Gaussian Kernel to interpolate the Power map
for h=1:height
    for w=1:width
        value=0;
        nK=0;
        for ch=1:size(coordinates,1)
            tmp=exp(-((w-coordinates(ch,1)).^2+(h-coordinates(ch,2)).^2)/2/sigma^2);
            value=value+tmp*coordinates(ch,3);
            nK=nK+tmp;
        end
        value=value/nK;
        powermap(h,w)=value;
    end
end

%Scale the powermap
maxp=max(max(powermap));
minp=min(min(powermap));
cmax=maxp;

cmin=minp;

if cmax<=cmin
    error('Max scale value should be no less than min value');
end
axes(axe)
imagesc(powermap,[cmin,cmax]);

axis off
hold on

w=get(axe,'XLim');
h=get(axe,'YLim');

dw=(w(2)-w(1))/12;
dh=(h(2)-h(1))/10;

markers={'o','+','*','x','^','v','>','<'};
for r=1:size(clst,1)
        x1=dw*rem(ind(r)-1,12)+dw/2;
        y1=dh*floor((ind(r)-1)/12)+dh/2;
%         text(x1,y1,num2str(clst(r)));
        plot(x1,y1,'Marker',markers{clst(r)},'Color','k');
        hold on
end

end

