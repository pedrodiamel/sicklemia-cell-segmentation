%--------------------------------------------------------------------------
%FUNCI�N EQDIFFUPWINDFIRST APROXIMACI�N DE LA PRIMERA DERIVADA
%--------------------------------------------------------------------------
function [ derivL, derivR ] = eqdiffupwindfirst(grid, data, dim)
%[DERIVL,DERIVR]=EQDIFFUPWINDFIRST(GRID,DATA,DIM)
%
% upwindFirstFirst: aproximaci�n upwind de primer orden para la primera
% derivada en la direcci�n dim.
%
% par�metros:
%   grid        Estructura Grid(ver processGrid.m para m�s detalles).
%   data        arreglo Data.
%   dim         Dimensi�n en que ser� calculada la derivada.
%
%   derivL      Aproximaci�n izquierda para la derivada.
%   derivR      Aproximaci�n derecha para la derivada.

%--------------------------------------------------------------------------
if((dim < 0) || (dim > grid.dim))
  error('Par�metro dim ilegal');
end

dxInv = 1 / grid.dx(dim);

% Cu�n grande ser� el estencil?
stencil = 1;

% Adicionar celdas fantasmas para todas las dimensiones (cond l�mites).
gdata = feval(grid.bdry{dim}, data, dim, stencil, grid.bdryData{dim});

%--------------------------------------------------------------------------
% Crear arreglo de cell para los �ndices del arreglo.
sizeData = size(gdata);
indices1 = cell(grid.dim, 1);
for i = 1 : grid.dim
indices1{i} = 1:sizeData(i);
end
indices2 = indices1;

%--------------------------------------------------------------------------
% Calcular los �ndices reales para la dimensi�n dim para las derivadas
% izquierdas y derechas
indices1{dim} = 2 : size(gdata, dim);
indices2{dim} = indices1{dim} - 1;

% Este arreglo incluye una entrada adicional en la dimensi�n de inter�s.
deriv = dxInv * (gdata(indices1{:}) - gdata(indices2{:}));

%--------------------------------------------------------------------------
% Tomando la aproximaci�n para la derivada izquierda.
indices1{dim} = 1 : size(deriv, dim) - 1;
derivL = deriv(indices1{:});

% Tomando la aproximaci�n para la derivada derecha.
indices1{dim} = 2 : size(deriv, dim);
derivR = deriv(indices1{:});
