%--------------------------------------------------------------------------
%FUNCI�N PARA EXTRAER LOS REPRESENTANTES DE LAS TEXTURAS
%--------------------------------------------------------------------------
function [G,MA,k,totalTime] = gettextura(X,caract,tecn,valor)
%[G,MA,K,TOTALTIME]=GETTEXTURA(X,CARACT,TECN,VALOR)
%
% Esta funci�n calcula de la poblaci�n de caracter�sticas X su 
% representante.
%
% El representante de un conjunto C de caracter�sticas es un subconjunto
% minimal S de C que satisface que:
% Todo elemento pr�ximo o semejante a C lo es tambi�n a S a partir de una 
% funci�n B de proximidad o semejanza.
% 
% Entrada:
%   X       vector de rasgos
%   caract  estructura de caracteristica (ver wndpass)
%   tecn    m�todo a utilizar (Kmeans o B0conexo)
%   valor   parametro del algoritmo de clasificaci�n
%
% Salida
%   G       grupos
%   MA      representantes
%   k       vector de dimensiones size(MA) que indica que objetos de MA representa
%           una misma textura 
%   totalTime tiempo de cpu
%

% Inicializaci�n
k = 0;
[n,p] = size(X);

% obteniendo el tiempo de la cpu actual
startTime = cputime;
switch tecn
    
    
    case 'K-means'
        
        % Aplicaci�n del algoritmo de clasificaci�n no supervisada kmeans
        % para formar k grupos de la poblaci�n de p�xeles de la imagen.
        if nargin < 4
        k = 10; % cantidad de grupos por defectos
        else
        k = int8(valor{1});
        end
          
        % Distancia empleada
        dist = 'sqEuclidean';
        
        try 
        [G,MA] = kmeans(X,k,'Start','cluster','distance',dist);
        k = 1:k;
        catch
        return;    
        end
                    
    case 'B0-conexo'
        
        % Aplicaci�n del algoritmo de clasificaci�n no supervisada beta
        % cero conexo para formar k componentes conexas (cada componente 
        % conexa es un grupo).  
        
        % Abriendo handle de barra de estado        
        hbarra  = waitbar(0,'...','WindowStyle','modal');
                
        Bo  = valor{1};
        Eps = valor{2};
        
        % Distancia empleada
        dist = 'euc';
        
        % Aplicar algoritmo bo
        [G,k] = vboconexo(X,caract,Bo,dist,Eps,hbarra);
        
              
        % Calculando los representantes de cada grupo        
        beg = 1;        
        for i=1:k
        
            indx = G==i;            
            R = vgetrepresentantes(X(indx,:),Bo,caract,Eps,hbarra);
            [m]  = size(R,1);
            
            D(i) = beg+m-1;            
            MA(beg:D(i),:) = R;            
            beg = beg+m;                       
            
        end
        
        % Asign�ndole a k el vector de las coordenadas de los
        % representantes
        k = D;
        
        %Cerrando la barra de estado
        close(hbarra);
        
end

endTime = cputime;
totalTime = endTime - startTime; 





