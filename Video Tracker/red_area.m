blue=i(115:315,1:187,3)-i(115:315,1:187,1);
imshow(blue);
b=blue>.5;
red=i(115:315,1:187,1)-i(115:315,1:187,3);
r=red>.5;
stats = regionprops(r, 'Area','Centroid');
max_area=0;max_obj=1;
    for object = 1:length(stats)
         area=stats(object).Area;
         if area > max_area
             max_area=area;
             max_obj=object;
         end
    end
 r_c=stats(max_obj).Centroid;
 stats = regionprops(b, 'Area','Centroid');
max_area=0;max_obj=1;
    for object = 1:length(stats)
         area=stats(object).Area;
         if area > max_area
             max_area=area;
             max_obj=object;
         end
    end
 b_c=stats(max_obj).Centroid;
 slope=(b_c(2)-r_c(2))/(b_c(1)-r_c(1));
 slope=slope*-1;
 if slope>1 
     if b_c(2)>r_c(2)
         pick_position_y=r_c(2)+35+115;
         pick_position_x=r_c(1);
     else
         pick_position_y=r_c(2)-35+115;
         pick_position_x=r_c(1);
     end
 else
     if b_c(1)>r_c(1)
         pick_position_x=r_c(1)+35+115;
         pick_position_y=r_c(2);
     else
         pick_position_x=r_c(1)+35+115;
         pick_position_y=r_c(2);
     end
 end