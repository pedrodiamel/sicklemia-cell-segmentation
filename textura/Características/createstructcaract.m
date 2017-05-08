%--------------------------------------------------------------------------
% FUNCIÓN PARA CREAR LA ESTRUCTURA DE LOS RASGOS POR CARACTERÍSTICAS
%--------------------------------------------------------------------------
function [outcaract,oldsize] = createstructcaract(namecaract)
%[OUTCARACT,OLDZISE]=CREATESTRUCTCARACT(NAMECARACT)
%  
%  estructura donde cada elemento es una estructura correspondiente a la 
%  característica i-ésima a extraer. El nombre de cada campo de caract
%  es el nombre de la característica que le corresponde
%  
%  typedef struct{
%
%       namecaract1
%       namecaract2
%       ...
%       namecaractn
%
%   } CARACT;
%
%   Cada campo de la estructura caract tiene la siguiente forma
%   typedef NAMECARACT struct{
%
%       namerasgos    nombre de cada rasgo
%       peso          peso de la característica
%       handlefunc    dirección de la función que calcula la característica  
%       index         arreglo con los índices de los rasgos de dicha
%                     característica en el vector de rasgos total X (ver 
%                     función wndpass)
%
%   }NAMECARACTi
%
%

% allcaract presenta todas las características a calcular por la función 
% wndpass
allcaract = {'Momentos','MCO','Gabor'};

% Medidas del momento 
rmoment = {'Media',...
    'Desviación Estándar',...
    'Suavidad',...
    'Tercer Momento',...
    'Uniformidad',...
    'Entropía '};

% Medidas de la matriz de co-ocurrencia
rmco    = {'Contraste',...
    'Correlación',...
    'Uniformidad',...
    'Homogeneidad',...
    'Máxima Probabilidad',...
    'Entropía'
    };

% Medidas del banco de filtros de gabor
rgabor  = {'Varianza',...
    'Desviación Estándar', ...
    'Energía de activación'};


% Nombre de los campos de la estructura namecaract
file  = {'func', 'rname', 'indx','peso'};

% Pesos correspondientes a cada característica. Estos pesos deben
% cummplir que sum(W)=1;
W = [1 1 1];

% Valores de la estructura namecaract
value  = {@statxture, rmoment, 1:6,  W(1);...
          @covector,  rmco,    1:6,  W(2);...
          @gabvector, rgabor,  1:24, W(3)};


caractaux = cell2struct(value,file,2);
for i=1:length(allcaract)
caract.(allcaract{i}) = caractaux(i);
end

%if isequal(sort(namecaract),sort(allcaract))
%outcaract = allcaract;
%end


n = length(namecaract);
oldsize = 0;
for i=1:n

    stat = namecaract{i};
    outcaract.(stat) =  caract.(stat);

    % reajustando
    indx = outcaract.(stat).indx + oldsize;
    outcaract.(stat).indx = indx;
    oldsize = oldsize + length(indx);

end
