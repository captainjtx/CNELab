function ExportDataToWorkspace(obj)

[data,chanNames,dataset,~,sample,evts,groupnames,pos,segments]=get_selected_data(obj);
dd=unique(dataset);

downsample=1;
if obj.DownSample~=1
    choice=questdlg( sprintf('Are you sure you wanna DOWNSAMPLE the data by %d ?',obj.DownSample),'CNELab','Yes','No','No');
    
    if strcmpi(choice,'Yes')
        downsample=obj.DownSample;
        %applying low pass filter
        freq=obj.SRate/downsample/2*0.95;
        order=3;
        
        [b,a]=butter(order,freq/(obj.SRate/downsample/2),'low');
        data=cnelab_filter_symmetric(b,a,data,obj.SRate/downsample,0,'iir');
    end
end
% The same as save merged data*********************************************
seg=unique(segments);

for s=1:length(seg)
    dat=data(segments==seg(s),:);
    sam=sample(segments==seg(s));
    
    cds=CommonDataStructure;
    
    cds.Data=dat(1:downsample:end,:);
    cds.DataInfo.Annotations=evts;
    cds.DataInfo.SampleRate=obj.SRate/downsample;
    units=obj.Units{dd(1)};
    for i=2:length(dd)
        units=cat(2,units,obj.Units{dd(i)});
    end
    %         cds.DataInfo.Units=units;
    
    cds.DataInfo.VideoName=obj.VideoFile;
    cds.DataInfo.TimeStamps=sam(1:downsample:end)/obj.SRate;
    
%     cds.DataInfo.Video.StartTime=obj.VideoStartTime;
%     cds.DataInfo.Video.TimeFrame=obj.VideoTimeFrame;
%     cds.DataInfo.Video.NumberOfFrame=obj.NumberOfFrame;
    
    cds.Montage.ChannelNames=chanNames;
    cds.Montage.Name=obj.Montage{dd(1)}(obj.MontageRef(dd(1))).name;
    cds.Montage.GroupNames=groupnames;
    cds.Montage.ChannelPosition=pos;
    
    sel{s}=cds;
end

%**************************************************************************
prompt={'Assign a name:'};
title='Export Selection';

def={'selection'};
answer=inputdlg(prompt,title,1,def);

if isempty(answer)
    return
end

assignin('base',answer{1},sel);

end

