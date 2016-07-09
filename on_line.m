function [f min_distance]=on_line(x,y,path)
if nargin==2
    path=load('path/path.mat');
else
   [r c]=size(path);
end
min_distance=sqrt((x-path(1,1))^2+(y-path(1,2))^2);
for i=1:r
    distance=sqrt((x-path(i,1))^2+(y-path(i,2))^2);
    if min_distance>distance
        min_distance=distance;
    end
end
if min_distance<30
    f=1;
else
    f=0;
end
end

    
