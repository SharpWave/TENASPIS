function varargout = base_session_dialog(varargin)
% BASE_SESSION_DIALOG MATLAB code for base_session_dialog.fig
%      BASE_SESSION_DIALOG, by itself, creates a new BASE_SESSION_DIALOG or raises the existing
%      singleton*.
%
%      H = BASE_SESSION_DIALOG returns the handle to a new BASE_SESSION_DIALOG or the handle to
%      the existing singleton*.
%
%      BASE_SESSION_DIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BASE_SESSION_DIALOG.M with the given input arguments.
%
%      BASE_SESSION_DIALOG('Property','Value',...) creates a new BASE_SESSION_DIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before base_session_dialog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to base_session_dialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help base_session_dialog

% Last Modified by GUIDE v2.5 10-Nov-2015 13:02:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @base_session_dialog_OpeningFcn, ...
                   'gui_OutputFcn',  @base_session_dialog_OutputFcn, ...
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


% --- Executes just before base_session_dialog is made visible.
function base_session_dialog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to base_session_dialog (see VARARGIN)

% Choose default command line output for base_session_dialog
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes base_session_dialog wait for user response (see UIRESUME)
% uiwait(handles.base_session_select_master);
% display all sessions for animal for active session
ht = findobj('Tag','tenaspisgui');
dt = guidata(ht);
MD = dt.MD;
animal = MD(dt.active_session_MDidx).Animal;

curr = 1;
for i = 1:length(MD)
    if (strcmp(MD(i).Animal,animal))
        handles.session_sel_list_box.String{curr} = [MD(i).Animal,'_',MD(i).Date,'_',int2str(MD(i).Session),' - ',MD(i).Env];
        handles.base_list_MDidxs(curr) = i;
        curr = curr + 1;
    end
end

guidata(hObject,handles);

% --- Outputs from this function are returned to the command line.
function varargout = base_session_dialog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in session_sel_list_box.
function session_sel_list_box_Callback(hObject, eventdata, handles)
% hObject    handle to session_sel_list_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns session_sel_list_box contents as cell array
%        contents{get(hObject,'Value')} returns selected item from session_sel_list_box


% --- Executes during object creation, after setting all properties.
function session_sel_list_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to session_sel_list_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in session_sel_box_ok.
function session_sel_box_ok_Callback(hObject, eventdata, handles)
% hObject    handle to session_sel_box_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ht = findobj('Tag','tenaspisgui');
dt = guidata(ht);
dt.base_session_MDidx = handles.base_list_MDidxs(handles.session_sel_list_box.Value);
guidata(ht,dt);

h = findobj('Tag','base_session_select_master');
close(h);
