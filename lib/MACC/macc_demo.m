Ts=0.01;
X0=0;%initial position
Xf=0.10; % end position - 10 Centimeters away
Len=100;
MIN_MOVEMENT_JERK=0;
DIM=[11 11];%another choice might be [ 15 15] or any other.....
t=(Ts*(0:2*Len-1));
Tonset=t(Len+1);
Tf=t(end);% total movement time
Tow=(t(Len+1:end)-Tonset)/(Tf-Tonset);
Traj=[X0*zeros(1,Len) , X0+(X0-Xf).*(15*Tow.^4-6*Tow.^5-10*Tow.^3)]';
Please_show_trajectories=1;
%[OnsetDetected,MovementIntialJerk]=MACCInitV4(Traj);
%or if you want to see the trajectories as well as the onset point try
%or maybe setting your own values:
[OnsetDetected,MovementIntialJerk,Model]=MACCInitV4(Traj,Ts,DIM,MIN_MOVEMENT_JERK,Please_show_trajectories);