function [f1 f2]=maskingexterior(img1);
    [h s v]=rgb2hsv(img1);
    hmask=h<.45;
    figure,imshow(hmask);
    im2=imfill(logical(hmask), 'holes');
    im2=bwareaopen(im2, 5000);
    max_area=0;
    max_obj=1;
    stats = regionprops(im2, 'BoundingBox', 'Centroid','Area');
    for object = 1:length(stats)
         area=stats(object).Area;
         if area > max_area
             max_area=area;
             max_obj=object;
         end
    end
    
    threshold_area=max_area/2;
    b=ceil(threshold_area);
    im2=bwareaopen(im2, b);
    f1=im2;
%     [B,L] = bwboundaries(im2,'noholes');
%     imshow(im2)
%     hold on
%     for k = 1:length(B)
%         boundary = B{k};
%         plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 2)
%     end
%     boundary = bwtraceboundary(im2,[500, 500],'N');
    
    im2 = cast(im2, class(img1));
    red=img1(:,:,1);
    blue=img1(:,:,3);
    green=img1(:,:,2);
    red_mask=red .* im2;
    green_mask=green .* im2;
    blue_mask=blue .* im2;
    maskedRGBImage = cat(3, red_mask, green_mask, blue_mask);
    f2=maskedRGBImage;
%     imshow(maskedRGBImage);
%     hold on;
%     plot(boundary(:,2),boundary(:,1),'g','LineWidth',3);
end