function Time_Freq_Map(obj,src)

option=obj.TFMapWin.method;

unit=obj.TFMapWin.unit;
%==========================================================================
fs=obj.SRate;
nL=round(obj.TFMapWin.ms_before*fs/1000);
nR=round(obj.TFMapWin.ms_after*fs/1000);

%Data selection************************************************************
if obj.TFMapWin.data_input==1
    omitMask=true;
    [data,chanNames,dataset,channel,sample,evts,groupnames,chanpos]=get_selected_data(obj,omitMask);
elseif obj.TFMapWin.data_input==2
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
elseif obj.TFMapWin.data_input==3
    t_evt=[obj.Evts{:,1}];
    t_label=t_evt(strcmpi(obj.Evts(:,2),obj.TFMapWin.event));
    if isempty(t_label)
        errordlg(['Event: ',obj.TFMapWin.event,' not found !']);
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
wd=round(obj.TFMapWin.stft_winlen);
ov=round(obj.TFMapWin.stft_overlap);

sl=obj.TFMapWin.min_clim;
sh=obj.TFMapWin.max_clim;

if isempty(wd)||wd>size(data,1)
    wd=round(fs/3);
    ov=round(wd*0.9);
end

if ov>wd
    ov=round(wd*0.9);
end
obj.TFMapWin.stft_winlen=wd;
obj.TFMapWin.stft_overlap=ov;
%**************************************************************************

s=[obj.TFMapWin.min_clim obj.TFMapWin.max_clim];
if s(1)>=s(2)
    s(1)=s(2)-abs(s(2))*0.1;
    obj.TFMapWin.min_clim=s(1);
end

freq=[obj.TFMapWin.min_freq obj.TFMapWin.max_freq];
if freq(1)>=freq(2)
    freq(1)=freq(2)-1;
    obj.TFMapWin.min_freq=freq(1);
end

if isempty(obj.TFMapFig)||~ishandle(obj.TFMapFig)||~strcmpi(get(obj.TFMapFig,'name'),'TFMap')
    obj.TFMapFig=figure('Name','TFMap','Visible','off','NumberTitle','off');
end
figure(obj.TFMapFig)
set(gcf,'visible','on')
clf

%Normalizatin**************************************************************
if obj.TFMapWin.normalization==1
    nref=[];
    baseline=[];
elseif obj.TFMapWin.normalization==2||obj.TFMapWin.normalization==3
    nref=[obj.TFMapWin.normalization_start,obj.TFMapWin.normalization_end];
    
    if nref(2)>=round(size(data,1)/fs*1000)
        nref(2)=round(size(data,1)/fs*1000);
    end
    if nref(1)>=nref(2)
        nref(1)=0;
    end
    if nref(1)<0;
        nref(1)=0;
    end  
    baseline=[];
    obj.TFMapWin.normalization_start=nref(1);
    obj.TFMapWin.normalization_end=nref(2);
elseif obj.TFMapWin.normalization==4
    nref=[];
    
    t_evt=[obj.Evts{:,1}];
    t_label=t_evt(strcmpi(obj.Evts(:,2),obj.TFMapWin.normalization_start_event));
    i_label=round(t_label*obj.SRate);
    i_label=min(max(1,i_label),size(obj.Data{1},1));

    baseline_start=i_label;

    t_label=t_evt(strcmpi(obj.Evts(:,2),obj.TFMapWin.normalization_end_event));
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
        
        obj.TFMapWin.clim_slider_max=max(max(abs(tf)));
        obj.TFMapWin.clim_slider_min=-max(max(abs(tf)));
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
        tf=bsp_tfmap(obj.TFMapFig,data,baseline,fs,wd,ov,s,nref,chanNames,freq,unit);
        cmax=max(max(abs(tf)));
        obj.TFMapWin.clim_slider_max=cmax*2;
        obj.TFMapWin.clim_slider_min=-cmax*2;
    case 3
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
            axe = axes('Parent',obj.TFMapFig,'units','normalized','Position',[0 0 1 1],'XLim',[0,1],'YLim',[0,1],'visible','off');
            
            cmax=-inf;
            nref_tmp=nref;
            for j=1:length(channames)
                if obj.TFMapWin.data_input==3
                    tfm=0;
                    tmp=obj.Selection_;
                    %compute the baseline spectrum
                    if obj.TFMapWin.normalization==3
                        rtfm=0;
                        for i=1:length(i_event)
                            obj.Selection_=[i_event(i)-nL+nref(1);i_event(i)-nL+nref(2)];
                            bdata=get_selected_data(obj,omitMask);
                            bdata=bdata(:,chanind);
                            bdata=bdata(:,j);
                            [rtf,f,t]=bsp_tfmap(obj.TFMapFig,bdata,baseline,fs,wd,ov,s,[],channames,freq,unit);
                            rtfm=rtfm+abs(rtf);
                        end
                        
                        rtfm=rtfm/length(i_event);
                        nref_tmp=[];
                    end
                    %******************************************************
                    for i=1:length(i_event)
                        
                        obj.Selection_=[i_event(i)-nL;i_event(i)+nR];
                        data=get_selected_data(obj,omitMask);
                        data=data(:,chanind);
                        data=data(:,j);
                        [tf,f,t]=bsp_tfmap(obj.TFMapFig,data,baseline,fs,wd,ov,s,nref_tmp,channames,freq,unit);
                        tfm=tfm+tf;
                    end
                    tfm=tfm/length(i_event);
                    obj.Selection_=tmp;
                    if obj.TFMapWin.normalization==3
                        tfm=tfm./repmat(mean(rtfm,2),1,size(tfm,2));
                    end
                else
                    [tfm,f,t]=bsp_tfmap(obj.TFMapFig,data(:,j),baseline,fs,wd,ov,s,nref,channames,freq,unit);
                end
                    
                tfmap_grid(obj.TFMapFig,axe,t,f,tfm,chanpos(j,:),dw,dh,channames{j},sl,sh,freq,unit);
                
                
                if ~isempty(tfm)
                    if strcmpi(unit,'dB')
                        cmax=max(max(max(abs(10*log10(tfm)))),cmax);
                    else
                        cmax=max(max(max(abs(tfm-1))),cmax);
                    end
                end
            end
            if strcmpi(unit,'dB')
                obj.TFMapWin.clim_slider_max=cmax*1.5;
                obj.TFMapWin.clim_slider_min=-cmax*1.5;
            else
                obj.TFMapWin.clim_slider_max=cmax*1.5;
                obj.TFMapWin.clim_slider_min=-1;
            end
            
            obj.TFMapWin.DisplayOnsetCallback([]);
end
end
