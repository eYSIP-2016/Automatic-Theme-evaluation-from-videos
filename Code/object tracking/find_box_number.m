%{
Function Name: find_box_number
Input: x, y coordinate
Output: grid number and the box number of the
Logic: The distance of the pixels is calculated with the centers of each of
the boxes and the box center that is at minimum distance to the is the box
containing the pixel.
%}
function[grid box]=find_box_number(x,y)

 box1x=[40,90,145,194,40,90,145,194,40,90,145,194];
 box1y=[95,95,95,95,160,160,160,160,225,225,225,225];
 box2x=[315,365,415,465,515,565,315,365,415,465,515,565,315,365,415,465,515,565,315,365,415,465,515,565];
 box2y=[100,100,100,100,100,100,165,165,165,165,165,165,230,230,230,230,230,230,300,300,300,300,300,300];

min_dist=1000;
closest_box=1;
grid=0;
if x<250
    grid=1;
    for i=1:length(box1x)
        dist=sqrt((x-box1x(i))^2+(y-box1y(i))^2);
        if dist<min_dist
            min_dist=dist;
            box=i;
        end
    end
else
    grid=2;
    for i=1:length(box2x)
        dist=sqrt((x-box2x(i))^2+(y-box2y(i))^2);
        if dist<min_dist
            min_dist=dist;
            box=i;
        end
    end        
end