function data=Remove_ECG_Artifact(data,montage,ECG_Indx,LFP_Indx,th,S)
% data=Remove_ECG_Artifact(data,montage,ECG_Indx,LFP_Indx,th,S)

if nargin<6
    S=2; % Number of PC to extract
end

if nargin<5
    th=0.5;
end

Ratio=3;
Fs=montage.SampleRate;

%datab=generate_bipolar_data(data(:,1:17), [1 0.0075 0.02 0.02]);
%[b,a]=butter(2,[1 50]/Fs*2);
%data=filter_symmetric(b,a,data,Fs,0,'IIR');

if length(ECG_Indx)>1
    ecg=data(:,ECG_Indx(1))-data(:,ECG_Indx(2));
else
    ecg=data(:,ECG_Indx);
end

lfp=data(:,LFP_Indx);
%N data length, L is the number of channels
[N,L]=size(lfp);
[r,d,pat]=qrs_detector(ecg,Fs);



if r(1)<Fs/Ratio+1;
    r(1)=[];
end
if r(end)>N-Fs/Ratio
    r(end)=[];
end
Lr=length(r);

if N/(Lr*Fs)<1.5
    Seg=[round(-Fs/Ratio):round(Fs/Ratio)];
   [lfpa,allignedIndex] = getaligneddata(lfp,r',round([-Fs/Ratio Fs/Ratio]));

    LSeg=length(Seg);
    lfpa=permute(lfpa,[1 3 2]);
    mx=max(lfpa(:));

    % MAsking Window to eliminate artifacts at the edges
    W=repmat(tukeywin(size(lfpa,1),.25),1,size(lfpa,2));

    close all;
    figure(1);
%     for k=1:L
%         subplot(1,L,k);
%         plot(lfpa(:,:,k).*W);
%         axis tight;
%         ylim([-1.25*mx 1.25*mx]);
%     end


    for k=1:L
        % Covarince of the masked data
        C=[lfpa(:,:,k).*W]*[lfpa(:,:,k).*W]';
        %        C=lfpa(:,:,k)*lfpa(:,:,k)';
        [V,D]=eig(C);
        D=diag(D);
        [D,si]=sort(D,'descend');
        eVal(k).D=D;
        eVec(k).V=V(:,si);

%         figure(2);
%         subplot(1,L,k);
%         plot(cumsum(D(1:10))/sum(D),'o-');
%         title(th);
%         axis tight;
%         ylim([0 1.1]);
% 
%         figure(3);
%         subplot(1,L,k);
%         plot(eVec(k).V(:,1:S));
%         axis tight;
    end

    n=1;
    for k=LFP_Indx
        if eVal(n).D(1)/sum(eVal(n).D)>th
            c=lfpa(:,:,n)'*eVec(n).V(:,[1:S]);
            p=zeros(LSeg,Lr);

            for s=1:S
                p=p+repmat(eVec(n).V(:,s),1,Lr).*repmat(c(:,s)',LSeg,1);
            end

            % SUBTRACTING Each PC from the data
            lfpa(:,:,n)=lfpa(:,:,n)-p;

%             figure(4);
%             subplot(1,L,n);
%             plot(lfpa(:,:,n));
%             axis tight;
%             ylim([-1.15*mx 1.15*mx]);
            fprintf('Channel:%d ECG Artifact Corrected\n',n);
        else
            fprintf('Channel:%d was Skipped\n',n);
        end
        n=n+1;
    end
    % Putting artifact cleaN SEGMENT BACK INTO CONT DATA
    for r=1:size(lfpa,2)
        lfp(allignedIndex(r,:),:)=squeeze(lfpa(:,r,:));
    end
    data(:,LFP_Indx)=lfp;

else
    fprintf('NO reliable ECG/RR detected ...%2.2f\n',N/(Lr*Fs));
end


