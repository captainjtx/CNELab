function varargout = new_electrode(varargin)
% NEW_ELECTRODE MATLAB code for new_electrode.fig
%      NEW_ELECTRODE, by itself, creates a new NEW_ELECTRODE or raises the existing
%      singleton*.
%
%      H = NEW_ELECTRODE returns the handle to a new NEW_ELECTRODE or the handle to
%      the existing singleton*.
%
%      NEW_ELECTRODE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEW_ELECTRODE.M with the given input arguments.
%
%      NEW_ELECTRODE('Property','Value',...) creates a new NEW_ELECTRODE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before new_electrode_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to new_electrode_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help new_electrode

% Last Modified by GUIDE v2.5 28-Aug-2015 23:47:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @new_electrode_OpeningFcn, ...
    'gui_OutputFcn',  @new_electrode_OutputFcn, ...
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


% --- Executes just before new_electrode is made visible.
function new_electrode_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to new_electrode (see VARARGIN)
handles.col=str2double(get(handles.col_edit,'string'));
handles.row=str2double(get(handles.row_edit,'string'));
handles.curv=str2double(get(handles.curv_edit,'string'));
handles.x=str2double(get(handles.x_edit,'string'));
handles.y=str2double(get(handles.y_edit,'string'));
handles.z=str2double(get(handles.z_edit,'string'));
handles.marker=80;
handles.type=1;
handles.size=str2double(get(handles.size_edit,'string'));
handles.color=[0 0 1];
setappdata(handles.figure1,'color',handles.color);
setappdata(handles.figure1,'cancel',0);
setappdata(handles.figure1,'location',[]);
handles.location=[];
guidata(hObject, handles);
% Choose default command line output for new_electrode
uiwait(handles.figure1);

cancel=getappdata(handles.figure1,'cancel');
if cancel==1
    return;
end
location=getappdata(handles.figure1,'location');
if ~isempty(location)
    handles.output{1}=location;
    handles.type=5;%imported electrode location
else
    handles.type=get(handles.popupmenu1,'value');
    if handles.type==4
        handles.row=1;
        handles.curv=eps;
    else
        handles.row=str2double(get(handles.row_edit,'string'));
        handles.curv=str2double(get(handles.curv_edit,'string'));
    end
    handles.col=str2double(get(handles.col_edit,'string'));
    handles.x=str2double(get(handles.x_edit,'string'));
    handles.y=str2double(get(handles.y_edit,'string'));
    handles.z=str2double(get(handles.z_edit,'string'));
    handles.marker=80;
    handles.size=str2double(get(handles.size_edit,'string'));
    [x,y,z]=creat_grid(handles.col,handles.row,handles.curv...
        ,handles.x,handles.y,handles.z,handles.size);
    handles.output{1} = [x y z];
end
handles.output{2} = handles.type;
color=getappdata(handles.figure1,'color');
handles.output{3} = color;
guidata(hObject, handles);

% Update handles structure


% UIWAIT makes new_electrode wait for user response (see UIRESUME)



% --- Outputs from this function are returned to the command line.
function varargout = new_electrode_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if isempty(handles)==0
    close(handles.figure1);
    varargout{1} = handles.output;
end

function CloseMenuItem_Callback(hObject, eventdata, handles)
setappdata(handles.figure1,'cancel',1);
uiresume;


function col_edit_Callback(hObject, eventdata, handles)
% hObject    handle to col_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of col_edit as text
%        str2double(get(hObject,'String')) returns contents of col_edit as a double


% --- Executes during object creation, after setting all properties.
function col_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to col_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function row_edit_Callback(hObject, eventdata, handles)
% hObject    handle to row_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of row_edit as text
%        str2double(get(hObject,'String')) returns contents of row_edit as a double


% --- Executes during object creation, after setting all properties.
function row_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to row_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function curv_edit_Callback(hObject, eventdata, handles)
% hObject    handle to curv_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of curv_edit as text
%        str2double(get(hObject,'String')) returns contents of curv_edit as a double


% --- Executes during object creation, after setting all properties.
function curv_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to curv_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_edit_Callback(hObject, eventdata, handles)
% hObject    handle to x_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_edit as text
%        str2double(get(hObject,'String')) returns contents of x_edit as a double


% --- Executes during object creation, after setting all properties.
function x_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_edit_Callback(hObject, eventdata, handles)
% hObject    handle to y_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_edit as text
%        str2double(get(hObject,'String')) returns contents of y_edit as a double


