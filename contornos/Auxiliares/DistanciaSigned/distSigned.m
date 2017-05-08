%--------------------------------------------------------------------------
%DISTANCIA SIGNED CALCULADA
%--------------------------------------------------------------------------
function data = distSigned(data)
%
%
% Construir la función signed a partir del uso del algorimo fast marching
% que crea a partir de un frente y con una función de velocidad constante
% en este caso F=1 dicha funcion.

% Construyendo una función de velocidad constante F=1
%speed = ones(size(data));

% invocando la función fast marching para la entrada 
front0  = bwperim(data,4);

%deltaT  = 1e+6;
%maxiter = 1e+8;
%maxT    = realmax;
%layer  = fastmarching(front0,speed,deltaT,maxiter,maxT);
layer = bwdist(front0);

% Poniendo los signos correspondientes 
layer(data==1) = -layer(data==1);
data = layer;