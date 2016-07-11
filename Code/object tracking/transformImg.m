function [ modi_img ] = transformImg( img, homomat, pout )

modi_img = zeros(pout(1),pout(2),3);
[m n] = size(img);

for i = pout(1,4):pout(1,1)
    for j = pout(2,4):pout(2,1)
        coor = [i;j;1];
        coor_old = homomat* coor;
        coor_old  = coor_old./coor_old(3,1);
        if ~(round(coor_old(1,1)) < 1 || round(coor_old(1,1)) > m || round(coor_old(2,1)) < 1 || round(coor_old(2,1)) > n)
            modi_img(i,j,:) = img(round(coor_old(1,1)),round(coor_old(2,1)),:);
        end
    end
end
modi_img = uint8(modi_img);
end
