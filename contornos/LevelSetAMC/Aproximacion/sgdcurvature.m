%--------------------------------------------------------------------------
%FUNCIÓN SGDCURVATURE PARA UNA APROXIMACIÓN DE LA CURVATURA DE SEGUNDO ORDEN
%--------------------------------------------------------------------------
function [ curvature, gradMag ] = sgdcurvature(grid, data)
% [CURVATURE,GRADMAG]=SGDCURVATURE(GRID,DATA)
%
% curvSecond: cálculo de la curvatura a partir de la aproximación de la
% diferencia central de segundo orden
%
% Computando una aproximación de la diferencia central de segundo orden 
% para la curvatura.
%
%       K = divergencia(grad(phi) / ||grad(phi)||)
%
% parámetros:
%   grid     estructura Grid (ver processGrid.m para más detalles).
%   data     arreglo Data.
%
%   curvature   aproximación de la curvatura.
%   gradMag     Magnitud del gradiente ||grad(phi)||
%               Incidentalmente calculada mientras se calcula la curvatura,
%               esta también de segundo orden
%
%--------------------------------------------------------------------------
% Obtener los términos de la derivada de primer y segundo orden.
[ second, first ] = eqdiffcentral(grid, data);

%--------------------------------------------------------------------------
% Computar la magnitud del gradiente.
gradMag2 = first{1}.^2;
for i = 2 : grid.dim
gradMag2 = gradMag2 + first{i}.^2;
end
gradMag = sqrt(gradMag2);

%--------------------------------------------------------------------------
%Cálculo de la curvatura. ver SETHIAN-1999-LEVEL-SET-AND-FAST-MARCHING-
%CAMBRIDGE capitulo 6 epigrafe 7 (ecuacion 6.35)
curvature = zeros(size(data));
for i = 1 : grid.dim;
  curvature = curvature + second{i,i} .* (gradMag2 - first{i}.^2);
  for j = 1 : i - 1
  curvature = curvature - 2 * first{i} .* first{j} .* second{i,j};
  end
end

%  Chequeamos el no encurrir en un error de tipo "Divide by Zero".
%  Si gradMag == 0 implica que curvature == 0, todos los términos 
%  para la aproximación de la curvatura involucran al menos la primera 
%  derivada.
nonzero = find(gradMag > 0);
curvature(nonzero) = curvature(nonzero) ./ gradMag(nonzero).^3;
