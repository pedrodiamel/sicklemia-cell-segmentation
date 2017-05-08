%--------------------------------------------------------------------------
%FUNCIÓN PARA CONSTRUIR UN GRUPO
%--------------------------------------------------------------------------
function G = BuilderGrup(G,n)
%G=BUILDERGRUP(G,N)
%	Dado un arreglo G se creará un grupo. Un grupo es un “árbol binario 
%   completo” con la propiedad de que el valor en cualquiera de sus nodos 
%   es menor o igual que el de  sus hijos
%
%   parámetros:
%	G lista de elementos en forma de grupo
%   	n cantidad de elementos
    
	for k = 2:n
       i=k;
       Y = G(k);
       j = fix(i/2);     
              
       while (j>0) && (Y.tmpo < G(j).tmpo)
       G(i)=G(j);       
       i=j;
       j=fix(i/2);        
       end
       
       G(i)=Y;
       
	end
    
end 







