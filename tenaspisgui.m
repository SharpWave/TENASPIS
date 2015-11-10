function varargout = tenaspisgui(varargin)
% TENASPISGUI MATLAB code for tenaspisgui.fig
%      TENASPISGUI, by itself, creates a new TENASPISGUI or raises the existing
%      singleton*.
%
%      H = TENASPISGUI returns the handle to a new TENASPISGUI or the handle to
%      the existing singleton*.
%
%      TENASPISGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TENASPISGUI.M with the given input arguments.
%
%      TENASPISGUI('Property','Value',...) creates a new TENASPISGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tenaspisgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tenaspisgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tenaspisgui

% Last Modified by GUIDE v2.5 10-Nov-2015 13:52:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tenaspisgui_OpeningFcn, ...
                   'gui_OutputFcn',  @tenaspisgui_OutputFcn, ...
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


% --- Executes just before tenaspisgui is made visible.
function tenaspisgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tenaspisgui (see VARARGIN)

% Choose default command line output for tenaspisgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tenaspisgui wait for user response (see UIRESUME)
% uiwait(handles.tenaspisgui);
axes(handles.imagedisplaybox);
image(imread('ff.jpg'));
axis off;

% --- Outputs from this function are returned to the command line.
function varargout = tenaspisgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in animal_select_box.
function animal_select_box_Callback(hObject, eventdata, handles)
% hObject    handle to animal_select_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns animal_select_box contents as cell array
%        contents{get(hObject,'Value')} returns selected item from animal_select_box

% In the date box, write in all dates for selected animals
if ~isfield(handles,'MD')
   
   axes(handles.imagedisplaybox);
   image(imread('f46.jpg'));
   axis off;
   %errordlg('YOURE SO STUPID!!!!');
   return;
end

MD = handles.MD;

selected_animal = handles.animal_select_box.Value(1);
handles.selected_animal_str = handles.animal_select_box.String{selected_animal};


animal_dates = [];
curr = 1;
for j = selected_animal
    for i = 1:length(MD)
        if (strcmp(MD(i).Animal,handles.animal_select_box.String{j}) && ~isempty(MD(i).Location))
            animal_dates{curr} = MD(i).Date;
            curr = curr+1;
        end
    end
end
handles.date_select_box.Value = [];
handles.date_select_box.String = unique(animal_dates);

handles.session_select_box.Value = [];
handles.session_select_box.String = [];
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function animal_select_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to animal_select_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on selection change in date_select_box.
function date_select_box_Callback(hObject, eventdata, handles)
% hObject    handle to date_select_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns date_select_box contents as cell array
%        contents{get(hObject,'Value')} returns selected item from date_select_box
selected_dates = handles.date_select_box.Value;


% find the entries of MD that match the selected animal and dates
% then display them in the session box
MD = handles.MD;
curr = 1;
sess_box_strings = [];

for i = 1:length(MD)
    for j = 1:length(selected_dates)
      if (strcmp(MD(i).Animal,handles.selected_animal_str) && strcmp(MD(i).Date,handles.date_select_box.String{selected_dates(j)}))
          sess_box_strings{curr} = [MD(i).Animal,'_',MD(i).Date,'_',int2str(MD(i).Session),' - ',MD(i).Env];
          handles.sess_box_MDidx(curr) = i;
          curr = curr + 1;
      end
    end
end

handles.session_select_box.Value = 1;
handles.session_select_box.String = sess_box_strings;
guidata(hObject,handles);
          

% --- Executes during object creation, after setting all properties.
function date_select_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to date_select_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in session_select_box.
function session_select_box_Callback(hObject, eventdata, handles)
% hObject    handle to session_select_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns session_select_box contents as cell array
%        contents{get(hObject,'Value')} returns selected item from session_select_box

% actually this callbox does nothing


% --- Executes during object creation, after setting all properties.
function session_select_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to session_select_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in queuebox.
function queuebox_Callback(hObject, eventdata, handles)
% hObject    handle to queuebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns queuebox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from queuebox


% --- Executes during object creation, after setting all properties.
function queuebox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to queuebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.queuebox_MDidx = [];
guidata(hObject,handles);

% --- Executes on button press in run_tenaspis_button.
function run_tenaspis_button_Callback(hObject, eventdata, handles)
% hObject    handle to run_tenaspis_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% runs the active session: handles.active_session_MDidx

% check whether base session for this animal is specified

% if yes, register this session to base session and register masks

% if no, run tenaspis with manual mask
keyboard;
i = handles.active_session_MDidx;
% assemble tenaspis call

% run tenaspis

