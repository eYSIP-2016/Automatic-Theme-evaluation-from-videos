clc;close all;clear all;
i=imread('cameraman.tif');
a=im2double(i);
x=a;
y=a;
[r c]=size(a);
factor=6;

for i=1:r
    for j=1:c
        x(i,j)=factor*log(1+a(i,j));
        y(i,j)=factor*a(i,j)^2;
    end
end
subplot(121);imshow(a);title('Before')
subplot(122);imshow(x);title('After')
figure, imshow(y)      