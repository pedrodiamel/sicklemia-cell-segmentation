%--------------------------------------------------------------------------
%FUNCIÓN PARA FORMAR GRUPOS
%--------------------------------------------------------------------------
function [G,C] = vboconexo(O,caract,Bo,dist,varargin)
%[G,C]=BOCONEXO(O,CARACT,BO,DIST)
%
%
%
% Entrada:
%   O   colección de objetos con p rasgos
%   Bo  menor valor de semejanza entre los objetos, este debe estar entre
%       cero y uno
%   caract estructura de características
%   dist   distancia entre objetos
%
% Salida
%   G   grupos beta cero conexos
%       Sea n la cantidad de objetos de O. G es un vector tal que: el
%       índice i representa el objeto i-ésimo y G(i) el grupo al que
%       pertenece
%
%   C   cantidad de componentes conexas
%

%--------------------------------------------------------------------------

[n,p] = size(O);
outClass = class(O);

% Inicializando el vector de grupo
G = zeros(1,n);

% Cantidad de características
cnames = fieldnames(caract);
ncarct = length(cnames);


% Distancia empleada por defecto
if nargin < 4
    
    Onorm = sqrt(sum(O.^2, 2));
    O = O ./ Onorm(:,ones(1,p)); 
    dist = 'euclidiana';

end


if nargin < 6
    % Abriendo handle de barra de estado
    hbarra  = waitbar(0,'Agrupando... 0%','WindowStyle','modal');
else
    % Obteniendo la barra de estado
    hbarra = varargin{2};
    waitbar(0,hbarra,'Agrupando... 0%');
end


% Valores auxiliares segun la distancia empleada
switch dist

    %case 'euclidiana'  
    %Onorm = sqrt(sum(O.^2, 2));
    %O = O ./ Onorm(:,ones(1,p)); 
    
    case 'seuclidiana'   
    additionalArg = 1 ./ var(O)';

    case 'Xpoint'
        if nargin < 5
        Eps = 0.2;
        else
        Eps = varargin{1};
        end

    case 'cosine' 
        Onorm = sqrt(sum(O.^2, 2));
        O = O ./ Onorm(:,ones(1,p));
        additionalArg = [];
        
        
end


%--------------------------------------------------------------------------
% MÉTODO

for i=1:(n-1)

    Y = zeros(1,n-i+1); % fila actual de semejanza entre objetos
    %----------------------------------------------------------------------
    % 1 CÁLCULO DE LA DISTANCIA
    % Función de semejanza entre objetos

    switch(dist)

        case 'euc'
            
            dsq = zeros(n-i,1,outClass);
            for q = 1:p
                dsq = dsq + (O(i,q) - O((i+1):n,q)).^2;
            end
            Y(2:end) = sqrt(dsq);
            Y = (Y<Bo).*Y;
        
        case 'euclidiana'
            %----------------------------------------------------------------------
            % DISTANCIA EUCLIDIANA POR MÉTODO DE EXTRACCIÓN

            currentdist = zeros(n-i,ncarct);
            for k=1:ncarct

                dsq = zeros(n-i,1,outClass);
                statcarat = caract.(cnames{k});

                indx = statcarat.indx;
                W    = statcarat.peso;
                for q = indx
                    dsq = dsq + (O(i,q) - O((i+1):n,q)).^2;
                end
                currentdist(:,k) = W.*sqrt(dsq);

            end
            Y(2:end) = sum(currentdist,2)./ncarct;
            Y = (Y<Bo).*Y;


        case 'seuclidiana'
            %----------------------------------------------------------------------
            % DISTANCIA EUCLIDIANA NORMALIZADA POR MÉTODO DE EXTRACCIÓN

            wgts = additionalArg;
            currentdist = zeros(n-i,ncarct);
            for k=1:ncarct

                dsq = zeros(n-i,1,outClass);
                statcarat = caract.(cnames{k});

                indx = statcarat.indx;
                W    = statcarat.peso;
                for q = indx
                    dsq = dsq + wgts(q).*(O(i,q) - O((i+1):n,q)).^2;
                end
                currentdist(:,k) = W.*sqrt(dsq);

            end
            Y(2:end) = sum(currentdist,2)./ncarct;
            Y = (Y<Bo).*Y;


        case 'Xpoint'
            %----------------------------------------------------------------------
            % DIFERENCIA MENOR QUE UN EPSILON


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
            
        
        case 'cosine' 
                    
            d = zeros(n-i,1,outClass);
            for q = 1:p
                d = d + (O(i,q).*O((i+1):n,q));
            end
            d(d>1) = 1; % protect against round-off, don't overwrite NaNs
            Y(2:end) = d;
            Y = (Y>Bo).*Y;

    end


    %----------------------------------------------------------------------
    % 3 BUSCANDO LOS B0-SEMEJANTES
    % Se buscan las posiciones en y que sean distintas de cero
    j = find(Y(:));

    if G(i) == 0 %no esta mark
        G(i)=i;      %formar un nuevo grupo
    end

    %----------------------------------------------------------------------
    % 4 ANÁLISIS DE LA CASUÍSTICA

    %Chequeando que el objeto i-ésimo sea bo-semejante a algún otro objeto
    %en caso de no serlo este formará un grupo degenerado
    if ~isempty(j)

        j = j+(i-1);%reajuste de las coordenadas

        jnz = find(G(j));
        jz  = find(~G(j));

        if ~isempty(jz) %si no está marcado
            jz = j(jz);
            G(jz) = G(i);
        end

        if ~isempty(jnz)

            % Se unirán todos los grupos presentes en
            % G(j) con los de G(i) y el representante
            % será el menor de todos
            % UNIR(G(i),G(j));

            jnz  = j(jnz);
            grup = unique(G(jnz));

            for k=1:length(grup)
                G(G==grup(k))=G(i);
            end

        end

    end % fin de la condición de Bo semejanza


    % Actualizando barra de estado
    try
        x = i/(n-1);
        waitbar(x,hbarra,['Agrupando ' mat2str(fix(x*100)) '% ...']);
    catch
        break;
    end


end



%--------------------------------------------------------------------------
% FIN DEL MÉTODO
% 1 ANÁLISIS DEL ÚLTIMO CASO
% ...
if G(n) == 0 % no está marcado
G(n)= n;     %formar un nuevo grupo degenerado
end

% cerrando barra de estado
if nargin < 6
close(hbarra);
end

% 2 FORMAR GRUPOS
% Organizamos los  grupos de manera tal que exista una correspodencia con
% el eje numérico

S = G;
S = unique(S);
C = length(S);

for i =1:C
    G(G==S(i)) = i;
end

end
