classdef SenStimGUI<handle
    properties
        Fig
        conf
        chan
        
        stim_popups
        refresh_btn
        
        stim_monopolar_radio
        stim_bipolar_radio
        
        JMonopolarSpinner
        JBipolarSpinner1
        JBipolarSpinner2
        
        saved_list
        
        JAmplitudeSpinner
        JPhaseDurationSpinner
        JFrequencySpinner
        JTrainLengthSpinner
        JTrainDelaySpinner
        JFastSettleSpinner
        
        save_stim_btn
        reset_stim_btn
        delete_list_btn
        
        cathodic_radio
        single_pulse_radio
        fast_settle_radio
        multi_stim_radio
        
        stop_btn
        stim_btn
        
        info_text
        
        savedStim
        
        DEFAULT_FREQ
        MAX_FREQ
        DEFAULT_DUR
        MAX_DUR
        DEFAULT_TL
        MAX_TL
        DEFAULT_TD
        MAX_TD
        DEFAULT_FS
        MAX_FS
        
        STIM_COUNT
        DEFAULT_PORT
        udp_fid
        log_fid
    end
    properties(Dependent)
        max_amp
        frontends
    end
    
    methods
        function obj=SenStimGUI(varargin)
            obj.varInit();
            obj.buildfig();
            obj.refresh();
        end
        function varInit(obj)
            obj.DEFAULT_FREQ = 60.0; %Hz
            obj.MAX_FREQ=1000;
            obj.DEFAULT_DUR = 0.3; %ms
            obj.MAX_DUR=10;
            obj.DEFAULT_TL = 2000.0; %ms
            obj.MAX_TL=60000;
            obj.DEFAULT_TD = 0.0; %ms
            obj.MAX_TD=100;
            obj.DEFAULT_FS = 0.0; %ms
            obj.MAX_FS=100;
            obj.STIM_COUNT=0;
            obj.DEFAULT_PORT=1126;
            obj.udp_fid=udp('127.0.0.1',obj.DEFAULT_PORT);
            fopen(obj.udp_fid);
            obj.log_fid=fopen('stim.log','w');
            fprintf(obj.log_fid,'%%elec    amplitude(mA)    phase duration(ms)    frequency(Hz)    train length(ms)    stim string\n');
        end
        function buildfig(obj)
            import javax.swing.JSlider;
            import javax.swing.JSpinner;
            import javax.swing.SpinnerNumberModel;
            import javax.swing.JButton;
            import java.awt.Color;
            import javax.swing.BorderFactory;
            import javax.swing.ImageIcon;
            import javax.swing.JPanel;
            import javax.swing.JRadioButton;
            
            screensize=get(0,'ScreenSize');
            obj.Fig=figure('MenuBar','none','ToolBar','none','DockControls','off','NumberTitle','off','RendererMode','manual',...
                'CloseRequestFcn',@(src,evts) OnClose(obj),'WindowScrollWheelFcn',@(src,evts) ScrollWheel(obj,src,evts),...
                'WindowButtonMotionFcn',@(src,evt) MouseMovement(obj),'WindowButtonDownFcn',@(src,evt) MouseDown(obj),...
                'WindowButtonUpFcn',@(src,evt) MouseUp(obj),'ResizeFcn',@(src,evt) Resize(obj),...
                'WindowKeyPressFcn',@(src,evt) KeyPress(obj,src,evt),'WindowKeyReleaseFcn',@(src,evt) KeyRelease(obj,src,evt),...
                'Units','Pixels','Visible','on',...
                'position',[10,screensize(4)-640,350,600],'Name','BrainMap Simulink Control');
            
            tabgp = uitabgroup(obj.Fig,'Position',[0 0.2 1 0.8]);
            
            tab2 = uitab(tabgp,'Title','Stim');
            
            hp_mono_bipolar=uipanel('parent',tab2,'units','normalized','position',[0,0.85,1,0.15]);
            
            obj.stim_monopolar_radio=uicontrol('Parent',hp_mono_bipolar,'Style','radiobutton','units','normalized','string','Monopolar','position',[0,0.52,0.3,0.46],...
                'HorizontalAlignment','left','callback',@(src,evts) MonopolarRadioCallback(obj,src),'value',1);
            
            model = javaObjectEDT(SpinnerNumberModel(java.lang.Integer(1),java.lang.Integer(1),java.lang.Integer(32),java.lang.Integer(1)));
            obj.JMonopolarSpinner =javaObjectEDT(JSpinner(model));
            [jh,gh]=javacomponent(obj.JMonopolarSpinner,[0,0,1,1],hp_mono_bipolar);
            set(gh,'Units','Norm','Position',[0.4,0.5,0.2,0.42]);
            set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) MonopolarSpinnerCallback(obj));
            obj.JMonopolarSpinner.setEnabled(true);
            
            obj.stim_bipolar_radio=uicontrol('Parent',hp_mono_bipolar,'Style','radiobutton','units','normalized','string','Bipolar','position',[0,0.02,0.3,0.46],...
                'HorizontalAlignment','left','callback',@(src,evts) BipolarRadioCallback(obj,src),'value',0);
            
            model = javaObjectEDT(SpinnerNumberModel(java.lang.Integer(1),java.lang.Integer(1),java.lang.Integer(32),java.lang.Integer(1)));
            obj.JBipolarSpinner1 =javaObjectEDT(JSpinner(model));
            [jh,gh]=javacomponent(obj.JBipolarSpinner1,[0,0,1,1],hp_mono_bipolar);
            set(gh,'Units','Norm','Position',[0.4,0.04,0.2,0.42]);
            set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) BipolarSpinnerCallback(obj));
            obj.JBipolarSpinner1.setEnabled(false);
            
            uicontrol('parent',hp_mono_bipolar,'style','text','units','normalized','position',[0.65,0.2,0.1,0.46],...
                'string','-','horizontalalignment','left','fontunits','normalized','fontsize',4);
            
            model = javaObjectEDT(SpinnerNumberModel(java.lang.Integer(2),java.lang.Integer(1),java.lang.Integer(32),java.lang.Integer(1)));
            obj.JBipolarSpinner2 =javaObjectEDT(JSpinner(model));
            [jh,gh]=javacomponent(obj.JBipolarSpinner2,[0,0,1,1],hp_mono_bipolar);
            set(gh,'Units','Norm','Position',[0.75,0.04,0.2,0.42]);
            set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) BipolarSpinnerCallback(obj));
            obj.JBipolarSpinner2.setEnabled(false);
            
            hp_stim_parameter=uipanel('parent',tab2,'units','normalized','position',[0,0.25,0.6,0.55]);
            
            %amplitude
            uicontrol('parent',hp_stim_parameter,'style','text','units','normalized','position',[0,0.86,0.6,0.13],...
                'string','Amplitude (mA)','horizontalalignment','left','fontunits','normalized','fontsize',0.4);
            model = javaObjectEDT(SpinnerNumberModel(0,0,obj.max_amp,0.1));
            obj.JAmplitudeSpinner =javaObjectEDT(JSpinner(model));
            [jh,gh]=javacomponent(obj.JAmplitudeSpinner,[0,0,1,0.1],hp_stim_parameter);
            set(gh,'Units','Norm','Position',[0.6,0.86,0.4,0.13]);
            set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) AmplitudeSpinnerCallback(obj));
            
            uicontrol('parent',hp_stim_parameter,'style','text','units','normalized','position',[0,0.72,0.6,0.13],...
                'string','Phase Duration (ms)','horizontalalignment','left','fontunits','normalized','fontsize',0.4);
            model = javaObjectEDT(SpinnerNumberModel(obj.DEFAULT_DUR,0,obj.MAX_DUR,.1));
            obj.JPhaseDurationSpinner =javaObjectEDT(JSpinner(model));
            [jh,gh]=javacomponent(obj.JPhaseDurationSpinner,[0,0,1,1],hp_stim_parameter);
            set(gh,'Units','Norm','Position',[0.6,0.72,0.4,0.13]);
            set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) PhaseDurationSpinnerCallback(obj));
            
            uicontrol('parent',hp_stim_parameter,'style','text','units','normalized','position',[0,0.58,0.6,0.13],...
                'string','Frequency (Hz)','horizontalalignment','left','fontunits','normalized','fontsize',0.4);
            model = javaObjectEDT(SpinnerNumberModel(obj.DEFAULT_FREQ,0,obj.MAX_FREQ,10));
            obj.JFrequencySpinner =javaObjectEDT(JSpinner(model));
            [jh,gh]=javacomponent(obj.JFrequencySpinner,[0,0,1,1],hp_stim_parameter);
            set(gh,'Units','Norm','Position',[0.6,0.58,0.4,0.13]);
            set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) FrequencySpinnerCallback(obj));
            
            uicontrol('parent',hp_stim_parameter,'style','text','units','normalized','position',[0,0.44,0.6,0.13],...
                'string','Train Length (ms)','horizontalalignment','left','fontunits','normalized','fontsize',0.4);
            model = javaObjectEDT(SpinnerNumberModel(obj.DEFAULT_TL,0,obj.MAX_TL,100));
            obj.JTrainLengthSpinner =javaObjectEDT(JSpinner(model));
            [jh,gh]=javacomponent(obj.JTrainLengthSpinner,[0,0,1,1],hp_stim_parameter);
            set(gh,'Units','Norm','Position',[0.6,0.44,0.4,0.13]);
            set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) TrainLengthSpinnerCallback(obj));
            
            uicontrol('parent',hp_stim_parameter,'style','text','units','normalized','position',[0,0.3,0.6,0.13],...
                'string','Train Delay (ms)','horizontalalignment','left','fontunits','normalized','fontsize',0.4);
            model = javaObjectEDT(SpinnerNumberModel(obj.DEFAULT_TD,0,obj.MAX_TD,1));
            obj.JTrainDelaySpinner =javaObjectEDT(JSpinner(model));
            [jh,gh]=javacomponent(obj.JTrainDelaySpinner,[0,0,1,1],hp_stim_parameter);
            set(gh,'Units','Norm','Position',[0.6,0.3,0.4,0.13]);
            set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) TrainDelaySpinnerCallback(obj));
            
            uicontrol('parent',hp_stim_parameter,'style','text','units','normalized','position',[0,0.16,0.6,0.13],...
                'string','Fast Settle (ms)','horizontalalignment','left','fontunits','normalized','fontsize',0.4);
            model = javaObjectEDT(SpinnerNumberModel(obj.DEFAULT_FS,0,obj.MAX_FS,1));
            obj.JFastSettleSpinner =javaObjectEDT(JSpinner(model));
            [jh,gh]=javacomponent(obj.JFastSettleSpinner,[0,0,1,1],hp_stim_parameter);
            set(gh,'Units','Norm','Position',[0.6,0.16,0.4,0.13]);
            set(handle(jh,'CallbackProperties'),'StateChangedCallback',@(h,e) FastSettleSpinnerCallback(obj));
            
            obj.save_stim_btn=uicontrol('parent',hp_stim_parameter,'style','pushbutton','string','Save','units','normalized','position',[0.73,0.01,0.25,0.12],...
                'callback',@(src,evts) saveStim(obj));
            
            obj.reset_stim_btn=uicontrol('parent',hp_stim_parameter,'style','pushbutton','string','Reset','units','normalized','position',[0.02,0.01,0.25,0.12],...
                'callback',@(src,evts) resetStim(obj));
            
            hp_saved_list=uipanel('parent',tab2,'units','normalized','position',[0.6,0.25,0.4,0.55]);
            obj.saved_list= uicontrol('parent',hp_saved_list,'style','listbox','units','normalized','position',[0.01,0.16,0.98,0.82],...
                'string',{},'callback',@(src,evt) ListCallback(obj,src),'max',1,'min',0);
            
            obj.delete_list_btn=uicontrol('parent',hp_saved_list,'style','pushbutton','string','Delete','units','normalized','position',[0.62,0.01,0.36,0.12],...
                'callback',@(src,evts) deleteStim(obj));
            
            hp_other_option=uipanel('parent',tab2,'units','normalized','position',[0,0.1,1,0.15]);
            
            
            obj.cathodic_radio=uicontrol('parent',hp_other_option,'units','normalized','style','radiobutton','position',[0.01,0.55,0.3,0.4],...
                'callback',@(src,evts) CathodicCallback(obj),'string','Cathodic First');
            
            obj.single_pulse_radio=uicontrol('parent',hp_other_option,'units','normalized','style','radiobutton','position',[0.31,0.55,0.3,0.4],...
                'callback',@(src,evts) SinglePulseCallback(obj,src),'string','Single Pulse');
            
            obj.fast_settle_radio=uicontrol('parent',hp_other_option,'units','normalized','style','radiobutton','position',[0.61,0.55,0.3,0.4],...
                'callback',@(src,evts) FastSettleCallback(obj),'string','Fast Settle');
            
            obj.multi_stim_radio=uicontrol('parent',hp_other_option,'units','normalized','style','radiobutton','position',[0.01,0.05,0.3,0.4],...
                'callback',@(src,evts) MultiStimCallback(obj,src),'string','Multi Stim');
            
            obj.stop_btn=uicontrol('parent',tab2,'style','pushbutton','string','Stop','units','normalized','position',[0.01,0.01,0.25,0.07],...
                'callback',@(src,evts) StopStim(obj));
            
            obj.stim_btn=uicontrol('parent',tab2,'style','pushbutton','string','Stim','units','normalized','position',[0.74,0.01,0.25,0.07],...
                'callback',@(src,evts) Stim(obj));
            
            obj.info_text=uicontrol('parent',obj.Fig,'style','text','String','','units','normalized','position',[0,0,1,0.18]);
            
            tab1 = uitab(tabgp,'Title','Front end');
            port_names={'Port A','Port B','Port C','Port D'};
            
            for port=1:4
                for num=1:4
                    uicontrol('Parent',tab1,'Style','text','string',port_names{port},'units','normalized',...
                        'position',[0,1-0.22*port,0.2,0.22],'HorizontalAlignment','center');
                    obj.stim_popups(port,num)=uicontrol('Parent',tab1,'Style','popup',...
                        'String',{'1','2'},'units','normalized','Position',[num*0.2,1-0.22*port,0.18,0.22],'value',2,...
                        'visible','off','callback',@(src,evts) FrontEndChange(obj,src,port,num));
                end
            end
            
            obj.refresh_btn=uicontrol('parent',tab1,'style','pushbutton','string','Read Frontends ','units','normalized','position',[0.68,0.01,0.3,0.08],...
                'callback',@(src,evts) refresh(obj));
            
            set(tabgp,'selectedtab',tab1);
        end
        
        function val=get.frontends(obj)
            val=[0,0];
            for port=1:4
                for num=1:4
                    if strcmp(get(obj.stim_popups(port,num),'visible'),'on')
                        version=get(obj.stim_popups(port,num),'value');
                        switch version
                            case 1
                                val(1)=val(1)+1;
                            case 2
                                val(2)=val(2)+1;
                        end
                    end
                end
            end
        end
        
        function val=get.max_amp(obj)
            val=0;
            
            for i=1:32:length(obj.chan)
                port=floor(obj.chan(i)/128)+1;
                num=floor((obj.chan(i)-(port-1)*128)/32)+1;
                
                version=get(obj.stim_popups(port,num),'value');
                
                switch version
                    case 1
                        val=val+0.93;
                    case 2
                        val=val+1.53;
                end
            end
        end
        
        function FastSettleSpinnerCallback(obj)
        end
        function FrequencySpinnerCallback(obj)
        end
        function TrainLengthSpinnerCallback(obj)
        end
        function TrainDelaySpinnerCallback(obj)
        end
        function AmplitudeSpinnerCallback(obj)
            %             obj.JAmplitudeSpinner.setValue(obj.JAmplitudeSpinner.getValue());
        end
        
        function PhaseDurationSpinnerCallback(obj)
            %             obj.JPhaseDurationSpinner.setValue(obj.JPhaseDurationSpinner.getValue());
        end
        
        function MonopolarSpinnerCallback(obj)
            
            
        end
        function BipolarSpinnerCallback(obj)
            
        end
        function MonopolarRadioCallback(obj,src)
            set(src,'value',1);
            obj.JMonopolarSpinner.setEnabled(true);
            set(obj.stim_bipolar_radio,'value',0);
            obj.JBipolarSpinner1.setEnabled(false);
            obj.JBipolarSpinner2.setEnabled(false);
        end
        function BipolarRadioCallback(obj,src)
            set(src,'value',1);
            obj.JMonopolarSpinner.setEnabled(false);
            set(obj.stim_monopolar_radio,'value',0);
            obj.JBipolarSpinner1.setEnabled(true);
            obj.JBipolarSpinner2.setEnabled(true);
        end
        function FrontEndChange(obj,src,port,num)
            obj.JAmplitudeSpinner.setValue(java.lang.Double(0));
            obj.JAmplitudeSpinner.getModel().setMaximum(java.lang.Double(obj.max_amp));
            obj.JAmplitudeSpinner.getModel().setStepSize(java.lang.Double(abs(obj.max_amp)/100));
            saveConfig(obj)
        end
        
        function refresh(obj)
            xippmex('close');
            xippmex();
            obj.chan=xippmex('elec','stim');
            
            for i=1:32:length(obj.chan)
                %set to maximum step size
                xippmex('stim','res',obj.chan(i),5);
            end
            
            for port=1:4
                for num=1:4
                    if ismember(128*(port-1)+num*32,obj.chan)
                        set(obj.stim_popups(port,num),'visible','on');
                    else
                        set(obj.stim_popups(port,num),'visible','off');
                    end
                end
            end
            
            obj.JAmplitudeSpinner.setValue(java.lang.Double(0));
            obj.JAmplitudeSpinner.getModel().setMaximum(java.lang.Double(obj.max_amp));
            obj.JAmplitudeSpinner.getModel().setStepSize(java.lang.Double(abs(obj.max_amp)/100));
            saveConfig(obj);
        end
        
        function MakeToolbar(obj)
        end
        
        function MakeMenu(obj)
            %**************************************************************************
            %First Order Menu------------------------------------------------------File
            obj.MenuFile=uimenu(obj.Fig,'Label','File');
            uimenu
        end
        
        function OpenFile(obj)
        end
        
        %for future ...
        function OnClose(obj)
            try
                
                xippmex('close');
            catch
            end
            saveConfig(obj);
            try
                fclose(obj.udp_fid);
            catch
            end
            try
                fclos(obj.log_fid);
            catch
            end
            try
                delete(obj.Fig);
            catch
            end
        end
        function ScrollWheel(obj,src,evts)
        end
        function MouseDown(obj)
        end
        function MouseUp(obj)
        end
        function MouseMovement(obj)
        end
        function Resize(obj)
        end
        function KeyPress(obj,src,evt)
        end
        function KeyRelease(obj,src,evt)
        end
        
        function saveStim(obj)
            prompt={'Name: '};
            amp=obj.JAmplitudeSpinner.getValue();
            freq=obj.JFrequencySpinner.getValue();
            tl=obj.JTrainLengthSpinner.getValue();
            
            if get(obj.stim_monopolar_radio,'value')
                def={[num2str(obj.JMonopolarSpinner.getValue()),' ',...
                    num2str(amp),'mA ',...
                    num2str(freq),'Hz ',num2str(tl),'ms']};
            elseif get(obj.stim_bipolar_radio,'value')
                def={[num2str(obj.JBipolarSpinner1.getValue()),'-',...
                    num2str(obj.JBipolarSpinner2.getValue()),' ',...
                    num2str(amp),'mA ',...
                    num2str(freq),'Hz ',num2str(tl),'ms']};
            end
            
            title='Save stimulation';
            answer=inputdlg(prompt,title,1,def);
            
            if isempty(answer)
                return
            end
            
            len=length(obj.savedStim);
            obj.savedStim(len+1).name=answer{1};
            obj.savedStim(len+1).amp=amp;
            obj.savedStim(len+1).dur=obj.JPhaseDurationSpinner.getValue();
            obj.savedStim(len+1).freq=freq;
            obj.savedStim(len+1).tl=tl;
            obj.savedStim(len+1).td=obj.JTrainDelaySpinner.getValue();
            obj.savedStim(len+1).fs=obj.JFastSettleSpinner.getValue();
            obj.savedStim(len+1).pol=get(obj.cathodic_radio,'value');
            obj.savedStim(len+1).sp=get(obj.single_pulse_radio,'value');
            obj.savedStim(len+1).mono=get(obj.stim_monopolar_radio,'value');
            obj.savedStim(len+1).bip=get(obj.stim_bipolar_radio,'value');
            obj.savedStim(len+1).fs_bool=get(obj.fast_settle_radio,'value');
            obj.savedStim(len+1).elec=[];
            
            if obj.savedStim(len+1).mono
                obj.savedStim(len+1).elec=obj.JMonopolarSpinner.getValue();
            elseif obj.savedStim(len+1).bip
                obj.savedStim(len+1).elec=[obj.JBipolarSpinner1.getValue(),obj.JBipolarSpinner2.getValue()];
            end
            set(obj.saved_list,'string',cat(1,get(obj.saved_list,'string'),answer(1)));
            set(obj.saved_list,'value',length(get(obj.saved_list,'string')));
        end
        
        function ListCallback(obj,src)
            ind=get(src,'value');
            ind=ind(end);
            stim=obj.savedStim(ind);
            
            set(obj.stim_monopolar_radio,'value',stim.mono);
            if(stim.mono)
                obj.JMonopolarSpinner.setEnabled(true);
                obj.JMonopolarSpinner.setValue(stim.elec);
            else
                obj.JMonopolarSpinner.setEnabled(false);
            end
            
            if(stim.bip)
                obj.JBipolarSpinner1.setEnabled(true);
                obj.JBipolarSpinner2.setEnabled(true);
                obj.JBipolarSpinner1.setValue(stim.elec(1));
                obj.JBipolarSpinner2.setValue(stim.elec(2));
            else
                obj.JBipolarSpinner1.setEnabled(false);
                obj.JBipolarSpinner2.setEnabled(false);
            end
            set(obj.stim_bipolar_radio,'value',stim.bip);
            
            
            obj.JAmplitudeSpinner.setValue(stim.amp);
            obj.JPhaseDurationSpinner.setValue(stim.dur);
            obj.JFrequencySpinner.setValue(stim.freq);
            obj.JTrainLengthSpinner.setValue(stim.tl);
            obj.JTrainDelaySpinner.setValue(stim.td);
            obj.JFastSettleSpinner.setValue(stim.fs);
            set(obj.cathodic_radio,'value',stim.pol);
            set(obj.single_pulse_radio,'value',stim.sp);
            set(obj.fast_settle_radio,'value',stim.fs_bool);
        end
        function resetStim(obj)
        end
        function deleteStim(obj)
            list=get(obj.saved_list,'string');
            
            if isempty(list)
                return
            end
            ind=get(obj.saved_list,'value');
            list(ind)=[];
            obj.savedStim(ind)=[];
            
            set(obj.saved_list,'string',list);
            if(isempty(list))
                set(obj.saved_list,'value',0);
            else
                set(obj.saved_list,'value',1);
            end
        end
        
        function CathodicCallback(obj)
        end
        
        function SinglePulseCallback(obj,src)
            if(get(src,'value'))
                obj.JTrainLengthSpinner.setValue(1000/obj.JFrequencySpinner.getValue());
                obj.JTrainLengthSpinner.setEnabled(false);
            else
                obj.JTrainLengthSpinner.setValue(obj.DEFAULT_TL);
                obj.JTrainLengthSpinner.setEnabled(true);
            end
        end
        
        function FastSettleCallback(obj)
        end
        
        function StopStim(obj)
            %halt stimulation immediately
            xippmex('stim','enable',0);
        end
        function Stim(obj)
            stim.tl=[];
            stim.dur=[];
            stim.td=[];
            stim.freq=[];
            stim.pol=[];
            stim.amp=[];
            stim.elec=[];
            
            
            
            if(get(obj.multi_stim_radio,'value'))
                list=get(obj.saved_list,'value');
                for i=1:length(list)
                    st=obj.savedStim(list(i));
                    st=divideCurrent(obj,st);
                    
                    stim.tl=cat(2,stim.tl,st.tl);
                    stim.dur=cat(2,stim.dur,st.dur);
                    stim.td=cat(2,stim.td,st.td);
                    stim.freq=cat(2,stim.freq,st.freq);
                    stim.pol=cat(2,stim.pol,st.pol);
                    stim.amp=cat(2,stim.amp,st.amp);
                    stim.elec=cat(2,stim.elec,st.elec);
                end
            else
                stim.tl=obj.JTrainLengthSpinner.getValue();
                stim.dur=obj.JPhaseDurationSpinner.getValue();
                stim.td=obj.JTrainDelaySpinner.getValue();
                stim.freq=obj.JFrequencySpinner.getValue();
                stim.pol=get(obj.cathodic_radio,'value');
                
                stim.amp=obj.JAmplitudeSpinner.getValue();
                
                
                if(get(obj.stim_monopolar_radio,'value'))
                    stim.elec=obj.JMonopolarSpinner.getValue();
                elseif (get(obj.stim_bipolar_radio,'value'))
                    stim.elec=[obj.JBipolarSpinner1.getValue(),obj.JBipolarSpinner2.getValue()];
                end
                
                %map electrodes
                stim=divideCurrent(obj,stim);
            end
            stim_str = stim_param_to_string(stim.elec, ...
                stim.tl, stim.freq, stim.dur, ...
                stim.amp, stim.td, stim.pol);
            disp(stim_str);
            obj.STIM_COUNT=obj.STIM_COUNT+1;
            xippmex('stim',stim_str);
            
            fwrite(obj.udp_fid,obj.STIM_COUNT);
            
            if get(obj.stim_monopolar_radio,'value')
                elec_str=num2str(get(obj.JMonopolarSpinner,'value'));
            elseif get(obj.stim_bipolar_radio,'value')
                elec_str=[num2str(get(obj.JBipolarSpinner1,'value')),'-',num2str(get(obj.JBipolarSpinner2,'value'))];
            end
            
            fprintf(obj.log_fid,'%d    %s    %f    %f    %d    %f    %s\n',...
                obj.STIM_COUNT,elec_str,get(obj.JAmplitudeSpinner,'value'),...
                get(obj.JPhaseDurationSpinner,'value'),...
                get(obj.JFrequencySpinner,'value'),...
                get(obj.JTrainLengthSpinner,'value'),...
                stim_str);
        end
        
        function stim=divideCurrent(obj,st)
            elec=[];
            amp=[];
            fe=obj.frontends;
            equal_current=st.amp<0.93*sum(fe);
            for i=1:32:length(obj.chan)
                port=floor(obj.chan(i)/128)+1;
                num=floor((obj.chan(i)-(port-1)*128)/32)+1;
                
                elec=cat(2,elec,st.elec+obj.chan(i)-1);
                
                version=get(obj.stim_popups(port,num),'value');
                
                switch version
                    case 1
                        if equal_current
                            amp=cat(2,amp,floor(st.amp/sum(fe)/0.93*127)*ones(size(st.elec)));
                        else
                            amp=cat(2,amp,127*ones(size(st.elec)));
                        end
                    case 2
                        if equal_current
                            amp=cat(2,amp,floor(st.amp/sum(fe)/1.53*75)*ones(size(st.elec)));
                        else
                            amp=cat(2,amp,floor((st.amp-0.93*fe(1))/1.53*75)*ones(size(st.elec)));
                        end
                end
            end
            
            
            stim.tl=st.tl*ones(size(elec));
            stim.dur=st.dur*ones(size(elec));
            stim.td=st.td*ones(size(elec));
            stim.freq=st.freq*ones(size(elec));
            if length(st.elec)==1
                stim.pol=st.pol*ones(size(elec));
            else
                stim.pol=repmat([st.pol,~st.pol],1,sum(fe));
            end
            
            stim.amp=amp;
            stim.elec=elec;
        end
        %%
        function MultiStimCallback(obj,src)
            if(get(src,'value'))
                set(obj.saved_list,'max',10);
                set(obj.saved_list,'min',1);
            else
                set(obj.saved_list,'max',1);
                set(obj.saved_list,'min',0);
            end
        end
        
        function saveConfig(obj)
            fid=fopen('frontend.cfg','w');
            ports={'A','B','C','D'};
            for port=1:4
                for num=1:4
                    if strcmp(get(obj.stim_popups(port,num),'visible'),'on')
                        version=get(obj.stim_popups(port,num),'val');
                        fprintf(fid,'Port%s: Micro+Stim %d\n',ports{port},version);
                    end
                end
            end
            fclose(fid);
        end
        
    end
end