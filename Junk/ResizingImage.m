a=imread('cameraman.tif');
% [r, c]=size(a);
% i=1;j=1;
% c1=zeros(r/2,c/2);
% for x=1:2:r
%     for y=1:2:c
%         c1(i,j)=a(x,y);
%         j=j+1;
%     end
%     i=i+1;
%     j=1;
% end
% figure, imshow(a);
% figure, imshow(c1/255);
% figure, imagesc(c1), colormap(gray)
% 
% 
% or 

c=imresize(a,1/2);
figure, imshow(c);
figure, imagesc(c), colormap(gray);
c=imresize(a,2);
figure, imshow(c);
figure, imagesc(c), colormap(gray);