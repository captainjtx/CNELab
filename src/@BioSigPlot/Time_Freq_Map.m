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
    case obj.MenuTFMapInteractive
        set(src,'checked','on');
        set(obj.MenuTFMapEvent,'checked','off');
        set(obj.MenuTFMapEventAverage,'checked','off');
        
    case obj.MenuTFMapEvent
        set(src,'checked','on');
        set(obj.MenuTFMapInteractive,'checked','off');
        set(obj.MenuTFMapEventAverage,'checked','off');
        MenuTFMapEvent(obj);
        return
    case obj.MenuTFMapEventAverage
        set(src,'checked','on')
        set(obj.MenuTFMapInteractive,'checked','off');
        set(obj.MenuTFMapEvent,'checked','off');
        MenuTFMapEventAverage(obj);
        return
    case obj.MenuTFMapNormalNone
        set(src,'checked','on');
        set(obj.MenuTFMapNormalWithin,'checked','off');
        set(obj.MenuTFMapNormalBaseline,'checked','off');
        
    case obj.MenuTFMapNormalWithin
        set(src,'checked','on');
        set(obj.MenuTFMapNormalBaseline,'checked','off');
        set(obj.MenuTFMapNormalNone,'checked','off');
        MenuTFMapNormalWithin(obj);
        return
    case obj.MenuTFMapNormalBaseline
        set(src,'checked','on');
        set(obj.MenuTFMapNormalWithin,'checked','off');
        set(obj.MenuTFMapNormalNone,'checked','off');
        MenuTFMapNormalBaseline(obj);
        return
    case obj.MenuTFMapDisplayOnset
        if strcmpi(get(src,'checked'),'on')
            set(src,'checked','off');
        else
            set(src,'checked','on');
        end
        
        MenuTFMapDisplayOnset(obj);
        return
end
%==========================================================================
%continue ?
if isempty(obj.TFMapFig)||~ishandle(obj.TFMapFig)
    if ismember(src,[obj.MenuTFMapAverage,obj.MenuTFMapChannel,obj.MenuTFMapGrid,...
            obj.MenuTFMap_Normal,obj.MenuTFMap_DB,...
            obj.MenuTFMapInteractive,obj.MenuTFMapEvent,obj.MenuTFMapEventAverage,...
            obj.MenuTFMapNormalNone,obj.MenuTFMapNormalWithin,obj.MenuTFMapNormalBaseline,...
            obj.MenuTFMapDisplayOnset])
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
nL=round(obj.TFMapBeforeOnset*fs/1000);
nR=round(obj.TFMapAfterOnset*fs/1000);

%Data selection************************************************************
if strcmpi(get(obj.MenuTFMapInteractive,'checked'),'on')
    omitMask=true;
    [data,chanNames,dataset,channel,sample,evts,groupnames,chanpos]=get_selected_data(obj,omitMask);
elseif strcmpi(get(obj.MenuTFMapEvent,'checked'),'on')
    if isempty(obj.SelectedEvent)
        errordlg('No event selection !');
        return
    elseif length(obj.SelectedEvent)>1
        warndlg('More than one event selected, using the first one !');
    end
    i_label=round(obj.Evts{obj.SelectedEvent(1),1}*fs);   
    i_label=min(max(1,i_label),size(obj.Data{1},1));
    
    i_label((i_label+nR)>size(obj.Data{1},1))=[];
    i_label((i_label-nL)<1)=[];
    if isempty(i_label)
        errordlg('Illegal selection!');
        return
    end
    obj.Selection=[reshape(i_label-nL,1,length(i_label));reshape(i_label+nR,1,length(i_label))];
    omitMask=true;
    [data,chanNames,dataset,channel,sample,evts,groupnames,chanpos]=get_selected_data(obj,omitMask);
elseif strcmpi(get(obj.MenuTFMapEventAverage,'checked'),'on')
    t_evt=[obj.Evts{:,1}];
    t_label=t_evt(strcmpi(obj.Evts(:,2),obj.TFMapEvent));
    if isempty(t_label)
        errordlg(['Event: ',obj.TFMapEvent,' not found !']);
        return
    end
    i_event=round(t_label*obj.SRate);
    i_event=min(max(1,i_event),size(obj.Data{1},1));
    
    i_event((i_event+nR)>size(obj.Data{1},1))=[];
    i_event((i_event-nL)<1)=[];
    
    omitMask=true;
    [data,chanNames,dataset,channel,sample,evts,groupnames,chanpos]=get_selected_data(obj,omitMask);
    %need to change the data
end
%**************************************************************************


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
    nref=round(fs/2);
    obj.STFTNormalizePoint=nref;
end

obj.STFTWindowLength=wd;
obj.STFTOverlap=ov;
obj.STFTNormalizePoint=nref;
%**************************************************************************

