%--------------------------------------------------------------------------
%FUNCIÓN EQDIFFUPWINDFIRST APROXIMACIÓN DE LA PRIMERA DERIVADA
%--------------------------------------------------------------------------
function [ derivL, derivR ] = eqdiffupwindfirst(grid, data, dim)
%[DERIVL,DERIVR]=EQDIFFUPWINDFIRST(GRID,DATA,DIM)
%
% upwindFirstFirst: aproximación upwind de primer orden para la primera
% derivada en la dirección dim.
%
% parámetros:
%   grid        Estructura Grid(ver processGrid.m para más detalles).
%   data        arreglo Data.
%   dim         Dimensión en que será calculada la derivada.
%
%   derivL      Aproximación izquierda para la derivada.
%   derivR      Aproximación derecha para la derivada.

%--------------------------------------------------------------------------
if((dim < 0) || (dim > grid.dim))
  error('Parámetro dim ilegal');
end

dxInv = 1 / grid.dx(dim);

% Cuán grande será el estencil?
stencil = 1;

% Adicionar celdas fantasmas para todas las dimensiones (cond límites).
gdata = feval(grid.bdry{dim}, data, dim, stencil, grid.bdryData{dim});

%--------------------------------------------------------------------------
% Crear arreglo de cell para los índices del arreglo.
sizeData = size(gdata);
indices1 = cell(grid.dim, 1);
for i = 1 : grid.dim
indices1{i} = 1:sizeData(i);
end
indices2 = indices1;

%--------------------------------------------------------------------------
% Calcular los índices reales para la dimensión dim para las derivadas
% izquierdas y derechas
indices1{dim} = 2 : size(gdata, dim);
indices2{dim} = indices1{dim} - 1;

% Este arreglo incluye una entrada adicional en la dimensión de interés.
deriv = dxInv * (gdata(indices1{:}) - gdata(indices2{:}));

%--------------------------------------------------------------------------
% Tomando la aproximación para la derivada izquierda.
indices1{dim} = 1 : size(deriv, dim) - 1;
derivL = deriv(indices1{:});

% Tomando la aproximación para la derivada derecha.
indices1{dim} = 2 : size(deriv, dim);
derivR = deriv(indices1{:});
