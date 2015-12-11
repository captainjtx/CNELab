function varargout = register_ct(varargin)
% REGISTER_CT MATLAB code for register_ct.fig
%      REGISTER_CT, by itself, creates a new REGISTER_CT or raises the existing
%      singleton*.
%
%      H = REGISTER_CT returns the handle to a new REGISTER_CT or the handle to
%      the existing singleton*.
%
%      REGISTER_CT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REGISTER_CT.M with the given input arguments.
%
%      REGISTER_CT('Property','Value',...) creates a new REGISTER_CT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before register_ct_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to register_ct_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help register_ct

% Last Modified by GUIDE v2.5 30-Aug-2015 19:38:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @register_ct_OpeningFcn, ...
                   'gui_OutputFcn',  @register_ct_OutputFcn, ...
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


% --- Executes just before register_ct is made visible.
function register_ct_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to register_ct (see VARARGIN)

% Choose default command line output for register_ct
handles.output = hObject;
handles.cortex=varargin{2};
handles.ct=varargin{1};
handles.H=varargin{3};
% v(:,1)=handles.ct.vertices(:,2);
% v(:,2)=handles.ct.vertices(:,1);
% v(:,3)=handles.ct.vertices(:,3);
% handles.ct.vertices=v; 
handles.ct_center=[mean(handles.ct.vertices(:,1)) mean(handles.ct.vertices(:,2)) mean(handles.ct.vertices(:,3))];
handles.cortex_center=[mean(handles.cortex.vertices(:,1)) mean(handles.cortex.vertices(:,2)) mean(handles.cortex.vertices(:,3))];
shift=repmat(handles.cortex_center-handles.ct_center,size(handles.ct.vertices,1),1);
handles.ct.vertices=handles.ct.vertices+shift;
handles.ct_center=handles.cortex_center;
%Pr=rot3d(handles.ct.vertices,handles.ct_center,[0 0 1],pi/2);
%handles.ct.vertices=Pr;
%rotate(handles.ct.vertices,[0 0 1],90,handles.ct_center);
scrsz = get(groot,'ScreenSize');
handles.display=figure('Position',[1 scrsz(3)/2 scrsz(3)/2 scrsz(3)/2],'color',[0 0 0],'name','');
set(handles.display, 'menubar', 'none');
set(gca,'color',[0 0 0]);
%handles.axes1;
handles.cortex_plot=patch('faces',handles.cortex.faces,'vertices',handles.cortex.vertices,...
    'edgecolor','none','facecolor',[0.95 0.95 0.95],...
    'facealpha',1,'BackfaceLighting', 'lit', ...
    'AmbientStrength',  0.5, ...
    'DiffuseStrength',  0.5, ...
    'SpecularStrength', 0.2, ...
    'SpecularExponent', 1, ...
    'SpecularColorReflectance', 0.5, ...
    'FaceLighting',     'gouraud', ...
    'EdgeLighting',     'gouraud');

hold on
handles.ct_plot=patch('faces',handles.ct.faces,'vertices',handles.ct.vertices,...
    'edgecolor','none','facecolor',[3 9 175]/255,...
    'facealpha',0.4,'BackfaceLighting', 'lit', ...
    'AmbientStrength',  0.5, ...
    'DiffuseStrength',  0.5, ...
    'SpecularStrength', 0.2, ...
    'SpecularExponent', 1, ...
    'SpecularColorReflectance', 0.5, ...
    'FaceLighting',     'gouraud', ...
    'EdgeLighting',     'gouraud');
axis vis3d
view(3); rotate3d;

camlight(0,70); daspect([1,1,1]);
set(handles.slider1,'value',0.4);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes register_ct wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = register_ct_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.alpha=get(hObject,'value');
set(handles.ct_plot,'facealpha',handles.alpha);
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
v=get(handles.ct_plot,'vertices');
f=get(handles.ct_plot,'faces');
%handles.ct_center=[mean(v(:,1)) mean(v(:,2)) mean(v(:,3))];
for i=1:size(v,1)
    handles.d_ct(i)=norm(handles.ct.vertices(i,:)-handles.cortex_center);
end
lfactor=get(handles.slider2,'value');
[~,A]=sort(handles.d_ct,'descend');
hide=A(1:round(size(v,1)*lfactor));
for i=1:length(hide)
    f(f(:)==hide(i))=nan;
end
set(handles.ct_plot,'faces',f);
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in autoBtn.
function autoBtn_Callback(hObject, eventdata, handles)
% hObject    handle to autoBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for i=1:size(handles.ct.vertices,1)
    handles.d_ct(i)=norm(handles.ct.vertices(i,:)-handles.ct_center);
end
for i=1:size(handles.cortex.vertices,1)
    handles.d_cortex(i)=norm(handles.cortex.vertices(i,:)-handles.cortex_center);
