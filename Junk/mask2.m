function f= mask2(img)
    red=img(:,:,1);
    green=img(:,:,2);
    blue=img(:,:,3);
    redmask=red>120;
    greenmask=green>110;
    bluemask=blue>120;
    maskedimg=redmask & bluemask & greenmask;
    figure, imshow(img);
    title('Original');
%     figure, imshow(redmask);
%     figure, imshow(greenmask);
%     figure, imshow(bluemask);
    figure, imshow(maskedimg);
    title('Masked');
    im2=maskedimg;
    im2=imfill(logical(im2), 'holes');
%     im2=bwareaopen(im2, 5000);
    figure, imshow(im2);
    title('Holes filled');
   
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
    figure, imshow(im2);
    title('Max.Area');
    structuringElement= strel('disk',25);
    im2=imclose(im2,structuringElement);
    f=im2;
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
    figure, imshow(maskedRGBImage);
    title('Masked with color and content');
    
end