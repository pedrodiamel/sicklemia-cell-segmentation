%--------------------------------------------------------------------------
%FUNCIÓN DE EXTRACCIÓN DE CARACTERÍSTIICAS USANDO VENTANAS DESLIZANTES
%--------------------------------------------------------------------------
function [X,caract,varargout] = vwndpass(varargin)
%[X,CARACT,VARARGOUT]=WNDPASS(VARARGIN) 
%
% Esta función realiza un barrido de la ventana de observación h (por defecto 
% de tamaño 9) de dimensiones impar, por toda la imagen I, realizando en cada 
% paso la extracción del vector característico a partir de los métodos 
% especificados (por defecto todos, Momento de orden k, Matriz de co-ocurrencia
% Modelos de Gabor).
%
% ENTRADA:
%   I   imagen
%   h   tamaño de la ventana de observación (por defecto 9)
%   namecaract nombre de los métodos de extracción (por defecto todas)
%
% SALIDA:
%   X      vectores característicos extraídos en la imagen por los métodos especificados           
%   caract estructura que guarda la información por características de los 
%          rasgos extraídos para el vector de rasgos X
%   t      tiempo de cpu en segundos
%
%
%--------------------------------------------------------------------------
%Chequeando los datos de entrada en el parse y construir la estructura
%CARACT
[I, h, caract,xSize,hbarra] = ParseInputs(varargin{:});
textacc     = 'Extrayendo ... ';

% Obteniendo las dimensiones de la imagen.
[height,width] = size(I);
wsize   = size(h);

% Inicializando el conjunto de vectores característicos como una matriz en
% la que las filas serán los vectores y las columnas los rasgos o  
% características extraídas.
X  = zeros(height*width,xSize);

% names es el nombre de cada método a emplear
names = fieldnames(caract);
N  = length(names);

% Añadiendo celdas artificiales a la imagen I. 
padSize = (wsize-1)/2;
I = padarray(I,padSize,'symmetric','both');

%--------------------------------------------------------------------------
% Inicialización

% Vector de filas y columnas para los elementos de la ventana de observación 
% en cada paso del algoritmo 
d = 2;
vs    = cell(d,1);

%--------------------------------------------------------------------------
% Obteniendo el tiempo de la cpu actual
startTime = cputime;

% Posición actual para el vector caracteristico que será calculado 
mid = 1;

% Barrido de la ventana de observación por toda la imagen, para la que se 
% extraerán en cada paso las características por los métodos especificados.
% para este caso el recorrido de la ventana será por columnas.   
for i=1:width
    for j=1:height
        
        % Moviendo la ventana de observación para la próxima posición. Cada
        % vez que se llegue al final de la fila se salta al principio de
        % la columna siguiente.
        mn = [j;i];
        mx = mn + wsize' - 1;
        
        % Calculando los índices de la ventana de observación para cada
        % dimensión 
        for k=1:d
        vs{k}= (mn(k):mx(k))';
        end

        % Seleccionando los valores de la imagen que corresponden a la
        % ventana de observación en este paso.
        wnd = I(vs{:});             
            
        % Aplicar cada método de extracción de características especificado
        % a la porción de la imagen wnd obtenida en el paso anterior. 
        for k=1:N             
            stat = names{k};                   
            func = caract.(stat).func;          
            indx = caract.(stat).indx;          
            X(mid,indx) = feval(func,wnd);       
        end
        
        
        % Actualizando barra de estado  
        try 
            x = mid/(width*height);       
            waitbar(x,hbarra,[textacc num2str(fix(x*100)) '%']); 
        catch
           
           % cerrando la barra de estado 
           close(hbarra);           
        end
        
        % Incrementando posición para el conjunto X
        mid = mid+1;  
            
    end
    
end

% Calculando el tiempo de cpu total
endTime = cputime;
totalTime = endTime - startTime; 

% Poniendo el tiempo en varargout
if nargout > 2
varargout{1} = totalTime;
end

% Cerrando la barra de estado 
if nargin < 4
close(hbarra);
end

end


function [I,H,outcaract,oldsize,hbarra] = ParseInputs(varargin)
%--------------------------------------------------------------------------

% Obteniendo la imagen a procesar
I   = varargin{1};

% Clases de características o métodos a emplear por wndpass
allcaract   = {'Momentos','MCO','Gabor'};
textacc     = 'Extrayendo ...';

if nargin == 1

    % Ventana de observación por defecto 9
    H = true(9);
    [outcaract,oldsize] = createstructcaract(allcaract);
    hbarra = waitbar(0,textacc,'WindowStyle','modal');

else

    H = varargin{2};
    % Convertir H a una matriz lógica
    if ~islogical(H)
        H = H ~= 0;
    end

    if nargin == 2

        [outcaract,oldsize] = createstructcaract(allcaract);
        hbarra = waitbar(0,textacc,'WindowStyle','modal');

    else

        statcarat =  varargin{3};
        if isstruct(statcarat)

            outcaract = statcarat;
            caract = fieldnames(statcarat);
            oldsize = 0;
            for i=1:length(statcarat)
                name = caract{i};
                oldsize = oldsize + length(statcarat.(name).indx);
            end

        else
            [outcaract,oldsize] = createstructcaract(statcarat);
        end

        if  nargin == 3
            hbarra = waitbar(0,textacc,'WindowStyle','modal');
        else
            hbarra = varargin{4};
            waitbar(0,hbarra,textacc);
        end

    end

end
end