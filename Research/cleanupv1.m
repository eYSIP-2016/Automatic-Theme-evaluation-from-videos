function f= cleanupv1(img)
    if nargin==0
        img=imread('test\3.jpg');
        size(img)
    end
    
    copy=img;
    figure,imshow(img);
        title('Original Image');
    
    color_transformation_structure= makecform('srgb2lab');
    lab_image=applycform(im2double(copy),color_transformation_structure);
    
    Lchannel=lab_image(:,:,1);
    achannel=lab_image(:,:,2);
    bchannel=lab_image(:,:,3);
    
    redm= achannel> max(max(achannel)/4);
    figure,imshow(redm);
        title('Redm Image');
    hold on;
    max_xpy =-1;index_xpy_max =0;
    max_xmy =-1;index_xmy_max =0;
    min_xpy =9999999;index_xpy_min =0;
    min_xmy =9999999;index_xmy_min =0;
    stats=regionprops(redm,'BoundingBox','Centroid','Area');
    for i=1:size(stats)
        if (stats(i).Centroid(1)+stats(i).Centroid(2))>max_xpy
            max_xpy=(stats(i).Centroid(1)+stats(i).Centroid(2));
            index_xpy_max=i
        end
        if (stats(i).Centroid(1)+stats(i).Centroid(2))<min_xpy
            min_xpy=(stats(i).Centroid(1)+stats(i).Centroid(2));
            index_xpy_min=i
        end
        if (stats(i).Centroid(1)-stats(i).Centroid(2))>max_xmy
            max_xmy=(stats(i).Centroid(1)-stats(i).Centroid(2));
            index_xmy_max=i
        end
        if (stats(i).Centroid(1)-stats(i).Centroid(2))<min_xmy
            min_xmy=(stats(i).Centroid(1)-stats(i).Centroid(2));
            index_xmy_min=i
        end
    end
    hold on;
    plot(stats(index_xpy_max).Centroid(1),stats(index_xpy_max).Centroid(2),'bs');
    hold on;
    plot(stats(index_xpy_min).Centroid(1),stats(index_xpy_min).Centroid(2),'bs');
    hold on;
    plot(stats(index_xmy_max).Centroid(1),stats(index_xmy_max).Centroid(2),'bs');
    hold on;
    plot(stats(index_xmy_min).Centroid(1),stats(index_xmy_min).Centroid(2),'bs');
    hold on;
    
    figure,imshow(Lchannel,[]);
    title('L channel');
    
    figure,imshow(achannel,[]);
    title('a channel');
    
    figure,imshow(redm,[]);
    title('redm channel');
    
    figure,imshow(bchannel,[]);
    title('b channel');
    
    windowSize=2;
    
    [LMean, aMean, bMean]= GetMeanLABValues(Lchannel,achannel,bchannel,windowSize);
    
    delL=LMean-Lchannel;
    dela=aMean-achannel;
    delb=bMean-bchannel;
    
    delE=sqrt(delL .^ 2 + dela .^ 2 + delb .^ 2);
    
% %     figure,imshow(delE,[]);
% %     title('Euclidian Dist. between original and mean image');
    
    copy(:,:,1)=img(:,:,1) .* cast(delE,class(img));
    copy(:,:,2)=img(:,:,2) .* cast(delE,class(img));
    copy(:,:,3)=img(:,:,3) .* cast(delE,class(img));
% %     figure,imshow(copy);
% %     title('Supersonic');
    %%========================================================================
    %    To just get white in the arena
% %     
% %     se=strel('diamond',2);
% %     ii=imdilate(delE,se);
% %     
% %     figure, imshow(ii);
% %     title('Dilated');
% %     
% %     ii=imerode(delE,se);
% %     
% %     figure, imshow(ii);
% %     title('Erosion');
% %     
% % % %     
% %     ii=delE;
% %     Ed=edge(ii,'canny');
% %     %Filtered image
% %     Ifilt = imfilter(ii,fspecial('gaussian'));
% %     %Use Ed as logical index into I to and replace with Ifilt
% %     ii(Ed) = Ifilt(Ed);
% %     
% %     figure, imshow(ii);
% %     title('After filtering');
% %     
% % 
% %     i2=imfill(logical(ii),'holes');
% %     figure, imshow(i2);
% %     title('Holes filled');
%   To find max. white area i.e the arena
% %     max_area=-1;
% %     index=-1;
% %     stats=regionprops(logical(delE),'BoundingBox','Centroid','Area')
% %     for i1=1:length(stats)
% %         if(stats(i1).Area>max_area)
% %             max_area=stats(i1).Area;
% %             index=i1;
% %         end
% %     end
% %     
% % %   To seperate max. white area i.e the arena
% %     i3=bwareaopen(delE,ceil(max_area/2));
% %     figure, imshow(i3);
% %     title('Max Area');
% % % %     %%===============================================================================
% %     threshold_val=1;
% %     im= delE>=threshold_val;
% %     figure,imshow(im,[]);
% %     title('Mask of high delE');
% %     
% %     figure,imshow(~im,[]);
% %     title('Mask of low delE');
end
% % 
function [LMean, aMean, bMean]= GetMeanLABValues(Lchannel,achannel,bchannel,windowSize)
    arr=ones(windowSize,windowSize)/windowSize^2;
    LMean=conv2(Lchannel,arr,'same');
    aMean=conv2(achannel,arr,'same');
    bMean=conv2(bchannel,arr,'same');
end
    