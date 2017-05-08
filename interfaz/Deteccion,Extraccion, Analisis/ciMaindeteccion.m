function varargout = ciMaindeteccion(varargin)
% CIMAINDETECCION M-file for ciMaindeteccion.fig
%      CIMAINDETECCION, by itself, creates a new CIMAINDETECCION or raises the existing
%      singleton*.
%
%      H = CIMAINDETECCION returns the handle to a new CIMAINDETECCION or the handle to
%      the existing singleton*.
%
%      CIMAINDETECCION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CIMAINDETECCION.M with the given input arguments.
%
%      CIMAINDETECCION('Property','Value',...) creates a new CIMAINDETECCION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ciMaindeteccion_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ciMaindeteccion_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ciMaindeteccion

% Last Modified by GUIDE v2.5 12-Jun-2009 15:05:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ciMaindeteccion_OpeningFcn, ...
                   'gui_OutputFcn',  @ciMaindeteccion_OutputFcn, ...
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


% --- Executes just before ciMaindeteccion is made visible.
function ciMaindeteccion_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ciMaindeteccion (see VARARGIN)

% Choose default command line output for ciMaindeteccion
handles.output = hObject;

%--------------------------------------------------------
% INICIALIZACIÓN
% Cargando la dirección del path del kernel
 run('.../addPathToKernel');

% strdirmat es la dirección del último acceso al disco en la extraxion de la
% matriz de aprendizaje
strdirmat = '...';
data.strdirmat = strdirmat;

% strdir es la dirección del último acceso al disco en la aprtura de la
% imagen
strdir = '...';
data.strdir = strdir;

% guardando los datos en la figura
set(hObject,'UserData',data);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ciMaindeteccion wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ciMaindeteccion_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%--------------------------------------------------------------------------
% CARGAR LAS TEXTURAS CONOCIDAS
% Executes on button press in pushbutton2.
%--------------------------------------------------------------------------
function pushbutton2_Callback(hObject, eventdata, handles)
%
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Obteniendo el handle y los datos de la figura
f    = handles.figure1;
data = get(f,'UserData');

% Obteniendo dirección de la última apertura
strdir = data.strdirmat;

% Apertura del fichero en la memoria
File = {'*.mat','database (*.mat)'};
[Filename, Pathname] = uigetfile(File,'Abrir',strdir);

% Si la direccion existe
if Filename

    % Dirección de entrada
    dirstar = fullfile(Pathname, Filename);
    data.strdirmat = dirstar;

    % Copiar la direccion en el label
    htext = handles.text20;
    set(htext,'String',Pathname);


    if  isfield(data,'mind')

        % Confirmar la selección
        button = questdlg('El conocimiento anterior se reescribirá',...
            'Confirmación','No');
        if strcmp(button,'No')
        return;
        end

    end

    % Leyendo de la memoria externa
    memo   = load(dirstar);
    campos = fieldnames(memo);

    % Chequear que el fichero tenga todos los campos
    % id del archivo 55511
    if ~isfield(memo,'id') || memo.id ~= 55511
        errordlg('Archivo no compatible','Error de fichero');
        return;
    end


    % Asignarle la estructura a los datos de figura1
    hbarra = waitbar(0,'Cargando...');

    n = length(campos);
    for i=2:n
        data.(campos{i}) = memo.(campos{i});
        x = i/n;
        waitbar(x,hbarra,['Cargando: ' campos{i} ' ' mat2str(fix(x*100)) '% ...']);
        pause(.1);
    end

    % Eliminando el handle
    close(hbarra);

    % Copiando los datos en la figura
    set(f,'UserData',data);



end

%FIN DE CARGAR TEXTURA
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% ABRIR IMAGEN ORIGINAL
% --- Executes on button press in pushbutton3.
%--------------------------------------------------------------------------
function pushbutton3_Callback(hObject, eventdata, handles)
%
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Obteniendo el handle y los datos de la figura 
f    = handles.figure1;
data = get(f,'UserData');

% Obteniendo dirección de la última apertura
if isfield(data,'strdir')
strdir = data.strdir;
else
strdir = ' ';
end


