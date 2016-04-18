function [center,weight]=getVolumeCenter(vol,xrange,yrange,zrange)
%vol will be a 3d matrix

center=0;
for z=1:size(vol,3)
    for x=1:size(vol,2)
        for y=1:size(vol,1)
            center=center+[x,y,z]*vol(y,x,z);
        end
    end
end
center=center/sum(sum(sum(vol)));

center(1)=center(1)/size(vol,2)*(xrange(2)-xrange(1))+xrange(1);
center(2)=center(2)/size(vol,1)*(yrange(2)-yrange(1))+yrange(1);
center(3)=center(3)/size(vol,3)*(zrange(2)-zrange(1))+zrange(1);

weight=sum(sum(sum(vol)));
end