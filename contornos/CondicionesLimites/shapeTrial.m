%--------------------------------------------------------------------------
%CREA DISTANCIA APROXIMADA PARA EL CONJUNTO DE PUNTOS TRIALES
%--------------------------------------------------------------------------
function [data,tcell] = shapeTrial(data,speed)
%DATA=SHAPETRIAL(DATA)
%
%
%

% Diferentes tipos en que se pueden clasificar los valores de tcell
% Typedef enum(Know,Trial,Far)TCELL
Know    = 0;
Trial   = 1;
Far     = 2;
Bdry    = 3;

[n,m] = size(data);
data0  = data.*realmax;
tcell  = data.*Far;

indx  = find(~data); 
indx  = [indx+1; indx-1; indx+n; indx-n];
indx  = unique(abs(indx)); 


% Obteniendo los vecinos de la banda que pertenecen al frente. Esto es
% comprobar cuales de ellos son Knows

indx = indx.*(indx <= n*m );
indx = indx.*(indx > 0 );

nonZero = find(indx);
indx    = indx(nonZero);

tcell(indx) = Trial;
data0(indx) = speed(indx);

tcell  = data.*tcell;
data   = data.*data0;

tcell(:,1) = Bdry;
tcell(1,:) = Bdry;
tcell(:,m) = Bdry;
tcell(n,:) = Bdry;



