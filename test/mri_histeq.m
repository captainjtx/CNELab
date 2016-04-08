function new_v=mri_histeq(v)
%MRI histogram equalization, masking black background
%Input v is a 3D volume matrix with the third dimension as the slices
%Output new_v is the equalized image

x=v;
for slice=1:size(v,3)
    k=0:1:255;
    t=size(x);
    p=zeros(1,256);
    for i=1:t(1);
        for j=1:t(2)
            p(x(i,j)+1)=p(x(i,j)+1)+1;
        end
    end
    p=p/t(1)/t(2);
    l=0:1:255;
    pp=ones(1,256)/256;
    figure(1)
    imshow(x,[0 255]);
    figure(2)
    subplot(2,1,1)
    stem(k,p);
    subplot(2,1,2)
    stem(l,pp);
    figure(3)
    PP=cumsum(pp);
    P=cumsum(p);
    for i=1:length(k)
        for j=1:length(l)-1
            if(P(i)>=PP(j)&&P(i)<PP(j+1))
                k(i)=l(j+1);
            end
        end
    end
    y=zeros(t);
    for i=1:t(1)
        for j=1:t(2)
            y(i,j)=k(x(i,j)+1);
        end
    end
    imshow(y,[0 255]);
end

end

