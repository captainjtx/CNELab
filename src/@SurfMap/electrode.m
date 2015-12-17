function varargout = electrode(varargin)
% ELECTRODE MATLAB code for electrode.fig
%      ELECTRODE, by itself, creates a new ELECTRODE or raises the existing
%      singleton*.
%
%      H = ELECTRODE returns the handle to a new ELECTRODE or the handle to
%      the existing singleton*.
%
%      ELECTRODE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ELECTRODE.M with the given input arguments.
%
%      ELECTRODE('Property','Value',...) creates a new ELECTRODE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before electrode_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to electrode_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help electrode

% Last Modified by GUIDE v2.5 18-Sep-2015 13:50:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @electrode_OpeningFcn, ...
    'gui_OutputFcn',  @electrode_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before electrode is made visible.
function electrode_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to electrode (see VARARGIN)
set(handles.axes1,'parent',handles.uipanel3);
handles.begin=0;
% set(handles.loadBtn,'enable','off');
% set(handles.regBtn,'enable','off');
% set(handles.addBtn,'enable','off');
% set(handles.movX,'string','0');
% set(handles.movY,'string','0');
% set(handles.movZ,'string','0');
% set(handles.rotX,'string','0');
% set(handles.rotY,'string','0');
% set(handles.rotZ,'string','0');
% set(handles.adjX,'string','0');
% set(handles.adjY,'string','0');
% set(handles.adjZ,'string','0');
% set(handles.applyBtn,'enable','off');
% set(handles.attachBtn,'enable','off');
% set(handles.saveBtn,'enable','off');
% set(handles.text4,'enable','off');
% set(handles.text5,'enable','off');
% set(handles.text6,'enable','off');
% set(handles.text7,'enable','off');
% set(handles.text8,'enable','off');
% set(handles.text9,'enable','off');
% set(handles.text10,'enable','off');
% set(handles.text11,'enable','off');
% set(handles.text12,'enable','off');
% set(handles.text13,'enable','off');
% set(handles.text14,'enable','off');
% set(handles.rotX,'enable','off');
% set(handles.rotY,'enable','off');
% set(handles.rotZ,'enable','off');
% set(handles.movX,'enable','off');
% set(handles.movY,'enable','off');
% set(handles.movZ,'enable','off');
% set(handles.adjX,'enable','off');
% set(handles.adjY,'enable','off');
% set(handles.adjZ,'enable','off');
% set(handles.movx_up,'enable','off');
% set(handles.movy_up,'enable','off');
% set(handles.movz_up,'enable','off');
% set(handles.movx_down,'enable','off');
% set(handles.movy_down,'enable','off');
% set(handles.movz_down,'enable','off');
% set(handles.rotx_up,'enable','off');
% set(handles.roty_up,'enable','off');
% set(handles.rotz_up,'enable','off');
% set(handles.rotx_down,'enable','off');
% set(handles.roty_down,'enable','off');
% set(handles.rotz_down,'enable','off');
%
% set(handles.adjx_up,'enable','off');
% set(handles.adjy_up,'enable','off');
% set(handles.adjz_up,'enable','off');
% set(handles.adjx_down,'enable','off');
% set(handles.adjy_down,'enable','off');
% set(handles.adjz_down,'enable','off');
% set(handles.scale_up,'enable','off');
% set(handles.scale_down,'enable','off');

handles.overlay=0;
handles.electrode.coor=[];
handles.electrode.col=[];
handles.electrode.marker=[];
handles.curr_coor=[];
handles.ini_coor=[];
handles.elec_no=0;
handles.alpha=0.85;
handles.smooth=0;
handles.elec_index=0;
set(handles.view_check,'value',0);
set(handles.alpha_slider,'value',0.85,'visible','off');
set(handles.smooth_slider,'value',0,'visible','off');
%handles.d=dialog('Position',[300 300 250 50],'name','Status');
%handles.info=uicontrol('parent',handles.d,'style','text','position',[20 80 210 40],'string','');
%load('color.mat');
set(handles.text11,'visible','on');
handles.color=[0 0 1];
handles.axes1;
cla;
% Choose default command line output for electrode
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes electrode wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = electrode_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in openBtn.
function openBtn_Callback(hObject, eventdata, handles)
% hObject    handle to openBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%load('colin27.mat');handles.model=hc;
%load('colin27_aseg.mat');handles.model2=hi;
%load('TCH.mat');handles.model=h2;
%load('TK2.mat');handles.model=hi;
%load('ct_pt5_re.mat');handles.model2=hi;

[filename,pathname]=uigetfile({'*.*','Data format (*.mat,*.dfs,*.surf)'},'Please select surface data');
fpath=[pathname filename];
if filename==0
    return;
end
handles.overlay=handles.overlay+1;
handles.curr_model=handles.overlay;

type=fpath(end-2:end);
set(handles.info,'string','Loading...');
if strcmp(type, 'mat')
    load(fpath);
    try
        handles.model(handles.overlay).faces=faces;
        handles.model(handles.overlay).vertices=vertices;
    catch
        errordlg('Unrecognized data.', 'Wrong data format');
        set(handles.info,'string','');
        return;
    end
elseif strcmp(type, 'dfs') 
    
    set(handles.info,'string','Reading surface data...');
    [NFV,hdr]=readdfs(fpath);
    temp=patch('faces',NFV.faces,'vertices',NFV.vertices);
    
set(handles.info,'string','Reducing mesh...');
%     if size(NFV.vertices,1)>200000
%         model=reducepatch(temp,0.3);
%     elseif size(NFV.vertices,1)>1000000
%             model=reducepatch(temp,0.5);
%     else
        model.vertices=get(temp,'vertices');
        model.faces=get(temp,'faces');
%    end
    delete(temp);
    handles.model(handles.overlay).faces=model.faces;
    handles.model(handles.overlay).vertices=model.vertices;
else
    try
        set(handles.info,'string','Reading surface data...');
        [hi.vertices, hi.faces] = freesurfer_read_surf(fpath);
        temp=patch('faces',hi.faces,'vertices',hi.vertices);
        set(handles.info,'string','Reducing mesh...');
        if size(hi.vertices,1)>2000000
            model=reducepatch(temp,0.1);
        elseif size(hi.vertices,1)>1000000
            model=reducepatch(temp,0.5);
        else
            model.vertices=get(temp,'Vertices');
            model.faces=get(temp,'Faces');
        end
        delete(temp);
        handles.model(handles.overlay).faces=model.faces;
        handles.model(handles.overlay).vertices=model.vertices;
    catch
        errordlg('Unrecognized data.', 'Wrong data format');
        set(handles.info,'string','');
        return;
    end
end
handles.axes1;

handles.head_plot(handles.overlay)=patch('faces',handles.model(handles.overlay).faces,'vertices',handles.model(handles.overlay).vertices,...
    'edgecolor','none','facecolor',[0.85 0.85 0.85],'clipping','on',...
    'facealpha',0.85,'BackfaceLighting', 'lit', ...
    'AmbientStrength',  0.5, ...
    'DiffuseStrength',  0.5, ...
    'SpecularStrength', 0.2, ...
    'SpecularExponent', 1, ...
    'SpecularColorReflectance', 0.5, ...
    'FaceLighting',     'gouraud', ...
    'EdgeLighting',     'gouraud');
%view(3);
rotate3d on;
hold on
if handles.begin==0
    light('position',[-200,0,0],'style','infinite');
    lighting('gouraud');
%     camlight; daspect([1,1,1]);
end
axis vis3d
%set(gca,'xlim',[min(handles.model(1).vertices(:)) max(handles.model(1).vertices(:))],'clipping','on')
handles.head_center=[mean(handles.model(1).vertices(:,1)) mean(handles.model(1).vertices(:,2))...
    (max(handles.model(1).vertices(:,3))-min(handles.model(1).vertices(:,3)))/3+...
    min(handles.model(1).vertices(:,3))];
[az, el]=view(gca);
handles.display_view=[az el];
setappdata(gcf,'view',[az el]);
set(handles.alpha_slider,'visible','on','value',0.85);
set(handles.text11,'visible','on','enable','on');
handles.alpha(handles.overlay)=0.85;
set(handles.smooth_slider,'visible','on','value',0);
set(handles.text15,'visible','on');
handles.smooth(handles.overlay)=0;
%hold on
set(handles.loadBtn,'enable','on');
set(handles.regBtn,'enable','on');
set(handles.addBtn,'enable','on');
for i=1:handles.overlay
    list{i}=strcat('Surface',' ',num2str(i));
