function [f1 f2]=mask(img1);
    [h s v]=rgb2hsv(img1);
    hmask=h>.5;
    imshow(hmask);
    im2=imfill(logical(hmask), 'holes');
    im2=bwareaopen(im2, 100);
    structuringElement= strel('disk',250);
    im2=imclose(im2,structuringElement);
    [row col]=size(hmask)
    boundary = bwtraceboundary(im2,[row, col],'N');
%     imshow(im2);
% %     im2 = cast(im2, class(img1));
% %     red=img1(:,:,1);
% %     blue=img1(:,:,3);
% %     green=img1(:,:,2);
% %     red_mask=red .* im2;
% %     green_mask=green .* im2;
% %     blue_mask=blue .* im2;
% %     maskedRGBImage = cat(3, red_mask, green_mask, blue_mask);
% %     f1=im2;
% %     f2=maskedRGBImage;
%     imshow(maskedRGBImage);
%     hold on;
%     plot(boundary(:,2),boundary(:,1),'g','LineWidth',3);
end

%  a= imread('pro.jpg');
% k= mask(a);
% [B L]=bwboundaries(k,'noholes');
% imshow(label2rgb(L, @jet,[.5 .5 .5]));
% hold on
% for t= 1:length(B)
% boundary= B{t}
% plot(boundary(:,2),boundary(:,1))
% end