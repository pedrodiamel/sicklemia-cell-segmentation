%--------------------------------------------------------------------------
%FUNCI�N FZAADVECCION CALCULA LA FUERZA EN FUNCI�N DE LA ADVECCI�N
%--------------------------------------------------------------------------
function [ ydot,stepBound, schemeData ] = fzaadveccion(y, t, schemeData)
% [YDOT,STEPBOUND,SCHEMEDATA]=FZAADVECCION(T,Y,SCHEMEDATA)
% 
%   Una fuerza que atrae la superficie hacia el l�mite, que tiene
%   un efecto equilibrante, especialmente cuando hay una variaci�n
%   grande en el valor del gradiente de la imagen. Este t�rmino
%   denota la proyecci�n de una (atractiva) fuerza vectorial en la
%   normalidad de la superficie. Esta fuerza, introducida en [50],
%   est� realizada como el gradiente de un campo potencial.
% 
%   P(x) = -[grad(G_alfa*I(x))]
%   
% Par�metros:
%   t   tiempo
%   y   conjunto de niveles actual
%   schemeData atributos de la funci�n
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
  % Obtener la fuerza de advecci�n.
  %if(isa(thisSchemeData.advect, 'cell'))
  advect = thisSchemeData.advect;  
  %else
  %error('schemeData.speed puede ser una celda');
  %end  
  
    %------------------------------------------------------------------------
  % Obtener el coeficiente de atracci�n.
  if(isa(thisSchemeData.beta, 'double'))
  beta = thisSchemeData.beta;  
  else
  % valor para el coeficiente de atracci�n por defecto
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
 
  
  
  