s=[obj.STFTScaleLow obj.STFTScaleHigh];
freq=[obj.STFTFreqLow obj.STFTFreqHigh];

if isempty(obj.TFMapFig)||~ishandle(obj.TFMapFig)
    obj.TFMapFig=figure('Name','TFMap','Visible','off','NumberTitle','off');
end
figure(obj.TFMapFig)
set(gcf,'visible','on')
clf

%Normalizatin**************************************************************
if strcmpi(get(obj.MenuTFMapNormalNone,'checked'),'on')
    nref=[];
    baseline=[];
elseif strcmpi(get(obj.MenuTFMapNormalWithin,'checked'),'on')
    nref=obj.STFTNormalizePoint;
    baseline=[];
elseif strcmpi(get(obj.MenuTFMapNormalBaseline,'checked'),'on')
    nref=[];
    
    t_evt=[obj.Evts{:,1}];
    t_label=t_evt(strcmpi(obj.Evts(:,2),obj.TFMapRestStart));
    i_label=round(t_label*obj.SRate);
    i_label=min(max(1,i_label),size(obj.Data{1},1));

    baseline_start=i_label;

    t_label=t_evt(strcmpi(obj.Evts(:,2),obj.TFMapRestEnd));
    i_label=round(t_label*obj.SRate);
    i_label=min(max(1,i_label),size(obj.Data{1},1));
    
    baseline_end=i_label;
    
    tmp=obj.Selection_;
    obj.Selection_=[reshape(baseline_start,1,length(i_label));reshape(baseline_end,1,length(i_label))];
    omitMask=true;
    baseline=get_selected_data(obj,omitMask);
    obj.Selection_=tmp;
end
%**************************************************************************
switch option
    case 1
        [tf,f,t]=bsp_tfmap(obj.TFMapFig,data,baseline,fs,wd,ov,s,nref,chanNames,freq,unit);
        
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
        bsp_tfmap(obj.TFMapFig,data,baseline,fs,wd,ov,s,nref,chanNames,freq,unit);
    case 3
            if isempty(sl)
                sl=-10;
                obj.STFTScaleLow=sl;
            end
            if isempty(sh)
                sh=10;
                obj.STFTScaleHigh=sh;
            end
            
            if isempty(chanpos)
                errordlg('No channel position in the data !');
                return
            end
            
            chanind=~isnan(chanpos(:,1))&~isnan(chanpos(:,2));
            data=data(:,chanind);
            channames=chanNames(chanind);
            chanpos=chanpos(chanind,:);
            
            chanpos(:,1)=chanpos(:,1)-min(chanpos(:,1));
            chanpos(:,2)=chanpos(:,2)-min(chanpos(:,2));
            
            dx=abs(pdist2(chanpos(:,1),chanpos(:,1)));
            dx=min(dx(dx~=0));
            if isempty(dx)
                dx=1;
            end
            
            dy=abs(pdist2(chanpos(:,2),chanpos(:,2)));
            dy=min(dy(dy~=0));
            if isempty(dy)
                dy=1;
            end
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
                axes(ax_back);
                if strcmpi(get(obj.MenuTFMapEventAverage,'checked'),'on')
                    tfm=0;
                    tmp=obj.Selection_;
                    for i=1:length(i_event)
                        obj.Selection_=[i_event(i)-nL;i_event(i)+nR];
                        data=get_selected_data(obj,omitMask);
                        data=data(:,chanind);
                        data=data(:,j);
                        [tf,f,t]=bsp_tfmap(obj.TFMapFig,data,baseline,fs,wd,ov,s,nref,channames,freq,unit);
                        tfm=tfm+tf;
                    end
                    obj.Selection_=tmp;
                    tfm=tfm/length(i_event);
                else
                    [tfm,f,t]=bsp_tfmap(obj.TFMapFig,data(:,j),baseline,fs,wd,ov,s,nref,channames,freq,unit);
                end
                tfmap_grid(t,f,tfm,chanpos(j,:),dw,dh,channames{j},sl,sh,freq);
            end
            MenuTFMapDisplayOnset(obj);
end
end


function MnuTFMapSettings(obj)

%**************************************************************************
% Dialog box to change the settings of Time frequency map
%**************************************************************************
fs=obj.SRate;

prompt={'STFT window:','STFT overlap:',...
    'Frequency low:','Frequency high',...
    'Lower bound of scale:','Upper bound of scale'};

def={num2str(obj.STFTWindowLength),num2str(obj.STFTOverlap),...
    num2str(obj.STFTFreqLow),num2str(obj.STFTFreqHigh),...
    num2str(obj.STFTScaleLow),num2str(obj.STFTScaleHigh)};

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

if ~isempty(obj.TFMapFig)&&ishandle(obj.TFMapFig)
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
        MenuTFMapDisplayOnset(obj);
        figure(obj.TFMapFig);
    end
