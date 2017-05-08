%--------------------------------------------------------------------------
%FUNCIÓN PARA BUSCAR EL MENOR VALOR DEL GRUPO Y SACARLO DEL GRUPO
%--------------------------------------------------------------------------
function [G,n,s] = FindSmallest (G,n)
%[G,N,S]=FINDSMALLEST(G,N)
%involucra suprimir la raíz y utilizar el barrido DownHeap para asegurar
%que los elementos restantes satisfagan la propiedad del heap.
%
%	parámetros:
%	G   lista de elementos en forma de grupo
%   	n   cantidad de elementos
%   	s   menor elemento de G
%

    s = G(1);    
    G(1) = G(n);   
    n = n-1;
    G = DownHeap(G,n,1);
 
end