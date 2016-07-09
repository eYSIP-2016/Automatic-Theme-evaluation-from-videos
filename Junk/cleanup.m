function p= cleanup(im)
    switch nargin
        case 0
            im=imread('test\6.jpg');
    end
    i=im;
%   To seperate the white arena
    red=max(max(i(:,:,1)));
    green=max(max(i(:,:,2)));
    blue=max(max(i(:,:,3)));
    mask= i(:,:,1)>= 0.5*red & i(:,:,2)>= 0.5*green & i(:,:,3)>= 0.5*blue;
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
    for i1=1:length(stats)
        if(stats(i1).Area>max_area)
            max_area=stats(i1).Area;
            index=i1;
        end
    end
    
%   To seperate max. white area i.e the arena
    i3=bwareaopen(i2,ceil(max_area));
    figure, imshow(i3);
    title('Max Area');
    
    stats=regionprops(i3,'BoundingBox','Centroid','Area');
    for i1=1:length(stats)
        if(stats(i1).Area>max_area)
            max_area=stats(i1).Area;
            index=i1;
        end
    end
    for k=1: length(stats)
        thisBB=stats(k).BoundingBox;
        rectangle('Position',[thisBB(1),thisBB(2),thisBB(3),thisBB(4)],'EdgeColor','g','LineWidth',2);
    end
    
    i3=cast(i3,class(i));
%     Getting back color in the arena

    logic3d(:,:,1)=i3.*i(:,:,1);
    logic3d(:,:,2)=i3.*i(:,:,2);
    logic3d(:,:,3)=i3.*i(:,:,3);
    figure, imshow(logic3d);
    title('Max Area with content and color');
    p=logic3d;
end
    
    