% Tipo de fichero
File = {'*.jpg','JPEG (*.jpg)';...
        '*.bmp','Archivo de mapa de bits (*.bmp)';...        
        '*.tif' ,'TIF  (*.tif)'; ...
        '*.*'  ,'Todos los archivos (*.*)';...
        };    
    
% Obteniendo la dirección
[FileName,PathName] = uigetfile(File,'Abrir',strdir);


if FileName
    
    
    % Reajustando los datos 
    if isfield(data,'rasgos')
    data = rmfield(data, 'rasgos');       
    end 
    
    % Creando dirección
    strdir = fullfile(PathName,FileName);
    data.strdir = strdir; 
    
    % Copiar la direccion en el label
    htext = handles.text21;
    set(htext,'String',PathName);
    
    
    % Obtener abcisa
    haxis = handles.axesdisplay;
    set(haxis,'Visible','on');
    axes(haxis);
    
    % Obtención de la imagen
    I = imread(strdir);
    data.imageorg =  I;     
    
    % Mostrar en el display de procesamiento
    imshow(I);
    drawnow
    
    % Guardando la imagen en la figura en escala de grises
    I = rgb2gray(I);
    data.image = I;   
        
    % Guardando los datos en la figura
    set(f,'UserData',data);
    
end

% FIN DE LA APERTURA
%--------------------------------------------------------------------------




%--------------------------------------------------------------------------
% PROCESO DE DETECCION, EXTRACION Y ANALISIS
% --- Executes on button press in pushbutton10.
%--------------------------------------------------------------------------
function pushbutton10_Callback(hObject, eventdata, handles)
%
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%--------------------------------------------------------------------------
%INICIALIZACION DE VARIABLES

% Selección del algoritmo de clasificación a emplear
hppmenu  = handles.popupmenu2;
contents = get(hppmenu,'String');
detect   = contents{get(hppmenu,'Value')};


% Selección del algoritmo de segmentación a emplear
hppmenu  = handles.popupmenu1;
contents = get(hppmenu,'String');
segment   = contents{get(hppmenu,'Value')};


% Obtener el handle y los datos de la figura
f    = handles.figure1;
data = get(f,'UserData');

% Obtener la imagen a procesar 
I = data.image;
[height,width] = size(I);

haxes = handles.axesdisplay;
axes(haxes);
imshow(I);

%haxes = handles.axesgraf;
%axes(haxes);

% Abriendo el handle de la barra de estado
hbarra = waitbar(0,' ... 0%','WindowStyle','modal');


%--------------------------------------------------------------------------
%VALIDANDO LOS DATOS

if isfield(data,{'image','matriz' })
% codigo de error
return;
end


%--------------------------------------------------------------------------
% EXTRACCIÓN DE CARACTERÍSTICAS DE LA IMAGEN BASADO EN EL CONOCIMIENTO 
% ADQUIRIDO

if ~isfield(data,'rasgos')

    % obtener conocimiento de los datos de la figura
    dim    = data.sizewnd;
    caract = data.caract;

    % Extracción de características usando un algoritmo de ventana 
    % deslizante. Se realizará la extracción en ventanas de tamaño 
    % dim (donde dim tiene que ser impar) y asignándolas al  pixel 
    % central.
    
    h = true(dim);
    [X,caract,t] = vwndpass(I,h,caract,hbarra);

    % Guardando los datos obtenidos en la extructura data
    data.rasgos = X;
    data.caract = caract;
    
    % Guardar los datos en la figura
    set(f,'UserData',data);
    
else
    
    % Copiando las caracteristicas calculadas
    X = data.rasgos;
    caract =  data.caract;

end


%--------------------------------------------------------------------------
% DETECCIÓN DE LOS OBJETOS EN LA IMAGEN

% Obtener matriz de aprendizaje adquirida
MA = data.matrz;
K  = data.clases;


if 0
% Selección del algoritmo de detección 
if strcmp(detect,'Votacion')
    
    % Aplicar el algoritmo de clasificación votacion
    % Umbral de semejanza
    %Eps = realmax;
    Landa = 1.0;
    [G,C] = vvotacion(MA,K,X,caract,Landa,hbarra);

