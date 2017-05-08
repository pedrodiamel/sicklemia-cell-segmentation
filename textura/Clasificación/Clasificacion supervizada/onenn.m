%--------------------------------------------------------------------------
%FUNCION PARA CLASIFICACION DE OBJETOS
%--------------------------------------------------------------------------
function [G,C] = onenn(MA,X,Eps)
%[G,C]=ONENN(MA,X)
%Algoritmo de clasificacion supervisada ONENN el vecino mas cercano
%
%--------------------------------------------------------------------------
% Matriz de semejanza MS
outClass = class(X);
[n,p] = size(X);
G     = zeros(n,1); 
[m,p] = size(MA);

%calculando la distacia de cada objeto co la matriz de semejanza 
%----------------------------------------------------------------------
% EUCLIDIANA NORMALIZADA
for i = 1:n
       
    dsq  = zeros(m,1,outClass);     
    for q = 1:p
        dsq  = dsq  + (MA(:,q) - X(i,q)).^2;               
    end    
    Y = sqrt(dsq);   
    [C,G(i)] = min(Y);
    G(i) = G(i)*(C<Eps);
    
end

% calculando la cantidad de grupos asignados
C = length(unique(G));