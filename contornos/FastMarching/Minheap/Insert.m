%--------------------------------------------------------------------------
%FUNCIÓN PARA INSERTAR UN ELEMENTO EN EL GRUPO
%--------------------------------------------------------------------------
function [G,n] = Insert(G,n,t,v)
%[G,N]=INSERT(G,N,T,V)
%incrementa el tamaño del heap en uno y lleva el elemento nuevo hacia
%arriba burbujeándolo, en busca de su posición correcta usando una  
%operación UpHeap. 
%
%	parámetros:
%	G   lista de elementos en forma de grupo
%       .G{i} = [t,v]
%   	n   cantidad de elementos
%   	t   valor T
%   	v   coordenadas de fT
%
    %Insertando un elemento en la posición n-ésima
	n = n + 1;    
    G(n).tmpo = t; G(n).cord = v;      
    
    %Burbujeando el valor hasta alcanzar la posición correcta
    G = UpHeap(G,n,n);
 
end