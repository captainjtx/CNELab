cs=load('s1_central_sulcus.mat');
ele=load('s1_orignal_mri_ct_fixed.mat');
%%
[xy,distance,t_a] = distance2curve(cs.coor,ele.coor,'linear');