function Temporal_PCA(obj)

if ~obj.IsChannelSelected
    msgbox('Please select the denoise channel','Temporal_PCA','error');
    return
end

prompt={'Noise Event Label: ','Segment Before (ms): ','Segment After (ms): '};
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

def={obj.TPCA_Event_Label,num2str(obj.TPCA_Seg_Before),num2str(obj.TPCA_Seg_After)};
answer=inputdlg(prompt,title,1,def);

if isempty(answer)
    return
end

for i=1:length(answer)
    if i==1
        obj.TPCA_Event_Label=answer{1};
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

end

