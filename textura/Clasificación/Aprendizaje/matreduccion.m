function [MAout,Kout] = matreduccion(MA,K,caract)

% Calculando la cantidad de clses
nk = length(unique(K));
p  = size(MA,2);
MAout = [];
Kout  = [];

% Abriendo handle de barra de estado
hbarra = waitbar(0,'Reduciendo... 0%');

for i=1:nk

    % Obtener los objetos de la clase i-ésima
    ic = find(K==i);
    O  = MA(ic,:);
    no = size(O,1);

    % Calculando la distancia promedio intergrupo
    Bo = 0;

    try
        Bo = pdist(O);
        Bo = sum(Bo)/length(Bo);

    catch

        for j=1:no

            dsq  = zeros(no-j,1);
            for q = 1:p
                dsq  = dsq  + (O(j,q) - O((j+1):no,q)).^2;
            end
            B = sqrt(dsq);
            Bo = Bo + sum(B);
        end
        no = no*(no-1)/2;
        Bo = Bo/no;


    end


    % Compactar los grupos no conocidos a partir del algoritmo de clasificacion
    % no supervisada Bo-compacto debido a la coexion intra grupo que se
    % obtiene

    Bo = Bo - Bo/5;
    [G,k] = vbocompacto(O,Bo,caract);

    % Calculando los reprsentantes de cada grupo correspondiente
    % a una clase
    represt = zeros(k,1);

    for j=1:k

        % Obteniendo los elementos del grupo. En este momento cada clase es
        % considerada un grupo
        ig = find(G==j);

        % Calculando la longitud del grupo j-ésimo
        zg = length(ig);

        % El representante del grupo unitario es el mismo
        if zg > 1

            % Calculando el coeficiente de tipicidad de cada objeto en el grupo
            % j-ésimo
            ct = zeros(zg,1);
            for t=1:zg

                % Calculando la distancia de cada elemento del grupo a Oii
                Y = zeros(1,zg);

                % EUCLIDIANA
                dsq  = zeros(zg,1);
                for q = 1:p
                    dsq  = dsq  + (O(ig,q) - O(t,q)).^2;
                end
                Y = sqrt(dsq);

                % Calculando la distancia promedio  del objeto Ot
                B = sum(Y)/(zg-1);
                den = sum((B-Y).^2)/(zg-1);

                % Calculando el coeficiente de tipicidad t
                ct(t) = B/den;

            end

            % Calculando los representantes.
            % El representante de un grupo será el objeto de mayor tipicidad
            [tmx,pos] = max(ct);
            represt(j) = ig(pos);


        else
            represt(j) = ig;
        end

        % Actualizando barra de estado
        try
            xx = j/k;
            waitbar(xx,hbarra,['Reduciendo ' mat2str(fix(xx*100)) '% ...']);
        catch
            break;
        end

    end

    pos = ic(represt);
    MAout = [MAout;MA(pos,:)];
    Kout  = [Kout,K(pos)];


end

% Cerrando barra de estado
close(hbarra);

