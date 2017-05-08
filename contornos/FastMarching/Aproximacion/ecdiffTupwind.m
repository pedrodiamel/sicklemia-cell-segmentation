%--------------------------------------------------------------------------
%FUNCI�N EQDIFFUPWIND ESQUEMA NUM�RICO PARA RESOLVER LA ECUACI�N CUADR�TICA 
%EIKONAL 
%--------------------------------------------------------------------------
function T = ecdiffTupwind(T,TA,TB,TC,TD,speed)
%T=EQDIFFUPWIND(T,TA,TB,TC,EPEED)
%   
%   Aproximaci�n del gradiente |grad(T)| usando valores contrarios a la 
%   direcci�n de propagaci�n.     
%    
%   Par�metros:
%   T   valor aproximado de gradiente en T en el tiempo n
%   TA,TB,TC,TD vecinos de T   
%   speed valor de la velocidad para T
%
%   T aproximaci�n del gradiente en T para el tiempo n+1
%
%--------------------------------------------------------------------------

% Selecionando valores en la direcci�n en contra a la propagaci�n del
% frente usados para aproximar T.
[Tx,Alfa] = min([T,TA,TC]);
[Ty,Beta] = min([T,TB,TD]);


switch (Alfa*10 + Beta)
    
    case {21,12,31,13}
    T = min(Tx,Ty) + speed;

    case {22,33,23,32}
        
        d = 2.0*speed^2-(Tx-Ty)^2;
        if d<0
        T = min(Tx,Ty) + speed;
        else
        T = (Tx+Ty + sqrt(d))/2.0;
        end

    otherwise
        disp('error')
        return;

end
end