end
scale=max(handles.d_ct)/max(handles.d_cortex);
set(handles.ct_plot,'vertices',get(handles.ct_plot,'vertices')/scale);
set(handles.ct_plot,'vertices',get(handles.ct_plot,'vertices')*1.8);
handles.ct.vertices=get(handles.ct_plot,'vertices');
handles.ct_center=[mean(handles.ct.vertices(:,1)) mean(handles.ct.vertices(:,2))...
    mean(handles.ct.vertices(:,3))];
shift=repmat(handles.cortex_center-handles.ct_center,size(handles.ct.vertices,1),1);
handles.ct.vertices=handles.ct.vertices+shift;
handles.ct_center=handles.cortex_center;
set(handles.ct_plot,'vertices',handles.ct.vertices);
guidata(hObject, handles);


% --- Executes on button press in xup.
function xup_Callback(hObject, eventdata, handles)
% hObject    handle to xup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
action=get(handles.action_popup,'value');
switch action
    case 1
        v=get(handles.cortex_plot,'vertices');
        v(:,1)=v(:,1)+5;
        set(handles.cortex_plot,'vertices',v);
    case 2
        v=get(handles.cortex_plot,'vertices');
        handles.ct_center=[mean(v(:,1)) mean(v(:,2)) mean(v(:,3))];
        rotate(handles.cortex_plot,[1 0 0],5,handles.cortex_center);
    case 3
        v=get(handles.cortex_plot,'vertices');
        c0=[mean(v(:,1)) mean(v(:,2)) mean(v(:,3))];
        v(:,1)=v(:,1)*1.1;
        c1=[mean(v(:,1)) mean(v(:,2)) mean(v(:,3))];
        shift=repmat(c1-c0,size(handles.cortex.vertices,1),1);
        v=v-shift;
        set(handles.cortex_plot,'vertices',v);
end
guidata(hObject, handles);
% --- Executes on button press in xdown.
function xdown_Callback(hObject, eventdata, handles)
% hObject    handle to xdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
action=get(handles.action_popup,'value');
switch action
    case 1
        v=get(handles.cortex_plot,'vertices');
        v(:,1)=v(:,1)-5;
        set(handles.cortex_plot,'vertices',v);
    case 2
        v=get(handles.cortex_plot,'vertices');
        handles.ct_center=[mean(v(:,1)) mean(v(:,2)) mean(v(:,3))];
        rotate(handles.cortex_plot,[1 0 0],-5,handles.cortex_center);
    case 3
        v=get(handles.cortex_plot,'vertices');
        c0=[mean(v(:,1)) mean(v(:,2)) mean(v(:,3))];
        v(:,1)=v(:,1)/1.1;
        c1=[mean(v(:,1)) mean(v(:,2)) mean(v(:,3))];
        shift=repmat(c1-c0,size(handles.cortex.vertices,1),1);
        v=v-shift;
        set(handles.cortex_plot,'vertices',v);
end
guidata(hObject, handles);
% --- Executes on button press in yup.
function yup_Callback(hObject, eventdata, handles)
% hObject    handle to yup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
action=get(handles.action_popup,'value');
switch action
    case 1
        v=get(handles.cortex_plot,'vertices');
        v(:,2)=v(:,2)+2;
        set(handles.cortex_plot,'vertices',v);
    case 2
        v=get(handles.cortex_plot,'vertices');
        handles.ct_center=[mean(v(:,1)) mean(v(:,2)) mean(v(:,3))];
        rotate(handles.cortex_plot,[0 1 0],5,handles.cortex_center);
    case 3
        v=get(handles.cortex_plot,'vertices');
        c0=[mean(v(:,1)) mean(v(:,2)) mean(v(:,3))];
        v(:,2)=v(:,2)*1.05;
        c1=[mean(v(:,1)) mean(v(:,2)) mean(v(:,3))];
        shift=repmat(c1-c0,size(handles.cortex.vertices,1),1);
        v=v-shift;
        set(handles.cortex_plot,'vertices',v);
end
guidata(hObject, handles);
% --- Executes on button press in ydown.
function ydown_Callback(hObject, eventdata, handles)
% hObject    handle to ydown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
action=get(handles.action_popup,'value');
switch action
    case 1
        v=get(handles.cortex_plot,'vertices');
        v(:,2)=v(:,2)-2;
        set(handles.cortex_plot,'vertices',v);
    case 2
        v=get(handles.cortex_plot,'vertices');
        handles.ct_center=[mean(v(:,1)) mean(v(:,2)) mean(v(:,3))];
        rotate(handles.cortex_plot,[0 1 0],-5,handles.cortex_center);
    case 3
        v=get(handles.cortex_plot,'vertices');
        c0=[mean(v(:,1)) mean(v(:,2)) mean(v(:,3))];
        v(:,2)=v(:,2)/1.05;
        c1=[mean(v(:,1)) mean(v(:,2)) mean(v(:,3))];
        shift=repmat(c1-c0,size(handles.cortex.vertices,1),1);
        v=v-shift;
        set(handles.cortex_plot,'vertices',v);
