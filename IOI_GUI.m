function varargout = IOI_GUI(varargin)
% IOI_GUI MATLAB code for IOI_GUI.fig
%      IOI_GUI, by itself, creates a new IOI_GUI or raises the existing
%      singleton*.
%
%      H = IOI_GUI returns the handle to a new IOI_GUI or the handle to
%      the existing singleton*.
%
%      IOI_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IOI_GUI.M with the given input arguments.
%
%      IOI_GUI('Property','Value',...) creates a new IOI_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IOI_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IOI_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IOI_GUI

% Last Modified by GUIDE v2.5 19-Apr-2018 10:18:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IOI_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @IOI_GUI_OutputFcn, ...
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


% --- Executes just before IOI_GUI is made visible.
function IOI_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IOI_GUI (see VARARGIN)

% Choose default command line output for IOI_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes IOI_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = IOI_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in Select_a_folder.
function Select_a_folder_Callback(hObject, eventdata, handles)
% hObject    handle to Select_a_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
constraint_filedir = [uigetdir('/Users/weikanglin/GitHub/IOI/batch') '/'];

set(handles.Messages,'string',' ');
set(handles.Show_folder, 'string', constraint_filedir);

margfiles = dir(fullfile(constraint_filedir, '*.margestats'));
Num_exp = length(margfiles);

if Num_exp<2
    ErrorMessage = sprintf(['Error: \n' ...
                'At least two constraints are required.\n']);
            disp(ErrorMessage)
    set(handles.Messages,'string',ErrorMessage);
    return        
end

exp_names = string(Num_exp);
for i=1:Num_exp
    exp_names(i) = erase(margfiles(i).name,'.margestats');
end
set(handles.List_of_Constraints, 'string', exp_names);
set(handles.Constraint_selected_list, 'string', exp_names);

for i = 1:Num_exp
    fileID = fopen([constraint_filedir margfiles(i).name]);
    Marg_header = fgets(fileID);
    Marg_header = fgets(fileID);
    Marg_header = fgets(fileID);
    All_params = textscan(fileID,'%s %*[^\n]');
    if i==1
        Common_Params = All_params{1};
    end
    common_index = ismember(Common_Params, All_params{1});
    Common_Params = Common_Params(common_index);
end
set(handles.List_of_Parameters, 'string', Common_Params);

Num_com_param = length(Common_Params);

txt = sprintf(['There are totally ' num2str(Num_exp) ' constraints and '...
    num2str(Num_com_param)  ' common parameters (including derived)\n']);
set(handles.Messages,'string',txt)

handles.constraint_filedir=constraint_filedir;
handles.margfiles=margfiles;
handles.exp_names=exp_names;
guidata(hObject,handles);



function Show_folder_Callback(hObject, eventdata, handles)
% hObject    handle to Show_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Show_folder as text
%        str2double(get(hObject,'String')) returns contents of Show_folder as a double


% --- Executes during object creation, after setting all properties.
function Show_folder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Show_folder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in List_of_Constraints.
function List_of_Constraints_Callback(hObject, eventdata, handles)
% hObject    handle to List_of_Constraints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns List_of_Constraints contents as cell array
%        contents{get(hObject,'Value')} returns selected item from List_of_Constraints
index_selected = get(hObject,'Value');
list = get(hObject,'String');
Constraint_selected = list(index_selected); 
set(handles.Constraint_selected_list,'string',Constraint_selected);
handles.exp_names = Constraint_selected;
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function List_of_Constraints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to List_of_Constraints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in List_of_Parameters.
function List_of_Parameters_Callback(hObject, eventdata, handles)
% hObject    handle to List_of_Parameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns List_of_Parameters contents as cell array
%        contents{get(hObject,'Value')} returns selected item from List_of_Parameters
index_selected = get(hObject,'Value');
list = get(hObject,'String');
Param_selected = list(index_selected); 
set(handles.Selected_Param_List,'string',Param_selected);
handles.Param_selected = Param_selected;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function List_of_Parameters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to List_of_Parameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Caculate_IOI.
function Caculate_IOI_Callback(hObject, eventdata, handles)
% hObject    handle to Caculate_IOI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Params = handles.Param_selected;
Outfile = 'IOIs.txt';
ParamDim = length(Params);
%%%%%% Find the common parameters
constraint_filedir = handles.constraint_filedir;
margfiles=handles.margfiles;
exp_names=handles.exp_names;
Num_exp = length(exp_names);
for i = 1:Num_exp
    fileID = fopen([constraint_filedir margfiles(i).name]);
    Marg_header = fgets(fileID);
    Marg_header = fgets(fileID);
    Marg_header = fgets(fileID);
    All_params = textscan(fileID,'%s %*[^\n]');
    if i==1
        Common_Params = All_params{1};
    end
    common_index = ismember(Common_Params, All_params{1});
    Common_Params = Common_Params(common_index);
