function varargout = ciMainEntrenamiento(varargin)
% CIMAINENTRENAMIENTO M-file for ciMainEntrenamiento.fig
%      CIMAINENTRENAMIENTO, by itself, creates a new CIMAINENTRENAMIENTO or raises the existing
%      singleton*.
%
%      H = CIMAINENTRENAMIENTO returns the handle to a new CIMAINENTRENAMIENTO or the handle to
%      the existing singleton*.
%
%      CIMAINENTRENAMIENTO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CIMAINENTRENAMIENTO.M with the given input arguments.
%
%      CIMAINENTRENAMIENTO('Property','Value',...) creates a new CIMAINENTRENAMIENTO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ciMainEntrenamiento_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ciMainEntrenamiento_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ciMainEntrenamiento

% Last Modified by GUIDE v2.5 12-Apr-2007 21:17:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ciMainEntrenamiento_OpeningFcn, ...
                   'gui_OutputFcn',  @ciMainEntrenamiento_OutputFcn, ...
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


% --- Executes just before ciMainEntrenamiento is made visible.
function ciMainEntrenamiento_OpeningFcn(hObject, eventdata, handles, varargin)
%
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ciMainEntrenamiento (see VARARGIN)

% Choose default command line output for ciMainEntrenamiento
handles.output = hObject;

%--------------------------------------------------------
% INICIALIZACIÓN
% Cargando la dirección del path del kernel
run('.../addPathToKernel');

% Dirección del último acceso al disco duro
strdir = '...';
data.strdir = strdir;
set(hObject,'UserData',data);

% Creando un puntero
layer = handles.uipanel3;
hcurse = datacursormode(hObject);
set(hcurse,...
    'UpdateFcn',{@cursor1_Callback,hObject,layer},...
    'Enable','off');
handles.hcurse = hcurse;

