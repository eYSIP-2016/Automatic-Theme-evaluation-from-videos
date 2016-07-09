function min_dist=minimum_distance(point,x,y)
x1=point(1)
y1=point(2)
min_dist=sqrt((max(y))^2+(max(x)^2));
length(x)
for i=1:length(x)
    x2=x(i);
    y2=y(i);
    dist=sqrt((x2-x1)^2+(y2-y1)^2);
    if(dist<min_dist)
        min_dist=dist;
    end
end
end