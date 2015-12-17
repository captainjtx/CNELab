function varargout = TH_input(varargin)
% TH_INPUT MATLAB code for TH_input.fig
%      TH_INPUT, by itself, creates a new TH_INPUT or raises the existing
%      singleton*.
%
%      H = TH_INPUT returns the handle to a new TH_INPUT or the handle to
%      the existing singleton*.
%
%      TH_INPUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TH_INPUT.M with the given input arguments.
%
%      TH_INPUT('Property','Value',...) creates a new TH_INPUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TH_input_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TH_input_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TH_input

% Last Modified by GUIDE v2.5 06-Sep-2015 19:11:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TH_input_OpeningFcn, ...
                   'gui_OutputFcn',  @TH_input_OutputFcn, ...
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


% --- Executes just before TH_input is made visible.
function TH_input_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TH_input (see VARARGIN)

% Choose default command line output for TH_input
handles.vol=varargin{1};
vol=handles.vol;
handles.th=quantile(vol(find(vol)),0.75);
handles.page=80;
handles.axes1;
imshow(handles.vol(:,:,80)/handles.th);
set(handles.show_page,'string',80);
set(handles.th_edit,'string',handles.th);
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TH_input wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TH_input_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
th=handles.th;
% Get default command line output from handles structure
varargout{1} = th;
close(handles.figure1);


% --- Executes on button press in fwdBtn.
function fwdBtn_Callback(hObject, eventdata, handles)
% hObject    handle to fwdBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    handles.page=handles.page+1;
    handles.axes1;
    imshow(handles.vol(:,:,handles.page)/handles.th);
    set(handles.show_page,'string',handles.page);
catch
    return;
end
guidata(hObject, handles);

% --- Executes on button press in backBtn.
function backBtn_Callback(hObject, eventdata, handles)
% hObject    handle to backBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    handles.page=handles.page-1;
    handles.axes1;
    imshow(handles.vol(:,:,handles.page)/handles.th);
    set(handles.show_page,'string',handles.page);
catch
    return;
end
guidata(hObject, handles);


function th_edit_Callback(hObject, eventdata, handles)
% hObject    handle to th_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of th_edit as text
handles.th=str2double(get(hObject,'String'));
handles.axes1;
imshow(handles.vol(:,:,handles.page)/handles.th);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function th_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to th_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in okBtn.
function okBtn_Callback(hObject, eventdata, handles)
% hObject    handle to okBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume;
