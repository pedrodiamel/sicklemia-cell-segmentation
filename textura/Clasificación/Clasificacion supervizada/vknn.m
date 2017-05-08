%--------------------------------------------------------------------------
%FUNCIÓN PARA CLASIFICACIÓN DE OBJETOS
%--------------------------------------------------------------------------
function [G,C,varargout] = vknn(MA,K,X,k,Eps,varargin)
%[G,C]=KNN(MA,X)
%Algoritmo de clasificación supervisada K-NN o los k vecinos más cercano
%
%--------------------------------------------------------------------------


if nargin < 7
hbarra = waitbar(0,'Clasificando ... 0% ','WindowStyle','modal');
else
hbarra = varargin{2};
waitbar(0,hbarra,'Clasificando ... 0%');    
end

outClass = class(X);
[n,p] = size(X);
G     = zeros(n,1); 
[m,p] = size(MA);


%Chequeando los datos de entrada
if m < k
error('Las dimensiones de k son mayores que m')    
end

dist = 'euclidiana';

% Cantidad de caracteristicas
% W structura con los conjunto de apoyo
caract = varargin{1};
cnames = fieldnames(caract); 
nc     = length(cnames);


switch dist
    
    case 'seuclidiana' 
    % Normalizando los objetos
    additionalArg = 1 ./ var([MA;X])';    
    
end


% obteniendo el tiempo de la cpu actual
startTime = cputime;

% Calculando la distacia de cada objeto con la matriz de semejanza 
for i = 1:n
     
    %----------------------------------------------------------------------
    % función de semejanza
    switch(dist) 
    
    case 'euclidiana' 
    % EUCLIDIANA

    currentdist = zeros(m,nc);
    for p=1:nc

        dsq = zeros(m,1,outClass);
        statcarat = caract.(cnames{p});

        indx = statcarat.indx;
        w    = statcarat.peso;

        for q = indx
            dsq = dsq + (MA(:,q) - X(i,q)).^2;
        end
        currentdist(:,p) = w.*sqrt(dsq);

    end
    Y = sum(currentdist,2)./nc;
    
           
    case 'seuclidiana'
    %----------------------------------------------------------------------
    % Distancia euclidiana por tipo de medida
       
    currentdist = zeros(m,nc); 
    wgts = additionalArg;
    for p=1:nc
            
        dsq = zeros(m,1,outClass);   
        statcarat = caract.(cnames{p});
        
        indx = statcarat.indx;
        w    = statcarat.peso; 
             
        for q = indx                
            dsq = dsq + wgts(q).*(MA(:,q) - X(i,q)).^2;                
        end                   
        currentdist(:,p) = w.*sqrt(dsq);
        
    end
    Y = sum(currentdist,2)./nc;       
            
    end
    
        
    %----------------------------------------------------------------------
    % seleccionar los k más semejantes
    
    cls = zeros(k,1);    
    for j=1:k
    
    [C,I]  = min(Y);
    cls(j) = K(I)*(C<Eps); 
    Y(I)   = inf; 
    
    end
    
    %----------------------------------------------------------------------
    % Asignando la clase que más se repite
    G(i) = mode(cls);
    
    % actualizando la barra de estado
    x = i/n;
    waitbar(x,hbarra,['Clasificando ... ' num2str(fix(x*100)) '%']); 
    
end

% Calculando la cantidad de grupos asignados
C = length(unique(G));

endTime = cputime;
totalTime = endTime - startTime; 

if nargin < 7
close(hbarra);   
end

% set time in varargout
if nargout > 2
varargout{1} = totalTime;
end


