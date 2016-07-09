function difference=min_distance(path,loc)
error=0;
difference=[1];
threshold=20;
distance=0;
path_lost_frame=1;
c=1;threshold=50;
min_c=1;path_lost=0;
mj=1;
[row column]=size(loc);
[row_path column_path]=size(path);
min_distance=9999999;
for i=1:row
    c=min_c;
    min_distance=sqrt((loc(i,2)-path(c,1))^2+(loc(i,3)-path(c,2))^2);
    upper_limit=min(c+80,row_path);
    for j=c:upper_limit;
        distance=sqrt((loc(i,2)-path(j,1))^2+(loc(i,3)-path(j,2))^2);
        if min_distance>distance
            min_distance=distance;
            min_c=j;
            mj=j;
        end
    end
    
    difference(end+1)=min_distance;
    if min_distance<threshold
        error=0;
        continue;
    else
        error=error+1;
        if(error>100)
            path_lost=1;
            path_lost_frame=i;
            break;
        else
            continue;
        end
    end    
end
if path_lost==1
    fprintf('Juhi = %d',path_lost_frame);
else
    fprintf('Bot followed the path perfectly\n');
end


