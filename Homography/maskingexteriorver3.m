%{
function name: maskingexteriorver3
input: image matrix
output: an image that contains only the arena (masks the area outside the arena)
logic:1.the red, green and blue layers of the image are extracted and and then each of the matrix is converted to a binary image such 
        that it contains only the pixels whose value is above 120.
      2.the red blue and green masks are then anded (&) so that all the
        dark pixels are masked. Now we fill the all the areas that are
        bounded by bounded by white as they lie inside the arena. Now we
        remove all white patches outside the arena by taking only the white
        patch with the largest area, i.e, the arena(as it would occupy the major area).
      3.Function bwareaopen() is used to remove all smaller areas. After
        which we have a binary image which contains 1(on) for the pixels inside the arena and 0(off) for pixels outside.
      4.This binary image is multiplied with the original image to obtain
        the masked image that contains only the arena and surrpunding is
        masked.
%}
function f= maskingexteriorver3(img)
red=img(:,:,1);
green=img(:,:,2);
blue=img(:,:,3);
redmask=red>120;
greenmask=green>120;
bluemask=blue>120;
[h s v]=rgb2hsv(img);
maskedimg=redmask & bluemask & greenmask;
im2=maskedimg;
im2=imfill(logical(im2), 'holes');
    im2=bwareaopen(im2, 5000);
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
    im2 = cast(im2, class(img));
    red=img(:,:,1);
    blue=img(:,:,3);
    green=img(:,:,2);
    red_mask=red .* im2;
    green_mask=green .* im2;
    blue_mask=blue .* im2;
    maskedRGBImage = cat(3, red_mask, green_mask, blue_mask);
    f=maskedRGBImage;
    figure, imshow(maskedRGBImage);