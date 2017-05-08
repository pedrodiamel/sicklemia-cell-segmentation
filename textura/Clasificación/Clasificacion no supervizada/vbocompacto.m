%--------------------------------------------------------------------------
%FUNCIÓN PARA FORMAR GRUPOS BO_COMPACTOS 
%--------------------------------------------------------------------------
function [G,C] = vbocompacto(O,Bo,caract,dist,varargin)
%--------------------------------------------------------------------------
%ENTRADA
%   O   colección de objetos con p rasgos
%   Bo  menor valor de semejanza entre los objetos, este debe estar entre
%       cero y uno
%--------------------------------------------------------------------------
%SALIDA
%   G   grupos beta cero compactos
%       Sea n la cantidad de objetos de O. G es un vector tal que: el
%       índice i representa el objeto i-ésimo y G(i) el grupo al que
%       pertenece
%
%ALGORITMO
%              
%   
%
%--------------------------------------------------------------------------
%INICIALIZACIÓN

[n,p] = size(O);    
outClass = class(O);
        

G = zeros(1,n);     % grupos
S = num2cell(1:n);  % entradas    
X = zeros(1,n);     % rastro


if nargin < 4
dist = 'euclidiana';
end

switch dist
    
    case 'seuclidiana'
    additionalArg = 1 ./ var(O)';
    
    case 'Xeuclidiana'
    
    additionalArg = 1 ./ var(O)';    
    % Cantidad de características
    cnames = fieldnames(caract); 
    ncarct = length(cnames);
    

    case 'mahalanobis'
    %inv(cov(X)); 
    additionalArg = cov(O) \ eye(p); 
    
    case 'Xpoint'
    % Cantidad de características
    cnames = fieldnames(caract); 
    ncarct = length(cnames);   
    
end

% Abriendo handle de barra de estado
if nargin < 5    
    % Abriendo handle de barra de estado
    hbarra  = waitbar(0,'AGRUPANDO... 0%','WindowStyle','modal');
else
    % Obteniendo la barra de estado
    hbarra = varargin{2};
    waitbar(0,hbarra,'AGRUPANDO... 0%');   
end



%--------------------------------------------------------------------------
%MÉTODO

