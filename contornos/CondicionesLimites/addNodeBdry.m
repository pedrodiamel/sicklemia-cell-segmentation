%--------------------------------------------------------------------------
%ADICIONAR NODOS KNOW EN LOS LIMIES
%--------------------------------------------------------------------------
function [speed,dataout] = addNodeBdry(speed,data)
%DATAOUT=ADDNODEKNOWS(DATAIN)
%
%

sz = size(speed);
dataout = ones(sz+2);
mn = [2;2];
mx  = sz'+1;
vs = cell(2,1);

% Interpolando los valores de la velocidad para los limites 
for i = 1 : 2
speed = addGhostExtrapolate(speed,i,1);
vs{i}= (mn(i):mx(i))';
end

dataout(vs{:}) = data; 
