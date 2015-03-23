function Temporal_PCA(obj)
obj.Selection=[];

if ~obj.IsChannelSelected
    msgbox('Please select the denoise channel','Temporal_PCA','error');
    return
end

prompt={'Noise Event Label: ','Segment Before (ms): ','Segment After (ms): ','Noise PCA-components: '};
title='Noise segment definition';
if isempty(obj.TPCA_Event_Label)
    obj.TPCA_Event_Label='A';
end

if isempty(obj.TPCA_Seg_Before)
    obj.TPCA_Seg_Before=100;
end

if isempty(obj.TPCA_Seg_After)
    obj.TPCA_Seg_After=100;
end

if isempty(obj.TPCA_S)
    obj.TPCA_S=1;
end

def={obj.TPCA_Event_Label,num2str(obj.TPCA_Seg_Before),num2str(obj.TPCA_Seg_After),num2str(obj.TPCA_S)};
answer=inputdlg(prompt,title,1,def);

if isempty(answer)
    return
end

for i=1:length(answer)
    if i==1
        obj.TPCA_Event_Label=answer{1};
    elseif i==4
        obj.TPCA_S=str2num(answer{4});
        if isempty(obj.TPCA_S)
            obj.TPCA_S=1;
        end
    else
        tmp=str2double(answer{i});
        if isempty(tmp)||isnan(tmp)
            msgbox('Invalid input',prompt{i},'error');
            return;
        end
        
        switch i
            case 2
                obj.TPCA_Seg_Before=tmp;
            case 3
                obj.TPCA_Seg_After=tmp;
        end
    end
end

%To do the real-business
t_evt=[obj.Evts{:,1}];
t_label=t_evt(strcmpi(obj.Evts(:,2),obj.TPCA_Event_Label));
i_label=round(t_label*obj.SRate);
i_label=min(max(1,i_label),size(obj.Data{1},1));

nL=round(obj.TPCA_Seg_Before*obj.SRate/1000); %ms
nR=round(obj.TPCA_Seg_After*obj.SRate/1000);

i_label((i_label+nR)>size(obj.Data{1},1))=[];
i_label((i_label-nL)<1)=[];

[data,chanNames,dataset,channel,sample]=get_selected_data(obj);

selection=[reshape(i_label-nL,1,length(i_label));reshape(i_label+nR,1,length(i_label))];

for d=1:size(data,2)
    chan=data(:,d);
    
    [data_a,~] = getaligneddata(chan,i_label,[-nL,nR]);
    
    data_a=permute(data_a,[1 3 2]);
    
    
    correlation=0;
    for i=1:size(data_a,2)
        correlation=data_a(:,i)*data_a(:,i)'+correlation;
    end
    
    correlation=correlation/size(data_a,2);
    
    [V,D]=eig(correlation);
    D=diag(D);
    
    [D,si]=sort(D,'descend');
    
    V=V(:,si);
    
    subspace=data_a'*V;
    subspace(:,obj.TPCA_S)=0;
    
    recon=subspace*V';
    
    for i_seg=1:size(selection,2)
        data(selection(1,i_seg):selection(2,i_seg),d)=recon(i_seg,:);
    end
    
    figure('Name',['PCA Eigne Value-',chanNames{d}]);
    plot(D,'--rs','LineWidth',2,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor','g',...
        'MarkerSize',10)
    xlabel('Subspace Dimension')
    ylabel('Subspace Weight')
    
end



for i=1:size(data,2)
    obj.PreprocData{dataset(i)}(sample,channel(i))=data(:,i);
end

obj.redrawChangeBlock('time');

obj.Selection=selection;


%**************************************************************************
%Plot the raw data and recon data

for i=1:length(data)
    
    
end


end

