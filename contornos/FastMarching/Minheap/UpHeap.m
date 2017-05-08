%--------------------------------------------------------------------------
%FUNCIÓN UPHEAP PARA BURBUJEAR UN ELEMENTO
%--------------------------------------------------------------------------
function G = UpHeap(G,n,k)
%G=UPHEAP(G,N,K)
%lleva el elemento k-ésimo hacia arriba burbujeándolo, en busca de su
%posición correcta en el grupo G. 
%
%	parámetros:
%	G lista de elementos en forma de grupo
%       .G{i} = [t,v]
%   	n cantidad de elementos
%   	k posición del elemento que se desea burbujear

	if n<k && k<1
       % // código de error 
       return;
	end

	i=k;
	Y = G(k);
	j= fix(i/2);   
             
	while (j>0) && (Y.tmpo < G(j).tmpo)
       
        G(i)=G(j);                      
        i=j;
        j=fix(i/2);

	end
	G(i)=Y;      
      

end