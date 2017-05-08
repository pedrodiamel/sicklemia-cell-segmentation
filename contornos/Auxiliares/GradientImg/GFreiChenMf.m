%--------------------------------------------------------------------------
%FUNCI�N  DE FILTRO A UNA IMG POR FREICHEN MODIFICADO
%--------------------------------------------------------------------------   
function [Gr,Ag] = GFreiChenMf(I)
%[GR,AG]=GFREICHENMF(I)
%	entrada:
%	I imagen que se va ha tratar
%   salida:
%   Gr gradiente de la imagen
%   Ag angulo
    
    %construcci�n de la m�scara para el c�lculo del gradiente en Y
    mky= [ sqrt(2)/2   1   sqrt(2)/2; 
              0        0      0; 
           -sqrt(2)/2  -1  -sqrt(2)/2];
    %construcci�n de la m�scara para el c�lculo del gradiente en X
    mkx= [-1  0  1; 
          -2  0  2; 
          -1  0  1];

%	c�lculo de GX mediante la convoluci�n de la imagen con la m�scara en x 	
	Gx= imfilter(double(I),mkx);
%	c�lculo de GX mediante la convoluci�n de la imagen con la m�scara en y 	
	Gy= imfilter(double(I),mky);

 	Gr      = sqrt(double(Gx.^2)+double(Gy.^2));
 	angulo  = atan2(double(Gy),double(Gx));
%	convierte el �ngulo a grados
 	Ag      = round(180*angulo/pi);
    
