function f= maskingexteriorver3(img)
%reducing r, g, b values
red=img(:,:,1);
green=img(:,:,2);
blue=img(:,:,3);
redmask=red>100;
greenmask=green>100;
bluemask=blue>100;
[h s v]=rgb2hsv(img);
maskedimg=redmask & bluemask & greenmask;
% figure, imshow(img);
% figure, imshow(redmask);
% figure, imshow(greenmask);
% figure, imshow(bluemask);
% figure, imshow(maskedimg);
figure,imshow(maskedimg);
im2=maskedimg;
im2=imfill(logical(im2), 'holes');
    im2=bwareaopen(im2, 5000);
    se = strel('square', 10);
    im2 = imerode(im2,se);
    figure, imshow(im2);
    im2=imdilate(im2,se);
    figure, imshow(im2);
    im2=imfill(logical(im2), 'holes');
    figure, imshow(im2);
    max_area=0;
    max_obj=1;
    stats = regionprops(im2, 'BoundingBox', 'Centroid','Area','Extrema');
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
%     imshow(im2);
%     hold on
%     for a=1:8
%     rectangle('Position',[extremes(a,2) extremes(a,2) 10 10],'EdgeColor','r');
%     end
%     [B,L] = bwboundaries(im2,'noholes');
%     imshow(im2)
%     hold on
%     for k = 1:length(B)
%         boundary = B{k};
%         plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 2)
%     end
%     boundary = bwtraceboundary(im2,[500, 500],'N');
    
    im2 = cast(im2, class(img));
    red=img(:,:,1);
    blue=img(:,:,3);
    green=img(:,:,2);
    red_mask=red .* im2;
    green_mask=green .* im2;
    blue_mask=blue .* im2;
    maskedRGBImage = cat(3, red_mask, green_mask, blue_mask);
    f=maskedRGBImage;
%     figure, imshow(maskedRGBImage);