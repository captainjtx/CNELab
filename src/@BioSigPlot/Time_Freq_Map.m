function Time_Freq_Map(obj,src)
%control the menu check====================================================
switch src
    case obj.MenuTFMapSettings
        MnuTFMapSettings(obj);
        return
    case obj.MenuTFMapAverage
        set(src,'checked','on');
        set(obj.MenuTFMapChannel,'checked','off');
        set(obj.MenuTFMapGrid,'checked','off');
    case obj.MenuTFMapChannel
        set(src,'checked','on');
        set(obj.MenuTFMapAverage,'checked','off');
        set(obj.MenuTFMapGrid,'checked','off');
    case obj.MenuTFMapGrid
        set(src,'checked','on');
        set(obj.MenuTFMapAverage,'checked','off');
        set(obj.MenuTFMapChannel,'checked','off');
    case obj.MenuTFMap_Normal
        set(src,'checked','on');
        set(obj.MenuTFMap_DB,'checked','off');
        obj.STFTScaleLow=[];
        obj.STFTScaleHigh=[];
    case obj.MenuTFMap_DB
        set(src,'checked','on');
        set(obj.MenuTFMap_Normal,'checked','off');
        obj.STFTScaleLow=[];
        obj.STFTScaleHigh=[];
end
%==========================================================================
%continue ?
if ~ishandle(obj.TFMapFig)
    if ismember(src,[obj.MenuTFMapAverage,obj.MenuTFMapChannel,obj.MenuTFMapGrid,...
            obj.MenuTFMap_Normal,obj.MenuTFMap_DB])
        return
    end
end
%==========================================================================
if strcmpi(get(obj.MenuTFMapAverage,'checked'),'on')
    option=1;
elseif strcmpi(get(obj.MenuTFMapChannel,'checked'),'on')
    option=2;
elseif strcmpi(get(obj.MenuTFMapGrid,'checked'),'on')
    option=3;
end

if strcmpi(get(obj.MenuTFMap_Normal,'checked'),'on')
    unit='normal';
else
    unit='dB';
end
%==========================================================================
fs=obj.SRate;

omitMask=true;
[data,chanNames,dataset,channel,sample,evts,groupnames,chanpos]=get_selected_data(obj,omitMask);

%set default parameter*****************************************************
wd=round(obj.STFTWindowLength);
ov=round(obj.STFTOverlap);
nref=round(obj.STFTNormalizePoint);
sl=obj.STFTScaleLow;
sh=obj.STFTScaleHigh;

if isempty(wd)||wd>size(data,1)
    wd=round(fs/3);
    ov=round(wd*0.9);
end

if ov>wd
    ov=round(wd*0.9);
end

if isempty(nref)||nref>size(data,1)
    nref=round(size(data,1)/4);
    obj.STFTNormalizePoint=nref;
end



obj.STFTWindowLength=wd;
obj.STFTOverlap=ov;
obj.STFTNormalizePoint=nref;
%**************************************************************************

s=[obj.STFTScaleLow obj.STFTScaleHigh];
freq=[obj.STFTFreqLow obj.STFTFreqHigh];



if ~ishandle(obj.TFMapFig)
    obj.TFMapFig=figure('Name','TFMap','Visible','off','NumberTitle','off');
end
figure(obj.TFMapFig)
set(gcf,'visible','on')
clf

