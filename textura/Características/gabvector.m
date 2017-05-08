%--------------------------------------------------------------------------
%FUNCION GABOR PARA LA EXTRACCION DE CARACTERISTICAS SEGUN LOS FILTROS DE
%GABOR
%--------------------------------------------------------------------------
function stats = gabvector(I)
% STATS=GABVECTOR extrayendo las caracteristicas de la imagen segun los
% filtros de gabor
%
%ENTRADA:  
%   I: imagen a la cual se le hará la extracción de un vector de
%   caracteristicas
%               
%SALIDA:
%   stats   vector característico
%           -Smoothness  ... 
%           -Desviación estandar
%           -Energía de activacion    
%METODO:
%   PASO 1: Calcular el banco de filtros de gabor
%   PASO 2: Convolucionar la imagen con dichos filtros
%   PASO 3: Extraer caracteristicas
%
%--------------------------------------------------------------------------
% calculando las mascaras de gabor en 8 direcciones 
wndzise  = length(I);
gbf  = gabfiltros(wndzise);


%Inicializando variables
numStats = 3;
numGLGM  = length(gbf);
stats    = zeros(numStats,numGLGM); 
    
for p = 1 : numGLGM

      % Convolucionamos la imagen con cada filtro del banco de filtro y
      % guardamos los resultados en glgm para luego calcularle las
      % características de la textura

      glgm = imfilter(I,gbf{p},'conv');      
      tGLGM = normalizeGLGM(glgm);

      s = size(tGLGM);
      [c,index] = meshgrid(1:s(1),1:s(2));
      index = index(:); 
      %////c = c(:);      
      
      %calculando 'Smoothness'
      stats(1,p) = calcSmoothness (tGLGM,index);      
      %calculando 'Desviacion'
      stats(2,p) = calcDesviacion(tGLGM,index);      
      %calculando 'Energia'
      stats(3,p) = calcEnergy(tGLGM); 
      
end

stats = stats(:);
stats = stats';

end
%--------------------------------------------------------------------------
function bc = gabfiltros(n)

  ang = [0,pi/4,pi/2,3*pi/4];   % orientación de los ángulos                             
  co = 4;                       % cantidad de orientaciones
  fase = [0, -pi/2];            % fase de los filtros
  cf = 2;                       % cantidad de fases
  
  
  [c,r] = meshgrid(1:cf,1:co);
  r = r(:);
  c = c(:);      
  bc  = kernel(n/4,ang(r(:)),fase(c(:)),0.5,n);  
  
end
%--------------------------------------------------------------------------
function G = kernel(lambda,theta,phi,gamma,w)
%
%   Genera un filtro con la función de gabor
%   lambda:  Longitud de onda
%   theta:   Orientación
%   phi:     Desplazamiento de fase
%   gamma:   Relación de aspecto
%   sigma:   Desviación estandar del factor gausiano
%   w:       número de píxeles del cuadrado del
  
  sigma = 0.56*lambda;
  %sigma = 10*lambda;
  n = fix(w/2);
  h = length(phi);  
    
  [c,r] = meshgrid(-n:n);
  x  = r(:);
  y  = c(:);
  xr =  x(:)*cos(theta) + y(:)*sin(theta);
  yr = -x(:)*sin(theta) + y(:)*cos(theta);
  
  
  A = (xr./lambda).*(2*pi);  
  for i=1:(w*w)
  A(i,:) = A(i,:) +  phi;
  end 
  
  g = exp(-(xr.^2 + (yr.^2).*gamma^2)./(2*sigma^2)).*cos(A);  
  G = cell(h,1);
  for i=1:h      
  [G{i}] =  reshape(g(:,i),w,w);
  end

 
end

%--------------------------------------------------------------------------
function glgm = normalizeGLGM(glgm)  
% Normalice glgm.

 mn = min(glgm(:));
 mx = max(glgm(:));
 if mn~=mx
 glgm = (glgm - mn)./(mx-mn);
 else
 glgm = (glgm - mn)./(mx-mn+eps);    
 end

end
%--------------------------------------------------------------------------
function E = calcEnergy(glgm)
% Energía de activación
E = sum(glgm(:));
end
%--------------------------------------------------------------------------
function M = Media(glgm,index)
% Media 
M = index .* double(glgm(:));
M = sum(M);
end
%--------------------------------------------------------------------------
function V = Varianza(glgm,mean,index)
% Varianza
index = (index - mean).^2;
V  = index .* double(glgm(:));
V  = sum(V);
end
%--------------------------------------------------------------------------
function D = calcDesviacion(glgm,r)
% Desviación estandar
M = Media(glgm,r);
D = Varianza(glgm,M,r); 
end
%--------------------------------------------------------------------------
function S = calcSmoothness(glgm,r)
% Varianza como descriptor de suavidad
V = calcDesviacion(glgm,r);
S = 1-(1/(1+V));
end

