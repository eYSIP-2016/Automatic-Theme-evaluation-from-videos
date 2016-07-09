clc;close all;
img= imread('test2.jpg');
f= cleanup(img);
figure,imshow(f);

x= f(:,:,1)<90 & f(:,:,2)<90 & f(:,:,3)<90;
figure, imshow(x);
title('Black extraction');

close all;