function varargout = session_add_dialog(varargin)
% SESSION_ADD_DIALOG MATLAB code for session_add_dialog.fig
%      SESSION_ADD_DIALOG, by itself, creates a new SESSION_ADD_DIALOG or raises the existing
%      singleton*.
%
%      H = SESSION_ADD_DIALOG returns the handle to a new SESSION_ADD_DIALOG or the handle to
%      the existing singleton*.
%
%      SESSION_ADD_DIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SESSION_ADD_DIALOG.M with the given input arguments.
%
%      SESSION_ADD_DIALOG('Property','Value',...) creates a new SESSION_ADD_DIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before session_add_dialog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to session_add_dialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help session_add_dialog

% Last Modified by GUIDE v2.5 06-Nov-2015 14:38:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @session_add_dialog_OpeningFcn, ...
                   'gui_OutputFcn',  @session_add_dialog_OutputFcn, ...
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


% --- Executes just before session_add_dialog is made visible.
function session_add_dialog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to session_add_dialog (see VARARGIN)

% Choose default command line output for session_add_dialog
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes session_add_dialog wait for user response (see UIRESUME)
% uiwait(handles.session_adder);


% --- Outputs from this function are returned to the command line.
function varargout = session_add_dialog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in movie_select_button.
function movie_select_button_Callback(hObject, eventdata, handles)
% hObject    handle to movie_select_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.h5','Pick an .h5 movie file')
handles.filepath = [PathName,FileName];
guidata(hObject,handles);

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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


% --- Executes on button press in date_select_button.
function date_select_button_Callback(hObject, eventdata, handles)
% hObject    handle to date_select_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ymd = uisetdate2;
handles.date = [int2str(ymd(2)),'/',int2str(ymd(3)),'/',int2str(ymd(1))];
guidata(hObject,handles);

% --- Executes on selection change in session_number_menu.
function session_number_menu_Callback(hObject, eventdata, handles)
% hObject    handle to session_number_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns session_number_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from session_number_menu


% --- Executes during object creation, after setting all properties.
function session_number_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to session_number_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function animal_name_box_Callback(hObject, eventdata, handles)
% hObject    handle to animal_name_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of animal_name_box as text
%        str2double(get(hObject,'String')) returns contents of animal_name_box as a double


% --- Executes during object creation, after setting all properties.
function animal_name_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to animal_name_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function experiment_type_box_Callback(hObject, eventdata, handles)
% hObject    handle to experiment_type_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of experiment_type_box as text
%        str2double(get(hObject,'String')) returns contents of experiment_type_box as a double


% --- Executes during object creation, after setting all properties.
function experiment_type_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to experiment_type_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OKbutton.
function OKbutton_Callback(hObject, eventdata, handles)
% hObject    handle to OKbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% grab data from popup and edit text fields
newdata.Animal = handles.animal_name_box.String;
newdata.Date = handles.date;
newdata.Session = str2num(handles.session_number_menu.String);
newdata.Env = handles.experiment_type_box.String;
newdata.Room = handles.room_box.String;
newdata.Location = handles.filepath;
newdata.Notes = [];

ht = findobj('Tag','tenaspisgui');
dt = guidata(ht);

dt.MD(end+1) = newdata;
guidata(ht,dt);


h = findobj('Tag','session_adder');
close(h);


% if data is invalid or fields are left blank, show dialog and return

% show user the entry in a dialog with yes/no buttons, 
%   if user clicks yes add entry to database, close yes/no dialog, close
%   session adder
%   if user clicks no, cloes yes/no dialog
% add the entry to 



function room_box_Callback(hObject, eventdata, handles)
% hObject    handle to room_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of room_box as text
%        str2double(get(hObject,'String')) returns contents of room_box as a double


% --- Executes during object creation, after setting all properties.
function room_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to room_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
