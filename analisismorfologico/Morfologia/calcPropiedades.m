%--------------------------------------------------------------------------
%FUNCION EXTRER MEDIDAS MORFOLOGICAS
%--------------------------------------------------------------------------
function [CSF,ESF,CENT] = calcPropiedades(BW)     
%[]=CALCMORFOLOGIA(I)
%
%   Entrada
%   I imagen binaria a procesar
%   
%   Saida
%   CSF     coeficiente circular elíptico
%   ESF     coeficiente circular de elongsacion 


% Cerrando y eliminando los objetos de los bordes
BW = imfill(BW, 'holes');
BW = imclearborder(BW);



% Preocesando
%BW = imopen(BW,strel('disk',2));
%BW = imclose(BW,strel('disk',4));
%BW = imerode(BW,strel('disk',2));
%imshow(BW);


% Etiquetando cada region de la imagen
BWE = bwlabel(BW);

% Extracion de las propiedades para cada región 
stats   = regionprops(BWE,'all');

cent    = cat(1, stats.Centroid);
mjaxis  = cat(1, stats.MajorAxisLength);   
mnaxis  = cat(1, stats.MinorAxisLength);
areas   = cat(1, stats.Area);
perms   = cat(1, stats.Perimeter);

% Seleccionando los objetos en el que su area este proxima a la media de
% todas las areas 
areaprom = sum(areas)/length(areas);
selec = (areas > areaprom/2) & (areas < 2*areaprom);

areas  = areas(selec);
perms  = perms(selec);
mjaxis = mjaxis(selec);
mnaxis = mnaxis(selec);
CENT   = cent(selec,:);


% Calculo de las coeficientes morfologicos 
CSF = 4.*pi.*(areas./(perms.^2)); %CSF = (CSF>1)+(CSF<=1).*CSF;
ESF = mnaxis./mjaxis;

