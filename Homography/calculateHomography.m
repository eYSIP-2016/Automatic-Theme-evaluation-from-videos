function [ homomat ] = calculateHomography(pout, pin )

x = pout(1, :); y = pout(2,:); X = pin(1,:); Y = pin(2,:);
rows0 = zeros(3, 4);
rowsXY = -[X; Y; ones(1,4)];
hx = [rowsXY; rows0; x.*X; x.*Y; x];
hy = [rows0; rowsXY; y.*X; y.*Y; y];
h = [hx hy];
[U, ~, ~] = svd(h);
homomat = (reshape(U(:,9), 3, 3)).';
homomat = homomat./homomat(3,3);

end