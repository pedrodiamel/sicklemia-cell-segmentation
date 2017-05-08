%--------------------------------------------------------------------------
%FUNCIÓN FZACURVATURA CALCULA LA FUERZA EN FUNCIÓN DE LA CURVATURA
%--------------------------------------------------------------------------
function [ ydot, stepBound, schemeData ] = fzacurvatura( y, schemeData)
% [YDOT,STEPBOUND,SCHEMEDATA]=FZACURVATURA(Y,SCHEMEDATA)
% 
% 
%
%
%

  %------------------------------------------------------------------------
  if(iscell(schemeData))
  thisSchemeData = schemeData{1};
  else
  thisSchemeData = schemeData;
  end

  checkStructureFields(thisSchemeData, 'grid', 'expand', 'curvatureFunc');
  grid = thisSchemeData.grid;

  %------------------------------------------------------------------------
  if(iscell(y))
  data = reshape(y{1}, grid.shape);    
  else
  data = reshape(y, grid.shape);
  end
  
  %-----------------------------------------------------------------------
  % Obteniendo la velocidad de expansión 
  if(isa(thisSchemeData.expand, 'double'))
  expand = thisSchemeData.expand;
  else
  error('schemeData.expand no es un escalar');
  end
  
  %-----------------------------------------------------------------------
  % Obteniendo el epsilon
  if(isa(thisSchemeData.eps, 'double'))
  eps = thisSchemeData.eps;
  else
  % valor de epsilon por defecto
  eps = 0.1;
  end

  %------------------------------------------------------------------------
  % De acuerdo con la función de O&F (4.5).
  [ curvature, gradMag ] = feval(thisSchemeData.curvatureFunc, grid, data);
  %delta =  eps.*curvature.* gradMag;
  %delta =  1-eps.*curvature;
  delta = curvature;
  
  %------------------------------------------------------------------------
  % De acuerdo con la función de O&F (4.7).
  stepBound = 1 / (2 * max(expand(:)) * sum(grid.dx .^ -2));
  
  % Reshape output into vector format and negate for RHS of ODE.
  ydot = delta(:);
  
    
