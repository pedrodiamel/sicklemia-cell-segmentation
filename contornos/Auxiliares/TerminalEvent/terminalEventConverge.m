function [ value] = terminalEventConverge(y, yOld, schemeDataIn)
% terminalEventConverge: Detects convergence of the integration.
%
%
% Parameters:
%   y              The current implicit surface function.
%   tOld           Time at the last timestep.
%   yOld           Implicit surface function during the last timestep.
%   schemeDataIn   Input version of a structure (see below).
%
%
%   .convergeNorm    Norm in which convergence is measured
%                      In order of increasing tightness, the options are:
%                      'average'    Average over all node points (default).
%                      'maximum'    Maximum over all node points.
%                      'pointwise'  Each node point tested individually.
%
%--------------------------------------------------------------------------


if(isfield(schemeDataIn, 'convergeNorm'))
convergeNorm = schemeDataIn.convergeNorm;
else
convergeNorm = 'average';
end

% Computar la norma.
update = findNorm(y - yOld, convergeNorm);

if(all(update < schemeDataIn.diflevel))
value = -1;
else
value = +1;
end



%--------------------------------------------------------------------------
%FUNCION FINDNORM 
function normX = findNorm(x, normType)
% NORMX=FINDNORM(X,NORMTYPE)
% findNorm: Calcular las normas de interes para compara los niveles.
%
% Tres tipos de normas son evaluadas:
%
%    'maximum'    retornar el maximo de los valores absolutos de x.
%    'average'    retornar la media de los valores absolutos de x.
%    'pointwise'  retornar el valor absoluto de todos los valores de x.
%
% Parametros:
%   x              arreglo con el valor de la normal para cada celda.
%   normType       Tipo de medida a aplicar.
%
%   normX          Valor de la norma a comparar.

switch(normType)

 case 'average'
  normX = mean(abs(x(:)));

 case 'maximum'
  normX = max(abs(x(:)));

 case 'pointwise'
  normX = abs(x);

 otherwise
 error([ 'Tipo desconocido: ' normType ]);

end
