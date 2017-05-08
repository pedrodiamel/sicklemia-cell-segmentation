%--------------------------------------------------------------------------
%FUNCIÓN QUE CALCULA EL REPRESENTANTE DE UN CONJUNTO B0CONEXO
%--------------------------------------------------------------------------
function [C] = vgetrepresentantes(X,Bo,caract,varargin)
%[C]=VGETREPRESENTANTES(X,BO,CARACT)
%
% El representante de un conjunto X de características es un subconjunto
% minimal C de X que satisface que:
%  *Todo elemento próximo o semejante a X lo es también a C a partir de una 
%   función B de proximidad o semejanza.
%  *El representante del conjunto unitario es él mismo
%
%

%Inicialización
cnames = fieldnames(caract); 
nc     = length(cnames);

outClass = class(X);
[n,p]  = size(X);
SG     = zeros(1,n); 

% El representante del conjunto unitario es él mismo
if n<2
C = X;
return;
end

if nargin < 5    
% Abriendo handle de barra de estado
hbarra  = waitbar(0,'Representantes 0%...','WindowStyle','modal');     
else        
% Obteniendo la barra de estado
hbarra = varargin{2};    
waitbar(0,hbarra,'Representantes 0%...');    
end

% Obteniendo el valor de epsilon
Eps = varargin{1};


C(1,:) = mean([X(1,:);X(2,:)]);
SG([1 2]) = 1;
m      = 1;

for i=3:n
    
      
    Y = zeros(m,nc);  
    for k=1:nc
    
        dsq = zeros(m,1,outClass);   
        statcarat = caract.(cnames{k});
        
        indx = statcarat.indx;
        w    = statcarat.peso;        
        for q = indx                
            dsq = dsq + (abs(C(1:m,q) - X(i,q)) <= Eps);            
        end
        Y(:,k) = w.*(dsq./length(indx));             
        
    end
    
    Y = sum(Y,2)./nc;
    Y = (Y>Bo).*Y;     
    [E,s] = max(Y);
    
    if E ~= 0
        
        SG(i) = s;
        % Recalculando el centroide cs
        ic = SG==s;
        C(s,:) = mean(X(ic,:));
        
    else
        m = m+1;
        C(m,:) = X(i,:);  
        SG(i) = m;
    end
    
    % Actualizando barra de estado 
    try
        x = i/(n+3);   
        waitbar(x,hbarra,['Representantes ' mat2str(fix(x*100)) '% ...']);
        
    catch      
    break; 
    end
    
end

% cerrando barra de estado
if nargin < 5
close(hbarra);
end

