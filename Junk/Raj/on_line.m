function [f min_distance]=on_line(x,y,path)
clock
[r c]=size(path);
min_distance=sqrt((x-path(1,1))^2+(y-path(1,2))^2);
for i=1:r
    dist=sqrt((x-path(i,1))^2+(y-path(i,2))^2);
    if min_distance>dist
        min_distance=dist;
    end
end
if min_distance<40
    f=1;
else
    f=0;
end
clock
end

    
