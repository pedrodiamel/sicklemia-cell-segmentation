%--------------------------------------------------------------------------
%FUNCION PARA LA EXTRACCION DE CARACTERISTICAS SEGUN LA MATRIZ DE
%CO_OCURRENCIA
%--------------------------------------------------------------------------
function t = covector(I)
%T=COVECTOR(I) Arma el vector caracteristico segun la matriz de
%coocurrencia 
%
%
%--------------------------------------------------------------------------
% Calculando el desplazamiento
d = 1;
numlevel =  max(I(:));

% Se obtienen las matrices de co-ocurrencia en las cuatro direcciones 
% Direcciones:
offset = [0  d; ... % 0       
         -d  d; ... % 45
         -d  0; ... % 90
         -d -d];    % 135

%Calculando las matrises de coocurencia en las deirecciones dada por el offset
glcm = graycomatrix(I,...          % imagen a procesar          
       'NumLevels', numlevel, ...  % máximo nivel de gris de I
       'G', [], ...                % gray limits
       'Offset', offset,...        % dirección
       'Symmetric',true);         % calcula la matriz simétrica     


% Cálculo de todas las caracteristicas para la matriz de coocurrencia. Las 
% caracteristicas son contrast, correlation, energy, homogeneity
t = coprops(glcm);  

% Promediando los vectores obtenidos por cada una de las matrices
t = sum(t,2)./4;
t = t(:);

end








