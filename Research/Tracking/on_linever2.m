function f=on_linever2(y,x,thresholdimg)
clock
[r c]=size(thresholdimg);
roi=zeros(r,c);
roi(x-20:x+20,y-20:y+20)=1;
% figure,imshow(roi);
masked_threshold=roi & thresholdimg;
line_pixels=find(masked_threshold);
% figure,imshow(masked_threshold);
if numel(line_pixels)>50
    f=1;
else
    f=0;
end
clock
end