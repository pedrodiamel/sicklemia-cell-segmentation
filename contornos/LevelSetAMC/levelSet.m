%--------------------------------------------------------------------------
%FUNCIÓN LEVEL SET PARA IMÁGENES
%--------------------------------------------------------------------------
function data = levelSet(speed,data,maxiter,eeps)
% DATA=LEVELSET(DATA,SPEED)

% Calculando las dimensiones de data
[w,h] = size(speed);

%--------------------------------------------------------------------------
% Creando una estructura para el trabajo con la red.
g.dim = 2;
g.min = [ +1.0; +1.0];
g.max = [w/2;h/2];
g.N   = [w;h];
g.bdry = @addGhostExtrapolate;
g = processGrid(g);

%--------------------------------------------------------------------------
derivFunc = @eqdiffupwindfirst;

%--------------------------------------------------------------------------
% Inicializando la estructura normData para el cálculo del movimiento en  
% función de la dirección normal del level set

normalData.grid = g;
normalData.derivFunc = derivFunc;
normalData.initial = data;
normalData.speed   = speed;


% -------------------------------------------------------------------------
% Inicializando la estructura curvData para el cálculo del movimiento en  
% función de la curvatura 
    
%curvData.grid = g;
%curvData.expand = speed;
%curvData.curvatureFunc = @sgdcurvature;
%curvData.eps = 0.06;


%--------------------------------------------------------------------------
% Inicializando la estructura advData para el cálculo del movimiento en  
% función de la advecccion de un campo potencial 
    
% Obteniendo la velocidad de advección 
%P  = (1./speed)-1;
%adv = P;

%advData.derivFunc = derivFunc;
%advData.grid = g;
%advData.advect = adv;
%advData.beta = 0.06;


%--------------------------------------------------------------------------
% Condición de parada. La diferencia en los level set al transcurrir el 
% tiempo tiene que ser mayor que epsilon.

terminalEvent = @terminalEventConverge;
structData.convergeNorm   = 'average';
structData.diflevel       = eeps;

%--------------------------------------------------------------------------
% Convirtiendo la matriz data en un vector columna.
y0 = data(:);

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
t = 0;
y = y0;

for steps =1:maxiter
        
    %   Una fuerza de tensión superficial que depende de la curvatura y
    %   actúa como una clase de elástico en el frente

    %schemeFunc = @fzacurvatura;
    %[ fcurv, stepBound, curvData ] = feval(schemeFunc, y, curvData);
    

    %	Una fuerza que atrae la superficie hacia el límite, que tiene
    %	un efecto equilibrante, especialmente cuando hay una variación
    %   grande en el valor del gradiente de la imagen. Este término
    %   denota la proyección de una (atractiva) fuerza vectorial en la
    %   normalidad de la superficie. Esta fuerza, introducida en [50],
    %   está realizada como el gradiente de un campo potencial.

    %schemeFunc = @fzaadveccion;
    %[ fadv, stepBound, advData ] = feval(schemeFunc, y, t, advData);

    
   %    Una fuerza motriz de expansión (o de deflación) que se sintetizó 
   %    de el gradiente de la imagen.
    
    
    schemeFunc = @fzanormal;
    [ fnorm, stepBound, normalData ] = feval(schemeFunc, y, normalData);


    % calculando
    %ydot = fnorm + fadv + fcurv;
    %ydot = (1-0.1.*fcurv).*fnorm;
    ydot = fnorm;

    % - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    % Determine CFL bound on timestep, but not beyond the final time.
    %   For vector level sets, use the most restrictive stepBound.
    deltaT = 0.1;

    % If there is a terminal event function registered, we need
    %   to maintain the info from the last timestep.
    if(~isempty(terminalEvent))
        yOld = y;
        tOld = t;
    end

    % Update time.
    t = t + deltaT;

    % Actualizando la funcion level set.
    y = y + deltaT * ydot;

    % Análisis de la condición de parada para el level set
    [ eventValue ] = feval(terminalEvent, y, yOld, structData);
    if((steps > 1) && any(sign(eventValue) ~= sign(eventValueOld)))
    disp('yes');    
    break;
    else
    eventValueOld = eventValue;
    end
    
end

% Obtener la estructura data redimensionando y
data = reshape(y, g.shape);

end