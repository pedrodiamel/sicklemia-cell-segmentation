%--------------------------------------------------------------------------
%FUNCION STATXTURE EXTRAE CARACTERISTICAS DE LA IMAGEN
%--------------------------------------------------------------------------
function [t] = statxture(f, scale)
%STATXTURE Calcula las medidas estadisticas de primer orden para la textura
%en la imagen.
% T = STATXURE(F,SCALE)calcula seis medidas de textura para la imagen o 
% (region) F. El parametro scale es un vector fila de 6-dimensiones que indica 
% que características por este método seran extraidas. La salida para T puede 
% ser cualquiera de estos 6 elementos:
% T(1) = Average gray level
% T(2) = Average contrast
% T(3) = Measure of smoothness
% T(4) = Third moment
% T(5) = Measure of uniformity
% T(6) = Entropy


if nargin == 1
scale (1:6) = 1;
else %Make sure it's a row vector.
scale = scale(:)';
end
% Obtain histogram and normalize it.
p = imhist(f);
p = p./numel(f);
L = length(p);

% Compute the three moments. We need the unnormalized ones
% from function statmoments. These are in vector mu.
[v, mu] = statmoments(p,3);

% Compute the six texture measures:
% Average gray level.
t (1) = mu(1);

% Standard deviation.
t(2) = mu(2).^0.5;

% Smoothness.
% First normalize the variance to [0 1] by
% dividing it by (L-1)^2.
varn = mu(2)/(L - 1)^2;
t(3) = 1 - 1/(1 + varn);

% Third moment (normalized by (L - 1)^2 also).
t(4) = mu(3)/(L - 1)^2;

% Uniformity.
t(5) = sum(p.^2);

% Entropy.
t(6) = -sum(p.*(log2(p + eps)));

% Scale the values.
t=t.*scale;