end

end

function MenuTFMapEvent(obj)

prompt={'Before onset(ms):','After onset(ms):'};

def={num2str(obj.TFMapBeforeOnset),num2str(obj.TFMapAfterOnset)};

title='Data Selection (Event) Settings';


answer=inputdlg(prompt,title,1,def);

if isempty(answer)
    return
end

msbefore=str2double(answer{1});

if ~isnan(msbefore)
    obj.TFMapBeforeOnset=msbefore;
else
    if isempty(obj.TFMapBeforeOnset)
        obj.TFMapBeforeOnset=1000;
    end
end

msafter=str2double(answer{2});

if ~isnan(msafter)
    obj.TFMapAfterOnset=msafter;
else
    if isempty(obj.TFMapAfterOnset)
        obj.TFMapAfterOnset=1000;
    end
end
% if ishandle(obj.TFMapFig)
%     Time_Freq_Map(obj,obj.BtnTFMap);
% end

end
function MenuTFMapEventAverage(obj)

prompt={'Event:','Before onset(ms):','After onset(ms):'};

if isempty(obj.TFMapEvent)
    obj.TFMapEvent='';
end

def={obj.TFMapEvent,num2str(obj.TFMapBeforeOnset),num2str(obj.TFMapAfterOnset)};

title='Data Selection (Event Average) Settings';


answer=inputdlg(prompt,title,1,def);

if isempty(answer)
    return
end

if ~ismember(answer{1},obj.Evts(:,2));
    errordlg(['Cannot find ' answer{1} ' in the events !']);
else
    obj.TFMapEvent=answer{1};
end

msbefore=str2double(answer{2});

if ~isnan(msbefore)
    obj.TFMapBeforeOnset=msbefore;
else
    if isempty(obj.TFMapBeforeOnset)
        obj.TFMapBeforeOnset=1000;
    end
end

msafter=str2double(answer{3});

if ~isnan(msafter)
    obj.TFMapAfterOnset=msafter;
else
    if isempty(obj.TFMapAfterOnset)
        obj.TFMapAfterOnset=1000;
    end
end

% if ishandle(obj.TFMapFig)
%     Time_Freq_Map(obj,obj.BtnTFMap);
% end

end

function MenuTFMapNormalWithin(obj)
prompt={'From 0 to (?) milliseconds: '};

if isempty(obj.TFMapEvent)
    obj.TFMapEvent='';
end

if isempty(obj.STFTNormalizePoint)
    obj.STFTNormalizePoint=obj.TFMapBeforeOnset/3;
end
def={num2str(obj.STFTNormalizePoint/obj.SRate*1000)};

title='Normalization Settings';


answer=inputdlg(prompt,title,1,def);

if isempty(answer)
    return
end

refn=round(str2double(answer{1})*obj.SRate/1000);
if ~isnan(refn)
    if obj.STFTNormalizePoint~=refn
        obj.STFTNormalizePoint=refn;
    end
end

% if ishandle(obj.TFMapFig)
%     Time_Freq_Map(obj,obj.BtnTFMap);
% end

end

function MenuTFMapNormalBaseline(obj)

prompt={'Event of Rest-Start: ','Event of Rest-End: '};

if isempty(obj.TFMapRestStart)
    obj.TFMapRestStart='';
end

if isempty(obj.TFMapRestEnd)
    obj.TFMapRestEnd='';
end
def={obj.TFMapRestStart,obj.TFMapRestEnd};

title='Normalization Settings';


answer=inputdlg(prompt,title,1,def);

if isempty(answer)
    return
end

if ~ismember(answer{1},obj.Evts(:,2));
    errordlg(['Cannot find ' answer{1} ' in the events !']);
else
    obj.TFMapRestStart=answer{1};
end

if ~ismember(answer{2},obj.Evts(:,2));
    errordlg(['Cannot find ' answer{2} ' in the events !']);
else
    obj.TFMapRestEnd=answer{2};
end

end

function MenuTFMapDisplayOnset(obj)

tonset=obj.TFMapBeforeOnset/1000;
if ~isempty(obj.TFMapFig)&&ishandle(obj.TFMapFig)
    
    h=findobj(obj.TFMapFig,'-regexp','Tag','TFMapAxes*');
    if strcmpi(get(obj.MenuTFMapDisplayOnset,'checked'),'on')
        for i=1:length(h)
            tmp=findobj(h(i),'Type','line');
            delete(tmp);
             line([tonset,tonset],[obj.STFTFreqLow,obj.STFTFreqHigh],'LineStyle',':',...
                 'color','k','linewidth',0.1,'Parent',h(i))
        end
    else
       for i=1:length(h)
           tmp=findobj(h(i),'Type','line');
           delete(tmp);
       end
    end
end
end
