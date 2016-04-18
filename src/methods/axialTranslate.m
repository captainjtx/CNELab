function new_coor=axialTranslate(coor,origin,dp)

center=mean(coor,1);
new_center=(center-origin)*(1+dp)+origin;
new_coor=coor-ones(size(coor,1),1)*center+ones(size(coor,1),1)*new_center;


end

