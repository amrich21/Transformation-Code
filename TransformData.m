function varargout = TransformData(varargin)
% TRANSFORMDATA MATLAB code for TransformData.fig
%      TRANSFORMDATA, by itself, creates a new TRANSFORMDATA or raises the existing
%      singleton*.
%
%      H = TRANSFORMDATA returns the handle to a new TRANSFORMDATA or the handle to
%      the existing singleton*.
%
%      TRANSFORMDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRANSFORMDATA.M with the given input arguments.
%
%      TRANSFORMDATA('Property','Value',...) creates a new TRANSFORMDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TransformData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TransformData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TransformData

% Last Modified by GUIDE v2.5 20-Dec-2018 04:24:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TransformData_OpeningFcn, ...
                   'gui_OutputFcn',  @TransformData_OutputFcn, ...
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
clc; clear; 

% --- Executes just before TransformData is made visible.
function TransformData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TransformData (see VARARGIN)

% Choose default command line output for TransformData
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TransformData wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global DataFolder defaultCalibration estimatedOrientation impacts
global sport rawFolder baselineFolder calFolder devices transformationInfo tFolder impactTimes

defaultCalibration = 0;
estimatedOrientation = 0;

% --- Outputs from this function are returned to the command line.
function varargout = TransformData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in defaultCalibration_checkbox.
function defaultCalibration_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to defaultCalibration_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global defaultCalibration
tempHand = findobj('Tag','defaultCalibration_checkbox');
if get(tempHand,'Value')
    defaultCalibration = 1;
end
% Hint: get(hObject,'Value') returns toggle state of defaultCalibration_checkbox


% --- Executes on button press in estimatedOrientation_checkbox.
function estimatedOrientation_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to estimatedOrientation_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global estimatedOrientation
tempHand = findobj('Tag','estimatedOrientation_checkbox');
if get(tempHand,'Value')
    estimatedOrientation = 1;
end
% Hint: get(hObject,'Value') returns toggle state of estimatedOrientation_checkbox

% --- Executes during object creation, after setting all properties.
function sport_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sport_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in sport_popup.
function sport_popup_Callback(hObject, eventdata, handles)
% hObject    handle to sport_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sport
contents = cellstr(get(hObject,'String'));
sport = contents{get(hObject,'Value')};
% Hints: contents = cellstr(get(hObject,'String')) returns sport_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sport_popup

% --- Executes on button press in selectDataFolder_pushbutton.
function selectDataFolder_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to selectDataFolder_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% adding folders to path
addpath('\\medctr\dfs\cib$\shared\02_projects\mouthpiece_data_collection\00_MATLAB_Code\functions');

global DataFolder defaultCalibration estimatedOrientation sport rawFolders rawFolder baselineFolder calFolder devices transformationInfo tFolder impactTimes impacts

%% Initialize
DataFolder = uigetdir('\\medctr\dfs\cib$\shared\02_projects\mouthpiece_data_collection');

%% Format raw data into structure/array of impacts
FormatInputData
CalibrateData
GetTransformationInfo
CalculateTransformedData