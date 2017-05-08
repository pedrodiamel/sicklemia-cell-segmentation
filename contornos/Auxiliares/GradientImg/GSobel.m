%--------------------------------------------------------------------------
%FUNCIÓN DE FILTRADO A UNA IMG POR SOLBEL
%--------------------------------------------------------------------------   
function [Gr,Ag] = GSobel(I)
%[GR,AG]=GSOBEL(I)
%	entrada:
%	I imagen que se va ha tratar
%   salida:
%   Gr gradiente de la imagen
%   Ag ángulo
    
    %construcción de la máscara para el cálculo del gradiente en Y
    mky = [-1 -2 -1; 
            0  0  0; 
            1  2  1];
    %construcción de la máscara para el cálculo del gradiente en X
    mkx = [-1  0  1; 
           -2  0  2; 
           -1  0  1];

%	cálculo de GX mediante la convolución de la imagen con la máscara en x 	
	Gx= imfilter(double(I),mkx);
%	cálculo de GY mediante la convolución de la imagen con la máscara en y 	
	Gy= imfilter(double(I),mky);

 	Gr      = sqrt(double(Gx.^2)+double(Gy.^2));
 	angulo  = atan2(double(Gy),double(Gx));
%	convierte el ángulo a grados
 	Ag      = round(180*angulo/pi);
    