end

Num_com_param = length(Common_Params);

%%%%%% Extract mu and C from files
C = zeros(ParamDim,ParamDim,Num_exp);
mu = zeros(ParamDim,Num_exp);
sigma = zeros(ParamDim,Num_exp);
index = zeros(ParamDim,1);

delimiterIn = ' ';
headerlinesIn = 1;

for i = 1:Num_exp
    fileID = fopen([constraint_filedir margfiles(i).name]);
    Marg_header = fgets(fileID);
    Marg_header = fgets(fileID);
    Marg_header = fgets(fileID);
    meat = textscan(fileID,'%s %f %f %*[^\n]');
    for k = 1:ParamDim
        index(k) = 1;
        str=meat{1};
        NotFound = true;
        for ii=1:length(meat{1})
            if (strcmp(str{ii},Params{k}) == 1|strcmp(str{ii},[Params{k},'*']) == 1)
                index(k) = ii;
                NotFound = false;
            end
        end
        if NotFound == true
            ErrorMessage = sprintf(['Error: \n' ...
                Params{k} ' is not in experiment: ' exp_names{i}]);
            disp(ErrorMessage)
            return
        end
        mu(k,i) = meat{2}(index(k));    
        sigma(k,i) = meat{3}(index(k));   
    end
    fclose(fileID);
    
    Corr = importdata([constraint_filedir exp_names{i} '.corr']);
    offset = 0;
    for ii=1:length(Corr)
        if Corr(ii-offset,1)==0.0
           Corr(ii-offset,:) = [];
           Corr(:,ii-offset)  = [];
           offset = offset+1;
        end
    end   
    Corr_select = Corr([index],[index]);
    for n=1:ParamDim
        for m=1:ParamDim
            C(n,m,i) = sigma(n,i).*Corr_select(n,m)*sigma(m,i);
        end
    end
end


%%%%%% calculating all the two-experiment IOIs
IOI = zeros(Num_exp,Num_exp-1);
for i = 1: Num_exp
    for j = (i+1):Num_exp
        IOI(i,j) = 0.5*(mu(:,i)-mu(:,j))'*(C(:,:,i)+C(:,:,j))^-1*(mu(:,i)-mu(:,j));
        IOI(j,i) = IOI(i,j);
    end
end


%%%%%% Saving the results in a matrix for
fileID = fopen(Outfile,'w');
fprintf(fileID,'%18s',' ');
fprintf(fileID,'%18s',exp_names{:});
for i=1:Num_exp
    fprintf(fileID,'\n');
    fprintf(fileID,'%18s',exp_names{i});
    fprintf(fileID,'%18.2f',round(IOI(i,:),2));
end

FishingMessage = sprintf(['Finished: \n' ...
    'Two-experiment IOIs have been saved in ' Outfile '.\n']);
set(handles.Messages,'string',FishingMessage)
 
fclose(fileID);



function Messages_Callback(hObject, eventdata, handles)
% hObject    handle to Messages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Messages as text
%        str2double(get(hObject,'String')) returns contents of Messages as a double


% --- Executes during object creation, after setting all properties.
function Messages_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Messages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Selected_Param_List_Callback(hObject, eventdata, handles)
% hObject    handle to Selected_Param_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Selected_Param_List as text
%        str2double(get(hObject,'String')) returns contents of Selected_Param_List as a double


% --- Executes during object creation, after setting all properties.
function Selected_Param_List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Selected_Param_List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Constraint_selected_list_Callback(hObject, eventdata, handles)
% hObject    handle to Constraint_selected_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Constraint_selected_list as text
%        str2double(get(hObject,'String')) returns contents of Constraint_selected_list as a double


% --- Executes during object creation, after setting all properties.
function Constraint_selected_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Constraint_selected_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
