%--------------------------------------------------------------------------
%FUNCION PARA EXTRAR LAS CARACTERISTICAS DE LA MATRIZ DE COOCURRENCIA
%--------------------------------------------------------------------------
function stats = coprops(glcm)

% Inicializando la estructura de salida de datos.
numStats  = 6;
numGLCM   = size(glcm,3);
stats     = zeros(numStats,numGLCM);

for p = 1 : numGLCM

    % Normalizando de la matriz de co-ocurrencia
    if numGLCM ~= 1
        tGLCM = normalizeGLCM(glcm(:,:,p));
    else
        tGLCM = normalizeGLCM(glcm);
    end

    % Obteniendo los subcriptores de las filas y las columnas de GLCM. Los
    % subcriptores se cprresponden colas coordenadas de los pixeles de GLCM
    s = size(tGLCM);
    [c,r] = meshgrid(1:s(1),1:s(2));
    r = r(:);
    c = c(:);

    % Calculando las medidas propuestas para la matriz de co-ocurrencia.
    % calculando 'Contrast'
    stats(1,p) = calculateContrast(tGLCM,r,c);
    % calculando 'Correlation'
    stats(2,p) = calculateCorrelation(tGLCM,r,c);
    % calculando 'Uniformity'
    stats(3,p) = calculateUniformity(tGLCM);
    % calculando 'Homogeneity'
    stats(4,p) = calculateHomogeneity(tGLCM,r,c);
    % calculando 'MaxProbability'
    stats(5,p) = calculateMaxProbability(tGLCM);
    % calculando 'Entropy'
    stats(6,p) = calculateEntropy(tGLCM);


end


%-----------------------------------------------------------------------------
function glcm = normalizeGLCM(glcm)

% Normalizando los valores de glcm
if any(glcm(:))
    glcm = glcm ./ sum(glcm(:));
end

%-----------------------------------------------------------------------------
function C = calculateContrast(glcm,r,c)
% Referencia: Haralick RM, Shapiro LG. Computer and Robot Vision: Vol. 1,
% Addison-Wesley, 1992, p. 460.
k = 2;
l = 1;
term1 = abs(r - c).^k;
term2 = glcm.^l;

term = term1 .* term2(:);
C = sum(term);

% normalizando la contraste rango: [0 (size(glcm,1)-1)^2] 
normC = (size(glcm,1)-1)^2;
C = C./normC;

%-----------------------------------------------------------------------------
function Corr = calculateCorrelation(glcm,r,c)
% References:
% Haralick RM, Shapiro LG. Computer and Robot Vision: Vol. 1, Addison-Wesley,
% 1992, p. 460.
% Bevk M, Kononenko I. A Statistical Approach to Texture Description of Medical
% Images: A Preliminary Study., The Nineteenth International Conference of
% Machine Learning, Sydney, 2002.
% http://www.cse.unsw.edu.au/~icml2002/workshops/MLCV02/MLCV02-Bevk.pdf, p.3.

% Correlación se define como la covariance(r,c) / S(r)*S(c) donde S es la
% desviación estandar.

% Calculando la media y la desviación estandar del valor e un pixel en cada
% fila
mr = meanIndex(r,glcm);
Sr = stdIndex(r,glcm,mr);

% Calculando la media y la desviación estandar del valor e un pixel en cada
% columna
mc = meanIndex(c,glcm);
Sc = stdIndex(c,glcm,mc);

term1 = (r - mr) .* (c - mc) .* glcm(:);
term2 = sum(term1);

ws = warning('off','Matlab:divideByZero');
Corr = term2 / (Sr * Sc + eps);
warning(ws);

%-----------------------------------------------------------------------------
function S = stdIndex(index,glcm,m)

term1 = (index - m).^2 .* glcm(:);
S = sqrt(sum(term1));

%-----------------------------------------------------------------------------
function M = meanIndex(index,glcm)

M = index .* glcm(:);
M = sum(M);

%-----------------------------------------------------------------------------
function U = calculateUniformity(glcm)
% Referencia: Haralick RM, Shapiro LG. Computer and Robot Vision: Vol. 1,
% Addison-Wesley, 1992, p. 460.

foo = glcm.^2;
U = sum(foo(:));

function P = calculateMaxProbability(glcm)
% Maxima Probabilidad
P = max(glcm(:));

function E = calculateEntropy(glcm)
% Entropia
term = glcm(:).*log2(glcm(:)+eps);
E = -sum(term(:));

%-----------------------------------------------------------------------------
function H = calculateHomogeneity(glcm,r,c)
% Referencia: Haralick RM, Shapiro LG. Computer and Robot Vision: Vol. 1,
% Addison-Wesley, 1992, p. 460.

term1 = (1 + abs(r - c));
term = glcm(:) ./ term1;
H = sum(term);

