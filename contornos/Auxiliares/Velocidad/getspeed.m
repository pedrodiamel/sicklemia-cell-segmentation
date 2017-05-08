%--------------------------------------------------------------------------
%FUNCIÓN PARA CALCULAR LA VELOCIDAD DEPENDIENTE DEL GRADIENTE DE LA IMAGEN
%--------------------------------------------------------------------------
function speed = getspeed(I,varargin)
%SPEED=GETSPEED(I)
%
%var = 3.0;
%k   = 3.0;
%G = FGausiana(I,k,var);

H = fspecial('gaussian');
G = imfilter(I,H,'replicate','conv');
[Gr,Ag] = GSobel(G);


if nargin < 2
speed = 1./(1+abs(Gr));  

else
alfa  = varargin{1}; 
speed = exp(-1*alfa*abs(Gr));
end