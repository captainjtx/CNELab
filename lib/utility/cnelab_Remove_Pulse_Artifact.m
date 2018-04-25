function data=cnelab_Remove_Pulse_Artifact(data,Fs,ECG_Indx,LFP_Indx,S)

if nargin<6
    S=1; % Number of PC to extract
end

if length(ECG_Indx)>1
    ecg=data(:,ECG_Indx(1))-data(:,ECG_Indx(2));
else
    ecg=data(:,ECG_Indx);
end

lfp=data(:,LFP_Indx);
%N data length, L is the number of channels
[N,~]=size(lfp);
[r,~,~]=cnelab_qrs_detector(ecg,Fs);

Ratio=median(diff(r))/Fs*3;

if r(1)<Fs/Ratio+1;
    r(1)=[];
end
if r(end)>N-Fs/Ratio
    r(end)=[];
end
Lr=length(r);

if N/(Lr*Fs)<1.5
    for d=1:length(LFP_Indx)
        lfp = data(:,LFP_Indx(d));
        
        [lfpa,~] = cnelab_getaligneddata(lfp,r',round([-Fs/Ratio Fs/Ratio]));
        
        lfpa=permute(lfpa,[1 3 2]);
        correlation=0;
        for i=1:size(lfpa,2)
            correlation=lfpa(:,i)*lfpa(:,i)'+correlation;
        end
        correlation=correlation/size(lfpa,2);

        %%
        [V,D]=eig(correlation);
        D=diag(D);
        [~,si]=sort(D,'descend');
        V = V(:,si);
        
        subspace=lfpa'*V;
        subspace(:,1:S)=0;
        
        recon=subspace*V';
        
        %%
        for i_r=1:length(r)
            data(r(i_r)-round(Fs/Ratio):r(i_r)+round(Fs/Ratio),LFP_Indx(d))=recon(i_r,:);
        end
    end
else
    fprintf('NO reliable ECG/RR detected ...%2.2f\n',N/(Lr*Fs));
end


