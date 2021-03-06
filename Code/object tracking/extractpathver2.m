%{
Function name: extractpathver2
Input: Image matrix
Output: Output image and an n*2 matrix that contains the x and y coordinates of the pixels that lie on the line to be followed.
Logic: Converting the rgb image to gray. Then thresholding to obtain the black lines and extracting
the largest connected area which is the path.
%}

function [path outimg] =extractpathver2(imgname)
if nargin==0
    imgname='PS2_rgb.png';
end
img=imread(imgname);
img=rgb2gray(img);
thresh=img<20;
I=thresh;
outimg =  bwareaopen(I,4000);
imshow(outimg);
[pathy pathx]=find(outimg);
path=[pathx';pathy'];
path=path';