function varargout = untitled24(varargin)
% UNTITLED24 MATLAB code for untitled24.fig
%      UNTITLED24, by itself, creates a new UNTITLED24 or raises the existing
%      singleton*.
%
%      H = UNTITLED24 returns the handle to a new UNTITLED24 or the handle to
%      the existing singleton*.
%
%      UNTITLED24('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED24.M with the given input arguments.
%
%      UNTITLED24('Property','Value',...) creates a new UNTITLED24 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled24_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled24_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled24

% Last Modified by GUIDE v2.5 20-Dec-2021 11:56:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled24_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled24_OutputFcn, ...
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


% --- Executes just before untitled24 is made visible.
function untitled24_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled24 (see VARARGIN)

% Choose default command line output for untitled24
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled24 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled24_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function uipanel1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2
clc
clear all
load Observation_wb.mat
t = 0:1/16000:161424/16000;
f = 0:161424
f = (f*16000/161425)-8000
win = hann(512);
nfft = 512;
inc = 256;
shortfft = zeros(nfft/2+1,fix(size(X,1)/inc)+1,size(X,2));
a = 0;
for i = 0:inc:(size(X,1)-nfft);
    a = a+1;
    for j = 1:size(X,2);
        w = win.*X(i+1:i+nfft,j);
        t = fft(w,nfft);
        shortfft(:,a,j) = t(1:nfft/2+1);
    end
end
p_value = zeros(nfft/2+1,181);
for i = 1:(nfft/2+1)
    sfft = zeros(a,size(X,2));
    for j = 1:a
        for k = 1:4
            sfft(j,k) = shortfft(i,j,k);
        end
    end
    [c,b] = Pmusic_g(0.025,sfft,(i-1)/512*16000);
    for j = 1:181
      p_value(i,j) = 1./c(j);
    end
end
ans = zeros(181,1);
for i = 1:257
    ans(:,1) = ans(:,1) + p_value(i,:)';
end
ans = 257./ans;
axes12 = polaraxes;
polaraxes(axes12)
polarplot(b,real(10*log(ans')));
axes12.ThetaZeroLocation = 'top';
axes12.ThetaLim = [-90,90];
p_value=ans;
theta = -90:1:90;    
n_source = 2;
P_middle = abs(p_value(2:end-1));
P_front = abs(p_value(1:end-2));
P_back = abs(p_value(3:end));
logic_front = (P_middle - P_front)>0;
logic_back = (P_middle - P_back)>0;
logic = logic_front & logic_back;
P_middle(~logic) = min(P_middle);
P_local = [abs(p_value(1));P_middle;abs(p_value(end))];
[~,doa_Idx] = maxk(P_local,n_source);
doa = theta(doa_Idx);
[~,minIdx] = min(abs(doa));
doa_source = doa(minIdx);
[~,maxIdx] = max(abs(doa));
interfer = doa(maxIdx);
disp(['The desired source DOA with MUSIC is: ',num2str(doa_source),' deg']);
disp(['The interfering DOA with MUSIC is: ',num2str(interfer),' deg']);
while true
    if pushbutton2_Callback==1 
        break
    end
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pushbutton2_Callback =1
return
