function [OnsetDetected,MovementIntialJerk,BestModel]=MACCInitV4(Traj,Ts,Dim,MinJerk,plot_flag)
%uses  [OnsetDetected,MovementIntialJerk]=MACCInitV4(Traj,Ts,Dim,MinJerk,plot_flag)
%This function computes  the Onset of a movement based on the idea that the
%initial  movement can be modeled by a third power of time multiplied by some
%constant MeanJerk. This idea is derived from the Minimum Acceleration Criterion
%with Constraints (MACC model) as published by Ben-Itzhak S, Karniel A.
%(see Ben-Itzhak S, Karniel A. Neural Comput. 2008 Mar;20(3):779-812.)
%
%INPUTS:
%1. Traj - A matrix or a column  vector where each column is one segmentated data of a single movement 
%                   It is assumed that the data was sampled evenly , typical sampling rate
%                   for instance can be 100Hz or 200 Hz. 
%2. Ts - the sampling time interval 
%3. Dim - Optional parameter vector size (1,2) - describes the segment dimensions in both direction (stationary segment and
%         movement segment) in samples of Ts. Default value is [15 15];,
%         you may try others such as [11 , 15] which we find similar or [11
%         11], but this can cause outliers if the stationary segment is
%         very noisy
%4. MinJerk - optional parameter which describes the apriori knowledge
%              about the minimum average jerk 
%5. plot_flag -  Optional parameter which controls graphic display of the algorithm.
%               set its value  to  1 - if you wish to see graphic representation of
%               the position,velocity, and the detection signal as well as the detected onset point.
%               notice that a pause instruction is executed at the end of the plot,
%               (user action is required)
%
%OUTPUTS:
%1. OnsetDetected - The onset detection time (Sec) relative to start of recording
%2. MovementIntialJerk - The initial jerk in the begining of  the movement
%3. BestModel - The overall model fit (A structure contains the time - t , and position - x) 
%
%
%Example
% Ts=0.01;
% X0=0;%initial position
% Xf=0.10; % end position - 10 Centimeters away
% Len=100;
%MIN_MOVEMENT_JERK=0;
% DIM=[11 11];%another choice might be [ 15 15] or any other.....
% t=(Ts*(0:2*Len-1));
% Tonset=t(Len+1);
% Tf=t(end);% total movement time
% Tow=(t(Len+1:end)-Tonset)/(Tf-Tonset);
% Traj=[X0*zeros(1,Len) , X0+(X0-Xf).*(15*Tow.^4-6*Tow.^5-10*Tow.^3)]';
%Please_show_trajectories=1;
%[OnsetDetected,MovementIntialJerk]=MACCInitV4(Traj);
%or if you want to see the trajectories as well as the onset point try
%or maybe setting your own values:
% [OnsetDetected,MovementIntialJerk,Model]=MACCInitV4(Traj,Ts,DIM,MIN_MOVEMENT_JERK,Please_show_trajectories);

%
%copyright
%Written By Lior Botzer June 2008   ,  Version  2.0
%Version 2: Removed the criteria for search window and the minimu required
%jerk
%Version 3: - unpublished
%Version 4: added option for different segments durations (see Dim input for
%           further details) and control of the minimum jerk allowed for
%           movement
%if used please cite: ......
%
% This function is released under free Software license; 
%%%%%%%%%%%%%%%%%%  CODE STARTS HERE %%%%%%%%%%%%%%%%%%
if size(Traj,1)==1
    Traj=Traj';
    warning('transposing the trajectory vector,next time use colomn vector instead') %#ok
end
if nargin<2 || isempty(Ts)
    disp('time sampling interval not specified, assuming 100Hz')
    Ts=0.01;
end
if nargin<3 || isempty(Dim)
    Dim=[11 11];
end
if nargin<4 || isempty(MinJerk)
    MinJerk=0;
end
if nargin<5 || isempty(plot_flag)
    plot_flag=0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%           SYSTEM    CONSTANTS               %%%%
Thres_FROM_PEAK_VEL=0.2;% This is a threshold for which for sure a movement already started
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%for convenience 
N=Dim(1);M=Dim(2);
%create time vector
t=(((1:size(Traj,1))-1)*Ts)';
if (size(t,1)<N+M+1)
    error('data too short');
end

[NumOfSamples,NumofTrajectories]=size(Traj); % Traj can be a matrix

%do some init of variables
MovementIntialJerk=zeros(1,NumofTrajectories);
OnsetDetected=zeros(1,NumofTrajectories);

