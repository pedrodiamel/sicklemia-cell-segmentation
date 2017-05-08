%--------------------------------------------------------------------------
%M�TODO FAST MARCHING
%--------------------------------------------------------------------------
function [data,tcell] = fastmarching(front0,speed,Eps,maxiter,maxT)
%DATA=FASTMARCHING(DATA)
%
%   |grad(T)|F = 1
%
%Par�metros:
%   data   matriz con la inicializaci�n para el m�todo       
%   speed  velocidad
%   Eps    ... para el gradiente |grad(T)|
%
%   data   aproximaci�n para el gradiente en el tiempo T 
%   tcell  tipo de cada elemento de data
%
%
%--------------------------------------------------------------------------
% M�ximo valor de iteraciones para fast marching por defecto
%maxiter = 1e+8;



% Diferentes tipos en que se pueden clasificar los valores de tcell 
% Typedef enum(Know,Trial,Far,Bdry)TCELL
Know    = 0; 
Trial   = 1; 
Far     = 2;
Bdry    = 3;

% Creando las condiciones iniciales para el algoritmo fast marching
[rn,rm] = size(speed);
data    = ones(rn,rm);
data(front0) = 0;


% Creamos el vector tcell para clasificar cada celda de la data, y creamos
% condiciones del l�mite

[speed,data] = addNodeBdry(speed,data);
[data,tcell] = shapeTrial(data,speed);

% Calculando la inversa de la velocidad
speed = 1./speed;


% Crear una banda con los valores triales de la data y sus posiciones
% respectivas. La banda satisface la condici�n de grupo, esto es un �rbol
% balanceado donde el valor del padre es menor que el de los hijos.

indx = find(tcell==Trial);
if isempty(indx)
    %/// error
    return;
end

nb   = length(indx);
fields = {'tmpo', 'cord'};
band = cell2struct(num2cell([data(indx),indx]), fields, 2);
band = BuilderGrup(band,nb);


% Direcciones de los vecinos en la data
[n,m] = size(data);
X = [1 n -1 -n] ;

% ---------------------
oldt = band(1).tmpo;

%--------------------------------------------------------------------------
% M�TODO FAST MARCHING
% resolvemos la ecuaci�n cuadr�tica hasta un valores de |grad(T)| superen un umbral o
% hasta un valor m�ximo de iteraciones 

for k = 1:maxiter
 
% Chequear condici�n de parada (1). La cantidad de elementos de la banda es cero, 
% esto implica que todos los valores en data son Know, o sea ya est�n calculados.
if nb == 0
break;
end

% Paso 1: Sea M el menor valor Trial de la banda. Extraemos del arreglo
% band el menor valor que por definici�n est� en la ra�z.
[band,nb,M] = FindSmallest(band,nb);
   
% Chequear condici�n de parada (2). El valor del gradiente |grad(T)| supera 
% un cierto umbral, lo que indica que el frente esta cerca del l�mite.  
if abs(M.tmpo-oldt) > Eps || M.tmpo > maxT  
break;
end

oldt = M.tmpo;

% Paso 2: Marcar M como Know. El frente avanza a ese punto y habr� que
% calcularle los valores triales de este en una vecindad igual a uno, es
% decir, todos los vecinos de M que no sean Know
tcell(M.cord) = Know; 

% Paso 3: Etiquetar los vecinos de M que no son Know
% Nos movemos por los cuatro vecinos de M etiquet�ndolos y calculando su 
% valor aproximado para el gradiente |grad(T)| en caso de no estar marcados 
% como Know 
for i = 1:4
    
    %Obteniendo el vecino M en la direcci�n X(i)
    indx = M.cord+X(i);  
    
    if tcell(indx) ~= Know  &&  tcell(indx) ~= Bdry 
       
      % calculando el valor aproximado del gradiente |grad(T)| a partir de 
      % la soluci�n de la ecuaci�n cuadr�tica Equ 16.   
      data(indx) = ...       
      ecdiffTupwind( data(indx), ...
                    data(indx-n), data(indx-1),...          
                    data(indx+n), data(indx+1),... 
                    speed(indx)); 
               
              
       if tcell(indx) == Trial
                     
           % Se puede mejorar manteniendo en la estructura
           % data un puntero a la banda
           j = find( [band(1:nb).cord] == indx);        
           
           
           %Actualizando un elemento en la  banda            
           oldfT        = band(j).tmpo;
           band(j).tmpo = data(indx);
           
           if oldfT < data(indx)             
           band = DownHeap(band,nb,j);             
           else         
           band = UpHeap(band,nb,j);
           end
           
           
       else 
           
           %Insertando un elemento (x,y) en la banda
           tcell(indx) = Trial;
           [band,nb]   = Insert(band,nb,data(indx),indx);
           
       end
    end            
end
end

% Obteniendo los valores reales de data, estos son los que no pertenecen a
% las celdas fantasmas
mn = [2;2];
mx = [rn;rm]+1;
vs = cell(2,1);

for i = 1:2
vs{i}= (mn(i):mx(i))';
end

data  = data(vs{:}); 
tcell = tcell(vs{:});
