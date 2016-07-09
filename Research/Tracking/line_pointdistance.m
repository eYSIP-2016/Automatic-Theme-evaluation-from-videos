function min_dist=line_pointdistance(point,line,x,y,img) %x-1 X 2 matrix containing the point l-equation of line
min_dist=10000000000000;
closest_line=0;
closest_point=point;
for n=1:length(line)
    d=diff(line(n),x);
    if d==1
        m1=Inf
    else
        m1=d;
    end
    m2=(-1/m1);
    if m2==Inf
        line2=point(1)-x;
    else
        line2= point(2)-y-m2*(point(1)-x);
    end
    [A,B] = equationsToMatrix([line(n), line2], [x, y]);
    X = linsolve(A,B);
    X = cast(X,'like',point);
    dist=sqrt((point(1)-X(1))^2+(point(2)-X(2))^2);
    if min_dist>dist
        min_dist=dist
        closest_line=n;
        closest_point=X
    end
end
    figure, imshow(img)
    hold on
%     rectangle('Position',[point(1) point(2) 10 10],'EdgeColor','g');
%     rectangle('Position',[closest_point(1) closest_point(2) 10 10],'EdgeColor','r');
    plot([point(1),closest_point(1)], [point(2), closest_point(2)]);
end
