%%%%%%%%%%%%%%%%%%%%%% GUI Initialisation and standard headers %%%%%%%%%%%%%%%%%%%%%%%%
function varargout = part3_gui(varargin)

% PART3_GUI MATLAB code for part3_gui.fig
%      PART3_GUI, by itself, creates a new PART3_GUI or raises the existing
%      singleton*.
%
%      H = PART3_GUI returns the handle to a new PART3_GUI or the handle to
%      the existing singleton*.
%
%      PART3_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PART3_GUI.M with the given input arguments.
%
%      PART3_GUI('Property','Value',...) creates a new PART3_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before part3_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to part3_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help part3_gui

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @part3_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @part3_gui_OutputFcn, ...
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
end

% --- Executes just before part3_gui is made visible.
function part3_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to part3_gui (see VARARGIN)
handles.output = hObject;   % Choose default command line output for part3_gui
guidata(hObject, handles);  % Update handles structure

axes(handles.axes1)
path1 = '/Users/chuzheng/Desktop/visual computing/reference case/2_NUS-EE5731-Visual-Computing-master/A1/assg1/h1.jpg';
img1 = imread(path1);
im1 = image(img1);
im1.ButtonDownFcn = @img1_clickFcn;
set(handles.panel_img1,'Title',path1)

axes(handles.axes2)
path2 = '/Users/chuzheng/Desktop/visual computing/reference case/2_NUS-EE5731-Visual-Computing-master/A1/assg1/h2.jpg';
img2 = imread(path2);
im2 = image(img2);
im2.ButtonDownFcn = @img2_clickFcn;
set(handles.panel_img2,'Title',path2)
end

% --- Outputs from this function are returned to the command line.
function varargout = part3_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

uiwait(gcf) % wait until four points are chosen

img1_mat = getpoints(handles,1);
img2_mat = getpoints(handles,2);
img1 = imread(get(handles.panel_img1,'Title'));
img2 = imread(get(handles.panel_img2,'Title'));
varargout{1} = img1_mat;
varargout{2} = img2_mat;
varargout{3} = img1;
varargout{4} = img2;
%delete(hObject);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

%%%%%%%%%%%%%%%%%%%%%%% Image clicks: Return four points  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function img1_clickFcn(hObject, eventdata, handles) 
    handles = guidata(hObject);

    currentpt = get(gca, 'CurrentPoint');
    row  = currentpt(1,2);
    col  = currentpt(1,1);
    
    idx1 = 1;
    output_handle = sprintf('im1_pt%d', idx1);
    colors = ['r', 'c', 'y', 'b'];
    while idx1 <= 4
        if not(strcmp(get(handles.(output_handle),'String'),""))    % if not empty (occupied)
            idx1 = idx1 + 1;
            output_handle = sprintf('im1_pt%d', idx1);
        else
            set(handles.(output_handle),'String',['Row = ', num2str(row), ', Column = ', num2str(col)]);
            hold on ; plot(col,row,'o','MarkerSize',5,'MarkerFaceColor', colors(idx1),'MarkerEdgeColor',colors(idx1)); drawnow; hold off;
            idx1 = 5;
        end
    end 
    
end

    
    
    
    
    
       
        
function img2_clickFcn(hObject, eventdata, handles)
    handles = guidata(hObject);

    currentpt = get(gca, 'CurrentPoint');
    row  = currentpt(1,2);
    col  = currentpt(1,1);
    
    idx1 = 1;
    output_handle = sprintf('im2_pt%d', idx1);
    colors = ['r', 'c', 'y', 'b'];
    while idx1 <= 4
        if not(strcmp(get(handles.(output_handle),'String'),""))    % if not empty (occupied)
            idx1 = idx1 + 1;
            output_handle = sprintf('im2_pt%d', idx1);
        else
            set(handles.(output_handle),'String',['Row = ', num2str(row), ', Column = ', num2str(col)]);
            hold on ; plot(col,row,'o','MarkerSize',5,'MarkerFaceColor', colors(idx1),'MarkerEdgeColor',colors(idx1)); drawnow; hold off;
            idx1 = 5;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Reset buttons: clears points %%%%%%%%%%%%%%%%%%%%%%%%%%%%
function reset1_Callback(hObject, eventdata, handles)
hold off;
handles = guidata(hObject);
for i = 1:4
    index = sprintf('im1_pt%d',i);
    handles.(index).String = "";
end
axes(handles.axes1)
path1 = get(handles.panel_img1,'Title');
img1 = imread(path1);
im1 = image(img1);
im1.ButtonDownFcn = @img1_clickFcn;
end

function reset2_Callback(hObject, eventdata, handles)
hold off;
handles = guidata(hObject);
for i = 1:4
    index = sprintf('im2_pt%d',i);
    handles.(index).String = "";
end
axes(handles.axes2)
path2 = get(handles.panel_img2,'Title');
img2 = imread(path2);
im2 = image(img2);
im2.ButtonDownFcn = @img2_clickFcn;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%% Calculate and swap buttons %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function calculate_Callback(hObject, eventdata, handles)

handles = guidata(hObject);
 
idx = 1;
while idx <= 4
   output_handle_img1 = sprintf('im1_pt%d', idx);
   output_handle_img2 = sprintf('im2_pt%d', idx);
   if not(strcmp(get(handles.(output_handle_img1),'String'),"")) && not(strcmp(get(handles.(output_handle_img2),'String'),""))
       idx = idx + 1; % In the n-th iteration, check if the n-th point in image 1&2 are chosen. 
                      % If points are chosen, then proceed to the next point until the 4th. 
   else
       f = warndlg('Please choose 4 points in each image','Error');
       return;
   end
end

uiresume(gcbf); % GUI returns data back to main file. "Resume" calculation in main file.
  
end

function swap_Callback(hObject, eventdata, handles)
% hObject    handle to reset2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hold off;
handles = guidata(hObject);
reset1_Callback(hObject,eventdata,handles);
reset2_Callback(hObject,eventdata,handles); % clear 8 points

path1 = get(handles.panel_img1,'Title');
path2 = get(handles.panel_img2,'Title');
set(handles.panel_img1,'Title',path2);
set(handles.panel_img2,'Title',path1); % swap displayed images

axes(handles.axes1)
img1 = imread(path2);
im1 = image(img1);
im1.ButtonDownFcn = @img1_clickFcn; % trigger click fcn to re-choose 4 points for each image

axes(handles.axes2)
img2 = imread(path1);
im2 = image(img2);
im2.ButtonDownFcn = @img2_clickFcn;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%% Getpoints function to return the chosen 8 coordinates %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mat = getpoints(handles,num)
    mat = zeros(3,4);
    for i = 1:4
        index = sprintf('im%d_pt%d',num,i); % return these 4 points in each two image
        s = get(handles.(index),'String'); % find them in handles variable
        com = strfind(s,',');
        equ = strfind(s,'=');
        row = str2num(s(equ(1,1)+2 : com-1));
        col = str2num(s(equ(1,2)+2 : end));
        mat(:,i) = [col ; row ; 1];
    end
end


function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
keyboard
end
