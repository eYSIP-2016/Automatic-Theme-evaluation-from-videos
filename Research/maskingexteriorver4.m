function [f1 f2]= maskingexteriorver3(img)
% img=gpuArray(img);
red=img(:,:,1);
green=img(:,:,2);
blue=img(:,:,3);
redmask=red>80;
greenmask=green>80;
bluemask=blue>80;
[h s v]=rgb2hsv(img);
maskedimg=redmask & bluemask & greenmask;
%  figure, imshow(img);
%  figure, imshow(redmask);
%  title('red mask');
%  figure, imshow(greenmask);
%  title('green mask');
%  figure, imshow(bluemask);
%   title('blue mask');
%  figure, imshow(maskedimg);
%  title('masked image');
%  figure,imshow(maskedimg);
 im2=maskedimg;
 im2=imfill(logical(im2), 'holes');
%  figure,imshow(maskedimg); 
%  title('image after filling holes');
    im2=bwareaopen(im2, 5000);
    se = strel('square', 10);
    im2 = imerode(im2,se);
%   figure, imshow(im2);
    im2=imdilate(im2,se);
%   figure, imshow(im2);
%     title('image after erosion and dilution');
    im2=imfill(logical(im2), 'holes');
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
%     figure, imshow(im2);
%     title('image after removing smaller areas');
    
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
    f2=maskedRGBImage;
    maskedRGBImage=imtool(gather(maskedRGBImage));
    figure, imshow(maskedRGBImage);
    title('final image after masking exterior');