% display stats (runtime, rec length, # of neurons

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in queue_add_button.
function queue_add_button_Callback(hObject, eventdata, handles)
% hObject    handle to queue_add_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% take everything highlighted in session_select_box and append it to the queue
% and then add it to the queuebox

% new queue is the set union of session_select_box and queue_box
MD = handles.MD;
handles.queuebox_MDidx = union(handles.sess_box_MDidx(handles.session_select_box.Value),handles.queuebox_MDidx);

curr = 1;
for i = handles.queuebox_MDidx
    queuebox_strings{curr} = [int2str(curr),'. ',MD(i).Animal,'_',MD(i).Date,'_',int2str(MD(i).Session),' - ',MD(i).Env];
    curr = curr + 1;
end

handles.queuebox.Value = 1;
handles.queuebox.String = queuebox_strings;

% update active session
handles.active_session_MDidx  =handles.queuebox_MDidx(1); 
handles.active_session_text.String = [MD(handles.active_session_MDidx).Animal,'_',MD(handles.active_session_MDidx).Date,'_',...
    int2str(MD(handles.active_session_MDidx).Session),' - ',MD(handles.active_session_MDidx).Env];
guidata(hObject,handles);


% --------------------------------------------------------------------
function OPTIONS_Callback(hObject, eventdata, handles)
% hObject    handle to OPTIONS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function CONTEXT_Callback(hObject, eventdata, handles)
% hObject    handle to CONTEXT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function FILE_Callback(hObject, eventdata, handles)
% hObject    handle to FILE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function NEW_DATABASE_Callback(hObject, eventdata, handles)
% hObject    handle to NEW_DATABASE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uiputfile

% --------------------------------------------------------------------
function LOAD_DATABASE_Callback(hObject, eventdata, handles)
% hObject    handle to LOAD_DATABASE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.mat','Select the database');
handles.dbfile = FileName;
handles.dbpath = PathName;
% load database
load([PathName,FileName]);

% determine which entries are valid
ValidDBentries = [];
curr = 1;
for i = 1:length(MD)
    if (~isempty(MD(i).Location))
        ValidDBentries = [ValidDBentries,i];
        AnimalListTmp{curr} = MD(i).Animal;
        curr = curr+1;
    end
end

% update animal text box
AllAnimals = unique(AnimalListTmp);

handles.animal_select_box.String = AllAnimals;
handles.animal_select_box.Value = [];

% clear date text box
handles.date_select_box.String = [];
handles.date_select_box.Value = [];

% clear session text box
handles.session_select_box.String = [];
handles.session_select_box.Value = [];

handles.MD = MD;
guidata(hObject,handles);


% --------------------------------------------------------------------
function add_session_button_Callback(hObject, eventdata, handles)
% hObject    handle to add_session_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% check if database loaded, if not, give error dialog and return
if (~isfield(handles,'MD'))
  errordlg('no database loaded','add session error');
  return;
end

% add entry to MD
sad = session_add_dialog;
uiwait(sad);

handles = guidata(hObject);

FileName = handles.dbfile;
PathName = handles.dbpath;

% backup old file
backupstr = ['! move ',PathName,FileName,' ',PathName,FileName,'.bak'];
display(backupstr)
eval(backupstr);

% save new MD
MD = handles.MD;
save([PathName,FileName],'MD');

% determine which entries are valid
ValidDBentries = [];
curr = 1;
for i = 1:length(MD)
    if (~isempty(MD(i).Location))
        ValidDBentries = [ValidDBentries,i];
        AnimalListTmp{curr} = MD(i).Animal;
        curr = curr+1;
    end
end

% update animal text box
AllAnimals = unique(AnimalListTmp);

handles.animal_select_box.String = AllAnimals;
handles.animal_select_box.Value = [];

% clear date text box
handles.date_select_box.String = [];
handles.date_select_box.Value = [];

% clear session text box
handles.session_select_box.String = [];
handles.session_select_box.Value = [];





% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1



% --- Executes on button press in queue_del_button.
function queue_del_button_Callback(hObject, eventdata, handles)
% hObject    handle to queue_del_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% remove selected (Value) entries from queuebox_MDidx
MD = handles.MD;
handles.queuebox_MDidx = setdiff(handles.queuebox_MDidx,handles.queuebox_MDidx(handles.queuebox.Value));

% compute new box string based off of new MDidx
curr = 1;
queuebox_strings = [];
for i = handles.queuebox_MDidx
    queuebox_strings{curr} = [int2str(curr),'. ',MD(i).Animal,'_',MD(i).Date,'_',int2str(MD(i).Session),' - ',MD(i).Env];
    curr = curr + 1;
end

handles.queuebox.Value = 1;
handles.queuebox.String = queuebox_strings;

handles.active_session_MDidx  = handles.queuebox_MDidx(1); 
handles.active_session_text.String = [MD(handles.active_session_MDidx).Animal,'_',MD(handles.active_session_MDidx).Date,'_',...
    int2str(MD(handles.active_session_MDidx).Session),' - ',MD(handles.active_session_MDidx).Env];

guidata(hObject,handles);

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function imagedisplaybox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imagedisplaybox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate imagedisplaybox


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


% --- Executes on button press in base_session_select.
function base_session_select_Callback(hObject, eventdata, handles)
% hObject    handle to base_session_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% spawns window for selecting base session
bsd = base_session_dialog;
uiwait(bsd);
handles = guidata(hObject);
i = handles.base_session_MDidx;
% fill in base session selection
MD = handles.MD;
handles.base_session_text.String = [MD(i).Animal,'_',MD(i).Date,'_',int2str(MD(i).Session),' - ',MD(i).Env];
guidata(hObject,handles);