switch option
    case 1
        [tf,f,t]=bsp_tfmap(obj.TFMapFig,data,fs,wd,ov,s,nref,chanNames,freq,unit);
        
        if strcmpi(unit,'dB')
            imagesc(t,f,10*log10(tf));
        else
            imagesc(t,f,tf);
        end
        
        if ~isempty(s)
            set(gca,'CLim',s);
        end
        set(gca,'YLim',freq);
        set(gca,'Tag','TFMapAxes');
        title('Time Frequency Map');
        colormap(jet);
        xlabel('time (s)');
        ylabel('frequency (Hz)')
        axis xy;
        colorbar
        
    case 2
        bsp_tfmap(obj.TFMapFig,data,fs,wd,ov,s,nref,chanNames,freq,unit);
    case 3
        if isempty(sl)
            sl=-10;
            obj.STFTScaleLow=sl;
        end
        if isempty(sh)
            sh=10;
            obj.STFTScaleHigh=sh;
        end
        
        
        chanind=~isnan(chanpos(:,1))&~isnan(chanpos(:,2));
        data=data(:,chanind);
        channames=chanNames(chanind);
        chanpos=chanpos(chanind,:);
        
        chanpos(:,1)=chanpos(:,1)-min(chanpos(:,1));
        chanpos(:,2)=chanpos(:,2)-min(chanpos(:,2));
        
        dx=abs(pdist2(chanpos(:,1),chanpos(:,1)));
        dx=min(dx(dx~=0));
        
        dy=abs(pdist2(chanpos(:,2),chanpos(:,2)));
        dy=min(dy(dy~=0));
        
        chanpos(:,1)=chanpos(:,1)+dx/2;
        chanpos(:,2)=chanpos(:,2)+dy*0.6;
        
        x_len=max(chanpos(:,1))+dx/2;
        y_len=max(chanpos(:,2))+dy*0.6;
        chanpos(:,1)=chanpos(:,1)/x_len;
        chanpos(:,2)=chanpos(:,2)/y_len;
        
        dw=dx/(x_len+2*dx);
        dh=dy/(y_len+2*dy);
        ax_back = axes('Position',[0 0 1 1],'Visible','off');
        set(ax_back,'XLim',[0,1]);
        set(ax_back,'YLim',[0,1]);
        

        for j=1:length(channames)
            [tf,f,t]=bsp_tfmap(obj.TFMapFig,data(:,j),fs,wd,ov,s,nref,channames,freq,unit);
            axes(ax_back);
            tfmap_grid(t,f,tf,chanpos(j,:),dw,dh,channames{j},sl,sh);
        end

end


end


function MnuTFMapSettings(obj)

%**************************************************************************
% Dialog box to change the settings of Time frequency map
%**************************************************************************
fs=obj.SRate;

prompt={'STFT window:','STFT overlap:',...
    'Frequency low:','Frequency high',...
    'Lower bound of scale:','Upper bound of scale',...
    'Normalization Points:'};

def={num2str(obj.STFTWindowLength),num2str(obj.STFTOverlap),...
    num2str(obj.STFTFreqLow),num2str(obj.STFTFreqHigh),...
    num2str(obj.STFTScaleLow),num2str(obj.STFTScaleHigh),...
    num2str(obj.STFTNormalizePoint)};

title='Time Frequency Settings';


answer=inputdlg(prompt,title,1,def);

if isempty(answer)
    return
end

wo=str2double(answer{1});

needredraw=false;
needrescale=false;
needroom=false;

if ~isnan(wo)
    if obj.STFTWindowLength~=wo
        needredraw=true;
        obj.STFTWindowLength=wo;
    end
end

ov=str2double(answer{2});
if ~isnan(ov)
    if obj.STFTOverlap~=ov
        needredraw=true;
        obj.STFTOverlap=ov;
    end
end

fl=str2double(answer{3});
if ~isnan(fl)
    if obj.STFTFreqLow~=fl&&fl>=0
        needroom=true;
        obj.STFTFreqLow=fl;
    end
end

fh=str2double(answer{4});
if ~isnan(fh)
    if obj.STFTFreqHigh~=fh&&fh<=fs/2
        needroom=true;
        obj.STFTFreqHigh=fh;
    end
end
sl=str2double(answer{5});
if ~isnan(sl)
    if isempty(obj.STFTScaleLow)||obj.STFTScaleLow~=sl
        needrescale=true;
        obj.STFTScaleLow=sl;
    end
end

sh=str2double(answer{6});
if ~isnan(sh)
    if isempty(obj.STFTScaleHigh)||obj.STFTScaleHigh~=sh
        needrescale=true;
        obj.STFTScaleHigh=sh;
    end
end

if obj.STFTScaleHigh<=obj.STFTScaleLow
    obj.STFTScaleLow=[];
    obj.STFTScaleHigh=[];
end

refn=str2double(answer{7});
if ~isnan(refn)
    if obj.STFTNormalizePoint~=refn
        needredraw=true;
        obj.STFTNormalizePoint=refn;
    end
end
if ishandle(obj.TFMapFig)
    if needredraw
        Time_Freq_Map(obj,obj.BtnTFMap);
        return
    end
    
    h=findobj(obj.TFMapFig,'-regexp','Tag','TFMapAxes*');
    
    if needrescale
        set(h,'CLim',[obj.STFTScaleLow,obj.STFTScaleHigh]);
        figure(obj.TFMapFig);
    end
    
    if needroom
        set(h,'YLim',[fl,fh]);
        figure(obj.TFMapFig);
    end
end

end