% Redimensionando la tabla
htabla = handles.htablaest;
set(htabla,'Position',[0 0 600 450]');


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ciMainEntrenamiento wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ciMainEntrenamiento_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



%--------------------------------------------------------------------------
% ABRIR IMANGEN ...
% Executes on button press in pushbutton1.
%--------------------------------------------------------------------------
function pushbutton1_Callback(hObject, eventdata, handles)
%
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Obteniendo el handle y los datos de la figura 
f    = handles.figure1;
olddata = get(f,'UserData');

% Obteniendo dirección de la última apertura
if isfield(olddata,'strdir')
strdir = olddata.strdir;
else
strdir = ' ';
end

% Desactivar el cursor
hcurse = handles.hcurse;
set(hcurse,'Enable','off');

% Actualizando la barra de acción
htext = handles.textaccion;
set(htext,'string','ABRIR IMAGEN...');

% Tipo de fichero
File = {'*.jpg' ,'JPEG (*.jpg)';...
        '*.bmp' ,'BMP  (*.bmp)';...       
        '*.*'   ,'Todos los archivos (*.*)';...
        };  
    
% Abriendo fichero    
[FileName,PathName] = uigetfile(File,'Abrir',strdir);

if FileName 
    
    % Reajustando los datos 
    if isfield(olddata,'mind')
    data.mind = olddata.mind;          
    end 
    
    
    % creando dirección
    strdir = fullfile(PathName,FileName);
    data.strdir = strdir; 
    
    % Obtención de la imagen
    I = imread(strdir);
    data.imageorg = I; 
    
    % Mostrando la imagen original
    axes(handles.axes2)
    imshow(I);
        
    % Guardando la imagen en la figura en escala de grises
    I = rgb2gray(I);
    data.image = I;   
    
    
    % Display de procesamiento
    % Convirtendo imagen a escala de grises y mostrarla       
    axes(handles.axesdisplay)
    imshow(I);  

    % actualizando los datos de la figura
    set(f,'UserData',data);
    
end

% FIN DE LA APERTURA
% /////--------------------------------------------------------------------


%--------------------------------------------------------------------------
% CHEQUEO DEL EDITOR PARA LAS DIMENSIONES
% Executes during the process of edit
%--------------------------------------------------------------------------
function editdim_Callback(hObject, eventdata, handles)
%
% hObject    handle to editdim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editdim as text
%        str2double(get(hObject,'String')) returns contents of editdim as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
	errordlg('Debe entrar un valor numérico','Bad Input','modal')
    set(hObject,'string','');
	return
end


% Executes during object creation, after setting all properties.
function editdim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editdim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% FIN DEL CHEQUEO
% /////--------------------------------------------------------------------


%--------------------------------------------------------------------------
% EXTRAER CARACTERÍSTICAS DE LA IMAGEN
% Executes on button press in pushbutton12.
%--------------------------------------------------------------------------
function pushbutton12_Callback(hObject, eventdata, handles)
%
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% En el proceso de extracción de características se seleccionan las características 
% a extraer así como el tamaño de la ventana de observación. Para esta versión 
% las características a extraer son las estadísticas de primer orden
% dependientes del n-ésimo momento; de segundo orden dependientes de la
% matriz de co-ocurrencia y espectrales a partir de un banco de filtros de
% gabor
%

% Obteniendo las características seleccionadas del listbox ...
hppmenu  = handles.popupmenucaract;
contents = get(hppmenu,'String');
numcomb  = get(hppmenu,'Value');
caract   = contents{numcomb};
caract   = strread(caract,'%s','delimiter',',');


% Obteniendo las dimensiones de la ventana de observación. Las dimensiones
% de esta deberán ser impar ...
hedit  = handles.editdim;
dim     = str2num(get(hedit,'String'));

% Chequeando que las dimensiones de la ventana sean impar
if isempty(dim) || mod(dim,2) == 0

    % Limpiando el edit    
    hedt = handles.editdim;
    set(hedt,'string',' ');
    
    % Mensaje de advertencia 
    warndlg('Las dimensiones deben ser impar','!! Advertencia !!');
    return;
    
end

% Obteniendo el handle de la figura y sus datos
f = handles.figure1;
data = get(f,'UserData');

% Actualizando la barra de acción
htext = handles.textaccion;
set(htext,'string','EXTRAER ...');

% Obteniendo imagen a procesar
I = data.image;

% Ocultando el texto de la barra de estado
htext = handles.textbestatdo;
set(htext,'visible','off');

h = true(dim);
if strcmp(caract,'Todos')
[X,caract,t] = vwndpass(I,h);
else
[X,caract,t] = vwndpass(I,h,caract);    
end

% Mostrando el texto por defecto de la barra de estado
set(htext,'visible','on');
pause(.1);

% Mostrando imagen en el display de la figura
axes(handles.axesdisplay);
imshow(I);

% Mostrando el tiempo total de la cpu 
hlabel  = handles.texttcpu;
set(hlabel,'String',num2str(t));

% Mostrando el tiempo actual de la cpu 
hlabel  = handles.textacpu;
set(hlabel,'String',num2str(t));


% Construyendo un vector con los nombres de los rasgos de cada
% característica
cnames = fieldnames(caract);
rasgosname = {};
for i=1:length(cnames)
stat = cnames{i};
rasgosname = [rasgosname,caract.(stat).rname];
end

% Mostrando la tabla con los rasgos adquiridos en vwndpass en dependencia
% de las características adquiridas

htabla = handles.htablaest;
set( htabla,...
     'Parent',handles.uipaneldisplay, ...
     'Data',X,...
     'ColumnName',rasgosname);
            
% Activando proceso de clasificación  
%hbtn = handles.pushbutton4;
%set(hbtn,'Enable','on'); 


% Salvando los datos necesarios en la estructura data que pertenecen a la
% figura en UserData
data.caract  = caract;
data.rasgos  = X;
data.time    = t;
data.oldtime = t;
data.sizewnd = dim;
data.numcomb = numcomb;

% Guardando los datos en la figura
set(f,'UserData',data);

% FIN DE LA EXTRACCIÓN
% /////--------------------------------------------------------------------


%--------------------------------------------------------------------------
% CARGAR CARACTERÍSTICAS DE LA MEMORIA EXTERNA
% Executes on button press in pushbutton15.
%--------------------------------------------------------------------------
function pushbutton15_Callback(hObject, eventdata, handles)
%
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Tipo del archivo donde se guardaron las características 
File = {'*.mat','database (*.mat)'};

% Actualizando la barra de acción
htext = handles.textaccion;
set(htext,'string','CARGAR CARACTERÍSTICAS ...');

% Abriendo fichero
[Filename, Pathname] = uigetfile(File,'Abrir');

% Si existe el fichero 
if Filename

    % Dirección de entrada
    dirstar = fullfile(Pathname, Filename);    
    
    % Obteniendo el handle y los datos de la figura
    f = handles.figure1;
    olddata = get(f,'UserData');
    
    % Campos posibles en la data
    campos = {'caract','rasgos','time','sizewnd','imageorg','numcomb'};
    if  isfield(olddata,campos)

        % Confirmar la selección
        button = ...
            questdlg('Las características anteriores se reescribirán',...
            'Confirmación','No');
        if strcmp(button,'No')
        return;
        end
    end
    
    % Leyendo el fichero de la memoria externa
    memo = load(dirstar);
    
    if isfield(olddata,'mind')
    data.mind = olddata.mind;
    end
    
    
    % Chequear que el archivo leído sea del tipo deseado
    % id del archivo 55512
    if ~isfield(memo,'id') || memo.id ~= 55512
    errordlg('El fichero no es de características','Error de fichero');   
    return;
    end
    
    % Copiando las variables a la estructura data
    htext = handles.textbestatdo;
    set(htext,'visible','off');
    h = mwaitbar(0,'CARGANDO...');
    
    n = length(campos);
    for i=1:n
        
        if isfield(memo,campos{i})
        data.(campos{i}) = memo.(campos{i});
        end
        
        x = i/n;
        mwaitbar(x,h,['CARGANDO: ' campos{i} ' ' mat2str(fix(x*100)) '% ...']);
        pause(0.1);
    end
        
    delete(findobj(get(h,'Children'),'flat','Tag','TMWWaitbar'));    
    set(htext,'visible','on');
    pause(.1);
    
       
    % Mostrar los datos en la interfaz ...
    dim = data.sizewnd;
    tmp = data.time;   
    X   = data.rasgos;
    caract = data.caract;
        
    
    % Poner características   
    if isfield(data,'numcomb')
    hcaract = handles.popupmenucaract;       
    i = data.numcomb;
    set(hcaract,'Value',i);
    end

    % Poner dimensiones de la ventana de observación
    hedit = handles.editdim;
    set(hedit,'string',num2str(dim));
    
    % Actualizando los tiempos de cpu
    hlabel  = handles.texttcpu;
    set(hlabel,'string',num2str(tmp));
    
    hlabel  = handles.textacpu;
    set(hlabel,'string',num2str(tmp));
    
    % Mostrando la imagen
    axes(handles.axes2);
    I = data.imageorg;
    imshow(I);
    
    I = rgb2gray(I);
    data.image = I;

    axes(handles.axesdisplay);
    imshow(I);
        
    % Mostrando los rasgos en la tabla   
    cnames = fieldnames(caract);
    rasgosname = {};

    for i=1:length(cnames)
    stat = cnames{i};
    rasgosname = [rasgosname,caract.(stat).rname];
    end
   
    % Obtener el handle
    htabla = handles.htablaest;
    set(htabla,...
        'Data',X,...
        'ColumnName',rasgosname,...
        'Visible','off');

       
    % Actualizar los datos de la figura
    set(f,'UserData',data);
   

    
end

% FIN DE CARGAR
% /////--------------------------------------------------------------------

%--------------------------------------------------------------------------
% GUARDAR LAS CARACTERÍSTICAS DE LA IMAGEN EN MEMORIA EXTERNA
% --- Executes on button press in pushbutton16.
%--------------------------------------------------------------------------
function pushbutton16_Callback(hObject, eventdata, handles)
%
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Obteniendo el handle y los datos de la figura
f = handles.figure1;
data = get(f,'UserData');

% Actualizando la barra de acción
htext = handles.textaccion;
set(htext,'string','GUARDAR CARACTERÍSTICAS ...');

% Campos posibles
file = {'caract','rasgos','time','sizewnd','imageorg','numcomb'};
if ~isfield(data,file)
    
    % No existe conocimiento
    warndlg('Datos insuficientes','!! Advertencia !!');
    return;
    
end

% Cargando el fichero de la memoria externa ...
File = {'*.mat','database (*.mat)'};
[Filename, Pathname] = uiputfile(File,'Guardar');

if Filename
    
    caract   = data.caract;
    rasgos   = data.rasgos;
    time     = data.time;
    sizewnd  = data.sizewnd;    
    imageorg = data.imageorg;
    numcomb  = data.numcomb ;
    id       = 55512;

    % Dirección de salida
    dirstar = fullfile(Pathname, Filename);    

    % Salvando en fichero
    htext = handles.textbestatdo;
    set(htext,'visible','off');
    h = mwaitbar(0,'GUARDANDO...');
    
    save(dirstar,'id');  
    n = length(file);
    for i=1:n
        save(dirstar,'-append',file{i});
        x = i/n;
        mwaitbar(x,h,['GUARDANDO: ' file{i} ' ' mat2str(fix(x*100)) '% ...']);
        pause(0.1);
    end
    delete(findobj(get(h,'Children'),'flat','Tag','TMWWaitbar'));    
    set(htext,'visible','on');
    pause(.1);

end
% FIN DE GUARDAR
% /////--------------------------------------------------------------------


%--------------------------------------------------------------------------
% CAMBIAR EL TEXTO DEL LABEL CORRESPONDIENTE AL PARÁMETRO DE LA CLASIIFICACIÓN 
% Executes on selection change in popupmenu2.
%--------------------------------------------------------------------------
function popupmenu2_Callback(hObject, eventdata, handles)
%
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2

contents = get(hObject,'String');
contents = contents{get(hObject,'Value')};

if strcmp(contents ,'K-means') 
% Algoritmo seleccionado k-means
str = 'NÚMERO DE GRUPOS'; 

hedit = handles.edit2;
f = handles.figure1;

set(hedit,'Position',[670 136 85 20]);
delete(findobj(get(f,'Children'),'flat','Tag','editeps'));

else
% Algoritmo seleccionado B0-conexo
str = 'UMBRAL DE SEMEJANZA';  

defEps = 0.2;
hedit = uicontrol('Style','edit',...
                  'Position',[713 136 42 20],... 
                  'BackgroundColor', [0.306 0.396 0.58], ...
                  'FontSize',8.0,...
                  'ForegroundColor',[1.0 1.0 1.0],...
                  'String',defEps,...
                  'Callback', @editeps_Callback,...
                  'Tag','editeps',...
                  'visible','on',...
                  'TooltipString','Epsilon para la función de semejanza');
                   
hedit = handles.edit2;
set(hedit,'Position',[670 136 41 20]);


end

% Poniendo el texto en label
hlabel  = handles.text21;
set(hlabel,'String',str);


%--------------------------------------------------------------------------
% CHEQUEO DEL EDITOR DEL EPSILOM
%--------------------------------------------------------------------------
function editeps_Callback(hObject, eventdata, handles)

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
	errordlg('Debe entrar un valor numérico','Bad Input','modal')
    set(hObject,'string','');
	return
end
% Proceed with callback...


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

%FIN CAMBIAR EL TEXTO
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% CHEQUEAR LA EDICIÓN DE LOS PARÁMETROS DE LA CLASIFICACIÓN 
%--------------------------------------------------------------------------
function edit2_Callback(hObject, eventdata, handles)
%
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
	errordlg('Debe entrar un valor numérico','Bad Input','modal')
    set(hObject,'string','');
	return
end
% Proceed with callback...

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
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% PROCESO DE CLASIFICACIÓN DE TEXTURAS
% Executes on button press in pushbutton17.
%--------------------------------------------------------------------------
function pushbutton17_Callback(hObject, eventdata, handles)
%
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Actualizando la barra de acción
htext = handles.textaccion;
set(htext,'string','CLASIFICACIÓN DE TEXTURAS ...');

% Ocultar tabla de características
if isfield(handles,'htabla')
    htabla = handles.htabla;
    set(htabla,'Visible','off');
end

% Obteniendo la técnica a aplicar para la clasificación
hppmenu  = handles.popupmenu2;
contents = get(hppmenu,'String');
tecn     = contents{get(hppmenu,'Value')};


% Obteniendo el handle y los datos de la figura
f = handles.figure1;
data = get(f,'UserData');


% Obteniendo el valor del edit como entrada para el algoritmo, en el caso
% del k-means es el número de grupos y en el caso del B0-conexo es el 
% umbral de semejanza
hedit    = handles.edit2;
Bo = str2double(get(hedit,'String'));
if isnan(Bo)
valor{1} = [];
else 
 valor{1}=Bo;
end


% Obteniendo el epsilon para el caso del Bo
hedit = findobj(get(f,'Children'),'flat','Tag','editeps');
if ~isempty(hedit)
valor{2}   = str2double(get(hedit,'string'));
end


if ~isfield(data,'caract')
    set(htext,'string','NO DISPONIBLE ...');
    return;
end

% Obtener las características
caract = data.caract;
X      = data.rasgos;


htext = handles.textbestatdo;
set(htext,'visible','off');
    
% Se clasificarán las texturas de la imagen indistintamente a partir de dos
% métodos no supervisados, kmeans y B0-conexo 
% clasificar las texturas
[G,MA,k,t] = gettextura(X,caract,tecn,valor);

set(htext,'visible','on');

% Reajustando los tiempos de cpu
if isfield(data,'oldtime')
data.time = data.oldtime + t;
else
data.time = t;    
end
data.currentime = t;

hlabel  = handles.texttcpu;
set(hlabel,'String',num2str(data.time));

hlabel  = handles.textacpu;
set(hlabel,'String',num2str(t));

% Guardando los grupos en data
data.grupos  = G;

% Mostramos los grupos formados en la imagen a partir de una escala de
% colores.
I = data.image;
[height,width] = size(I);
axes(handles.axesdisplay);
colors = showgrup(G,length(k),height,width);

% Creando las clases
% Inicialmente todas las texturas son desconocidas 
m  = size(MA,1);
K  = ones(1,m);

% Mostrar representantes y sus respectivas clases en la tabla
cnames = fieldnames(caract);
rasgos = {};
for i=1:length(cnames)
stat = cnames{i};
rasgos = [rasgos,caract.(stat).rname];
end

% Obtener el handle de la tabla
htabla = handles.htablaest;
set( htabla, ...     
     'Data',[MA,K'],...
     'ColumnName',[rasgos,{'clases'}],...
     'Visible','off');


% Salvando los grupos y la matriz de aprendizaje
data.matrz      = MA;
data.colors     = colors;
data.cantgrupos = k;
data.clases     = K;

% Actualizando los datos en la figura
set(f,'UserData',data);


% FIN DEL PROCESO DE CLASIFICACIÓN
% /////--------------------------------------------------------------------


%--------------------------------------------------------------------------
% AGREGAR TEXTURAS A LA BASE DE CONOCIMIENTO
% Executes on button press in pushbutton18.
%--------------------------------------------------------------------------
function pushbutton18_Callback(hObject, eventdata, handles)
%
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% obtener el handle y los datos de la figura
f = handles.figure1;
data = get(f,'UserData');

% Actualizando la barra de acción
htext = handles.textaccion;
set(htext,'string','AGREGAR TEXTURAS ...');

if ~isfield(data,'matrz')
set(htext,'string','NO DISPONIBLE ...');
return;
end


% Obteniendo las variables necesarias
MA       = data.matrz;      % matriz de aprendizaje
K        = data.clases;     % clases de cada objeto
swnd     = data.sizewnd;    % tamaño de la ventana
caract   = data.caract;     % características


% Asignando variables a la estructura de conocimiento
newmind.sizewnd = swnd;
newmind.caract  = caract;
newmind.matrz   = MA;
newmind.clases  = K;

% Si no existe conocimiento en la base de conocimiento
if ~isfield(data,'mind')
       
   
    % Salvando en data el conocimiento adquirido
    data.mind = newmind;
    set(f,'UserData',data);
    
    
    % Mostrar representantes y sus respectivas clases en la tabla
    cnames = fieldnames(caract);
    rasgos = {};
    for i=1:length(cnames)
    stat = cnames{i};
    rasgos = [rasgos,caract.(stat).rname];
    end

    % Mostrar los resultados en la tabla
    htabla = handles.htablaest;
    set(    htabla,...       
            'Position',[0 0 600 450],...
            'Data',[MA,K'],...
            'ColumnName',[rasgos,{'clases'}],...
            'Visible','off');
            
    % Desactivar botón de aprendizaje
    %set(hObject,'Enable','off');    
    return;
    
end

% Obtener las texturas de la base de conocimiento
mind       = data.mind;
cnames     = fieldnames(mind.caract); 
statcnames = fieldnames(caract); 

% Chequeando la compatibilidad entre los conociminetos
if (mind.sizewnd ~= swnd) | ~isequal(cnames,statcnames)
    
    button = ...
    questdlg('No compatibilidad. Desea reescribir el conocimiento?',...
    'Confirmación','No');

    if strcmp(button,'No')
    return;
    end

   
    % Salvando en data el conocimiento adquirido
    data.mind = newmind;
    set(f,'UserData',data);
    
    
    % Mostrar representantes y sus respectivas clases en la tabla
    cnames = fieldnames(caract);
    rasgos = {};
    for i=1:length(cnames)
    stat = cnames{i};
    rasgos = [rasgos,caract.(stat).rname];
    end
    
    
    % Mostrar los resultados en la tabla
    htabla = handles.htablaest;
    set(    htabla,...       
            'Position',[0 0 600 450],...
            'Data',[MA,K'],...
            'ColumnName',[rasgos,{'clases'}],...
            'Visible','off');
    
        
    % Desactivar botón de aprendizaje
    %set(hObject,'Enable','off'); 
    return;

end

% uniendo las texturas
oldMA = mind.matrz;
oldK  = mind.clases;

htext = handles.textbestatdo;
set(htext,'visible','off');

%Unimos las texturas nuevas a la base de conocimiento de manera que se
%aporte información y evitando que la misma sea redundante 
[MA,K] = matunion(oldMA ,oldK ,MA,K,caract);

% Reduciendo la matriz de aprendiaje optenida
[MA,K] = matreduccion(MA,K,caract);


set(htext,'visible','on');
pause(.1);

% Mind = newmind;
mind.matrz   = MA;
mind.clases  = K;

% Mostrar los resultados en la tabla
caract = data.caract;
cnames = fieldnames(caract);
rasgos = {};
for i=1:length(cnames)
    stat = cnames{i};
    rasgos = [rasgos,caract.(stat).rname];
end

htabla = handles.htablaest;
set(    htabla,...       
        'Position',[0 0 600 450],...
        'Data',[MA,K'],...
        'ColumnName',[rasgos,{'clases'}],...
        'Visible','off');

    
% desactivar botón de aprendizaje
%set(hObject,'Enable','off'); 

% salvando en data el conocimiento adquirido
data.mind = mind;
set(f,'UserData',data);

%FIN DE LA UNIÓN
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% GUARDANDO LAS TEXTURAS EN MEMORIA EXTERNA
% --- Executes on button press in pushbutton20.
%--------------------------------------------------------------------------
function pushbutton20_Callback(hObject, eventdata, handles)
%
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Actualizando la barra de acción
htext = handles.textaccion;
set(htext,'string','GUARDANDO TEXTURAS ...');

% Obteniendo el handle y los datos de la figura 
f = handles.figure1;
data = get(f,'UserData');

if ~isfield(data,'mind')
    
    % No existe conocimiento
    warndlg('No existe conocimiento','!! Advertencia !!');
    return;
    
end

% Buscando la dirección en memoria externa
File = {'*.mat','database (*.mat)'};
[Filename, Pathname] = uiputfile(File,'Guardar');

if Filename
            
    % Obteniendo las texturas
    mind = data.mind;  
    file = fieldnames(mind);
    
    matrz   = mind.matrz;
    clases  = mind.clases;
    sizewnd = mind.sizewnd;
    caract  = mind.caract;
    
        
    % Dirección de salida
    dirstar = fullfile(Pathname, Filename);    

    % Salvando en fichero
    htext = handles.textbestatdo;
    set(htext,'visible','off');
    h = mwaitbar(0,'GUARDANDO...');
    
    % Creando identificador de fichero
    id = 55511;      
    save(dirstar,'id'); 
    n = length(file);
    for i=1:n
                       
        save(dirstar,'-append',file{i});
        x = i/n;
        mwaitbar(x,h,['GUARDANDO ' file{i} ' ' mat2str(fix(x*100)) '% ...']);
        pause(0.1);
    end
    delete(findobj(get(h,'Children'),'flat','Tag','TMWWaitbar'));    
    set(htext,'visible','on');
    pause(.1);
    
end

%FIN DE GUARDAR TEXTURA 
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% CARGAR TEXTURAS EN MEMORIA EXTERNA
% Executes on button press in pushbutton19.
%--------------------------------------------------------------------------
function pushbutton19_Callback(hObject, eventdata, handles)
%
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Actualizando la barra de acción
htext = handles.textaccion;
set(htext,'string','ABRIENDO TEXTURAS ...');

% Tipos de fichero 
File = {'*.mat','database (*.mat)'};
[Filename, Pathname] = uigetfile(File,'Abrir');
if Filename
    
    % Dirección de entrada
    dirstar = fullfile(Pathname, Filename);
    
    % Obteniendo el handle y los datos de la figura
    f = handles.figure1;
    olddata = get(f,'UserData');
    
    campos = {'matrz','clases','sizewnd','caract'};
    if  isfield(olddata,campos)
            
        % Confirmar la selección 
        button = ...
        questdlg('Las texturas en el proceso actual se reescribirán',...
        'Confirmación','No');
        if strcmp(button,'No')
        return;
        end

    end
    
    memo = load(dirstar);
    
    % Chequear que el archivo leído sea del tipo deseado
    % id del archivo 55511
    if ~isfield(memo,'id') || memo.id ~= 55511
    errordlg('El fichero no es de texturas','Error de fichero');    
    return;
    end
    
    % Copiando las variables a la estructura data
    
    if isfield(olddata,'mind')
    data.mind = olddata.mind;
    end
    
    
    htext = handles.textbestatdo;
    set(htext,'visible','off');
    h = mwaitbar(0,'CARGANDO...');
    
    n = length(campos);
    for i=1:n
    data.(campos{i}) = memo.(campos{i});
    x = i/n;
    mwaitbar(x,h,['CARGANDO: ' campos{i} ' ' mat2str(fix(x*100)) '% ...']);
    pause(0.1);
    end
        
    delete(findobj(get(h,'Children'),'flat','Tag','TMWWaitbar'));    
    set(htext,'visible','on');
    pause(.1);
    
    
    % mostrar los resultados en la tabla
    MA     = data.matrz;
    K      = data.clases;
    
    
    caract = data.caract;
    cnames = fieldnames(caract);
    rasgos = {};
    for i=1:length(cnames)
    stat = cnames{i};
    rasgos = [rasgos,caract.(stat).rname];
    end
    
    % Mostrar los resultados en la tabla
    htabla = handles.htablaest;
    set(    htabla,...       
            'Position',[0 0 600 450],...
            'Data',[MA,K'],...
            'ColumnName',[rasgos,{'clases'}],...
            'Visible','off');
    
    
    % Guardando los datos en la figura
    set(f,'UserData',data);
    
end

%FIN DE LA APERTURA
%--------------------------------------------------------------------------





%--------------------------------------------------------------------------
% MENÚ
% --- Executes on button press in pushbutton2.
%--------------------------------------------------------------------------
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Actualizando la barra de acción
htext = handles.textaccion;
set(htext,'string','MENÚ ...');

f = handles.figure1;
%dataold = get(f,'UserData');
data = 0;
set(f,'UserData',data);


%FIN DE MENÚ
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% PROCESO DE SELECCIÓN DE GRUPOS
% Executes on button press in pushbutton3.
%--------------------------------------------------------------------------
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

zoom off;
pan off;

% Obteniendo el handle y los datos de la figura
f = handles.figure1;
data = get(f,'UserData');

% Actualizando la barra de acción
htext = handles.textaccion;

if ~isfield(data,'grupos')
    set(htext,'string','NO DISPONIBLE ...');
    return;
end
set(htext,'string','SELECCIÓN DE GRUPOS ...');

% Obteniendo grupos
%G = data.grupos;
%k = data.cantgrupos;
%k = length(k);

% Calculando las dimensiones de la imagen
%I = data.image;
%[height,width] = size(I);

% Mostramos los grupos formados en la imagen a partir de una escala de
% colores.
%axes(handles.axesdisplay);
%showgrup(G,k,height,width);

hcurse = handles.hcurse;
set(hcurse,'Enable','on');



function txt = cursor1_Callback(empt,event_obj,hfigure,hpanel)
%
% CLASIFICACIÓN DE LOS GRUPOS
% El usuario de forma interactiva seleccionará los grupos que pertenecen a
% las texturas de los objetos de estudio.

% Obteniendo la posición del cursor actual
pos   = get(event_obj,'Position');

% Obtener datos de la figura 
data = get(hfigure,'UserData');

G      = data.grupos;
colors = data.colors;

% Calculando las dimensiones de la imagen
I = data.image;
[height] = size(I,1);

indk2  = pos;
indk2  = (indk2(:,1)-1).*height + indk2(:,2);
numgrup = G(indk2);
colors = colors(numgrup,:,:);

% Guardando las coordenadas del cursor actual
data.pointselec = indk2;
set(hfigure,'UserData',data);

% Valores de salida
set(hpanel,'BackgroundColor',colors);
txt = {num2str(pos), ...
       ['RGB: ' num2str(int8(colors))],...
       ['Grupo: ' num2str(int8(numgrup))]};


%FIN DE LA SELECCIÓN
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

%FIN DEL ZOOM
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% PAN
% --- Executes on button press in pushbutton5.
%--------------------------------------------------------------------------
function pushbutton5_Callback(hObject, eventdata, handles)
%
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pan on;

%FIN DEL PAN
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% VER GRUPO EN LA IMAGEN
% --- Executes on button press in pushbutton6.
%--------------------------------------------------------------------------
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

zoom off;
pan off;

% Obtener el handle y los datos de la figura 
f = handles.figure1;
data = get(f,'UserData');

% Actualizando la barra de acción
htext = handles.textaccion;


if ~isfield(data,'pointselec') || ~isfield(data,'grupos')
    set(htext,'string','NO DISPONIBLE ...');
    return;
end
set(htext,'string','VER GRUPO EN LA IMAGEN ...');

% Desactivar el cursor
hcurse = handles.hcurse;
set(hcurse,'Enable','off');

zoom reset; 
zoom off; 
pan  off;


% Obteniendo el punto seleccionado
indk2 = data.pointselec;

% Obtener datos necesarios
G      = data.grupos;
colors = data.colors;

numgrup = G(indk2);
colors = colors(numgrup,:,:);

% convirtiendo el color a rgb
colors = uint8(round(colors*255));

% Calculando las dimensiones de la imagen
I = data.imageorg;
[height,width,prof] = size(I);

% Obtener el grupo seleccionado
G = reshape(G,height,width);
[col,row] = find(G == numgrup);

n = length(col);
for i=1:n
I(col(i),row(i),:) = colors; 
end

% Mostrando imagen
axes(handles.axesdisplay);
imshow(I);


%FIN DE VER GRUPO DE LA TEXTURA SELECCIONADA
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% MOSTRAR TODOS LOS GRUPOS
% Executes on button press in pushbutton7.
%--------------------------------------------------------------------------
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

zoom off;
pan  off;

% Obteniendo el handle y los datos de la figura
f = handles.figure1;
data = get(f,'UserData');

% Actualizando la barra de acción
htext = handles.textaccion;

if ~isfield(data,'grupos')
    set(htext,'string','NO DISPONIBLE ...');
    return;
end
set(htext,'string','MOSTRAR TODOS LOS GRUPOS ...');


% Calculando las dimensiones de la imagen
I = data.image;
[height,width] = size(I);

% Obteniendo grupos
G = data.grupos;
k = data.cantgrupos;
k = length(k);

% Mostramos los grupos formados en la imagen a partir de una escala de
% colores.
axes(handles.axesdisplay);
showgrup(G,k,height,width);


%FIN DE MOSTRAR TODOS LOS GRUPOS
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% ADICIONAR TEXTURA
% Executes on button press in pushbutton8.
%--------------------------------------------------------------------------
function pushbutton8_Callback(hObject, eventdata, handles)
%
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

zoom off;
pan  off;

% Desactivar el cursor de selección
hcurse = handles.hcurse;
set(hcurse,'Enable','off');

% Obtener el handle y los datos de la figura
f = handles.figure1;
data = get(f,'UserData');


% Actualizando la barra de acción
htext = handles.textaccion;

if ~isfield(data,'grupos')
    set(htext,'string','NO DISPONIBLE ...');
    return;
end
set(htext,'string','ADICIONANDO TEXTURA ...');


% Obtener punto de selección
if ~isfield(data,'pointselec')
return;
end
indk2 = data.pointselec;

% Obteniendo los grupos
G = data.grupos;
indk2 = G(indk2);

% Obteniendo los índices de representantes 
k = data.cantgrupos;

if indk2 == 1
indk2 = 1:k(indk2);
else
indk2 = (k(indk2-1)+1):k(indk2);    
end


% Confirmar la selección 
button = ...
questdlg(['Está seguro de incorporar la textura (' num2str(indk2) ')...?'],...
'Confirmación','No');

if strcmp(button,'Yes')

    % Incorporando la textura n a las conocidas
    K = data.clases;
    K(indk2) = 2;
    data.clases = K;

    % Obtener matriz de aprendizaje
    MA = data.matrz;
    
    
    % Mostrar los resultados en la tabla
    
    caract = data.caract;
    cnames = fieldnames(caract);
    rasgos = {};
    for i=1:length(cnames)
    stat = cnames{i};
    rasgos = [rasgos,caract.(stat).rname];
    end
    
    htabla = handles.htablaest;
    set(    htabla,...       
            'Position',[0 0 600 450],...
            'Data',[MA,K'],...
            'ColumnName',[rasgos,{'clases'}],...
            'Visible','off');
        

    % Salvar los datos en la figura
    set(f,'UserData',data);

    % activando el aprendizaje
    %btn = handles.pushbutton10;
    %set(btn,'Enable','on');
    
end

%FIN DE ADICIONAR TEXTURA
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% ELIMINAR TEXTURA
% Executes on button press in pushbutton9.
%--------------------------------------------------------------------------
function pushbutton9_Callback(hObject, eventdata, handles)
%
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

zoom off;
pan  off;

% Desactivar el cursor de selección
hcurse = handles.hcurse;
set(hcurse,'Enable','off');

% Obtener el handle de la figura
f = handles.figure1;

% Obtener datos de la figura 
data  = get(f,'UserData');

% Obtener el punto seleccionado
if ~isfield(data,'pointselec')
return;
end
indk2 = data.pointselec;

% Actualizando la barra de acción
htext = handles.textaccion;

if ~isfield(data,'grupos')
    set(htext,'string','NO DISPONIBLE ...');
    return;
end
set(htext,'string','ELIMINANDO TEXTURA ...');


% Obtener grupos
G     = data.grupos;
indk2 = G(indk2);
k     = data.cantgrupos;

if indk2 == 1
indk2 = 1:k(indk2);
else
indk2 = (k(indk2-1)+1):k(indk2);    
end


% Confirmar la selección 
button = ...
questdlg(['Está seguro de quitar la textura (' num2str(indk2) ')...?'],...
'Confirmación','No');

if strcmp(button,'Yes')


    % Incorporando la textura n a las conocidas
    K = data.clases;
    K(indk2) = 1;
    data.clases = K;

    % Obtener matriz de aprendizaje
    MA = data.matrz;

    % Mostrar los resultados en la tabla
    caract = data.caract;
    cnames = fieldnames(caract);
    rasgos = {};
    for i=1:length(cnames)
    stat = cnames{i};
    rasgos = [rasgos,caract.(stat).rname];
    end
    
    htabla = handles.htablaest;
    set(    htabla,...       
            'Position',[0 0 600 450],...
            'Data',[MA,K'],...
            'ColumnName',[rasgos,{'clases'}],...
            'Visible','off');
            

    % Salvar los datos en la figura
    set(f,'UserData',data);

    % Activando el aprendizaje
    %btn = handles.pushbutton10;
    %set(btn,'Enable','on');


end
%FIN DE ELIMINAR TEXTURA
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% VER IMAGEN ORIGINAL
% Executes on button press in pushbutton10.
%--------------------------------------------------------------------------
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

zoom off;
pan  off;

% Desactivar el cursor de selección
hcurse = handles.hcurse;
set(hcurse,'Enable','off');

% Obtener el handle y los datos de la figura
f = handles.figure1;
data  = get(f,'UserData');

% Actualizando la barra de acción
htext = handles.textaccion;

if ~isfield(data,'grupos')
    set(htext,'string','NO DISPONIBLE ...');
    return;
end
set(htext,'string','VER IMAGEN...');

I = data.imageorg;
axes(handles.axesdisplay);
imshow(I);


%FIN DE VER IMAGEN ORIGINAL
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% VER TABLA
% Executes on button press in pushbutton11.
%--------------------------------------------------------------------------
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

zoom off;
pan  off;

% Desactivar el cursor de selección
hcurse = handles.hcurse;
set(hcurse,'Enable','off');

% Obtener el handle y los datos de la figura
%f = handles.figure1;
%data  = get(f,'UserData');

% Actualizando la barra de acción
htext = handles.textaccion;
set(htext,'string','VER TABLA...');

if ~isfield(handles,'htablaest')
set(htext,'string','NO DISPONIBLE...');
return;
end


% Mostrar los resultados en la tabla
htabla = handles.htablaest;

estvis = get(htabla,'visible');
if strcmp(estvis,'off')
set(htabla,'visible','on');
pause(.2);
else
set(htabla,'visible','off');    
end


%FIN DE VER TABLA
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% TEST PARA LA MATRIZ OBTENIDA
% Executes on button press in pushbutton22.
%--------------------------------------------------------------------------
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Obtener el handle y los datos de la figura
f = handles.figure1;
data = get(f,'UserData');

% Actualizando la barra de acción
htext = handles.textaccion;
set(htext,'string','TEST...');

% Chequear si existen características en data. Este test se realiza sobre el
% conocimiento adquirido
if ~isfield(data,'mind')
    
    % No existe conocimiento
    warndlg('No existe conocimiento','!! Advertencia !!');
    return;
    
end

% Chequear si existe imagen 
if ~isfield(data,'image')
    
    % No existe conocimiento
    warndlg('Cargue la imagen por favor','!! Advertencia !!');
    return;
    
end

% Obteniendo la imagen y sus dimensiones
I = data.image;
[height,width] = size(I);

% cargar conocimiento
mind = data.mind;

% Ocultando texto
htext = handles.textbestatdo;
set(htext,'visible','off');

% crear la barra de estado para el proceso
hbarra = waitbar(0,'PROCESO ... 0%','WindowStyle','modal');

%--------------------------------
% PASO 1: OBTENER CARACTERÍSTICAS
if ~isfield(data,'btest')
    
    
    dim    = mind.sizewnd;
    caract = mind.caract;
    h = true(dim);
    [X,caract,t] = vwndpass(I,h,caract,hbarra);

    data.caract = caract;
    data.rasgos = X;
    data.btest = true;

    % Guardando los datos en la figura
    set(f,'UserData',data);

else
    
    
    caract = data.caract;
    X = data.rasgos;
    
end

%PASO 2: CLASIFICAR TEXTURAS
% Obtener matriz de aprendizaje adquirida
MA = mind.matrz;
K  = mind.clases;

% Obteniendo la técnica a aplicar para la clasificación
hppmenu  = handles.popupmenu5;
contents = get(hppmenu,'String');
alg      = contents{get(hppmenu,'Value')};

% Obtener el epsilon del editor
hedit = handles.edit3;
Eps   = get(hedit,'string');
if isempty(Eps)
Eps   = realmax;
else
Eps = str2double(Eps);
end


if strcmp(alg,'Knn')

k = sum(K==2);
k = k - fix(k/2);

[G,C] = vknn(MA,K,X,k,Eps,caract,hbarra);
else
[G,C] = vvotacion(MA,K,X,caract,Eps,hbarra);
end


%delete(findobj(get(hbarra,'Children'),'flat','Tag','TMWWaitbar')); 
close(hbarra);
set(htext,'visible','on');
pause(.1);

% mostrando las regiones detectadas por el algoritmo de clasificación 
G = reshape(G,height,width);
G = G==2;
I(G) = 0;

axes(handles.axesdisplay);
imshow(I);

hTotal  = handles.text38; %Total
hDetetc = handles.text37; %Detectados

% Calculando el total de elemento y la cantidad de detectados
Total  = prod(numel(I));
Detect =  sum(G(:));

% Mostrandolos en la interfaz
set(hTotal,'String',num2str(Total));
set(hDetetc,'String',num2str(Detect));


%FIN DEL TEST
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
%CHEQUEO DEL EDITOR
%--------------------------------------------------------------------------
function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
	errordlg('Debe entrar un valor numérico','Bad Input','modal')
    set(hObject,'string','');
	return
end
% Proceed with callback...



% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%FIN DEL CHEQUEO
%--------------------------------------------------------------------------




% --- Executes on selection change in popupmenucaract.
function popupmenucaract_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenucaract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenucaract contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenucaract


% --- Executes during object creation, after setting all properties.
function popupmenucaract_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenucaract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%--------------------------------------------------------------------------
% AJUSTAR IMAGEN
% --- Executes on button press in pushbutton21.
%--------------------------------------------------------------------------
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Actualizando la barra de acción
htext = handles.textaccion;
set(htext,'string','AJUSTANDO IMAGEN...');

% Obtener el handle y los datos de la figura 
f = handles.figure1;
data = get(f,'UserData');

% Tratamiento de la imagen. Eliminación de ruido y mejoras de propiedades
% como el contraste y el brillo.
if ~isfield(data,'image')
    set(htext,'string','NO DISPONIBLE...');
end

I = data.image;
I = imresalt(I);
data.image = I;

% Guardando los datos en la figura
set(f,'UserData',data);

%FIN DE AJUSTAR IMAGEN
%--------------------------------------------------------------------------

% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%--------------------------------------------------------------------------
% CAPTURAR LAS COORDENADAS DEL MOUSE
% Executes on mouse motion over figure - except title and menu.
%--------------------------------------------------------------------------
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
%
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

f = handles.figure1;
cpoint = get(f,'CurrentPoint');

htextx  = handles.textx;
htexty  = handles.texty;
   
set(htextx,'string',mat2str(cpoint(1)));
set(htexty,'string',mat2str(cpoint(2)));

