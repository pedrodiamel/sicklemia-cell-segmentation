function bc = gabfiltros(n)

  ang = [0,pi/4,pi/2,3*pi/4];   % orientaci�n de los �ngulos                             
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
%   Genera un filtro con la funci�n de gabor
%   lambda:  Longitud de onda
%   theta:   Orientaci�n
%   phi:     Desplazamiento de fase
%   gamma:   Relaci�n de aspecto
%   sigma:   Desviaci�n estandar del factor gausiano
%   w:       n�mero de p�xeles del cuadrado del
  
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