else 
    
    % Umbral de semejanza
    Eps = realmax;
    %Eps = 10.0;
    
    % Obtener la cantidad de vecinos
    k = sum(K==2);
    k = k - fix(k/2);
    
    
    % Aplicar el algoritmo de clasificación knn
    [G,C] = vknn(MA,K,X,k,Eps,caract,hbarra);
    data.G = G;
    data.C = C;
    
    % Guardar los datos en la figura
    set(f,'UserData',data);

end

end

G = data.G;
%C = X.C;

% Creando una imagen binaria tal que los objetos detectados sean igual a uno 
% y los demás cero
layer = (G==2);

% Guardando layer en los datos de la figura
data.layer  = layer;

% Redimencionando el layer
layer = reshape(layer,height,width);
data.layerdetect = layer;

% Cerrando el handle de la barra
close(hbarra); 



%--------------------------------------------------------------------------
% MOSTRANDO RESULTADOS PRELIMINARES DE DETECCIÓN 
haxes = handles.axesdisplay;
axes(haxes);

IM = I;
IM(layer) = 0;
%imshow(IM);
drawnow


%--------------------------------------------------------------------------
%PROCESO DE SEGMENTACIÓN DE LA IMAGEN
startTime = cputime;
switch segment

     
    % Segmentación por el método Fast Marching
    case 'FastMarching'
        
        
        % Obtener la detección de los objetos de la imagen
        layer = data.layer;
        
        % Calcular la velocidad para la propagación 
        vEps  = 0.1;
        spd   = getspeed(I,vEps);
        %imshow(spd);
        
        % Umbral de los valores de T en el frente
        dT  = 5.0;
                
        % Aplicando el método Fast Marching para segmentar imagenes
        front0  = layer;
        maxiter = 1e+8;
        maxT    = 1000;        
        [layer,tcell] = fastmarching(front0,spd,dT,maxiter,maxT);
        
        %---------------------------
        haxes = handles.axesdisplay;
        axes(haxes);

        IM = I;
        %imshow(IM);
        drawnow
        
        % Mostrando el level set cero 
        level = 0;
        displayType = 'contour';        
        h = visualizeLevelSet(layer, displayType, level);

        % Reconstruyendo layer
        %layer = tcell==1; %0
        
        ptr0 = getFrontCurv(layer);       
        layer = zeros(size(layer));
        layer(cell2mat(ptr0)) = 1;        
        data.layerdetect = layer;
        
       
        
    % Segmentación por el método Level Set    
    case 'LevelSet'
        
        % Obteniendo los grupos de la imagen representados en una capa
        % layer = data.layer;
        layer0 = distSigned(layer);
       
        % Obtener la figura correcta.
        %level = 0;
        %displayType = 'surf';
        %t0 = 0;
        %h = visualizeLevelSet(layer0, displayType, level);
        
        % Obtener la velocidad 
        spd   = getspeed(I);
        %imshow(spd);
       
        % Obtener el epsilon para la condición de parada del level set
        Eps  = 0.003;
               
        % Obtener el maximo de iteraciones para el level set
        %maxiter  = 1e+6;
         maxiter  = 5000;
        
        % Se reajustará la curva hasta que se pegue lo más posible a los bordes
        layer = levelSet(spd,layer0,maxiter,Eps);

        % Obtener la figura correcta.
        level = 0;
        displayType = 'contour';
        t0 = 0;
        h = visualizeLevelSet(layer, displayType, level);
        
        layer = layer>=0;
        ptr0 = getFrontCurv(layer);
        
        %layer = zeros(size(layer));
        layer(cell2mat(ptr0)) = 1;
        data.layerdetect = layer;
        %imshow(layer);

   
    % Segmentación combinando Fast Marching y LevelSet
    case 'FastMarching,LevelSet'
           
        % Obtener la detección de los objetos de la imagen
        layer = data.layer;
        
        
        % Calcular la velocidad para la propagación 
        vEps  = 0.5;
        spd   = getspeed(I,vEps);
        
        % Umbral de los valores de T en el frente
        dT  = 5.0;
        
        % Aplicando el método Fast Marching para segmentar imagenes
        front0  = layer;
        maxiter = 1e+8;
        maxT    = 200;
        [layer,tcell] = fastmarching(front0,spd,dT,maxiter,maxT);
        
        
        % Mostrando el level set cero 
        level = 0;
        displayType = 'contour';        
        h = visualizeLevelSet(layer, displayType, level);

        % Reconstruyendo layer
        layer = tcell==0; 
        layer0 = distSigned(layer);
        
        % Obtener la velocidad 
        spd   = getspeed(I);
        
        % Obtener el epsilon para la condición de parada del level set
        Eps  = 0.004;
                
        % Obtener el maximo de iteraciones para el level set
        maxiter  = 1e+6;
        
        % Se reajustará la curva hasta que se pegue lo más posible a los bordes
        layer = levelSet(spd,layer0,maxiter,Eps);

        % Obtener la figura correcta.
        level = 0;
        displayType = 'contour';
        t0 = 0;
        h = visualizeLevelSet(layer, displayType, level);
        
        layer = layer>=0%layer<0;
        ptr0 = getFrontCurv(layer);
        
        %layer = zeros(size(layer));
        layer(cell2mat(ptr0)) = 1;
        data.layerdetect = layer;
                   
