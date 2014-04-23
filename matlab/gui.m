
function varargout = gui(varargin)
% GUI M-file for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 25-Jul-2011 19:53:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% axes(handles.ui_axes);
loadText = imread('blank.jpg');
imshow(loadText,'Parent',handles.ui_axes);

ui_slider_val = get(handles.ui_slider,'value');
set(handles.ui_text,'String',ui_slider_val);


% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function ui_slider_Callback(hObject, eventdata, handles)
% hObject    handle to ui_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

ui_slider_val = get(hObject,'Value');

set(handles.ui_text,'String',ui_slider_val);

fileName = get(handles.ui_edit,'String');

W1 = strcat('R_',fileName);
T1 = imread(W1);
W2 = strcat('O_',fileName);
T2 = imread(W2);

J = T1;
B = T2;
BWThreshold = ui_slider_val;

outline = bwperim(im2bw(J,BWThreshold));
% imshow(outline);

lineSize = 0.005*min(size(B,1),size(B,2));

SE1 = strel('line', lineSize, 90);
SE2 = strel('line', lineSize, 0);
outline = imdilate(outline,[SE1 SE2]);
%imshow(outline);

B = mat2gray(B);

Z = gray2rgb(B*255);
%imshow(Z);

for n = 1:1:size(Z,1)
    for n2 = 1:1:size(Z,2)
         Z(n,n2,2) = Z(n,n2,1) + 255*outline(n,n2);
         Z(n,n2,1) = Z(n,n2,1) - 255*outline(n,n2);
         Z(n,n2,3) = Z(n,n2,1) - 255*outline(n,n2);
    end
end

imshow(Z,'Parent',handles.ui_axes);




% --- Executes during object creation, after setting all properties.
function ui_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ui_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function ui_axes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ui_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate ui_axes



function ui_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ui_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ui_edit as text
%        str2double(get(hObject,'String')) returns contents of ui_edit as a
%        double




% --- Executes during object creation, after setting all properties.
function ui_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ui_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over axes background.
function ui_axes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to ui_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ui_button.
function ui_button_Callback(hObject, eventdata, handles)
% hObject    handle to ui_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ui_slider_val = get(handles.ui_slider,'Value');

fileName = get(handles.ui_edit,'String');

loadText = imread('load.jpg');

cla(handles.ui_axes);
imshow(loadText,'Parent',handles.ui_axes);
pause(0.5);

main(fileName);

W1 = strcat('R_',fileName);
T1 = imread(W1);
W2 = strcat('O_',fileName);
T2 = imread(W2);

J = T1;
B = T2;
BWThreshold = ui_slider_val;

outline = bwperim(im2bw(J,BWThreshold));
%imshow(outline);

lineSize = 0.005*min(size(B,1),size(B,2));

SE1 = strel('line', lineSize, 90);
SE2 = strel('line', lineSize, 0);
outline = imdilate(outline,[SE1 SE2]);
%imshow(outline);
% 
B = mat2gray(B);
Z = gray2rgb(B*255);
imshow(Z);

for n = 1:1:size(Z,1)
    for n2 = 1:1:size(Z,2)
         Z(n,n2,2) = Z(n,n2,1) + 255*outline(n,n2);
         Z(n,n2,1) = Z(n,n2,1) - 255*outline(n,n2);
         Z(n,n2,3) = Z(n,n2,1) - 255*outline(n,n2);
    end
end
cla(handles.ui_axes);
imshow(Z,'Parent',handles.ui_axes);


% --------------------------------------------------------------------
function uipushtool2_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

J = getimage(handles.ui_axes);

fileName = get(handles.ui_edit,'String');

imwrite(J,strcat('D_',fileName),'jpg');
