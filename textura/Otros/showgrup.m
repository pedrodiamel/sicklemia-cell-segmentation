function colors = showgrup(G,k,height,width)

G = reshape(G,height,width);
colors = jet(k); 

ptrNaN    = find(isnan(G));
G(ptrNaN) = k;

% Calculando los índices
vs = cell(2,1);
vs{1}= (1:height)';
vs{2}= (1:width)';

IG = zeros(height,width,3);
realcolors = colors(G(vs{:}),:);
IG(:) = realcolors(:); 

imshow(IG);