end
set(handles.surf_list,'string',list,'visible','on','value',handles.curr_model);
set(handles.col_surf_Btn,'visible','on');
set(handles.del_surf_Btn,'visible','on');
set(handles.gen_outer_Btn,'visible','on');
set(handles.export_Btn,'visible','on');
set(handles.selBtn,'enable','on');
handles.begin=1;

set(handles.show_ct_check,'visible','on');
set(handles.info,'string','');
guidata(hObject, handles);



% --- Executes on button press in addBtn.
function addBtn_Callback(hObject, eventdata, handles)
% hObject    handle to addBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
status=get(handles.applyBtn,'enable');
if strcmp(status,'on')==1
    if handles.elec_no==0
        delete(handles.curr_elec.top);
        delete(handles.curr_elec.side);
        delete(handles.curr_elec.stick);
    else
        set(handles.curr_elec.top,'vertices',handles.position_bak.top);
        set(handles.curr_elec.side,'vertices',handles.position_bak.side);
        set(handles.curr_elec.stick,'vertices',handles.position_bak.stick);
    end
end
try
%     set(handles.label,'visible','off');
catch
end
varargout=new_electrode;
handles.ini_coor=varargout{1};
handles.curr_coor=varargout{1};
handles.color=varargout{3};%current color
handles.markersize=varargout{2};%current size
handles.type=varargout{2};
x=handles.ini_coor(:,1);
y=handles.ini_coor(:,2);
z=handles.ini_coor(:,3);

contact_size=1;
[side,top,stick]=scatter3d(handles.curr_coor(:,1),handles.curr_coor(:,2),...
    handles.curr_coor(:,3),handles.color,contact_size,1,handles.type,0);%get the electrode handles
handles.curr_elec.side=patch('faces',side.faces,'vertices',...
    side.vertices,'edgecolor','none','facecolor',handles.color,'facelighting',...
    'gouraud');

handles.curr_elec.top=patch('faces',top.faces,'vertices',...
    top.vertices,'edgecolor','none','facecolor',handles.color,'facelighting',...
    'gouraud',...
    'DiffuseStrength',  0.5, ...
    'SpecularStrength', 0.2, ...
    'SpecularColorReflectance', 0.4);
try
%     set(handles.label,'position',[x(1)-3 y(1)-3 z(1)+3],'visible','off');
catch
%     handles.label=text(x(1)-3,y(1)-3,z(1)+3,'C1','fontsize',12,'color',[0 0 0]) ;
end
if ~isempty(stick)
    handles.curr_elec.stick=patch('faces',stick.faces,'vertices',...
        stick.vertices,'edgecolor','none','facecolor',[0 0 0],'facealpha',0.3,'facelighting',...
        'gouraud');
else
    handles.curr_elec.stick=[];
end
handles.self_center=[mean(x) mean(y) mean(z)];
set(handles.movX,'string','0');
set(handles.movY,'string','0');
set(handles.movZ,'string','0');
set(handles.rotX,'string','0');
set(handles.rotY,'string','0');
set(handles.rotZ,'string','0');
set(handles.adjX,'string','0');
set(handles.adjY,'string','0');
set(handles.adjZ,'string','0');
set(handles.applyBtn,'enable','on');
set(handles.attachBtn,'enable','on');
set(handles.saveBtn,'enable','on');
set(handles.cancelBtn,'enable','on');
set(handles.text4,'enable','on');
set(handles.text5,'enable','on');
set(handles.text6,'enable','on');
set(handles.text7,'enable','on');
set(handles.text8,'enable','on');
set(handles.text9,'enable','on');
set(handles.text10,'enable','on');
set(handles.text12,'enable','on');
set(handles.text13,'enable','on');
set(handles.text14,'enable','on');
set(handles.rotX,'enable','on');
set(handles.rotY,'enable','on');
set(handles.rotZ,'enable','on');
set(handles.movX,'enable','on');
set(handles.movY,'enable','on');
set(handles.movZ,'enable','on');
set(handles.adjX,'enable','on');
set(handles.adjY,'enable','on');
set(handles.adjZ,'enable','on');
set(handles.movx_up,'enable','on');
set(handles.movy_up,'enable','on');
set(handles.movz_up,'enable','on');
set(handles.movx_down,'enable','on');
set(handles.movy_down,'enable','on');
set(handles.movz_down,'enable','on');
set(handles.rotx_up,'enable','on');
set(handles.roty_up,'enable','on');
set(handles.rotz_up,'enable','on');
set(handles.rotx_down,'enable','on');
set(handles.roty_down,'enable','on');
set(handles.rotz_down,'enable','on');

set(handles.adjx_up,'enable','on');
set(handles.adjy_up,'enable','on');
set(handles.adjz_up,'enable','on');
set(handles.adjx_down,'enable','on');
set(handles.adjy_down,'enable','on');
set(handles.adjz_down,'enable','on');
set(handles.scale_up,'enable','on');
set(handles.scale_down,'enable','on');
set(handles.mappingBtn,'visible','on');
set(handles.del_elec_Btn,'visible','on');
set(handles.duplicateBtn,'visible','on');
set(handles.contact_Btn,'visible','on');
set(handles.col_map_popup,'visible','on','string',{'Jet' 'Hot' 'Cool'...
    'Spring' 'Summer' 'Autumn' 'Winter' 'Gray' 'Copper'},'value',1);
set(handles.style_popup,'visible','on','value',1);
handles.elec_index=0;
set(handles.info,'string','Use ''Apply''');
guidata(hObject, handles);

% --- Executes on button press in applyBtn.
function applyBtn_Callback(hObject, eventdata, handles)
handles.ini_coor=handles.curr_coor;
set(handles.movX,'string','0');
set(handles.movY,'string','0');
set(handles.movZ,'string','0');
set(handles.rotX,'string','0');
set(handles.rotY,'string','0');
set(handles.rotZ,'string','0');
set(handles.adjX,'string','0');
set(handles.adjY,'string','0');
set(handles.adjZ,'string','0');

if handles.elec_index==0 %new added electrode!!
    handles.elec_no=handles.elec_no+1;
    handles.elec_index=handles.elec_no; %further operations will be done on the current saved electrode;
end
ele_id=handles.elec_index;
handles.electrode(ele_id).coor=handles.curr_coor;
handles.electrode(ele_id).col=handles.color;
%handles.electrode.marker{ele_no}=handles.markersize;
handles.electrode(ele_id).side=get(handles.curr_elec.side);
handles.electrode(ele_id).top=get(handles.curr_elec.top);

%handles.elec_bak.top=handles.curr_elec.top;
handles.position_bak.side=get(handles.curr_elec.side,'vertices');
handles.position_bak.top=get(handles.curr_elec.top,'vertices');
try
    handles.position_bak.stick=get(handles.curr_elec.stick,'vertices');
catch
    handles.position_bak.stick=[];
end
handles.position_bak.coor=handles.curr_coor;

if ~isempty(handles.curr_elec.stick)
    handles.electrode(ele_id).stick=get(handles.curr_elec.stick);
else
    handles.electrode(ele_id).stick=[];
end
% handles.electrode(ele_id).H{3}=handles.curr_elec.stick;  %save the handles!!
%setappdata('gcf','electrode',handles.curr_coor);
for i=1:handles.elec_no
    coor{i}=handles.electrode(i).coor;
end
assignin ('base','location',coor);
for i=1:handles.elec_no
    list{i}=strcat('Electrode',' ',num2str(i));
end
set(handles.elec_list,'string',list,'enable','on','value',handles.elec_index);
set(hObject,'enable','off');
set(handles.info,'string','Applied');pause(2);
set(handles.info,'string','');
guidata(hObject, handles);



function movX_Callback(hObject, eventdata, handles)
% hObject    handle to movX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of movX as text
%        str2double(get(hObject,'String')) returns contents of movX as a double


% --- Executes during object creation, after setting all properties.
function movX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white','enable','off');
end



function movY_Callback(hObject, eventdata, handles)
% hObject    handle to movY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of movY as text
%        str2double(get(hObject,'String')) returns contents of movY as a double


% --- Executes during object creation, after setting all properties.
function movY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white','enable','off');
end



function movZ_Callback(hObject, eventdata, handles)
% hObject    handle to movZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of movZ as text
%        str2double(get(hObject,'String')) returns contents of movZ as a double


% --- Executes during object creation, after setting all properties.
function movZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white','enable','off');
end



function rotX_Callback(hObject, eventdata, handles)
% hObject    handle to rotX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rotX as text
%        str2double(get(hObject,'String')) returns contents of rotX as a double