%check if some of the movements in the Traj matrix are in the negative
%direction, if so change the sign of the vector
NegativeDirectionInd=find(Traj(1,:)>Traj(end,:));
if ~isempty(NegativeDirectionInd)
    Traj(:,NegativeDirectionInd) =-Traj(:,NegativeDirectionInd);
    s=-1;
else
    s=1;
end

%compute velocity and find peak velocity
Vel=diff(Traj)/Ts;% compute the velocity for the trajectory
[Max_Vel_val,maxVpos]=max(Vel);% detect the peak velocity value and position


for r=1:NumofTrajectories,

    %use the Velocity threshold method for establishing maximum search
    %window on the cost function
    
    % go back in time from peak velocity and locate the first time that velocity fell below some threshold
    IndVelLow=find(Vel(maxVpos(r):-1:1,r)<Max_Vel_val(r)*Thres_FROM_PEAK_VEL,1);
    SearchEndPoint=min(NumOfSamples-1-M,M+round((maxVpos(r)-IndVelLow)));%search window ends at Thres_FROM_PEAK_VEL
    SearchEndPoint=min(maxVpos(r),max(M*3,SearchEndPoint));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %1.compute the models
    if SearchEndPoint<N+M+1
        %probably very fast reaction time
        error('early movement detected aboarding....\n')
    end
    %1a - compute index matrix for all Linear segments, this is a matrix which holds the
    %        indexes of all possible segments of the movement
    IndMatLin=((1:N)')*ones(1,SearchEndPoint-N+1)+ones(N,1)*(0:(SearchEndPoint-N));
    %1b - compute index matrix for all MACC segments, this is a matrix which holds the
    %        indexes of all possible segments of the movement
    IndMatMACC=(((1:M)-1)')*ones(1,SearchEndPoint-N+1)+ones(M,1)*(N:(SearchEndPoint));

    %1c - create data segments by cutting the  trajectory  Traj(:,r) into
    %several segments each having size of (Segment) points. The total
    %number of segments is - SearchEndPoint 

    LinearSegments=reshape(Traj(IndMatLin,r),N,SearchEndPoint-N+1);%the linear segments with all possible shifts (column number indicate the lag in samples)
    MACCSegments=reshape(Traj(IndMatMACC,r),M,SearchEndPoint-N+1);%the MACC segments with all possible shifts (column number indicate the lag in samples)

    LinMeanVal=mean(LinearSegments);%this is the constant error value of the stationary model
    LimModel=ones(N,1)*LinMeanVal;%this is the linear model itself

    MACCSegmentsB=MACCSegments-ones(M,1)*LinMeanVal;%1st remove the estimated bias

    MeanJerk=(t(1:M).^3)\ MACCSegmentsB;% compute regression to estimate the best mean jerk - MeanJerk
    MeanJerk=max([MeanJerk' , ones(SearchEndPoint-N+1,1)*MinJerk],[],2)';%solution must be larger then MinJerk
    Yest=((t(1:M).^3)*ones(1,length(MeanJerk))).*(ones(M,1)*MeanJerk)+ones(M,1)*LinMeanVal;%This is the movement model (MACC based) with the bias

    %hence my full estimation is the linear model and the MACC model
    est=[LimModel(1:end-1,:) ; Yest]; %omit the last point since it the same time point in both models
    %while the data is simply
    Data=[LinearSegments(1:end-1,:) ; MACCSegments];%omit the last point since it the same time point in both models

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    %compute the total RMS error using the sum of the Linear and the MACC
    %model
    ModelEr=mean((Data-est).^2).^0.5;

 
    k = local_max(-ModelEr);%detect the local minima in the signal
    %select the last minima as the onset,shift it respectively 
    CurrentOnsetInd=k(end)+N-1;
    
    
    %set the outputs accordingly

    OnsetDetected(r)=t(CurrentOnsetInd);
    MovementIntialJerk(r)=MeanJerk(k(end));%this is the jerk in the initial Segment of the movement

    if nargout>2 %create the model if asked
        BestModel{r}.x=s*est(:,k(end)); %#ok
        BestModel{r}.t=Ts*(((IndMatLin(1,k(end))):(IndMatMACC(end,k(end))))-1)';%#ok
    end
    


    %plot some figures if asked...
    if plot_flag
        if ~isempty(intersect(r,NegativeDirectionInd))
            %invert back to the original trajectory
            Traj(:,r) =-Traj(:,r);
        end
        %%%%%%%%%%%%%%%%%some plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        figure(10);clf;set(gcf,'position',[100   100   1000   800]);
        set(gcf,'name','MACC based Onset detection','NumberTitle','off');
        %create the model
        Tmc=Ts*((IndMatLin(:,k(end)))-1);
        Xmc=LimModel(:,k(end));
        Tmcj=Ts*((IndMatMACC(:,k(end)))-1);
        
        %multiply by the sign (s) of the signal (inverts the signal if the
        %sign is negative)
        Xmcj= s*MovementIntialJerk(r)*(Tmcj-Tmcj(1)).^3+Xmc(1);
        Xmcj= [Xmc(end) ,Xmcj']';
        Vmcj= diff(Xmcj)/Ts;%s*3*MovementIntialJerk(r)*((Tmcj-Tmcj(1)).^2);
        Amcj= diff(Vmcj)/Ts;%s*6*MovementIntialJerk(r)*(Tmcj-Tmcj(1));
        
        %%%
        subplot(311)
        hData=plot(t,Traj(:,r),'k.');set(hData,'linewidth',3);%the data
        hold on
        hMod1=plot(Tmc,Xmc,'rd');set(hMod1,'linewidth',3);%The model   
        hMod2=plot(Tmcj,Xmcj(2:end),'bd');set(hMod2,'linewidth',3);%The model 
        hf=title('Position - Data Vs. model');set(hf,'fontsize',14,'fontweight','bold')%ylabel('time (Sec)')
        set(gca,'FontSize',14,'fontweight','bold')
        hf=ylabel('m');set(hf,'fontsize',14,'fontweight','bold')
        xlim([0 maxVpos(r)]*Ts);
        dy=max(Xmcj)-min(Xmcj);
        ylim([max(Xmcj)-dy*1.3 min(Xmcj)+dy*1.3]); 
        hOnset=line(ones(1,2)*OnsetDetected(r),ylim);set(hOnset,'color',[0.8 0.8 0.8],'linestyle',':','linewidth',3);uistack(hOnset,'bottom')
        legend([hData,hMod1,hMod2],{'Raw data','Stationary Fit','MACC fit'},'location','NorthWest');
        axis tight
        %%%
        subplot(312)
        hData=plot(t(2:end),diff(Traj(:,r))/Ts,'k.');set(hData,'linewidth',3);%the data
        hold on
        hMod1=plot(Tmc,0,'rd');set(hMod1,'linewidth',3);%The model   
        hMod2=plot(Tmcj(1:end),Vmcj,'bd');set(hMod2,'linewidth',3);%The model  (the first time point is similar please ignore
        hf=title('Velocity - Data Vs. model');set(hf,'fontsize',14,'fontweight','bold')%ylabel('time (Sec)')
        set(gca,'FontSize',14,'fontweight','bold')
        hf=ylabel('Velocity (m/s)');set(hf,'fontsize',14,'fontweight','bold')
        xlim([0 maxVpos(r)]*Ts);
        dy=max(Vmcj)-min(Vmcj);
        ylim([max(Vmcj)-dy*1.3 min(Vmcj)+dy*1.3]); 
        hOnset=line(ones(1,2)*OnsetDetected(r),ylim);set(hOnset,'color',[0.8 0.8 0.8],'linestyle',':','linewidth',3);uistack(hOnset,'bottom')
        axis tight
        %%%
        subplot(313)
        hData=plot(t(3:end),diff(Traj(:,r),2)/(Ts^2),'k.');set(hData,'linewidth',3);%the data
        hold on
        hMod1=plot(Tmc,0,'rd');set(hMod1,'linewidth',3);%The model   
        hMod2=plot(Tmcj(2:end),Amcj,'bd');set(hMod2,'linewidth',3);%The model  (the first time point is similar please ignore
        hf=title('Acceleration - Data Vs. model');set(hf,'fontsize',14,'fontweight','bold')%ylabel('time (Sec)')
        set(gca,'FontSize',14,'fontweight','bold')
        hf=ylabel('Acceleration (m/S^2)');set(hf,'fontsize',14,'fontweight','bold')
        xlabel('Time')
        xlim([0 maxVpos(r)]*Ts);
        dy=max(Amcj)-min(Amcj);
        ylim([max(Amcj)-dy*1.3 min(Amcj)+dy*1.3]); 
        hOnset=line(ones(1,2)*OnsetDetected(r),ylim);set(hOnset,'color',[0.8 0.8 0.8],'linestyle',':','linewidth',3);uistack(hOnset,'bottom')
        axis tight

        if NumofTrajectories>1
            fprintf('press any key to continue\n')
            pause;
        end
    end
end
return;

