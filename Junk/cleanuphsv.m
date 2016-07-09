function p= cleanuphsv(im)
    i=im;
%   To seperate the white arena
    [h s v]=rgb2hsv(i);
    mask= s>0.1;
    figure, imshow(mask);
    title('Masked');
    
% %     se=strel('square',10);
% %     erode= imerode(mask,se);
% %     figure, imshow(erode);
% %     title('Square');
% %     
% %     se1=strel('diamond',10);
% %     erode1= imerode(mask,se1);
% %     figure, imshow(erode1);
% %     title('Diamond');
% %     
% %     se2=strel('disk',10,8);
% %     erode2= imerode(mask,se2);
% %     figure, imshow(erode2);
% %     title('Disk');
% %     
% %     se3=strel('line',10,0);
% %     erode3= imerode(mask,se3);
% %     figure, imshow(erode3);
% %     title('Line');
    
%    To just get white in the arena
    i2=imfill(logical(mask),'holes');
    figure, imshow(i2);
    title('Holes filled');
%   To find max. white area i.e the arena
    max_area=-1;
    index=-1;
    stats=regionprops(i2,'BoundingBox','Centroid','Area');
    for i=1:length(stats)
        if(stats(i).Area>max_area)
            max_area=stats(i).Area;
            index=i;
        end
    end
%   To seperate max. white area i.e the arena
    i3=bwareaopen(i2,max_area);
    figure, imshow(i3);
    title('Max Area');
%   Getting back contents on the arena.
    i4= logical(i3.* mask);
    figure, imshow(i4);
    title('Max Area with content');
%   Getting back color in the arena
    logic3d(:,:,1)=i4;
    logic3d(:,:,2)=i4;
    logic3d(:,:,3)=i4;
    
    i= uint8(i.* uint8(logic3d)); 
    figure, imshow(i);
    title('Max Area with content and color');
    p=i;
end
    
    