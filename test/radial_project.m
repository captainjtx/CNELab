function ppoints = radial_project(points,origin,shift)
%points is n*3 matrix, origin is the origin point, shift is the amont of
%projection

%This function project points along the radical direction accroding to
%origin by shift

center=mean(points,1);

ppoints=points+(center-origin)*shift;

end