end
guidata(hObject, handles);
% --- Executes on button press in zup.
function zup_Callback(hObject, eventdata, handles)
% hObject    handle to zup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
action=get(handles.action_popup,'value');
switch action
    case 1
        v=get(handles.cortex_plot,'vertices');
        v(:,3)=v(:,3)+2;
        set(handles.cortex_plot,'vertices',v);
    case 2
        v=get(handles.cortex_plot,'vertices');
        handles.ct_center=[mean(v(:,1)) mean(v(:,2)) mean(v(:,3))];
        rotate(handles.cortex_plot,[0 0 1],5,handles.cortex_center);
    case 3
        v=get(handles.cortex_plot,'vertices');
        c0=[mean(v(:,1)) mean(v(:,2)) mean(v(:,3))];
        v(:,3)=v(:,3)*1.05;
        c1=[mean(v(:,1)) mean(v(:,2)) mean(v(:,3))];
        shift=repmat(c1-c0,size(handles.cortex.vertices,1),1);
        v=v-shift;
        set(handles.cortex_plot,'vertices',v);
end
guidata(hObject, handles);
% --- Executes on button press in zdown.
function zdown_Callback(hObject, eventdata, handles)
% hObject    handle to zdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
action=get(handles.action_popup,'value');
switch action
    case 1
        v=get(handles.cortex_plot,'vertices');
        v(:,3)=v(:,3)-2;
        set(handles.cortex_plot,'vertices',v);
    case 2
        v=get(handles.cortex_plot,'vertices');
        handles.ct_center=[mean(v(:,1)) mean(v(:,2)) mean(v(:,3))];
        rotate(handles.cortex_plot,[0 0 1],-5,handles.cortex_center);
    case 3
        v=get(handles.cortex_plot,'vertices');
        c0=[mean(v(:,1)) mean(v(:,2)) mean(v(:,3))];
        v(:,3)=v(:,3)/1.05;
        c1=[mean(v(:,1)) mean(v(:,2)) mean(v(:,3))];
        shift=repmat(c1-c0,size(handles.cortex.vertices,1),1);
        v=v-shift;
        set(handles.cortex_plot,'vertices',v);
end
guidata(hObject, handles);

% --- Executes on selection change in action_popup.
function action_popup_Callback(hObject, eventdata, handles)
% hObject    handle to action_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns action_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from action_popup


% --- Executes during object creation, after setting all properties.
function action_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to action_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveBtn.
function saveBtn_Callback(hObject, eventdata, handles)
% hObject    handle to saveBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%hi=get(handles.ct_plot);
%uisave('hi');
vertices=get(handles.ct_plot,'vertices');
faces=get(handles.ct_plot,'faces');
vc=get(handles.cortex_plot,'vertices');
dim=[max(vc(:,1))+20 max(vc(:,2))+20 max(vc(:,3))+20];
[v,f]=ct_innerskull(vertices,faces,dim);

uisave('_ct_re',{'faces' 'vertices'});
vertices=get(handles.cortex_plot,'vertices');
faces=get(handles.cortex_plot,'faces');
uisave('_cortex_re',{'faces' 'vertices'});


% --- Executes on button press in applyBtn.
function applyBtn_Callback(hObject, eventdata, handles)
% hObject    handle to applyBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ct=get(handles.ct_plot);
cortex=get(handles.cortex_plot);
set(handles.H.head_plot(handles.H.curr_model),'vertices',cortex.Vertices);
handles.H.model(handles.H.curr_model).vertices=cortex.Vertices;
setappdata(handles.H.figure1,'ct',ct);
setappdata(handles.H.figure1,'new_v',cortex.Vertices);
set(handles.H.show_ct_check,'enable','on','value',1);
handles.H.figure1;
%set(gcf,'KeyPressFcn',@ct_display_press);
axes(handles.H.axes1);
%xl=get(gca,'xlim');
% handles.H.ct_plot=patch('faces',handles.ct.faces,'vertices',handles.ct.vertices,...
%     'edgecolor','none','facecolor',[3 9 175]/255,...
%     'facealpha',0.4);
patch('faces',ct.Faces,'vertices',ct.Vertices,...
    'edgecolor','none','facecolor',[3 9 175]/255,...
    'facealpha',0.2);

%set(gca,'xlim',xl);
guidata(hObject, handles);
close(handles.figure1);
close(handles.display);
%axis vis3d
%view(3); rotate3d;

%camlight(0,70); daspect([1,1,1]);
%



% --- Executes on button press in cancelBtn.
function cancelBtn_Callback(hObject, eventdata, handles)
% hObject    handle to cancelBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1);
close(handles.display);