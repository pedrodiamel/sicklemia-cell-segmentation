%--------------------------------------------------------------------------
%FUNCIÓN FZANORMAL CALCULA LA FUERZA EN FUNCIÓN DE LA NORMAL
%--------------------------------------------------------------------------
function [ ydot, stepBound, schemeData ] = fzanormal( y, schemeData)
%[YDOT,STEPBOUND,SCHEMEDATA]=FZANORMAL(Y,SCHEMEDATA)
%
%   Una fuerza motriz de expansión (o de deflación) que se sintetizó de el
%   gradiente de la imagen
%
% Parámetros:
%   t   tiempo
%   y   conjunto de niveles actual
%   schemeData atributos de la función
%
%---------------------------------------------------------------------------

  if(iscell(schemeData))
  thisSchemeData = schemeData{1};
  else
  thisSchemeData = schemeData;
  end

  checkStructureFields(thisSchemeData, 'grid', 'derivFunc', 'speed');
  grid = thisSchemeData.grid;

  %---------------------------------------------------------------------------
  % For most cases, we are interested in the first implicit surface function.
  if(iscell(y))
  data = reshape(y{1}, grid.shape);    
  else
  data = reshape(y, grid.shape);
  end

  %---------------------------------------------------------------------------
  % Get speed field.
  if(isa(thisSchemeData.speed, 'double'))
  speed = thisSchemeData.speed;
  else
  error('schemeData.speed must be a scalar');
  end
  
  %---------------------------------------------------------------------------
  % In the end, all we care about is the magnitude of the gradient.
  magnitude = zeros(size(data));

  % In this case, keep track of stepBound for each node until the very
  %   end (since we need to divide by the appropriate gradient magnitude).
  stepBoundInv = zeros(size(data));

  % Determine the upwind direction dimension by dimension
  for i = 1 : grid.dim
    
    % Get upwinded derivative approximations.
    [ derivL, derivR ] = feval(thisSchemeData.derivFunc, grid, data, i);
    
    % Effective velocity in this dimension (scaled by \|\grad \phi\|).
    prodL = speed .* derivL;
    prodR = speed .* derivR;
    magL = abs(prodL);
    magR = abs(prodR);
    
    % Determine the upwind direction.
    %   Either both sides agree in sign (take direction in which they agree), 
    %   or characteristics are converging (take larger magnitude direction).
    flowL = ((prodL >= 0) & (prodR >= 0)) | ...
            ((prodL >= 0) & (prodR <= 0) & (magL >= magR));
    flowR = ((prodL <= 0) & (prodR <= 0)) | ...
            ((prodL >= 0) & (prodR <= 0) & (magL < magR));

    % For diverging characteristics, take gradient = 0
    %   (so we don't actually need to calculate this term).
    %flow0 = ((prodL <= 0) & (prodR >= 0));
    
    % Now we know the upwind direction, add its contribution to \|\grad \phi\|.
    magnitude = magnitude + derivL.^2 .* flowL + derivR.^2 .* flowR;
    
    % CFL condition: sum of effective velocities from O&F (6.2).
    effectiveVelocity = magL .* flowL + magR .* flowR;
    dxInv = 1 / grid.dx(i);
    stepBoundInv = stepBoundInv + dxInv * effectiveVelocity;
  end

  %---------------------------------------------------------------------------
  % Finally, calculate speed * \|\grad \phi\|
  magnitude = sqrt(magnitude);
  delta = speed .* magnitude;

  % Find the most restrictive timestep bound.
  nonZero = find(magnitude > 0);
  stepBoundInvNonZero = stepBoundInv(nonZero) ./ magnitude(nonZero);
  stepBound = 1 / max(stepBoundInvNonZero(:));
  
  % Reshape output into vector format and negate for RHS of ODE.
  ydot = -delta(:);
