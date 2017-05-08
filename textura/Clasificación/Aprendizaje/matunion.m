%--------------------------------------------------------------------------
%FUNCIÓN PARA UNIR DOS MATRICES DE APRENDIZAJE
%--------------------------------------------------------------------------
function [MA,K] = matunion(MA,K,X,C,caract)

% Matriz de semejanza MS
outClass = class(X);
[n]      = size(X,1);
[m]      = size(MA,1);

cnames = fieldnames(caract); 
nc     = length(cnames);
fdist   = 'euclidiana';

% Abriendo handle de barra de estado
hbarra = mwaitbar(0,'UNIENDO... 0%');

%Uniendo las dos matrices de semejanza
for i=1:n
        
    switch(fdist)            
    case 'euclidiana'
    %----------------------------------------------------------------------
    % EUCLIDIANA
        
    Y = zeros(m,1); 
    dist = zeros(m,nc);
    for k=1:nc
    
        dsq  = zeros(m,1,outClass);  
        statcarat = caract.(cnames{k});
        
        indx = statcarat.indx;
        w    = statcarat.peso;        
        for q = indx               
            dsq = dsq + (MA(:,q) - X(i,q)).^2;
        end
        dist(:,k) = w.*sqrt(dsq);      
        
    end
    Y  = sum(dist,2)./nc;
    
    
    case 'pointX'
    %----------------------------------------------------------------------
    % DIFERENCIA MENOR QUE UN EPSILON
    
    Eps = 0.1;
    dist = zeros(m,nc);    
    for k=1:nc
    
        dsq = zeros(m,1,outClass);   
        statcarat = caract.(cnames{k});
        
        indx = statcarat.indx;
        w    = statcarat.peso;        
        for q = indx                
        	dsq = dsq + (abs(MA(:,q) - X(i,q)) <= Eps);         
        end
        dist(:,k) = w.*(dsq./length(indx));             
        
    end
    Y = sum(dist,2)./nc;
    end
    
    % Buscando si el conocimiento que se va a añadir fue declarado
    % perteneciente a la clase de texturas conocidas
    [E,j] = min(Y);
    clases = C(i);
    
    if E < 0.1 
    % el conocimiento ya esta incorporado reajustarle la clase a que
    % pertenece 
    	if K(j) ~= clases 
    	%K(j) = max([K(j),C(i)]);
        K(j)  = min([K(j),C(i)]);
    	end
    else
 
        % Seleccionar todos los objetos de MA pertenecientes  la clase de Oi
        ic = K==clases;
        nic = sum(ic);
        
        if nic

            % Calculando la semejanza promedio de Oi a cada elemento de su clase
            G = (nic-1);
            B = sum(Y(ic))/G;

            % Calculando su tipicidad
            coef = sum((B-Y(ic)).^2)/G;
            T = B/coef;

            % Nos interesa añadir los vectores de menor tipicidad
            if T < 15

                % Añadir textura nueva
                m = m+1;
                MA(m,:) = X(i,:);
                K(m) = C(i);

            end

        else

            % Añadir textura nueva
            m = m+1;
            MA(m,:) = X(i,:);
            K(m) = C(i);

        end
        
    end

    % Actualizando barra de estado
    try
        x = i/n;
        mwaitbar(x,hbarra,['UNIENDO ' mat2str(fix(x*100)) '% ...']);
    catch
        break;
    end
    
      
    
end

% Cerrando barra de estado
% close(hbarra);
delete(findobj(get(hbarra,'Children'),'flat','Tag','TMWWaitbar')); 






