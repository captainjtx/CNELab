function Spatial_PCA( obj )
obj.Selection=[];

%Assign the default value for the prompt dialog
prompt={'Noise Event Label: ','Segment Before (ms): ','Segment After (ms): '};
title='Noise segment definition';

if isempty(obj.SPCA_Event_Label)
    obj.SPCA_Event_Label='A';
end

if isempty(obj.SPCA_Seg_Before)
    obj.SPCA_Seg_Before=40;
end

if isempty(obj.SPCA_Seg_After)
    obj.SPCA_Seg_After=100;
end


def={obj.SPCA_Event_Label,num2str(obj.SPCA_Seg_Before),num2str(obj.SPCA_Seg_After)};
answer=inputdlg(prompt,title,1,def);

if isempty(answer)
    return
end

for i=1:length(answer)
    if i==1
        obj.SPCA_Event_Label=answer{1};
    else
        tmp=str2double(answer{i});
        if isempty(tmp)||isnan(tmp)
            msgbox('Invalid input',prompt{i},'error');
            return;
        end
        
        switch i
            case 2
                obj.SPCA_Seg_Before=tmp;
            case 3
                obj.SPCA_Seg_After=tmp;
        end
    end
end

%To do the real-business
t_evt=[obj.Evts{:,1}];
t_label=t_evt(strcmpi(obj.Evts(:,2),obj.SPCA_Event_Label));
i_label=round(t_label*obj.SRate);
i_label=min(max(1,i_label),size(obj.Data{1},1));

nL=round(obj.SPCA_Seg_Before*obj.SRate/1000); %ms
nR=round(obj.SPCA_Seg_After*obj.SRate/1000);

i_label((i_label+nR)>size(obj.Data{1},1))=[];
i_label((i_label-nL)<1)=[];

omitMask=true;
[data,chanNames,dataset,channel,sample]=get_selected_data(obj,omitMask);

selection=[reshape(i_label-nL,1,length(i_label));reshape(i_label+nR,1,length(i_label))];

evts=cell(length(i_label),2);

rawdata=data;

aveVar=0;

for i=1:length(i_label)
    pos=i_label(i);
    dataseg=data(pos-obj.SPCA_Seg_Before:pos+obj.SPCA_Seg_After,:);
    
    evts{i,1}=(i-1)*(obj.SPCA_Seg_Before+obj.SPCA_Seg_After+1)/obj.SRate;
    evts{i,2}=num2str(i);
    
    cd=cov(dataseg);
    aveVar=aveVar+cd/trace(cd);
end

%=======================================================================PCA
%**************************************************************************
aveVar=aveVar/length(i_label);

[V,D]=eig(aveVar);

[e,ID]=sort(diag(D),'descend');

SV=V(:,ID);

%==========================================================================
%**************************************************************************
pcadata=rawdata*SV;
recondata=rawdata;

mix=SV';
demix=SV;
weg=e;

method='Spatial PCA';

if size(data,2)<15
    dataview='Vertical';
else
    dataview='Horizontal';
end

channames{1}=chanNames;
subspacename=cell(1,length(chanNames));
reconname=cell(1,length(chanNames));
for i=1:length(chanNames)
    reconname{i}=['Recon-',chanNames{i}];
    subspacename{i}=['SPCA-',num2str(i)];
end
channames{2}=subspacename;
channames{3}=reconname;

obj.SPFObj=SPFPlot(method,rawdata,pcadata,recondata,mix,demix,weg,...
    'SRate',obj.SRate,...
    'WinLength',min(size(data,1)/obj.SRate,15),...
    'DataView',dataview,...
    'Gain',mean(obj.Gain_{obj.DisplayedData(1)}),...
    'ControlPanelDisplay','off',...
    'LockLayout','off',...
    'DisplayGauge','off',...
    'ChanNames',channames);

if isempty(obj.SPFObj)
    return
end

obj.SPFObj.sample=sample;
obj.SPFObj.channel=channel;
obj.SPFObj.dataset=dataset;

addlistener(obj.SPFObj,'MaskSubspace',@(src,evt)spf_selected_data(obj,dataset,channel,sample));

obj.Selection=selection;

end

function spf_selected_data(obj,dataset,channel,sample)
fdata=obj.SPFObj.PreprocData{3};
%**************************************************************************
bufferSample=obj.BufferStartSample:obj.BufferEndSample;
[buf_ind,~]=ismember(bufferSample,sample);

for i=1:size(fdata,2)
    obj.PreprocData{dataset(i)}(buf_ind,channel(i))=fdata(bufferSample(buf_ind)-sample(1)+1,i);
end

obj.redrawChangeBlock('time');

end