end

endTime = cputime;
totalTime = endTime - startTime; 
disp(totalTime);

%--------------------------------------------------------------------------
% ANALISIS MORFOLOGICO DE LOS OBJETOS DE LA IMAGEN



% obteniendo los grupos de la imagen representados en una capa
BW = data.layerdetect;
%imshow(BW);
[CSF,ESF,CENT] = calcPropiedades(BW);

% Análisis de la forma de los objetos en cuanto a su esfericidad 
ELONG = ESF < 0.5;             % deformadas alargadas
OTRAS = ESF > 0.5 & CSF < 0.8; % deformadas poco alargadas en las que se incluyen estrellada y hoja
DISC  = ESF > 0.5 & CSF > 0.8; % se considera discoidales normales

% Actualizando los indicadores 
htext = handles.text23;
cant  = sum(DISC);
set(htext,'string',num2str(cant));

htext = handles.text27;
cant  = sum(ELONG);
set(htext,'string',num2str(cant));

htext = handles.text26;
cant  = sum(OTRAS);
set(htext,'string',num2str(cant));

htext = handles.text25;
cant  = sum(OTRAS)+ sum(ELONG) + sum(DISC);
set(htext,'string',num2str(cant));

haxes = handles.axesdisplay;
axes(haxes);


hold on
hp = plot(haxes,...
     CENT(DISC,1) , CENT(DISC,2) , 'ro', ...
     CENT(ELONG,1), CENT(ELONG,2), 'g*', ...
     CENT(OTRAS,1), CENT(OTRAS,2), 'm+'); 
hold off


haxes = handles.axesgraf;
axes(haxes);



%hold on
hp = plot(haxes,...
        CSF(DISC) ,ESF(DISC)  ,'ro', ...
        CSF(ELONG),ESF(ELONG) ,'g*',...
        CSF(OTRAS),ESF(OTRAS) ,'m+');
    
set(haxes,...    
    'xcolor',[0.682 0.467 0],...
    'ycolor',[0.682 0.467 0],...
    'color',[0.439 0 0],... 
    'Box',  'off'...
);    
%hold off


set(get(haxes,'XLabel'),'String','CSF','fontsize',7,'Position',[0.75 -0.1]);
set(get(haxes,'YLabel'),'String','ESF','fontsize',7,'Position',[-0.1 0.75]);

line([.8 .8],[.0 1.5],'LineStyle','-','Color',[0.682 0.467 0.0]);
line([.0 1.5],[.5 .5],'LineStyle','-','Color',[0.682 0.467 0.0]);



% FIN DEL PROCESO
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% ZOOM
% --- Executes on button press in pushbutton4.
%--------------------------------------------------------------------------
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

zoom on;

%--------------------------------------------------------------------------
% PAN
% --- Executes on button press in pushbutton5.
%--------------------------------------------------------------------------
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pan on;

%--------------------------------------------------------------------------
% TABLA
% --- Executes on button press in pushbutton6.
%--------------------------------------------------------------------------
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
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


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

f = handles.figure1;
cpoint = get(f,'CurrentPoint');

htextx  = handles.textx;
htexty  = handles.texty;
   
set(htextx,'string',mat2str(cpoint(1)));
set(htexty,'string',mat2str(cpoint(2)));

