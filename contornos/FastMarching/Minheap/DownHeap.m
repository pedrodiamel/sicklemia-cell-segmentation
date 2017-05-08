%--------------------------------------------------------------------------
%FUNCI�N DOWNHEAP PARA BURBUJEAR DE LA RA�Z A LAS HOJAS
%--------------------------------------------------------------------------
function G = DownHeap(G,n,k)
%G=DOWNHEAP(G,N,K)
%lleva el elemento k-�simo hacia abajo burbuje�ndolo, en busca de su
%posici�n correcta en el grupo G. 
%
%	par�metros:
%	G lista de elementos en forma de grupo     
%   	n cantidad de elementos
%   	k elemento a burbujear
%
      
	if n<k && k<1
       % // c�digo de error 
       return;
	end

	Y = G(k);       
	i=k;
	j=2*k;       
	if (j<=n-1) && (G(j).tmpo > G(j+1).tmpo)
	j=j+1;
	end          
       
	while (j<=n) && (Y.tmpo > G(j).tmpo)

        G(i)=G(j);    
        i=j;
        j=i*2; 
        if(j+1<=n) && (G(j).tmpo>G(j+1).tmpo)
        j=j+1;
        end

	end
	G(i)=Y;     

end