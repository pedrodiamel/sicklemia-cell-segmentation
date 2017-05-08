%--------------------------------------------------------------------------
%FUNCION VOTACION PARA LA CLASIFICACION NO SUPERVISADA DE OBJETOS
%--------------------------------------------------------------------------
function [G,C,varargout] = vvotacion(MA,K,X,W,Landa,varargin)
%[G,C]=VOTACION(MA,K,X,W)
%
%   MA matriz de aprendizaje
%   K  clases de cada objeto de la matriz de aprendizaje
%   X  objetos a clasificar
%   W  conjuntos de apoyo
%

%--------------------------------------------------------------------------
%ALGORITMO DE VOTACION  
%Fases
%   1. Definir sistema de conjunto de apoyo  
%   2. Definir funcion de semejanza entre objetos
%   3. Evaluacion por filas dado un conjunto de apoyo fijo
%   4. Evaluacion por clases para un conjunto de apoyo fijo
%   5. Evaluacion por clases para el sistema de conjuntos de apoyo 
%   6. Regla de decision
%
%--------------------------------------------------------------------------
% PASO 1: DEFINIR SISTEMA DE CONJUNTO APOYO
% para el problema de la clasificacion de textura selecionamos manualmente
% los conjunto de apoyo correspondiente a los tipos de medidas extraidos de
% la imagen esto es por ejemplo: {Momentos, MCO, Gabor}.
% Para problemas más generales se recomienda extraer los conjuntos de apoyo
% a partir de de los textores tipicos, que son calculados por los
% algoritmos clasicos de seleccion de variable

%--------------------------------------------------------------------------
% PASO 2: DEFINIR FUNCION DE SEMEJANZA ENTRE OBJETOS 
% para este problemas usaremos la distancia euclidiana como funcion de 
% semejanza entre cada conjunto de apoyo


if nargin < 6
hbarra = waitbar(0,'Clasificando ... 0%','WindowStyle','modal');
else
hbarra = varargin{1};
waitbar(0,hbarra,'Clasificando ... 0%');    
end


% Cantidad de caracteristicas
% W structura con los conjunto de apoyo
cnames = fieldnames(W); 
nc     = length(cnames);


%--------------------------------------------------------------------------
% PASO 3: EVALUCION POR FILAS DADO UN CONJUNTO DE APOYO FIJO
% Este es el voto de un objeto por conjunto de apoyo. Cada objeto de la MA
% le dará un voto al objeto a clasificar considerando solo los rasgos del
% conjunto de apoyo para cada conjunto de apoyo

% Matriz de semejanza MS
outClass = class(X);
[n]      = size(X,1);
G        = zeros(n,1); 
[m,p]    = size(MA);

% obteniendo el tiempo de la cpu actual
startTime = cputime;

dist = 'euclidiana';

switch dist
    
    case 'neuclidiana'     
    % Normalizando los objetos
    additionalArg = 1 ./ var([X;MA])';
        
end



for i = 1:n
         
    
    %----------------------------------------------------------------------
    % funcion de semejanza entre conjuntos de apoyo
    switch(dist) 
    
        
    case 'euclidiana'
    %----------------------------------------------------------------------   
    % EUCLIDIANA

    Y = zeros(m,nc);    
    for k=1:nc
    
        dsq  = zeros(m,1,outClass);  
        statcarat = W.(cnames{k});
        
        indx = statcarat.indx;
        w    = statcarat.peso;        
        for q = indx               
            dsq  = dsq  + (MA(:,q) - X(i,q)).^2;
        end
        Y(:,k) = w.*sqrt(dsq);             
        
    end
    
    
    case 'neuclidiana'
    %----------------------------------------------------------------------   
    %  EUCLIDIA NANORMALIZADA

    wgts = additionalArg;
    Y = zeros(m,nc);    
    for k=1:nc
    
        dsq  = zeros(m,1,outClass);  
        statcarat = W.(cnames{k});        
        
        indx = statcarat.indx;
        w    = statcarat.peso;         
        
        for q = indx               
            dsq  = dsq  + (MA(:,q) - X(i,q)).^2;
        end
        Y(:,k) = w.*sqrt(dsq);             
        
    end
    
    
    case 'pointX'
    %----------------------------------------------------------------------
    % DIFERENCIA MENOR QUE UN EPSILON
    
    Eps = 0.1;  
    Y = zeros(m,nc);  
    for k=1:nc
    
        dsq = zeros(m,1,outClass);   
        statcarat = W.(cnames{k});
        
        indx = statcarat.indx;
        w    = statcarat.peso;        
        for q = indx                
            dsq = dsq + (abs(MA(:,q) - X(i,q)) <= Eps);            
        end
        Y(:,k) = w.*(dsq./length(indx));             
        
    end
           
    
    end
    %----------------------------------------------------------------------
    % PASO 4: EVALUACIÓN POR CLASES PARA UN CONJUNTO DE APOYO FIJO
    % Este es el voto que le da la clase al objeto por conjunto de apoyo
        
    
    % nk es el numero de clases
    nk = length(unique(K));   
    C  = zeros(nk,nc);
    
    for k=1:nk
    
        ik = find(K==k);
        cardk = length(ik);
        for w=1:nc
        C(k,w) = sum(Y(ik,w))./cardk; 
        end
        
    end
    
    
    %----------------------------------------------------------------------
    % PASO 5: EVALUACIÓN POR CLASES PARA UN SISTEMA DE CONJUNTOS DE APOYO 
    % Este es el voto de la clase. combinar todos los conjuntos de apoyos 
    % en uno solo   
    
    V = zeros(nk,1);
    V = sum(C,2)./nc;
    
    %----------------------------------------------------------------------
    % PASO 6: REGLA DE DECISIÓN 
    % para este problema usaremos mayoría simple. Esto es el objeto a clasificar
    % es de la clase con mayor voto
    %Landa = 0.6;
    
    V = (V>Landa).*V;
    [maximovoto,iclase] = min(V);
    G(i) = iclase;   
    
    
    
    % Actualizando la barra de estado
    x = i/n;
    waitbar(x,hbarra,['Clasificando ... ' num2str(fix(x*100)) '%']); 
    
    
end

endTime = cputime;
totalTime = endTime - startTime; 

if nargin < 6
close(hbarra);
end

% set time in varargout
if nargout > 2
varargout{1} = totalTime;
end

