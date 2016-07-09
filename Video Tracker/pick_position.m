function [pick_position_x pick_position_y]=pick_position(blue,red,y,x)
% blue=i(115:315,1:187,3)-i(115:315,1:187,1);
figure,imshow(blue);
b=blue>.2;
figure,imshow(b);
% red=i(115:315,1:187,1)-i(115:315,1:187,3);
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