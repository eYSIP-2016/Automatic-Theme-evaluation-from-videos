%{
Function Name: pick_position
Input: blue mask, red mask, top-left y coordinate of the current patch, top-left x coordinate of the current patch
Output: x, y coordinate of the the position from/to where the number is picked/dropped
Logic: The Centroid of the blue and the red masks are identified and the
slope between them is calculated. If the slope is greater than 1 or less
than -1 then the deposition position is either on the top or below the
centroid of the red mask and comparing it with the y coordinate of red mask
we find the side from/on which the number is picked/deposited. Similarly we find the 
side from which the number is picked if the slope is between -1 and 1.  
%}
function [pick_position_x pick_position_y]=pick_position(blue,red,y,x)
figure,imshow(blue);
b=blue>.2;
figure,imshow(b);
r=red>.2;
figure,imshow(red);
figure,imshow(r);
stats = regionprops(r, 'Area','Centroid');
max_area=0;max_obj=1;
    for object = 1:length(stats)
         area=stats(object).Area;
         if area > max_area
             max_area=area;
             max_obj=object;
         end
    end
 r_c=stats(max_obj).Centroid
 stats = regionprops(b, 'Area','Centroid');
max_area=0;max_obj=1;
    for object = 1:length(stats)
         area=stats(object).Area;
         if area > max_area
             max_area=area;
             max_obj=object;
         end
    end
 b_c=stats(max_obj).Centroid
 slope=(b_c(2)-r_c(2))/(b_c(1)-r_c(1));
 if slope>1 || slope<-1
     if b_c(2)<r_c(2)
         pick_position_y=r_c(2)-35+y;
         pick_position_x=r_c(1)+x;
     else
         pick_position_y=r_c(2)+35+y;
         pick_position_x=r_c(1)+x;
     end
 else
     if b_c(1)>r_c(1)
         pick_position_x=r_c(1)+35+x;
         pick_position_y=r_c(2)+y;
     else
         pick_position_x=r_c(1)-35+x;
         pick_position_y=r_c(2)+y;
     end
 end