%--------------------------------------------------------------------------
%FUNCIÓN  DE FILTRO A UNA IMG POR FREICHEN MODIFICADO
%--------------------------------------------------------------------------   
function [Gr,Ag] = GFreiChenMf(I)
%[GR,AG]=GFREICHENMF(I)
%	entrada:
%	I imagen que se va ha tratar
%   salida:
%   Gr gradiente de la imagen
%   Ag angulo
    
    %construcción de la máscara para el cálculo del gradiente en Y
    mky= [ sqrt(2)/2   1   sqrt(2)/2; 
              0        0      0; 
           -sqrt(2)/2  -1  -sqrt(2)/2];
    %construcción de la máscara para el cálculo del gradiente en X
    mkx= [-1  0  1; 
          -2  0  2; 
          -1  0  1];

%	cálculo de GX mediante la convolución de la imagen con la máscara en x 	
	Gx= imfilter(double(I),mkx);
%	cálculo de GX mediante la convolución de la imagen con la máscara en y 	
	Gy= imfilter(double(I),mky);

 	Gr      = sqrt(double(Gx.^2)+double(Gy.^2));
 	angulo  = atan2(double(Gy),double(Gx));
%	convierte el ángulo a grados
 	Ag      = round(180*angulo/pi);
    
