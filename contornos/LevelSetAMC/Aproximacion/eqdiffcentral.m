%--------------------------------------------------------------------------
%FUNCION EQDIFFCENTRAL
%--------------------------------------------------------------------------
function [ second, first ] = eqdiffcentral(grid, data)
% diffcenter: aproximaci�n central de segundo y primer orden del diferencial 
% por Hessian.
%
%   [ second, first ] = diffcenter(grid, data)
%
% Computar una aproximaci�n central de segundo orden para el diferencial por
% Hessian (la derivada espacial mixta de segundo orden para data).
%
% par�metros:
%   grid	estructura Grid  (ver processGrid.m para m�s detalles).
%   data    arreglo Data.
%
%   second      arreglo de cell 2D que contiene la aproximaci�n central de 
%               los t�rminos.                 
%               second{i,j} = d^2 data / dx_i dx_j   if j < i
%                           = d^2 data / dx_i^2      if j = i
%                           = []                     if j > i
%
%   first       arreglo de cell 1D  que contiene la aproximaci�n central 
%               para el gradient
%               first{i}    = d data / dx_i
%
% Los elementos de  second (y first) tienen las mismas dimensiones que el
% arreglo data.
%
%Por que la aproximacion del gradiente es provista? 
%   Una aproximaci�n del gradiente es parte del proceso de computar los
%   t�rminos de las derivadas parciales mixtas en Hessian, asi se retornan
%   estos valores requeridos como resultado de una peque�a computaci�n 
%   extra. Note que este gradiente es una aproximaci�n de diferencia central 
%   de segundo orden, asi que esto es inapropiado para ser usado en los 
%   t�rminos de un PDE.
%
%---------------------------------------------------------------------------
dxInv = 1 ./ grid.dx;

% Cu�n grande ser� el estencil?
stencil = 1;

% Adicionar celdas fantasmas para todas las dimensiones (cond l�mites).
data = addGhostAllDims(grid, data, stencil);

%---------------------------------------------------------------------------
% Necesitamos �ndices para el arreglo data real.
indReal = cell(grid.dim, 1);
for i = 1 : grid.dim
  indReal{i} = 1 + stencil : grid.N(i) + stencil;
end

% Tambi�n �ndices para data(incluyendo las celdas fantasmas).
indAll = cell(grid.dim, 1);
for i = 1 : grid.dim
  indAll{i} = 1 : grid.N(i) + 2 * stencil;
end

%---------------------------------------------------------------------------
% Derivada parcial de primer orden (aproximaci�n del gradiente).
first = cell(grid.dim, 1);
for i = 1 : grid.dim
  % dejando las celdas fantasmas intactas (para las parciales mixtas debajo)
  indices1 = indAll;
  indices2 = indAll;
  indices1{i} = indReal{i} + 1;
  indices2{i} = indReal{i} - 1;
  first{i} = 0.5 * dxInv(i) * (data(indices1{:}) - data(indices2{:}));
end

%---------------------------------------------------------------------------
% Derivada parcial central de segundo orden (aproximaci�n de Hessian).
%   S�lo calcularemos la de segundo orden para la diagonal inferior, 
%   a partir de las derivadas parciales.

second = cell(grid.dim, grid.dim);
for i = 1 : grid.dim
  % Primero, las  derivadas parciales puras de segundo orden.   
  indices1 = indReal;
  indices2 = indReal;
  indices1{i} = indices1{i} + 1;
  indices2{i} = indices2{i} - 1;
  second{i,i} = dxInv(i).^2 * (data(indices1{:}) - 2 * data(indReal{:}) ...
                               + data(indices2{:}));

  % Ahora las mixtas.
  for j = 1 : i - 1
    
    indices1 = indReal;
    indices2 = indReal;
    % In already differentiated dimension, we have no ghost cells.
    indices1{i} = 1 : grid.N(i);
    indices2{i} = 1 : grid.N(i);
    % Now take a centered difference in second direction.
    indices1{j} = indReal{j} + 1;
    indices2{j} = indReal{j} - 1;

    second{i,j} =  0.5 * dxInv(i) * (first{i}(indices1{:}) ...
                                     - first{i}(indices2{:}));
  end
end

%---------------------------------------------------------------------------
% Si queremos usar la aproximaci�n del gradiente,
%   quitamos las celdas fantasmas.
if(nargout > 1)
  for i = 1 : grid.dim
    indices1 = indReal;
    % En las dimensiones diferenciadas, no necesitamos las celdas 
    % fantasmas.
    indices1{i} = 1 : grid.N(i);
    first{i} = first{i}(indices1{:});
  end
end
