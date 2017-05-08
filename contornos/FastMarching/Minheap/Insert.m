%--------------------------------------------------------------------------
%FUNCI�N PARA INSERTAR UN ELEMENTO EN EL GRUPO
%--------------------------------------------------------------------------
function [G,n] = Insert(G,n,t,v)
%[G,N]=INSERT(G,N,T,V)
%incrementa el tama�o del heap en uno y lleva el elemento nuevo hacia
%arriba burbuje�ndolo, en busca de su posici�n correcta usando una  
%operaci�n UpHeap. 
%
%	par�metros:
%	G   lista de elementos en forma de grupo
%       .G{i} = [t,v]
%   	n   cantidad de elementos
%   	t   valor T
%   	v   coordenadas de fT
%
    %Insertando un elemento en la posici�n n-�sima
	n = n + 1;    
    G(n).tmpo = t; G(n).cord = v;      
    
    %Burbujeando el valor hasta alcanzar la posici�n correcta
    G = UpHeap(G,n,n);
 
end