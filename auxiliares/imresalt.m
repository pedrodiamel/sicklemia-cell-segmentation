%--------------------------------------------------------------------------
%FUNCION IMRESALT MEJORA EL RENDIMIENTO DE LA IMAGEN
%--------------------------------------------------------------------------
function I = imresalt(I)
%IMG=IMRESALT(IMG)
%
%   imresalt: elimina el ruido y ajusta algunos de los atributos de la
%   imagen para obtener un mejor rendimiento de la imagen
%
%Parametros:
%   I    imagen a procesar
%   I    imagen mejorada


% Opcion para mostrar la imagen
mostrar = 1;

% Ajustando los valores de la imagen de forma automatica
%I = imadjust(I,[0.3 0.5],[]);
I   = imadjust(I);

%I = histeq(I,80);
%I = adapthisteq(I,'Distribution','rayleigh','Alpha',0.9);
%I = adapthisteq(I,'NumTiles',[50 100]);
%I = decorrstretch(I,'tol',0.15);



% Eliminando el ruido de la imagen 
%I = medfilt2(I,[3 3]);


%H = fspecial('unsharp');
%H = fspecial('gaussian');
%H = fspecial('laplacian');
%H = fspecial('log') ;
%I = imfilter(I,H,'replicate');


if mostrar
    % Mostar la imagen procesda
    imshow(I);
    %axis on;
end
