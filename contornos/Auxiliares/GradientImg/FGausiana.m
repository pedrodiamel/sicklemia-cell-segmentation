%--------------------------------------------------------------------------
%FUNCIÓN CÁLCULO DE LA GAUSSIANA
%--------------------------------------------------------------------------
function G = FGausiana(I,k,var)
%G=FGAUSIANA(I,K,VAR)
%
%	parámetros:
%	Img imagen que se va a tratar
%	k es el tamaño con que se va a construir la máscara
%	var es el parámetro sigma de la gaussiana
%
%
%	Esta función construye un segmento de gausiana delimitada por -k,k con 
%   sigma=var
 	G   =   fspecial('gaussian',[k k],var);

%	imfilter hace la convolución entre dos funciones en este caso Img y G
 	G  =   imfilter(I,G); 
 




