function [new_coor]=find_closest(current_coor,brain_vertice)
vn=size(brain_vertice,1);
cn=size(current_coor,1);
d=zeros(vn,1);
new_coor=zeros(size(current_coor));
for i=1:cn
    for j=1:vn
        d(j)=norm(current_coor(i,:)-brain_vertice(j,:));
    end
    [~,ind]=min(d);
    new_coor(i,:)=brain_vertice(ind,:);
end