clc;clear all;close all;
BW= imread('process.jpg');
BW= mask2(BW);
figure, imshow(BW);
s=size(BW);
axis on;
C= [-1 -1];
for row=1:s(1)
    for col=1:s(2)
        if BW(row,col)
                break;
        end
    end
    contour= bwtraceboundary(BW,[row col],'W',4);
    if(~isempty(contour))
        hold on; plot(contour(:,2),contour(:,1),'g','LineWidth',2);
        C=[C;contour];
%         hold on; plot(col,row,'gx','LineWidth',2);
%     else
%         hold on; plot (col,row,'rx','LineWidth',2);
    end
end
[a b]=size(C);
x = zeros(C,1);
for  i=2:a
    x(i)=atand(((C(i,1)-C(i-1,1))/(C(i,2)-C(i-1,2))));
end
y = ones(a,1);
for i=3:a
    y(i)=cosd(x(i)-x(i-1));
end
[Bsort Bidx] =Nsmallelements(y, 4);
Bsort
Bidx
for i=1:size(Bidx)
    hold on; plot(C(Bidx(i),2),C(Bidx(i),1),'rx','LineWidth',2);
end