% --- Executes during object creation, after setting all properties.
function rotX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white','enable','off');
end



function rotY_Callback(hObject, eventdata, handles)
% hObject    handle to rotY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rotY as text
%        str2double(get(hObject,'String')) returns contents of rotY as a double


% --- Executes during object creation, after setting all properties.
function rotY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white','enable','off');
end



function rotZ_Callback(hObject, eventdata, handles)
% hObject    handle to rotZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rotZ as text
%        str2double(get(hObject,'String')) returns contents of rotZ as a double


% --- Executes during object creation, after setting all properties.
function rotZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white','enable','off');
end



function adjX_Callback(hObject, eventdata, handles)
% hObject    handle to adjX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of adjX as text
%        str2double(get(hObject,'String')) returns contents of adjX as a double


% --- Executes during object creation, after setting all properties.
function adjX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to adjX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white','enable','off');
end



function adjY_Callback(hObject, eventdata, handles)
% hObject    handle to adjY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of adjY as text
%        str2double(get(hObject,'String')) returns contents of adjY as a double


% --- Executes during object creation, after setting all properties.
function adjY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to adjY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white','enable','off');
end



function adjZ_Callback(hObject, eventdata, handles)
% hObject    handle to adjZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of adjZ as text
%        str2double(get(hObject,'String')) returns contents of adjZ as a double


% --- Executes during object creation, after setting all properties.
function adjZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to adjZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white','enable','off');
end


% --- Executes on button press in view_check.
function view_check_Callback(hObject, eventdata, handles)
% hObject    handle to view_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of view_check
keep_view=get(hObject,'Value');
switch keep_view
    case 1
        [az, el]=view(gca);
        handles.display_view=[az el];
        setappdata(gcf,'view',[az el]);
        rotate3d off
        %set(gcf,'KeyPressFcn',@keyboard2_Callback);
        %set(gcf,'KeyPressFcn',{@select2,handles.cluster.label(handles.display_feature),handles.cluster.index});
    case 0
        %set(gcf,'KeyPressFcn','');
        rotate3d on
end
guidata(hObject, handles);


% --- Executes on button press in movx_down.
function movx_up_Callback(hObject, eventdata, handles)
% hObject    handle to movx_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.applyBtn,'enable','on');
v=get(handles.curr_elec.top,'vertices');
v(:,1)=v(:,1)+5;
set(handles.curr_elec.top,'vertices',v);
v=get(handles.curr_elec.side,'vertices');
v(:,1)=v(:,1)+5;
set(handles.curr_elec.side,'vertices',v);
handles.mov_x=str2double(get(handles.movX,'string'))+5;
set(handles.movX,'string',num2str(handles.mov_x));
try
    v=get(handles.curr_elec.stick,'vertices');
    v(:,1)=v(:,1)+5;
    set(handles.curr_elec.stick,'vertices',v);
catch
end
handles.curr_coor(:,1)=handles.curr_coor(:,1)+5;
p=handles.curr_coor(1,:);
% set(handles.label,'position',[p(1)-3 p(2)-3 p(3)+3]);
guidata(hObject, handles);

% --- Executes on button press in movx_up.
function movx_down_Callback(hObject, eventdata, handles)
% hObject    handle to movx_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.applyBtn,'enable','on');
v=get(handles.curr_elec.top,'vertices');
v(:,1)=v(:,1)-5;
set(handles.curr_elec.top,'vertices',v);
v=get(handles.curr_elec.side,'vertices');
v(:,1)=v(:,1)-5;
set(handles.curr_elec.side,'vertices',v);
try
    v=get(handles.curr_elec.stick,'vertices');
    v(:,1)=v(:,1)-5;
    set(handles.curr_elec.stick,'vertices',v);
catch
end
handles.mov_x=str2double(get(handles.movX,'string'))-5;
set(handles.movX,'string',num2str(handles.mov_x));

handles.curr_coor(:,1)=handles.curr_coor(:,1)-5;
p=handles.curr_coor(1,:);
% set(handles.label,'position',[p(1)-3 p(2)-3 p(3)+3])
guidata(hObject, handles);

% --- Executes on button press in movy_down.
function movy_down_Callback(hObject, eventdata, handles)
% hObject    handle to movy_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.applyBtn,'enable','on');
v=get(handles.curr_elec.top,'vertices');
v(:,2)=v(:,2)-5;
set(handles.curr_elec.top,'vertices',v);
v=get(handles.curr_elec.side,'vertices');
v(:,2)=v(:,2)-5;
set(handles.curr_elec.side,'vertices',v);
try
    v=get(handles.curr_elec.stick,'vertices');
    v(:,2)=v(:,2)-5;
    set(handles.curr_elec.stick,'vertices',v);
catch
end
handles.mov_y=str2double(get(handles.movY,'string'))-5;
set(handles.movY,'string',num2str(handles.mov_y));

handles.curr_coor(:,2)=handles.curr_coor(:,2)-5;
p=handles.curr_coor(1,:);
% set(handles.label,'position',[p(1)-3 p(2)-3 p(3)+3])
guidata(hObject, handles);

% --- Executes on button press in movy_up.
function movy_up_Callback(hObject, eventdata, handles)
% hObject    handle to movy_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.applyBtn,'enable','on');
v=get(handles.curr_elec.top,'vertices');
v(:,2)=v(:,2)+5;
set(handles.curr_elec.top,'vertices',v);
v=get(handles.curr_elec.side,'vertices');
v(:,2)=v(:,2)+5;
set(handles.curr_elec.side,'vertices',v);
try
    v=get(handles.curr_elec.stick,'vertices');
    v(:,2)=v(:,2)+5;
    set(handles.curr_elec.stick,'vertices',v);
catch
end
handles.mov_y=str2double(get(handles.movY,'string'))+5;
set(handles.movY,'string',num2str(handles.mov_y));

handles.curr_coor(:,2)=handles.curr_coor(:,2)+5;
p=handles.curr_coor(1,:);
% set(handles.label,'position',[p(1)-3 p(2)-3 p(3)+3])
guidata(hObject, handles);

% --- Executes on button press in movz_down.
function movz_down_Callback(hObject, eventdata, handles)
% hObject    handle to movz_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.applyBtn,'enable','on');
v=get(handles.curr_elec.top,'vertices');
v(:,3)=v(:,3)-5;
set(handles.curr_elec.top,'vertices',v);
v=get(handles.curr_elec.side,'vertices');
v(:,3)=v(:,3)-5;
set(handles.curr_elec.side,'vertices',v);
try
    v=get(handles.curr_elec.stick,'vertices');
    v(:,3)=v(:,3)-5;
    set(handles.curr_elec.stick,'vertices',v);
catch
end
handles.mov_z=str2double(get(handles.movZ,'string'))-5;
set(handles.movZ,'string',num2str(handles.mov_z));

handles.curr_coor(:,3)=handles.curr_coor(:,3)-5;
p=handles.curr_coor(1,:);
% set(handles.label,'position',[p(1)-3 p(2)-3 p(3)+3])
guidata(hObject, handles);

% --- Executes on button press in movz_up.
function movz_up_Callback(hObject, eventdata, handles)
% hObject    handle to movz_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set(handles.curr_elec.top,'ZData',get(handles.curr_elec.top,'ZData')+5);
% set(handles.curr_elec.side,'ZData',get(handles.curr_elec.side,'ZData')+5);
set(handles.applyBtn,'enable','on');
v=get(handles.curr_elec.top,'vertices');
v(:,3)=v(:,3)+5;
set(handles.curr_elec.top,'vertices',v);
v=get(handles.curr_elec.side,'vertices');
v(:,3)=v(:,3)+5;
set(handles.curr_elec.side,'vertices',v);
try
    v=get(handles.curr_elec.stick,'vertices');
    v(:,3)=v(:,3)+5;
    set(handles.curr_elec.stick,'vertices',v);
catch
end

handles.mov_z=str2double(get(handles.movZ,'string'))+5;
set(handles.movZ,'string',num2str(handles.mov_z));

handles.curr_coor(:,3)=handles.curr_coor(:,3)+5;
p=handles.curr_coor(1,:);
% set(handles.label,'position',[p(1)-3 p(2)-3 p(3)+3])
guidata(hObject, handles);

% --- Executes on button press in rotx_down.
function rotx_down_Callback(hObject, eventdata, handles)
% hObject    handle to rotx_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.applyBtn,'enable','on');
rotate(handles.curr_elec.side,[1 0 0],-5,handles.head_center);
rotate(handles.curr_elec.top,[1 0 0],-5,handles.head_center);
try
    rotate(handles.curr_elec.stick,[1 0 0],-5,handles.head_center);
