%{
Function name: trackobject
Input: Image matrix
Output: Bounding box of the robot.
Logic: Masking on the basis of hue and saturation value. The robot is distinguished
       based on the red sheet which is stuck on the bot.
%}
function [hueimage img bb]=trackobject(image)
    % [img0 img]=maskingexteriorver4(image);

    [h s v]=rgb2hsv(imgage);
    hueimage=(h>0.9)|(h<0.1);
    simage=s>0.2;
    hueimage=hueimage & simage;

    data=bwareaopen(hueimage, 10); %removing noises
    stats1 = regionprops(data, 'BoundingBox', 'Centroid','Area');
    figure,imshow(data);
    max_area=0;
    max_obj=1;

    %extracting the largest red patch in the frame, i.e, the bot
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
    % drawing rectangle around the identified robot  
      hold on
      rectangle('Position',bb,'EdgeColor','r','LineWidth',2);
      plot(bc(1),bc(2), '-m+');
      plot(bb(1),bb(2), '-m+');
end