% --- Executes during object creation, after setting all properties.
function y_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_edit_Callback(hObject, eventdata, handles)
% hObject    handle to z_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_edit as text
%        str2double(get(hObject,'String')) returns contents of z_edit as a double


% --- Executes during object creation, after setting all properties.
function z_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function markersize_Callback(hObject, eventdata, handles)
% hObject    handle to markersize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of markersize as text
%        str2double(get(hObject,'String')) returns contents of markersize as a double


% --- Executes during object creation, after setting all properties.
function markersize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to markersize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function size_edit_Callback(hObject, eventdata, handles)
% hObject    handle to size_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of size_edit as text
%        str2double(get(hObject,'String')) returns contents of size_edit as a double


% --- Executes during object creation, after setting all properties.
function size_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to size_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in imortCol_check.
function imortCol_check_Callback(hObject, eventdata, handles)
% hObject    handle to imortCol_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile({'*.mat;*.txt','Data format (*.mat)'},'Please select mapping data');
fpath=[pathname filename];
if isempty(fpath)
    return;
end
if ischar(fpath)
    load(fpath);
else
    
    return;
end
handles.color=ss(:);
setappdata(handles.figure1,'color',handles.color);
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of imortCol_check


% --- Executes on button press in colorBtn.
function colorBtn_Callback(hObject, eventdata, handles)
% hObject    handle to colorBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.color=uisetcolor;
setappdata(handles.figure1,'color',handles.color);
guidata(hObject, handles);

% --- Executes on button press in previewBtn.
function previewBtn_Callback(hObject, eventdata, handles)
% hObject    handle to previewBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.location)
    x=handles.location(:,1);
    y=handles.location(:,2);
    z=handles.location(:,3);
else
%     handles.col=str2double(get(handles.col_edit,'string'));
%     handles.row=str2double(get(handles.row_edit,'string'));
%     handles.curv=str2double(get(handles.curv_edit,'string'));
%     handles.x=str2double(get(handles.x_edit,'string'));
%     handles.y=str2double(get(handles.y_edit,'string'));
%     handles.z=str2double(get(handles.z_edit,'string'));
%     handles.marker=80;
%     handles.size=str2double(get(handles.size_edit,'string'));
%     [x,y,z]=creat_grid(handles.col,handles.row,handles.curv...
%         ,handles.x,handles.y,handles.z,handles.size);
    handles.type=get(handles.popupmenu1,'value');
    if handles.type==4
        handles.row=1;
        handles.curv=eps;
    else
        handles.row=str2double(get(handles.row_edit,'string'));
        handles.curv=str2double(get(handles.curv_edit,'string'));
    end
    handles.col=str2double(get(handles.col_edit,'string'));
    handles.x=str2double(get(handles.x_edit,'string'));
    handles.y=str2double(get(handles.y_edit,'string'));
    handles.z=str2double(get(handles.z_edit,'string'));
    handles.marker=80;
    handles.size=str2double(get(handles.size_edit,'string'));
    [x,y,z]=creat_grid(handles.col,handles.row,handles.curv...
        ,handles.x,handles.y,handles.z,handles.size);
    handles.output{1} = [x y z];
end
figure;
%scatter3(x,y,z,handles.marker,handles.color,'filled');zlim([100 200]);
scatter3d(x,y,z,handles.color,2.5,1,handles.type);

axis vis3d;
%zlim([min(z)-80 max(z)+80]);
camlight;
% light('position',[200,0,0],'style','infinite');
% lighting('gouraud')
lighting phong;

%scatter3(x,y,z,handles.marker,handles.color,'filled');

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.type=get(hObject,'value');
if handles.type==4
    set(handles.row_edit,'enable','off','string','');
    set(handles.curv_edit,'enable','off','string','');
    set(handles.size_edit,'string','10');
end
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in genBtn.
function genBtn_Callback(hObject, eventdata, handles)
% hObject    handle to genBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);
uiresume(handles.figure1);


% --- Executes on button press in importBtn.
function importBtn_Callback(hObject, eventdata, handles)
% hObject    handle to importBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile({'*.mat;*.txt','Data format (*.mat)'},'Please select file');
fpath=[pathname filename];
if isempty(fpath)
    return;
end
load(fpath);
handles.location=syn;
handles.type=5;
setappdata(handles.figure1,'location',handles.location);
guidata(hObject, handles);