catch
end

handles.rot_x=pi/(180/(str2double(get(handles.rotX,'string'))-5));
set(handles.rotX,'string',num2str(handles.rot_x*180/pi));
Pr=rot3d(handles.curr_coor,handles.head_center,[1 0 0],-5*pi/180);
handles.curr_coor=Pr;
p=handles.curr_coor(1,:);
% set(handles.label,'position',[p(1)-3 p(2)-3 p(3)+3])
guidata(hObject, handles);

% --- Executes on button press in rotx_up.
function rotx_up_Callback(hObject, eventdata, handles)
% hObject    handle to rotx_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.applyBtn,'enable','on');
rotate(handles.curr_elec.side,[1 0 0],5,handles.head_center);
rotate(handles.curr_elec.top,[1 0 0],5,handles.head_center);
try
    rotate(handles.curr_elec.stick,[1 0 0],5,handles.head_center);
catch
end

handles.rot_x=pi/(180/(str2double(get(handles.rotX,'string'))+5));
set(handles.rotX,'string',num2str(handles.rot_x*180/pi));
Pr=rot3d(handles.curr_coor,handles.head_center,[1 0 0],5*pi/180);
handles.curr_coor=Pr;
p=handles.curr_coor(1,:);
% set(handles.label,'position',[p(1)-3 p(2)-3 p(3)+3])
guidata(hObject, handles);



% --- Executes on button press in roty_down.
function roty_down_Callback(hObject, eventdata, handles)
% hObject    handle to roty_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.applyBtn,'enable','on');
rotate(handles.curr_elec.side,[0 1 0],-5,handles.head_center);
rotate(handles.curr_elec.top,[0 1 0],-5,handles.head_center);
try
    rotate(handles.curr_elec.stick,[0 1 0],-5,handles.head_center);
catch
end
handles.rot_y=pi/(180/(str2double(get(handles.rotY,'string'))-5));
set(handles.rotY,'string',num2str(handles.rot_y*180/pi));
Pr=rot3d(handles.curr_coor,handles.head_center,[0 1 0],-5*pi/180);
handles.curr_coor=Pr;
p=handles.curr_coor(1,:);
% set(handles.label,'position',[p(1)-3 p(2)-3 p(3)+3])
guidata(hObject, handles);

% --- Executes on button press in roty_up.
function roty_up_Callback(hObject, eventdata, handles)
% hObject    handle to roty_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.applyBtn,'enable','on');
rotate(handles.curr_elec.side,[0 1 0],5,handles.head_center);
rotate(handles.curr_elec.top,[0 1 0],5,handles.head_center);
try
    rotate(handles.curr_elec.stick,[0 1 0],5,handles.head_center);
catch
end

handles.rot_y=pi/(180/(str2double(get(handles.rotY,'string'))+5));
set(handles.rotY,'string',num2str(handles.rot_y*180/pi));
Pr=rot3d(handles.curr_coor,handles.head_center,[0 1 0],5*pi/180);
handles.curr_coor=Pr;
p=handles.curr_coor(1,:);
% set(handles.label,'position',[p(1)-3 p(2)-3 p(3)+3])
guidata(hObject, handles);

% --- Executes on button press in rotz_down.
function rotz_down_Callback(hObject, eventdata, handles)
% hObject    handle to rotz_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.applyBtn,'enable','on');
rotate(handles.curr_elec.side,[0 0 1],-5,handles.head_center);
rotate(handles.curr_elec.top,[0 0 1],-5,handles.head_center);
try
    rotate(handles.curr_elec.stick,[0 0 1],-5,handles.head_center);
catch
end

handles.rot_z=pi/(180/(str2double(get(handles.rotZ,'string'))-5));
set(handles.rotZ,'string',num2str(handles.rot_z*180/pi));
Pr=rot3d(handles.curr_coor,handles.head_center,[0 0 1],-5*pi/180);
handles.curr_coor=Pr;
p=handles.curr_coor(1,:);
% set(handles.label,'position',[p(1)-3 p(2)-3 p(3)+3])
guidata(hObject, handles);

% --- Executes on button press in rotz_up.
function rotz_up_Callback(hObject, eventdata, handles)
% hObject    handle to rotz_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.applyBtn,'enable','on');
rotate(handles.curr_elec.side,[0 0 1],5,handles.head_center);
rotate(handles.curr_elec.top,[0 0 1],5,handles.head_center);
try
    rotate(handles.curr_elec.stick,[0 0 1],5,handles.head_center);
catch
end

handles.rot_z=pi/(180/(str2double(get(handles.rotZ,'string'))+5));
set(handles.rotZ,'string',num2str(handles.rot_z*180/pi));
Pr=rot3d(handles.curr_coor,handles.head_center,[0 0 1],5*pi/180);
handles.curr_coor=Pr;
p=handles.curr_coor(1,:);
% set(handles.label,'position',[p(1)-3 p(2)-3 p(3)+3])
guidata(hObject, handles);

% --- Executes on button press in adjx_down.
function adjx_down_Callback(hObject, eventdata, handles)
% hObject    handle to adjx_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.applyBtn,'enable','on');
handles.self_center=[mean(handles.curr_coor(:,1)) ...
    mean(handles.curr_coor(:,2)) mean(handles.curr_coor(:,3))];
rotate(handles.curr_elec.side,[1 0 0],-5,handles.self_center);
rotate(handles.curr_elec.top,[1 0 0],-5,handles.self_center);
try
    rotate(handles.curr_elec.stick,[1 0 0],-5,handles.self_center);
catch
end
handles.adj_x=pi/(180/(str2double(get(handles.adjX,'string'))-5));
set(handles.adjX,'string',num2str(handles.adj_x*180/pi));
Pr=rot3d(handles.curr_coor,handles.self_center,[1 0 0],-5*pi/180);
handles.curr_coor=Pr;
p=handles.curr_coor(1,:);
% set(handles.label,'position',[p(1)-3 p(2)-3 p(3)+3])
guidata(hObject, handles);


% --- Executes on button press in adjx_up.
function adjx_up_Callback(hObject, eventdata, handles)
% hObject    handle to adjx_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.applyBtn,'enable','on');
handles.self_center=[mean(handles.curr_coor(:,1)) ...
    mean(handles.curr_coor(:,2)) mean(handles.curr_coor(:,3))];
rotate(handles.curr_elec.side,[1 0 0],5,handles.self_center);
rotate(handles.curr_elec.top,[1 0 0],5,handles.self_center);
try
    rotate(handles.curr_elec.stick,[1 0 0],5,handles.self_center);
catch
end

handles.adj_x=pi/(180/(str2double(get(handles.adjX,'string'))+5));
set(handles.adjX,'string',num2str(handles.adj_x*180/pi));
Pr=rot3d(handles.curr_coor,handles.self_center,[1 0 0],5*pi/180);
handles.curr_coor=Pr;
p=handles.curr_coor(1,:);
% set(handles.label,'position',[p(1)-3 p(2)-3 p(3)+3])
guidata(hObject, handles);

% --- Executes on button press in adjy_down.
function adjy_down_Callback(hObject, eventdata, handles)
% hObject    handle to adjy_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.applyBtn,'enable','on');
handles.self_center=[mean(handles.curr_coor(:,1)) ...
    mean(handles.curr_coor(:,2)) mean(handles.curr_coor(:,3))];
rotate(handles.curr_elec.side,[0 1 0],-5,handles.self_center);
rotate(handles.curr_elec.top,[0 1 0],-5,handles.self_center);
try
    rotate(handles.curr_elec.stick,[0 1 0],-5,handles.self_center);
catch
end

handles.adj_y=pi/(180/(str2double(get(handles.adjY,'string'))-5));
set(handles.adjY,'string',num2str(handles.adj_y*180/pi));
Pr=rot3d(handles.curr_coor,handles.self_center,[0 1 0],-5*pi/180);
handles.curr_coor=Pr;
p=handles.curr_coor(1,:);
% set(handles.label,'position',[p(1)-3 p(2)-3 p(3)+3])
guidata(hObject, handles);

% --- Executes on button press in adjy_up.
function adjy_up_Callback(hObject, eventdata, handles)
% hObject    handle to adjy_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.applyBtn,'enable','on');
handles.self_center=[mean(handles.curr_coor(:,1)) ...
    mean(handles.curr_coor(:,2)) mean(handles.curr_coor(:,3))];
