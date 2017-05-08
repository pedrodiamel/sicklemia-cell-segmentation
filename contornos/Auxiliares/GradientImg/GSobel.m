%--------------------------------------------------------------------------
%FUNCI�N DE FILTRADO A UNA IMG POR SOLBEL
%--------------------------------------------------------------------------   
function [Gr,Ag] = GSobel(I)
%[GR,AG]=GSOBEL(I)
%	entrada:
%	I imagen que se va ha tratar
%   salida:
%   Gr gradiente de la imagen
%   Ag �ngulo
    
    %construcci�n de la m�scara para el c�lculo del gradiente en Y
    mky = [-1 -2 -1; 
            0  0  0; 
            1  2  1];
    %construcci�n de la m�scara para el c�lculo del gradiente en X
    mkx = [-1  0  1; 
           -2  0  2; 
           -1  0  1];

%	c�lculo de GX mediante la convoluci�n de la imagen con la m�scara en x 	
	Gx= imfilter(double(I),mkx);
%	c�lculo de GY mediante la convoluci�n de la imagen con la m�scara en y 	
	Gy= imfilter(double(I),mky);

 	Gr      = sqrt(double(Gx.^2)+double(Gy.^2));
 	angulo  = atan2(double(Gy),double(Gx));
%	convierte el �ngulo a grados
 	Ag      = round(180*angulo/pi);
    
