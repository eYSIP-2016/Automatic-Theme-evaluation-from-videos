%{
Function Name: trackobject()
Input: Image matrix
Output: Bounding box of the bot
Logic: The image is converted to hsv and based on the hue value for red the
bot is identified.
%}
function [bb]=trackobject(image)
% for masking the exterior so that any noises outside the arena does not
% effect the output
[img0 img]=maskingexteriorver4(image);

%% masking based on hue
[h s v]=rgb2hsv(img);
hueimage=(h>0.9)|(h<0.1);
simage=s>0.2;
hueimage=hueimage & simage;
data=bwareaopen(hueimage, 10);

%% for taking the largest area, smaller area are noises 

stats1 = regionprops(data, 'BoundingBox', 'Centroid','Area');
figure,imshow(data);
max_area=0;
max_obj=1;
for object = 1:length(stats1)
     area=stats1(object).Area;
     if area > max_area
         max_area=area;
         max_obj=object;
     end
end
bb = stats1(max_obj).BoundingBox;
bc = stats1(max_obj).Centroid;
syms x y ;
%% drawing a bounding box arount the object
hold on
rectangle('Position',bb,'EdgeColor','r','LineWidth',2);
plot(bc(1),bc(2), '-m+');
plot(bb(1),bb(2), '-m+');

end


