function C= findingcorners(img)
red=img(:,:,1);
green=img(:,:,2);
blue=img(:,:,3);
redmask=red>90;
greenmask=green>90;
bluemask=blue>90;
[h s v]=rgb2hsv(img);
hmask=h>.2;
% figure, imshow(hmask);
maskedimg=redmask & bluemask & greenmask;
% figure, imshow(img);
% figure, imshow(redmask);
% figure, imshow(greenmask);
% figure, imshow(bluemask);
% figure, imshow(maskedimg);
im2=maskedimg;
im2=imfill(logical(im2), 'holes');
    im2=bwareaopen(im2, 5000);
    se = strel('square', 5);
    im2 = imerode(im2,se);
    im2=imdilate(im2,se);
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
    figure, imshow(f1);
%     %% 1. Get rid of the white border
%     I2 = imclearborder(im2bw(f1));
%     %% 2. Find each of the four corners
    [y,x] = find(f1);
    [value,location] = min(y+x);
    C = [x(location),y(location)];
    [value,location] = min(y-x);
    C(2,:) = [x(location),y(location)];
    [value,location] = max(y+x);
    C(3,:) = [x(location),y(location)];
    [value,location] = max(y-x);
    C(4,:) = [x(location),y(location)];
    
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
    %% 3. Plot the corners
    figure, imshow(f2);
    hold on
    for a=1:4
    rectangle('Position',[C(a,1) C(a,2) 10 10],'EdgeColor','g');
    end
%     figure, imshow(maskedRGBImage);