rotate(handles.curr_elec.side,[0 1 0],5,handles.self_center);
rotate(handles.curr_elec.top,[0 1 0],5,handles.self_center);
try
    rotate(handles.curr_elec.stick,[0 1 0],5,handles.self_center);
catch
end

handles.adj_y=pi/(180/(str2double(get(handles.adjY,'string'))+5));
set(handles.adjY,'string',num2str(handles.adj_y*180/pi));
Pr=rot3d(handles.curr_coor,handles.self_center,[0 1 0],5*pi/180);
handles.curr_coor=Pr;
p=handles.curr_coor(1,:);
% set(handles.label,'position',[p(1)-3 p(2)-3 p(3)+3])
guidata(hObject, handles);

% --- Executes on button press in adjz_down.
function adjz_down_Callback(hObject, eventdata, handles)
% hObject    handle to adjz_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.applyBtn,'enable','on');

handles.self_center=[mean(handles.curr_coor(:,1)) ...
    mean(handles.curr_coor(:,2)) mean(handles.curr_coor(:,3))];
rotate(handles.curr_elec.side,[0 0 1],-5,handles.self_center);
rotate(handles.curr_elec.top,[0 0 1],-5,handles.self_center);
try
    rotate(handles.curr_elec.stick,[0 0 1],-5,handles.self_center);
catch
end

handles.adj_z=pi/(180/(str2double(get(handles.adjZ,'string'))-5));
set(handles.adjZ,'string',num2str(handles.adj_z*180/pi));
Pr=rot3d(handles.curr_coor,handles.self_center,[0 0 1],-5*pi/180);
handles.curr_coor=Pr;
p=handles.curr_coor(1,:);
% set(handles.label,'position',[p(1)-3 p(2)-3 p(3)+3])
guidata(hObject, handles);

% --- Executes on button press in adjz_up.
function adjz_up_Callback(hObject, eventdata, handles)
% hObject    handle to adjz_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.applyBtn,'enable','on');
handles.self_center=[mean(handles.curr_coor(:,1)) ...
    mean(handles.curr_coor(:,2)) mean(handles.curr_coor(:,3))];
rotate(handles.curr_elec.side,[0 0 1],5,handles.self_center);
rotate(handles.curr_elec.top,[0 0 1],5,handles.self_center);
try
    rotate(handles.curr_elec.stick,[0 0 1],5,handles.self_center);
catch
end

handles.adj_z=pi/(180/(str2double(get(handles.adjZ,'string'))+5));
set(handles.adjZ,'string',num2str(handles.adj_z*180/pi));
Pr=rot3d(handles.curr_coor,handles.self_center,[0 0 1],5*pi/180);
handles.curr_coor=Pr;
p=handles.curr_coor(1,:);
% set(handles.label,'position',[p(1)-3 p(2)-3 p(3)+3])
guidata(hObject, handles);


% --- Executes on button press in scale_down.
function scale_down_Callback(hObject, eventdata, handles)
% hObject    handle to scale_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.applyBtn,'enable','on');
handles.self_center=mean(handles.curr_coor);
c0=handles.self_center;
coor=handles.curr_coor/1.1;
c1=mean(coor);
shift=repmat(c1-c0,size(handles.curr_coor,1),1);
handles.curr_coor=coor-shift;

v=get(handles.curr_elec.top,'vertices');
v=v/1.1;
shift=repmat(c1-c0,size(v,1),1);
v=v-shift;
set(handles.curr_elec.top,'vertices',v);

v=get(handles.curr_elec.side,'vertices');
v=v/1.1;
shift=repmat(c1-c0,size(v,1),1);
v=v-shift;
set(handles.curr_elec.side,'vertices',v);

if ~isempty(handles.curr_elec.stick)
    v=get(handles.curr_elec.stick,'vertices');
    v=v/1.1;
    shift=repmat(c1-c0,size(v,1),1);
    v=v-shift;
    set(handles.curr_elec.stick,'vertices',v);
end
p=handles.curr_coor(1,:);
% set(handles.label,'position',[p(1)-3 p(2)-3 p(3)+3])
guidata(hObject, handles);

% --- Executes on button press in scale_up.
function scale_up_Callback(hObject, eventdata, handles)
% hObject    handle to scale_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.applyBtn,'enable','on');
handles.self_center=mean(handles.curr_coor);
c0=handles.self_center;
coor=handles.curr_coor*1.1;
c1=mean(coor);
shift=repmat(c1-c0,size(handles.curr_coor,1),1);
handles.curr_coor=coor-shift;

v=get(handles.curr_elec.top,'vertices');
v=v*1.1;
shift=repmat(c1-c0,size(v,1),1);
v=v-shift;
set(handles.curr_elec.top,'vertices',v);

v=get(handles.curr_elec.side,'vertices');
v=v*1.1;
shift=repmat(c1-c0,size(v,1),1);
v=v-shift;
set(handles.curr_elec.side,'vertices',v);

if ~isempty(handles.curr_elec.stick)
    v=get(handles.curr_elec.stick,'vertices');
    v=v*1.1;
    shift=repmat(c1-c0,size(v,1),1);
    v=v-shift;
    set(handles.curr_elec.stick,'vertices',v);
end
p=handles.curr_coor(1,:);
% set(handles.label,'position',[p(1)-3 p(2)-3 p(3)+3])
guidata(hObject, handles);


% --- Executes on button press in saveBtn.
function saveBtn_Callback(hObject, eventdata, handles)
% hObject    handle to saveBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
electrode_information=handles.electrode;
uisave('electrode_information');
set(handles.info,'string','Current electrodes saved');pause(2);
set(handles.info,'string','');
guidata(hObject,handles);

% --- Executes on slider movement.
function alpha_slider_Callback(hObject, eventdata, handles)
% hObject    handle to alpha_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.alpha(handles.curr_model)=get(hObject,'Value');
handles.axes1;
set(handles.head_plot(handles.curr_model),'facealpha',handles.alpha(handles.curr_model));
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function alpha_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in loadBtn.
function loadBtn_Callback(hObject, eventdata, handles)
% hObject    handle to loadBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile({'*.mat;*.txt','Data format (*.mat)'},'Please select file');
fpath=[pathname filename];
if isempty(fpath)
    return;
end
load(fpath);
handles.electrode=electrode_information;
for i=1:length(handles.electrode)
    handles.curr_elec.side=patch('faces',handles.electrode(i).side.Faces,...
        'vertices',handles.electrode(i).side.Vertices,...
        'facecolor',handles.electrode(i).col,'edgecolor','none');
    handles.curr_elec.top=patch('faces',handles.electrode(i).top.Faces,...
        'vertices',handles.electrode(i).top.Vertices,...
        'facecolor',handles.electrode(i).col,'edgecolor','none');
    if ~isempty(handles.electrode(i).stick)
        handles.curr_elec.stick=patch('faces',handles.electrode(i).stick.Faces,...
            'vertices',handles.electrode(i).stick.Vertices,...
            'facecolor',[0 0 0],'edgecolor','none','facealpha',0.3);
    else
        handles.curr_elec.stick=[];
    end
    %     scatter3d(handles.electrode.coor{i}(:,1),handles.electrode.coor{i}(:,2),...
    %         handles.electrode.coor{i}(:,3),...
    %       handles.electrode.col{i},handles.electrode.marker{i},0.5);
    %  hold on
end
axis vis3d
handles.elec_no=length(handles.electrode);
handles.elec_index=handles.elec_no;
for i=1:handles.elec_no
    list{i}=strcat('Electrode',' ',num2str(i));
end
set(handles.elec_list,'string',list,'enable','on','value',handles.elec_index);
ele_id=handles.elec_index;
handles.curr_coor=handles.electrode(ele_id).coor;
handles.color=handles.electrode(ele_id).col;
x=handles.curr_coor(:,1);y=handles.curr_coor(:,2);z=handles.curr_coor(:,3);
try
%     set(handles.label,'position',[x(1)-3 y(1)-3 z(1)+3],'visible','on');
catch
%     handles.label=text(x(1)-3,y(1)-3,z(1)+3,'C1','fontsize',12,'color',[0 0 0]) ;
end

