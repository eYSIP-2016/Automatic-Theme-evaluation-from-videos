function [hueimage img bb]=trackobject(image)
[img0 img]=maskingexteriorver4(image);
[h s v]=rgb2hsv(img);
hueimage=(h>0.9)|(h<0.1);
simage=s>0.2;
hueimage=hueimage & simage;
% imshow(hueimage);
data=bwareaopen(hueimage, 10);

stats1 = regionprops(data, 'BoundingBox', 'Centroid','Area');
% if mod(frame,10) == 0
figure,imshow(data);

% hold on
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
%  ,
% line=[y-100,y-200,y-300,y-400,y-500,y-600,y-700,y-800,y-900,y-1000,y-1100,x-100,x-200,x-300,x-400,x-500,x-600,x-700,x-800,x-900,x-1000,x-1100,x-1200,x-1300,x-1400];
% xyz= line_pointdistance(bc,line,x,y,img);
%   figure, imshow(image);
  hold on
  rectangle('Position',bb,'EdgeColor','r','LineWidth',2);
  plot(bc(1),bc(2), '-m+');
  plot(bb(1),bb(2), '-m+');
% %  a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
%  set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
% end
end


