clc;clear all;close all;
I= imread('007.png');
if ndims(I)==3
    I= rgb2gray(I);
end
subplot(221),imshow(I), title('org');

BW= edge(I,'sobel');
subplot(222), imshow(BW), title('edge');

se=strel('disk',3);
BW= imdilate(BW,se);
BW=imerode(BW,se);
subplot(223), imshow(BW), title('dilation-erosion');

BW=imfill(BW,'holes');
subplot(224), imshow(BW), title('fill');
%# get boundary
B = bwboundaries(BW, 8, 'noholes');
B = B{1};

%%# boudary signature
%# convert boundary from cartesian to ploar coordinates
objB = bsxfun(@minus, B, mean(B));
[theta, rho] = cart2pol(objB(:,2), objB(:,1));

%# find corners
%#corners = find( diff(diff(rho)>0) < 0 );     %# find peaks
[~,order] = sort(rho, 'descend');
corners = order(1:10);

%# plot boundary signature + corners
figure, plot(theta, rho, '.'), hold on
plot(theta(corners), rho(corners), 'ro'), hold off
xlim([-pi pi]), title('Boundary Signature'), xlabel('\theta'), ylabel('\rho')

%# plot image + corners
figure, imshow(BW), hold on
plot(B(corners,2), B(corners,1), 's', 'MarkerSize',10, 'MarkerFaceColor','r')
hold off, title('Corner')