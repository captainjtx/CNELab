function VolumeSmoothSpinnerCallback(obj)
obj.smooth_sigma=obj.JVolumeSmoothSpinner.getValue();

set(obj.TextInfo,'String','Smoothing the volume ...','FontSize',18,'Foregroundcolor','r','HorizontalAlignment','center');
drawnow

allkeys=keys(obj.mapObj);
is_ele=regexp(allkeys,'^Volume');

for i=1:length(is_ele)
    if ~isempty(is_ele{i})
        mapval=obj.mapObj(allkeys{i});
        delete(mapval.handles);
        
        if obj.smooth_sigma>0
            img_vol=imgaussfilt3(mapval.volume,obj.smooth_sigma./mapval.pixdim);
        else
            img_vol=mapval.volume;
        end
        tmp=vol3d('cdata',img_vol,'texture','3D','Parent',obj.axis_3d,...
            'XData',mapval.xrange,'YData',mapval.yrange,'ZData',mapval.zrange);
        mapval.handles=tmp.handles;
        
        if mapval.checked
            set(mapval.handles,'visible','on');
        else
            set(mapval.handles,'visible','off');
        end
        
        obj.mapObj([mapval.category,num2str(mapval.ind)])=mapval;
    end
end

set(obj.TextInfo,'String',{'Volume smooth complete !'},'FontSize',18,'foregroundcolor',[12,60,38]/255,'HorizontalAlignment','center');
end

