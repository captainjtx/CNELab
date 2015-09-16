%denoising using correlation of the sliding window 

omitmask=true;
[data,chanNames,dataset,channel,sample,evts,groupnames,pos]=get_selected_data(bsp,omitmask);

fs=bsp.SRate;
winlen=300; %ms
overlap=250;

step=winlen-overlap;
t=[];
first_eig=[];
corr=[];
cross_corr=[];
for i=1:step:size(data,1)-winlen
    
    t=[t,sample(1)+i+winlen/2];
    
    seg=data(i:i+winlen,:);
    
%     tmp=0;
%     for m=1:size(seg,2)
%         for n=m+1:size(seg,2)
%             tmp=tmp+max(xcorr(seg(:,m),seg(:,n),50));
%         end
%     end
%     cross_corr=[cross_corr,tmp];
    corr=[corr,(sum(sum(abs(corrcoef(seg))))-size(seg,2))/2];
    
    
%     cov_data=cov(seg);
%     [V,D]=eig(cov_data/trace(cov_data));
%     
%     [e,ID]=sort(diag(D),'descend');
%     
%     first_eig=[first_eig,sum(e(1:20))];
    
end

figure
subplot(2,1,1)
plot(sample/fs,data(:,4));
axis tight
subplot(2,1,2)
plot(t/fs,corr);
% plot(t/fs,first_eig);
xlim([sample(1)/fs,sample(end)/fs])