% handles.curr_elec.side=handles.electrode(ele_id).H(2);
% handles.curr_elec.top=handles.electrode(ele_id).H(1);
% handles.curr_elec.stick=handles.electrode(ele_id).H(3);
set(handles.movX,'string','0');
set(handles.movY,'string','0');
set(handles.movZ,'string','0');
set(handles.rotX,'string','0');
set(handles.rotY,'string','0');
set(handles.rotZ,'string','0');
set(handles.adjX,'string','0');
set(handles.adjY,'string','0');
set(handles.adjZ,'string','0');
%set(handles.applyBtn,'enable','on');
set(handles.attachBtn,'enable','on');
set(handles.saveBtn,'enable','on');
set(handles.text4,'enable','on');
set(handles.text5,'enable','on');
set(handles.text6,'enable','on');
set(handles.text7,'enable','on');
set(handles.text8,'enable','on');
set(handles.text9,'enable','on');
set(handles.text10,'enable','on');
set(handles.text11,'enable','on');
set(handles.text12,'enable','on');
set(handles.text13,'enable','on');
set(handles.text14,'enable','on');
set(handles.rotX,'enable','on');
set(handles.rotY,'enable','on');
set(handles.rotZ,'enable','on');
set(handles.movX,'enable','on');
set(handles.movY,'enable','on');
set(handles.movZ,'enable','on');
set(handles.adjX,'enable','on');
set(handles.adjY,'enable','on');
set(handles.adjZ,'enable','on');
set(handles.movx_up,'enable','on');
set(handles.movy_up,'enable','on');
set(handles.movz_up,'enable','on');
set(handles.movx_down,'enable','on');
set(handles.movy_down,'enable','on');
set(handles.movz_down,'enable','on');
set(handles.rotx_up,'enable','on');
set(handles.roty_up,'enable','on');
set(handles.rotz_up,'enable','on');
set(handles.rotx_down,'enable','on');
set(handles.roty_down,'enable','on');
set(handles.rotz_down,'enable','on');

set(handles.adjx_up,'enable','on');
set(handles.adjy_up,'enable','on');
set(handles.adjz_up,'enable','on');
set(handles.adjx_down,'enable','on');
set(handles.adjy_down,'enable','on');
set(handles.adjz_down,'enable','on');
set(handles.scale_up,'enable','on');
set(handles.scale_down,'enable','on');
set(handles.mappingBtn,'visible','on');
set(handles.del_elec_Btn,'visible','on');
set(handles.duplicateBtn,'visible','on');
set(handles.contact_Btn,'visible','on');
set(handles.col_map_popup,'visible','on','string',{'Jet' 'Hot' 'Cool'...
    'Spring' 'Summer' 'Autumn' 'Winter' 'Gray' 'Copper'},'value',1);
set(handles.style_popup,'visible','on','value',1);
handles.self_center=mean(handles.curr_coor);
handles.position_bak.side=get(handles.curr_elec.side,'vertices');
handles.position_bak.top=get(handles.curr_elec.top,'vertices');
try
    handles.position_bak.stick=get(handles.curr_elec.stick,'vertices');
catch
    handles.position_bak.stick=[];
end
handles.position_bak.coor=handles.curr_coor;
guidata(hObject, handles);


% function axes1_ButtonDownFcn(hObject, eventdata, handles)
% handles=guidata(handles);
% C=get(gcf,'currentpoint');
% if C(1)>4 && C(1)<54 && C(2)>2.5 && C(2)<14
%     %set(gcf,'pointer','crosshair');
%     [pl,xd,yd]=select3('selectionMode','closest','pt',2,'Axes',handles.axes1);
% else
%     return;
% end
% for i=1:length(xd)
%     if ~isempty(xd{i})
%         x=xd{i};
%         y=yd{i};
%         break;
%     end
% end
% if x==1
%     return;
% elseif x>5
%     return;
% end
% axes(handles.axes_dist);
% try
%     plot(pl(:,1),pl(:,2),':',pl(:,1),pl(:,2),'.','color',[0.31 0.4 0.58],'linewidth',1.2,'markersize',20);
%     hold on
%     plot(x,y,'.','color',[0.75 0.05 0.05],'markersize',30);
%     hold off
%     set(gca,'color',[0.97 0.97 0.97],'ytick',[],'xtick',[],'xcolor',[0.55 0.55 0.55],'ycolor',[0.55 0.55 0.55]);
%     xlim([1 max(pl(:,1))])
%     box off
% catch
%     return;
% end
%
% if handles.action==1
%     handles.x=x;
% else
%     handles.sub_x=x;
%
% end
% guidata(hObject, handles);
% goBtn_Callback(hObject, eventdata, handles);


% --- Executes on button press in attachBtn.
function attachBtn_Callback(hObject, eventdata, handles)
% hObject    handle to attachBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Import inner skull surface?'],...
    ['Close ' get(handles.figure1,'Name') 'Events found.'],...
    'Yes','No','No');
if strcmp(selection,'No')
    %if ~isempty(getappdata(handles.figure1,'new_v'))       
    %    vertices=getappdata(handles.figure1,'new_v');
    %    handles.model(handles.curr_model).vertices=vertices;
    %else
        vertices=handles.model(handles.curr_model).vertices;
    %end
     %patch('vertices',vertices,'faces',faces,'facecolor',[1 1 0],'edgecolor','none',...
     %'facealpha',0.5);
else
    [filename,pathname]=uigetfile({'*.*','Data format (*.mat,*.dfs,*.surf)'},'Please select file');
    fpath=[pathname filename];
    if isempty(fpath)
        return;
    end
    set(handles.info,'string','Loading inner skull surface');
    type=fpath(end-2:end);
    if strcmp(type, 'mat')
        load(fpath);
    elseif strcmp(type, 'dfs')        
        [NFV,hdr]=readdfs(fpath);
        vertices=NFV.vertices;       
    else
        try
            [vertices, ~] = freesurfer_read_surf(fpath);
        catch
            errordlg('Unrecognized data.', 'Wrong data format');
            return;
        end
    end
end
v1=get(handles.curr_elec.top,'vertices');
v2=get(handles.curr_elec.side,'vertices');
set(handles.info,'string','Computing nearest vertex...');
[new_coor]=find_closest(handles.curr_coor,vertices);
[side,top,stick]=scatter3d(new_coor(:,1),new_coor(:,2),...
    new_coor(:,3),handles.color,2.5,1,5,0,handles.head_center);

set(handles.curr_elec.top,'vertices',top.vertices);
set(handles.curr_elec.side,'vertices',side.vertices);

shift=new_coor-handles.curr_coor;
s_matrix1=[];
s_matrix2=[];
N1=size(v1,1)/size(handles.curr_coor,1);
N2=size(v2,1)/size(handles.curr_coor,1);
for i=1:size(handles.curr_coor,1)
    shiftm1=repmat(shift(i,:),N1,1);
    shiftm2=repmat(shift(i,:),N2,1);
    s_matrix1=[s_matrix1;shiftm1];
    s_matrix2=[s_matrix2;shiftm2];
end
try
    v3=get(handles.curr_elec.stick,'vertices');
    N3=size(v3,1)/size(handles.curr_coor,1);
    for i=1:size(handles.curr_coor,1)
        shiftm3=repmat(shift(i,:),N3,1);
        s_matrix3=[s_matrix3;shiftm3];
    end
    set(handles.curr_elec.stick,'vertices',v3+s_matrix3);
catch
end
set(handles.curr_elec.top,'vertices',v1+s_matrix1);
set(handles.curr_elec.side,'vertices',v2+s_matrix2);
handles.curr_coor=new_coor;
set(handles.applyBtn,'enable','on')
set(handles.info,'string','Electrode attached. Use cancel to restore.');
guidata(hObject, handles);


% --- Executes on button press in regBtn.
function regBtn_Callback(hObject, eventdata, handles)
[filename,pathname]=uigetfile({'*.mat;*.nii;*.hdr','Data format (*.mat,*.nii,*.hdr)'},'Please select CT data');
fpath=[pathname filename];
if isempty(fpath)
    return;
end
set(handles.info,'string','Pre-processing data, please wait...')
[v,f]=import_ct(fpath);
%load(fpath);
%ct=hi;
ct.vertices=v;
ct.faces=f;
selection = questdlg(['Will open a new window for registration'],...
    ['CT Registration'],...
    'Yes','Directly apply','Yes');
if strcmp(selection,'Directly apply')
    %xl=get(gca,'xlim');
    handles.ct_plot=patch('faces',ct.faces,'vertices',ct.vertices,...
        'edgecolor','none','facecolor',[3 9 175]/255,...
        'facealpha',0.3);
    
    set(handles.show_ct_check,'enable','on');
    %set(gca,'xlim',xl);
else
    cortex=handles.model(handles.curr_model);
    register_ct(ct,cortex,handles);
