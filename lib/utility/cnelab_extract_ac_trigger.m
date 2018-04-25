function [Trigger,RisingIdx,FallingIdx]=cnelab_extract_ac_trigger(trigger,fs,param_1,param_2)
% Use param_1 for better amplitude differentiation. The default
% number is 4. Param_2 is the neglectable interval (sample number). The 
% default number is 50 samples.
if nargin<4
    param_2=50;
end
if nargin<3
    param_1=4;
end
trg=cnelab_envelope(trigger,fs);
trg=data_norm(trg);
trg(trg<1)=0; % 0.75 was identified manually from data by visual inspection
rTriggerData = round(trg*param_1);

dTriggerData = [0;find(rTriggerData(1:end-1)~=rTriggerData(2:end))]+1;
d1=find(diff(dTriggerData)<param_2)+1;
%d2=find(diff(dTriggerData)<50);
dTriggerData([1;d1]) = [];
sectionCodes = [dTriggerData(1:end-1) dTriggerData(2:end)-1 rTriggerData(dTriggerData(1:end-1))];
Trigger=sectionCodes;
RisingIdx=sectionCodes((sectionCodes(:,3)==min(Trigger(:,3))),1);
FallingIdx=sectionCodes((sectionCodes(:,3)==max(Trigger(:,3))),1);
edge=nan(1,length(trigger));
for i=Trigger(:,1)'
edge(i)=0;
end
plot(trigger);hold on;plot(edge,'r.');
end
% Written by Su Liu
% sliu31@uh.edu


