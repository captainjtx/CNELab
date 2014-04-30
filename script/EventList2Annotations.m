function Annotations=EventList2Annotations(EventList)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for i=1:size(EventList,1)
    Annotations.stamp(i)=EventList{i,1};
    Annotations.text{i}=EventList{i,2};
end
end