end
%handles.ct=getappdata(handles.figure1,'ct');
guidata(hObject, handles);


% --- Executes on button press in selBtn.
function selBtn_Callback(hObject, eventdata, handles)
% hObject    handle to selBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%set(gcf,'WindowButtonUpFcn',{@selBtn_mouseUpFcn});
no=input_no;
no=str2num(no{1});
for i=1:no
    %C(i,:)=get(gcf,'currentpoint');
    [x(i),y(i),z(i)]=get_cursor(handles);
    [xs,ys,zs]=sphere(15);
    handles.S(i)=surf(xs*2+x(i),ys*2+y(i),zs*2+z(i),'facecolor',[0 1 0],...
        'LineStyle','none','facealpha',0.6);  %all the point handles
end
datacursormode off
p=[x' y' z'];
for i=1:size(p,1)
    pl{i}=num2str(p(i,:));
end
set(handles.point_list,'enable','on','string',pl);
set(handles.point_elec_Btn,'enable','on');
set(handles.del_point_Btn,'enable','on');
guidata(hObject, handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over selBtn.


function ct_display_press(hObject, eventdata, handles)
key=get(gcf,'CurrentKey');

try
    handles.ct=getappdata(handles.figure1,'ct');
    handles.ct_plot=patch('faces',handles.ct.Faces,'vertices',handles.ct.Vertices,...
        'edgecolor','none','facecolor',[3 9 175]/255,...
        'facealpha',0.2);
catch
end
guidata(hObject, handles);


% --- Executes on selection change in elec_list.
function elec_list_Callback(hObject, eventdata, handles)
% hObject    handle to elec_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pre=handles.elec_index;
if pre==get(hObject,'Value')
    return;
end
status=get(handles.applyBtn,'enable');
if strcmp(status,'on')==1
    set(handles.curr_elec.side,'Vertices',handles.position_bak.side);
    set(handles.curr_elec.top,'Vertices',handles.position_bak.top);
    if ~isempty(handles.position_bak.stick)
        set(handles.curr_elec.stick,'Vertices',handles.position_bak.stick);
    end
end

handles.elec_index=get(hObject,'Value');
ele_id=handles.elec_index;
handles.curr_coor=handles.electrode(ele_id).coor;
handles.color=handles.electrode(ele_id).col;
handles.curr_elec.side=findobj('vertices',handles.electrode(ele_id).side.Vertices);
handles.curr_elec.top=findobj('vertices',handles.electrode(ele_id).top.Vertices);

if ~isempty(handles.electrode(ele_id).stick)
    handles.curr_elec.stick=findobj('vertices',handles.electrode(ele_id).stick.Vertices);
    handles.position_bak.stick=get(handles.curr_elec.stick,'vertices');
    %             handles.curr_elec.stick=patch('faces',handles.electrode(ele_id).stick.Faces,...
    %             'vertices',handles.electrode(ele_id).stick.Vertices,...
    %             'facecolor',[0 0 0],'edgecolor','none','facealpha',0.3);
else
    handles.curr_elec.stick=[];
    handles.position_bak.stick=[];
end
handles.position_bak.side=get(handles.curr_elec.side,'vertices');
handles.position_bak.top=get(handles.curr_elec.top,'vertices');
handles.position_bak.coor=handles.curr_coor;
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns elec_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from elec_list


% --- Executes during object creation, after setting all properties.
function elec_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elec_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cancelBtn.
function cancelBtn_Callback(hObject, eventdata, handles)
% hObject    handle to cancelBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
status=get(handles.applyBtn,'enable');
if strcmp(status,'on')==1
    set(handles.curr_elec.side,'Vertices',handles.position_bak.side);
    set(handles.curr_elec.top,'Vertices',handles.position_bak.top);
    handles.curr_coor=handles.position_bak.coor;
    if ~isempty(handles.position_bak.stick)
        set(handles.curr_elec.stick,'Vertices',handles.position_bak.stick);
    end
else
    return;
end
set(handles.info,'string','Position restored');pause(2);
set(handles.info,'string','');
guidata(hObject, handles);
% --- Executes on slider movement.
function smooth_slider_Callback(hObject, eventdata, handles)
% hObject    handle to smooth_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.smooth(handles.curr_model)=get(hObject,'Value');
if ~isempty(getappdata(handles.figure1,'new_v'))      
        vertices=getappdata(handles.figure1,'new_v');
        handles.model(handles.curr_model).vertices=vertices;
end
[v, f] = smoothMesh(handles.model(handles.curr_model).vertices,...
    handles.model(handles.curr_model).faces,handles.smooth(handles.curr_model)*50);
set(handles.head_plot(handles.curr_model),'faces',f);
set(handles.head_plot(handles.curr_model),'vertices',v);
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function smooth_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smooth_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in surf_list.
function surf_list_Callback(hObject, eventdata, handles)
% hObject    handle to surf_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.curr_model=get(hObject,'Value');
set(handles.alpha_slider,'value',handles.alpha(handles.curr_model));
set(handles.smooth_slider,'value',handles.smooth(handles.curr_model));
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns surf_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from surf_list


% --- Executes during object creation, after setting all properties.
function surf_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to surf_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in del_surf_Btn.
function del_surf_Btn_Callback(hObject, eventdata, handles)
% hObject    handle to del_surf_Btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.head_plot(handles.curr_model));
handles.head_plot(handles.curr_model)=[];
handles.overlay=handles.overlay-1;
if handles.curr_model~=1
    handles.curr_model=handles.curr_model-1;
end
if handles.overlay==0
    set(handles.show_ct_check,'visible','off');
    set(handles.alpha_slider,'visible','off');
    set(handles.smooth_slider,'visible','off');
    set(handles.col_surf_Btn,'visible','off');
    set(handles.del_surf_Btn,'visible','off');
    set(handles.gen_outer_Btn,'visible','off');
    set(handles.export_Btn,'visible','off');
    set(handles.surf_list,'visible','off');
    set(handles.text11,'visible','off');
    set(handles.text15,'visible','off');
else  
    set(handles.alpha_slider,'value',handles.alpha(handles.curr_model));
    set(handles.smooth_slider,'value',handles.smooth(handles.curr_model));
    for i=1:handles.overlay
        list{i}=strcat('Surface',' ',num2str(i));
    end
    set(handles.surf_list,'string',list,'value',handles.curr_model);
end
guidata(hObject, handles);


% --- Executes on button press in col_surf_Btn.
function col_surf_Btn_Callback(hObject, eventdata, handles)
% hObject    handle to col_surf_Btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
saveas(handles.axes1,'test','tiff');


% --- Executes on button press in gen_outer_Btn.
function gen_outer_Btn_Callback(hObject, eventdata, handles)
% hObject    handle to gen_outer_Btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% txt=textprogressbar('calculating outputs: ');
% for i=1:100,
%     textprogressbar(i);
%     pause(0.1);
% end
% textprogressbar('done');
if ~isempty(getappdata(handles.figure1,'new_v'))      
        v=getappdata(handles.figure1,'new_v');
        handles.model(handles.curr_model).vertices=v;
else
    v=handles.model(handles.curr_model).vertices;
end
dim(1)=max(v(:,2)+20);
dim(2)=max(v(:,1)+20);
dim(3)=max(v(:,3)+20);
set(handles.info,'string','Computing outer cortex surface...');
[h.vertices,h.faces]=model_outer(handles.model(handles.curr_model),dim); 
handles.overlay=handles.overlay+1;
handles.curr_model=handles.overlay;
handles.model(handles.curr_model).vertices=h.vertices;
handles.model(handles.curr_model).faces=h.faces;
handles.head_plot(handles.curr_model)=patch('vertices',h.vertices,'faces',...
    h.faces,'facecolor',[220 208 255]/255,'edgecolor','none',...
     'facealpha',0.4);
set(handles.alpha_slider,'value',0.4);
handles.alpha(handles.curr_model)=0.4;
set(handles.smooth_slider,'value',0);
handles.smooth(handles.curr_model)=0;
list=get(handles.surf_list,'string');
list{handles.overlay}=strcat('Surface',' ',num2str(handles.overlay));
set(handles.surf_list,'string',list,'value',handles.curr_model);
set(handles.info,'string','');
guidata(hObject, handles);
% --- Executes on button press in export_Btn.
function export_Btn_Callback(hObject, eventdata, handles)
% hObject    handle to export_Btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vertices=handles.model(handles.curr_model).vertices;
faces=handles.model(handles.curr_model).faces;
uisave({'vertices','faces'});
set(handles.info,'string','Current surface model saved');pause(2);
set(handles.info,'string','');
guidata(hObject,handles);

% --- Executes on button press in show_ct.
function show_ct_check_Callback(hObject, eventdata, handles)
% hObject    handle to show_ct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
show=get(hObject,'value');
if ~isfield(handles,'ct_plot')
    handles.ct_plot=findobj('facecolor',[3 9 175]/255);
end
if show==1
    xl=get(gca,'xlim');
    set(handles.ct_plot,'visible','on');
    set(gca,'xlim',xl);
else
    set(handles.ct_plot,'visible','off');
end
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of show_ct


% --- Executes on button press in del_elec_Btn.
function del_elec_Btn_Callback(hObject, eventdata, handles)
% hObject    handle to del_elec_Btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in col_elec_Btn.
function col_elec_Btn_Callback(hObject, eventdata, handles)
% hObject    handle to col_elec_Btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in contact_Btn.
function contact_Btn_Callback(hObject, eventdata, handles)
% hObject    handle to contact_Btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in mappingBtn.
function mappingBtn_Callback(hObject, eventdata, handles)
% hObject    handle to mappingBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile({'*.mat;*.txt','Data format (*.mat)'},'Please select mapping data');
fpath=[pathname filename];
if filename==0
    return;
end
load(fpath);
if size(handles.curr_coor,1)~=length(sp(:))
    errordlg('Mapping data dimension mismatch. Please check the current electrode setting', 'Warning');
    return;
end
md=sp(:);
md(md<50)=nan;
v1=get(handles.curr_elec.top,'vertices');
v2=get(handles.curr_elec.side,'vertices');
n1=size(v1,1)/length(md);
n2=size(v2,1)/length(md);
r1=repmat(md,1,n1);r1=r1';
r2=repmat(md,1,n2);r2=r2';
handles.mapping1=r1(:);handles.mapping2=r2(:);
map=get(handles.col_map_popup,'string');
map=map{get(handles.col_map_popup,'value')};
set(handles.curr_elec.top,'facevertexcdata',handles.mapping1,'facecolor','flat');colormap(map);
set(handles.curr_elec.side,'facevertexcdata',handles.mapping2,'facecolor','flat');
guidata(hObject, handles);


% --- Executes on button press in duplicateBtn.
function duplicateBtn_Callback(hObject, eventdata, handles)
% hObject    handle to duplicateBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in col_map_popup.
function col_map_popup_Callback(hObject, eventdata, handles)
% hObject    handle to col_map_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
map=get(handles.col_map_popup,'string');
map=map{get(handles.col_map_popup,'value')};
set(handles.curr_elec.top,'facevertexcdata',handles.mapping1,'facecolor','flat');colormap(map);
set(handles.curr_elec.side,'facevertexcdata',handles.mapping2,'facecolor','flat');
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns col_map_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from col_map_popup


% --- Executes during object creation, after setting all properties.
function col_map_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to col_map_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in style_popup.
function style_popup_Callback(hObject, eventdata, handles)
% hObject    handle to style_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(hObject,'String'));
style=contents{get(hObject,'Value')};
switch style
    case 'Con'
        set(handles.curr_elec.top,'visible','on');
        set(handles.curr_elec.side,'visible','on');
        try
            set(handles.curr_elec.stick,'visible','on');
        catch
        end
    case 'Flat'
        set(handles.curr_elec.top,'visible','on');
        set(handles.curr_elec.side,'visible','off');
        try
            set(handles.curr_elec.stick,'visible','off');
        catch
        end
    case 'Ball'
    case 'Circle'