for i=1:(n-1)
    
     
    Y = zeros(1,n-i+1); %fila actual de semejanza entre objetos                  
    %----------------------------------------------------------------------
    % 1 CALCULO DE LA DISTANCIA
    % Funcion de semejanza entre objetos 
    switch(dist)
        
    case 'euclidiana'
    %----------------------------------------------------------------------
    % EUCLIDIANA
    
    dsq = zeros(n-i,1,outClass);    
    for q = 1:p
        dsq = dsq + (O(i,q) - O((i+1):n,q)).^2;          
    end   
    Y(2:end) = sqrt(dsq);
    Y = (Y<Bo).*Y;
    
    
    case 'seuclidiana'
    %----------------------------------------------------------------------
    % EUCLIDIANA NORMALIZADA
    dsq  = zeros(n-i,1,outClass); 
    wgts = additionalArg;
    for q = 1:p
        dsq  = dsq  +  wgts(q).*(O(i,q) - O((i+1):n,q)).^2;         
    end    
    Y(2:end) = sqrt(dsq); 
    Y = (Y<Bo).*Y;
    
    case 'Xeuclidiana'
    %----------------------------------------------------------------------
    % DIFERENCIA MENOR QUE UN EPSILON
    wgts = additionalArg;   
    currentdist = zeros(n-i,ncarct);    
    for k=1:ncarct
    
        dsq = zeros(n-i,1,outClass);   
        statcarat = caract.(cnames{k});
        
        indx = statcarat.indx;
        W    = statcarat.peso;
        
        nwgts= wgts(indx);
        for q = indx                
        dsq = dsq + nwgts(q).*(abs(O(i,q) - O((i+1):n,q))).^2;            
        end
        currentdist(:,k) = W.*(dsq./length(indx));             
        
    end
    Y(2:end) = sum(currentdist,2)./ncarct;
    Y = (Y<Bo).*Y;
        
       
    
    case 'mahalanobis'
    %----------------------------------------------------------------------
    % MAHALANOBIS
    
    dsq  = zeros(n-i,1,outClass);
    invcov = additionalArg;
    del = repmat(O(i,:),n-i,1) - O((i+1):n,:);
    dsq = sum((del*invcov).*del,2);
    Y(2:end) = sqrt(dsq);
    Y = (Y<Bo).*Y;
   
    
    
    case 'Xpoint'
    %----------------------------------------------------------------------
    % DIFERENCIA MENOR QUE UN EPSILON
    
    Eps = 0.2;
    currentdist = zeros(n-i,ncarct);    
    for k=1:ncarct
    
        dsq = zeros(n-i,1,outClass);   
        statcarat = caract.(cnames{k});
        
        indx = statcarat.indx;
        W    = statcarat.peso;        
        for q = indx                
        dsq = dsq + (abs(O(i,q) - O((i+1):n,q)) < Eps);            
        end
        currentdist(:,k) = W.*(dsq./length(indx));             
        
    end
    Y(2:end) = sum(currentdist,2)./ncarct;
    Y = (Y>Bo).*Y;
    Y = 1-Y;
    
    end
    
    

    
    %----------------------------------------------------------------------
    % ELIMINANDO SEMEJANZAS QUE NO SATISFACEN LA CONDICION DE BO_SEMEJANZA 
    %Y = (Y<Bo).*Y;
                
    %----------------------------------------------------------------------  
    % 2 BUSCANDO LOS MAXIMOS POR FILAS
    % se buscan cules fueron los valores para el paso i-esimo en el vector
    % X que cambiarán su valor al ser actualizado con Y
    
    for j=1:(n-i)
        
        %En S{i} se guardará la lista de los indices en G del maximo 
        %bo_semejante en la columna i-esima para cada paso del algoritmo  
        
        k = j+(i-1);
        if (X(j)==Y(j)) && (Y(j) ~= 0)
            S{k} = [S{k},i]; 
        else
            if X(j)<Y(j)
            S{k} = i;
            X(j) = Y(j);
            end        
        end
       
    end  
    
    % El primer valor de X en cada paso del algoritmo representa el valor
    % maximo bo_semejante en la columna i-esima    
    MAXF = X(1); %maximo por filas
    
    
    %----------------------------------------------------------------------
    % 3 BUSCANDO MAXIMOS POR COLUMNAS 
    % Buscando en Y el valor de maximo bo_semejanza y guardando sus
    % respectivas posisciones 
    
    MAXC = max(Y);              %maximo por columna     
    
    j    = find(Y(:)==MAXC);    %indices de los maxf     
    j    = j+(i-1);             %reajuste de las coordenadas
    
    
    %----------------------------------------------------------------------
    % 4 ANALISIS DE LA CASUISTICA
    
    %Chequeando que el objeto i-esimo sea bo-semejante a algún otro objeto
    %en caso de no serlo este formará un grupo degenerado  
    if (MAXF + MAXC) ~= 0 
        
        %fila maximo Bo semejante
        if MAXF >= MAXC   
            
                %El maximo se encontraba en la fila o en ambas 
                %Analisis de los diferentes casos                
                grup = unique(G(S{i}));                  
                
                if G(i) == 0 %si no esta marcado                 
                mingrup = grup(1); 
                G(i) = mingrup;                
                
                for k=2:length(grup)
                    ptr = find(G==grup(k));
                    if ~isempty(ptr)
                    G(ptr)=mingrup;
                    end
                end                
                else %esta marcado, pertenese a algun grupo
                                        
                % Se uniran todos los grupos presentes en
                % S(i) con los de G(i) y el representante 
                % sera el menor de todos

                % UNIR(G(i),G(S(i)));            
                grup = unique([G(i),grup]);
                mingrup = grup(1); 
                G(i) = mingrup;                

                for k=2:length(grup)
                    ptr = find(G==grup(k));
                    if ~isempty(ptr)
                    G(ptr)=mingrup;
                    end
                end                   
                end             
        end        
               
        %columna maximo Bo semejante
        if MAXF <= MAXC  
        
                if G(i) == 0 %no esta marcado
                G(i)=i; %formar un nuevo grupo
                S{i}=i;            
                end                
           
                jnz = find(G(j));            
                jz  = find(~G(j));
                if ~isempty(jz) %si maxc no esta marcado 
                    jz = j(jz);
                    G(jz) = G(i);           
                end            
            
                if ~isempty(jnz) 
                % Se uniran todos los grupos presentes en
                % G(j) con los de G(i) y el representante 
                % sera el menor de todos    

            	% UNIR(G(i),G(j)); 
            	jnz = j(jnz);
                grup = unique([G(i),G(jnz)]);
                mingrup = grup(1); 
                G(i) = mingrup;                

                for k=2:length(grup)
                  ptr = find(G(:)==grup(k));
                  if ~isempty(ptr)
                  G(ptr)=mingrup;
                  end
                end                      
                end
        end    
               
    else % grupo degenerado
        if G(i) == 0 % no esta marcado
        G(i)=S{i};   %formar un nuevo grupo degenerado    
        end
        
    end % fin de la condicion de Bo semejanza
    X = X(2:n-i+1);    
    
    
        % actualizando barra de estado 
    try
        x = i/(n-1);       
        waitbar(x,hbarra,['AGRUPANDO ' mat2str(fix(x*100)) '% ...']); 
        
    catch      
    break; 
    end
    
    
end

%--------------------------------------------------------------------------
% FIN DEL METODO
% 1 ANALISIS DEL ULTIMO CASO
% ...
if G(n) == 0 % no esta marcado
G(n)= S{n};   %formar un nuevo grupo degenerado    
end
grup = unique(G(S{n}));

% UNIR//////////////////////////////////            
grup = unique([G(n),grup]);
mingrup = grup(1); 

G(n) = mingrup;                
for k=2:length(grup)
    ptr = G==grup(k);    
    G(ptr)=mingrup;
    
end                   


% 2 FORMAR GRUPOS 
% Organizamos los  grupos de manera tal que exista una correspodencia con
% el eje numérico

S = G;
S = unique(S);
C = length(S);

for i =1:C
G(G(:)==S(i)) = i;
end

% cerrando barra de estado
if nargin < 5
close(hbarra);
end









