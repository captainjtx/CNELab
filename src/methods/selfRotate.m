function new_coor = selfRotate(coor,origin,theta)
center=mean(coor,1);

V=center-origin;
R=rot(V,theta);

new_coor=R*(coor'-origin'*ones(1,size(coor,1)));

new_coor=new_coor';

new_coor=new_coor+ones(size(coor,1),1)*origin;

end
