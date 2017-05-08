%--------------------------------------------------------------------------
%FUNCIÓN FZAADVECCION CALCULA LA FUERZA EN FUNCIÓN DE LA ADVECCIÓN
%--------------------------------------------------------------------------
function [ ydot,stepBound, schemeData ] = fzaadveccion(y, t, schemeData)
% [YDOT,STEPBOUND,SCHEMEDATA]=FZAADVECCION(T,Y,SCHEMEDATA)
% 
%   Una fuerza que atrae la superficie hacia el límite, que tiene
%   un efecto equilibrante, especialmente cuando hay una variación
%   grande en el valor del gradiente de la imagen. Este término
%   denota la proyección de una (atractiva) fuerza vectorial en la
%   normalidad de la superficie. Esta fuerza, introducida en [50],
%   está realizada como el gradiente de un campo potencial.
% 
%   P(x) = -[grad(G_alfa*I(x))]
%   
% Parámetros:
%   t   tiempo
%   y   conjunto de niveles actual
%   schemeData atributos de la función
%
%

  %---------------------------------------------------------------------------
  if(iscell(schemeData))
  thisSchemeData = schemeData{1};
  else
  thisSchemeData = schemeData;
  end

  checkStructureFields(thisSchemeData, 'grid', 'derivFunc', 'advect');
  grid = thisSchemeData.grid;

  %---------------------------------------------------------------------------
  % For most cases, we are interested in the first implicit surface function.
  if(iscell(y))
  data = reshape(y{1}, grid.shape);    
  else
  data = reshape(y, grid.shape);
  end

  %------------------------------------------------------------------------
  % Obtener la fuerza de advección.
  %if(isa(thisSchemeData.advect, 'cell'))
  advect = thisSchemeData.advect;  
  %else
  %error('schemeData.speed puede ser una celda');
  %end  
  
    %------------------------------------------------------------------------
  % Obtener el coeficiente de atracción.
  if(isa(thisSchemeData.beta, 'double'))
  beta = thisSchemeData.beta;  
  else
  % valor para el coeficiente de atracción por defecto
  beta = 1.0;
  end  
   
  
  %------------------------------------------------------------------------
  % In the end, all we care about is the magnitude of the gradient.
  %---------------------------------------------------------------------------
  % Approximate the convective term dimension by dimension.
  delta = zeros(size(data));
  stepBoundInv = 0;
  for i = 1 : grid.dim
    
    % Get upwinded derivative approximations.
    [ derivL, derivR ] = feval(thisSchemeData.derivFunc, grid, data, i);
    [ dL, dR ] = feval(thisSchemeData.derivFunc, grid, advect, i);
    
    % Figure out upwind direction.
    fL = (dL < 0);
    fR = (dR > 0);
    v  = dL.*fR + dR.*fL;         
        
    flowL = (v < 0);
    flowR = (v > 0);
    
    % Approximate convective term with upwinded derivatives
    %   (where v == 0 derivative doesn't matter).
    deriv = derivL .* flowR + derivR .* flowL;
    
    % Dot product requires sum over dimensions.
    delta = delta + deriv .* v;
    
  
    
    
    % CFL condition.
    stepBoundInv = stepBoundInv + max(abs(v(:))) / grid.dx(i);
  end
  
  %---------------------------------------------------------------------------
  stepBound = 1 / stepBoundInv;
  
  % Reshape output into vector format and negate for RHS of ODE.
  ydot = -beta*delta(:);
 
  
  
  