end
% Hints: contents = cellstr(get(hObject,'String')) returns style_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from style_popup


% --- Executes during object creation, after setting all properties.
function style_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to style_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in show_ct_check.
% function show_ct_check_Callback(hObject, eventdata, handles)
% % hObject    handle to show_ct_check (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hint: get(hObject,'Value') returns toggle state of show_ct_check


% --- Executes on selection change in point_list.
function point_list_Callback(hObject, eventdata, handles)
% hObject    handle to point_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns point_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from point_list


% --- Executes during object creation, after setting all properties.
function point_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to point_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in del_point_Btn.
function del_point_Btn_Callback(hObject, eventdata, handles)
% hObject    handle to del_point_Btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in point_elec_Btn.
function point_elec_Btn_Callback(hObject, eventdata, handles)
% hObject    handle to point_elec_Btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    for i=1:length(handles.S)
        delete(handles.S(i));
    end

list=get(handles.point_list,'string');
for i=1:length(list)
    coor_list(i,:)=str2num(list{i});
end
handles.curr_coor=coor_list;
[side,top,~]=scatter3d(handles.curr_coor(:,1),handles.curr_coor(:,2),...
    handles.curr_coor(:,3),[0 1 0],3,1,5,0,handles.head_center);%get the electrode handles
handles.curr_elec.side=patch('faces',side.faces,'vertices',...
    side.vertices,'edgecolor','none','facecolor',[0 1 0],'facelighting',...
    'gouraud');

handles.curr_elec.top=patch('faces',top.faces,'vertices',...
    top.vertices,'edgecolor','none','facecolor',[0 1 0],'facelighting',...
    'gouraud',...
    'DiffuseStrength',  0.5, ...
    'SpecularStrength', 0.2, ...
    'SpecularColorReflectance', 0.4);
try
%     set(handles.label,'position',[x(1)-3 y(1)-3 z(1)+3],'visible','on');
catch
%     handles.label=text(coor_list(1,1)-3,coor_list(1,2)-3,coor_list(1,3)+3,'C1','fontsize',12,'color',[0 0 0]) ;
end

handles.curr_elec.stick=[];

handles.self_center=[mean(coor_list(:,1)) mean(coor_list(:,2)) mean(coor_list(:,3))];
set(handles.movX,'string','0');
set(handles.movY,'string','0');
set(handles.movZ,'string','0');
set(handles.rotX,'string','0');
set(handles.rotY,'string','0');
set(handles.rotZ,'string','0');
set(handles.adjX,'string','0');
set(handles.adjY,'string','0');
set(handles.adjZ,'string','0');
set(handles.applyBtn,'enable','on');
set(handles.attachBtn,'enable','on');
set(handles.saveBtn,'enable','on');
set(handles.cancelBtn,'enable','on');
set(handles.text4,'enable','on');
set(handles.text5,'enable','on');
set(handles.text6,'enable','on');
set(handles.text7,'enable','on');
set(handles.text8,'enable','on');
set(handles.text9,'enable','on');
set(handles.text10,'enable','on');
set(handles.text12,'enable','on');
set(handles.text13,'enable','on');
set(handles.text14,'enable','on');
set(handles.rotX,'enable','on');
set(handles.rotY,'enable','on');
set(handles.rotZ,'enable','on');
set(handles.movX,'enable','on');
set(handles.movY,'enable','on');
set(handles.movZ,'enable','on');
set(handles.adjX,'enable','on');
set(handles.adjY,'enable','on');
set(handles.adjZ,'enable','on');
set(handles.movx_up,'enable','on');
set(handles.movy_up,'enable','on');
set(handles.movz_up,'enable','on');
set(handles.movx_down,'enable','on');
set(handles.movy_down,'enable','on');
set(handles.movz_down,'enable','on');
set(handles.rotx_up,'enable','on');
set(handles.roty_up,'enable','on');
set(handles.rotz_up,'enable','on');
set(handles.rotx_down,'enable','on');
set(handles.roty_down,'enable','on');
set(handles.rotz_down,'enable','on');
set(handles.adjx_up,'enable','on');
set(handles.adjy_up,'enable','on');
set(handles.adjz_up,'enable','on');
set(handles.adjx_down,'enable','on');
set(handles.adjy_down,'enable','on');
set(handles.adjz_down,'enable','on');
set(handles.scale_up,'enable','on');
set(handles.scale_down,'enable','on');
set(handles.mappingBtn,'visible','on');
set(handles.del_elec_Btn,'visible','on');
set(handles.duplicateBtn,'visible','on');
set(handles.contact_Btn,'visible','on');
set(handles.attachBtn,'enable','on');
set(handles.col_map_popup,'visible','on','string',{'Jet' 'Hot' 'Cool'...
    'Spring' 'Summer' 'Autumn' 'Winter' 'Gray' 'Copper'},'value',1);
set(handles.style_popup,'visible','on','value',1);
handles.elec_index=0;
set(handles.info,'string','Use ''Apply''');
guidata(hObject, handles);
