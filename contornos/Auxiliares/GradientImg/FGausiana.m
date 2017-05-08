%--------------------------------------------------------------------------
%FUNCI�N C�LCULO DE LA GAUSSIANA
%--------------------------------------------------------------------------
function G = FGausiana(I,k,var)
%G=FGAUSIANA(I,K,VAR)
%
%	par�metros:
%	Img imagen que se va a tratar
%	k es el tama�o con que se va a construir la m�scara
%	var es el par�metro sigma de la gaussiana
%
%
%	Esta funci�n construye un segmento de gausiana delimitada por -k,k con 
%   sigma=var
 	G   =   fspecial('gaussian',[k k],var);

%	imfilter hace la convoluci�n entre dos funciones en este caso Img y G
 	G  =   imfilter(I,G); 
 




