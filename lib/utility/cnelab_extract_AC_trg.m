function [Tr,RisingIdx,FallingIdx]=cnelab_extract_AC_trg(trigger,fs,param_1,param_2,param_3,fig)
%
% This function finds the rising and falling edges of the AC trigger.
% Param_1 is the threshold.
% Use param_2 for better amplitude differentiation. The default
% number is 4. Param_3 is the neglectable interval (sample number). The 
% default number is 50 samples. Use a smaller value if all edges need to be found.
% Set fig=1 to see the result in figures.
%
if nargin<6
    fig=0;
end
if nargin<5
    param_3=50;
end
if nargin<4
    param_2=4;
end
[b,a]=butter(2,16/(fs/2),'high');
triggerf=filtfilt(b,a,trigger);
trg=abs(hilbert(triggerf));
trg(trg<param_1)=0; 
rTriggerData = round(trg*param_2);
rTriggerData=cnelab_replace_with_localmax(rTriggerData,10);
dTriggerData = find(rTriggerData(1:end-1)~=rTriggerData(2:end))+1;
D=diff(dTriggerData);
F=find(D<5);
a=1;
count=0;
for i=1:length(F)-1
    if F(i+1)~=F(i)+1
        x(a)=round((dTriggerData(F(i-count))+dTriggerData(F(i)+1))/2);
        y(a)=F(i)+1;
        a=a+1;
        count=0;
        continue;
    end
    count=count+1;
end
F=[F;y'];
dTriggerData(F)=[];
dTriggerData=sort([dTriggerData;x']);
th=param_3;
FF=find(diff(dTriggerData)<th)+1;
dTriggerData(FF) = [];
Trigger = dTriggerData(1:end);
if param_3>=0.1*fs
    trg2=cnelab_envelope(triggerf,fs);
    ap= round(trg2*2);
    ap=cnelab_replace_with_localmax(ap,16);
    ap=round(ap/2);
    amp=ap(Trigger(:,1));
    Trigger=[Trigger zeros(length(Trigger),1) amp];
    DA=diff(Trigger);
    F1=find(DA(:,1)<2*param_3);
    F2=find(DA(:,3)==0);
    F1=F1(ismember(F1,F2))+1;
    Trigger(F1,:)=[];
    Trigger(:,2)= [Trigger(2:end,1)-1;length(trigger)];
    FallingIdx=Trigger(find(diff(Trigger(:,3))<0)+1,1);
    RisingIdx=Trigger(~ismember(Trigger(:,1),FallingIdx),1);
else
    Trigger(:,2)= [Trigger(2:end)-1;length(trigger)];
    idx=round((Trigger(:,1)+Trigger(:,2))/2);
    amp=rTriggerData(idx);
    Trigger=[Trigger amp];
    DA=diff(Trigger(:,3));
    F1=find(diff(DA)==0)+1;
    amp2=rTriggerData(round(((Trigger(F1,1)+Trigger(F1,2))/2+Trigger(F1,1))/2));
    Trigger(F1,3)=amp2;
    F2=find(DA==1)+1;
    Trigger(F2,:)=[];
    Trigger(:,2)=[Trigger(2:end,1)-1;length(trigger)];
    Trigger(:,3)=round(Trigger(:,3)/param_1);
    RisingIdx=Trigger((Trigger(:,3)~=0),1);
    FallingIdx=Trigger((Trigger(:,3)==0),1);
end

for i=1:length(Trigger)
    Tr(Trigger(i,1):Trigger(i,2))=Trigger(i,3);
end
if fig==1
    edge=nan(1,length(trigger));
    for i=Trigger(:,1)'
        edge(i)=0;
    end
    
    plot(triggerf);hold on;plot(edge,'r.');hold on
    
    plot(Tr,'g');hold off
end
end
% Written by Su Liu
% sliu31@uh.edu



