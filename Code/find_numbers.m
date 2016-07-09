function [number]=find_numbers(img)
img=rgb2gray(img);
thresh=img < 20;
I=thresh;
outimg = xor(bwareaopen(I,200),  bwareaopen(I,4000));
number=ocr(outimg,'TextLayout','block');
% number=[];
r=1;
% for i=1:length(res.WordConfidences)
%     x=cell2mat(res.Words(i));
%     number(i,1)=str2num(x);
%     number(i,2)=res.WordBoundingBoxes(i,1)+res.WordBoundingBoxes(i,3)/2;
%     number(i,3)=res.WordBoundingBoxes(i,2)+res.WordBoundingBoxes(i,4)/2;
%     [grid box_no]=find_box_number(number(i,2),number(i,3));
%     number(i,2)=grid;
%     number(i,3)=box_no;
% end

imshow(outimg);