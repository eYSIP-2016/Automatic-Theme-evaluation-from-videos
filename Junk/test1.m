function [f1 f2]=test1(img1);
    [h s v]=rgb2hsv(img1);
    hmask=h>0.5;
%     imshow(hmask)
    im2=imfill(logical(hmask), 'holes');
%    imshow(im2);
    im2=bwareaopen(im2, 5000);
    boundary = bwtraceboundary(im2,[500, 500],'N');
%     imshow(im2);
    im2 = cast(im2, class(img1));
    red=img1(:,:,1);
    blue=img1(:,:,3);
    green=img1(:,:,2);
    red_mask=red .* im2;
    green_mask=green .* im2;
    blue_mask=blue .* im2;
    maskedRGBImage = cat(3, red_mask, green_mask, blue_mask);
    f1=im2;
    f2=maskedRGBImage;
    imshow(maskedRGBImage);
    hold on;
    plot(boundary(:,2),boundary(:,1),'g','LineWidth',3);
end