function newv = gaussInterpolant(x,y,v,newx,newy)
sigma=0.1;

output=newx;


x=x(:);
y=y(:);

newx=reshape(newx,numel(newx),1);
newy=reshape(newy,numel(newy),1);

newv=zeros(length(newx),1);

max_x=max([x;newx]);
max_y=max([y;newy]);

x=x/max_x;
y=y/max_y;

newx=newx/max_x;
newy=newy/max_y;



sigma2=sigma^2;
% epsilon=(3*sigma)^2;
X=[x,y];
for i=1:length(newx)
    norm=0;
    
    Y=[newx(i),newy(i)];
    
    [idx,D]=rangesearch(X,Y,3*sigma);
    idx=idx{1};
    D=D{1};
    for j=1:length(idx)
        weight=exp(-D(j)/2/sigma2);
        newv(i)=newv(i)+v(idx(j))*weight;
        norm=norm+weight;
    end
    
    if norm
        newv(i)=newv(i)/norm;
    end
end

newv=reshape(newv,size(output));
end

