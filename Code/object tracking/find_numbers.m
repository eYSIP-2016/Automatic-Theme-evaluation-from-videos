%{
Function name: find_numbers
Input: image matrix
Output: Structure containg the numbers and their corresponding position
Logic: Uses an inbuilt matlab function ocr()
%}
function [number]=find_numbers(img)
img=rgb2gray(img);
thresh=img < 20;
I=thresh;
outimg = xor(bwareaopen(I,200),  bwareaopen(I,4000));
number=ocr(outimg,'TextLayout','block');
imshow(outimg);