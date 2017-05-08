%--------------------------------------------------------------------------
%FUNCIÓN GETFRONTCURV PARA OBTENER VALORES DEL FRENTE
%--------------------------------------------------------------------------
function ptr0 = getFrontCurv(data)


% calculando las dimensiones de data
h = size(data,1);

% Obteniendo los contornos de la curva
level = [0 0];
C = contourc(data,level);

in = 1;out = 0;
n  = length(C);
k  = 1;

while in<=n

    out = out + C(2,in) +1;
    in = in+1;

    i = in:out;
    front = [(round(C(1,i))-1).*h ;round(C(2,i))];
    front = sum(front);

    ptr0{k} = [front];
    in = out + 1;
    k = k+1;

end

