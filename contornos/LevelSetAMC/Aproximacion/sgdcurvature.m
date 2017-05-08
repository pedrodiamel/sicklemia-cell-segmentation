%--------------------------------------------------------------------------
%FUNCI�N SGDCURVATURE PARA UNA APROXIMACI�N DE LA CURVATURA DE SEGUNDO ORDEN
%--------------------------------------------------------------------------
function [ curvature, gradMag ] = sgdcurvature(grid, data)
% [CURVATURE,GRADMAG]=SGDCURVATURE(GRID,DATA)
%
% curvSecond: c�lculo de la curvatura a partir de la aproximaci�n de la
% diferencia central de segundo orden
%
% Computando una aproximaci�n de la diferencia central de segundo orden 
% para la curvatura.
%
%       K = divergencia(grad(phi) / ||grad(phi)||)
%
% par�metros:
%   grid     estructura Grid (ver processGrid.m para m�s detalles).
%   data     arreglo Data.
%
%   curvature   aproximaci�n de la curvatura.
%   gradMag     Magnitud del gradiente ||grad(phi)||
%               Incidentalmente calculada mientras se calcula la curvatura,
%               esta tambi�n de segundo orden
%
%--------------------------------------------------------------------------
% Obtener los t�rminos de la derivada de primer y segundo orden.
[ second, first ] = eqdiffcentral(grid, data);

%--------------------------------------------------------------------------
% Computar la magnitud del gradiente.
gradMag2 = first{1}.^2;
for i = 2 : grid.dim
gradMag2 = gradMag2 + first{i}.^2;
end
gradMag = sqrt(gradMag2);

%--------------------------------------------------------------------------
%C�lculo de la curvatura. ver SETHIAN-1999-LEVEL-SET-AND-FAST-MARCHING-
%CAMBRIDGE capitulo 6 epigrafe 7 (ecuacion 6.35)
curvature = zeros(size(data));
for i = 1 : grid.dim;
  curvature = curvature + second{i,i} .* (gradMag2 - first{i}.^2);
  for j = 1 : i - 1
  curvature = curvature - 2 * first{i} .* first{j} .* second{i,j};
  end
end

%  Chequeamos el no encurrir en un error de tipo "Divide by Zero".
%  Si gradMag == 0 implica que curvature == 0, todos los t�rminos 
%  para la aproximaci�n de la curvatura involucran al menos la primera 
%  derivada.
nonzero = find(gradMag > 0);
curvature(nonzero) = curvature(nonzero) ./ gradMag(nonzero).^3;
