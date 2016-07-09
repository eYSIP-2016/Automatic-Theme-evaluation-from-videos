clc;clear;close all;
warning off;

%% reading file from the user

[FileName,PathName] = uigetfile('*.avi','Select a video(.avi) file'); 
if FileName ==0
    return ;
end

[~,outFolder,~] = fileparts(FileName);

inputfile=strcat(PathName,FileName);
vidObj = VideoReader(inputfile);
vidWidth = vidObj.Width;
vidHeight = vidObj.Height;

%% storing the frame pixel in a matrix 

mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);
fprintf('No of Frames: %d',vidObj.NumberOfFrames);
k = 1;
for frame =1:vidObj.NumberOfFrames
    mov(k).cdata = read(vidObj, frame);
    k = k+1;
end

fr=vidObj.NumberOfFrames

%%

pout = zeros(2,4);
pin = zeros(2,4);


%% masking the area outside the arena to remve any noises
img=mov(1).cdata;
img=maskingexteriorver3(img);
corners=cleanupv1(img);

%% mapping the corners for the transform video 
pin(1,1)=corners(2,1);
pin(2,1)=corners(1,1);
pin(1,2)=corners(2,2);
pin(2,2)=corners(1,2);
pin(1,3)=corners(2,3);
pin(2,3)=corners(1,3);
pin(1,4)=corners(2,4);
pin(2,4)=corners(1,4);
 
img = rgb2gray(mov(1).cdata);
[x,y] = size(img);

pin = round(pin);

pout(2,1) = 600;
pout(2,2) = 600;
pout(2,3) = 1;
pout(2,4) = 1;

pout(1,1) = 360;
pout(1,2) = 1;
pout(1,3) = 360;
pout(1,4) = 1;


%-- Applying Homography --%

[homomat] = calculateHomography( pin, pout);       

%-- Transforming into new Image --%
%  movfinal = struct('cdata',zeros(vidHeight,vidWidth,1,'uint8'),'colormap',[]);
 movfinal = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);
    
for frame =1:vidObj.NumberOfFrames
    frame
    img = mov(frame).cdata;
    [modi_img] = transformImg(img,homomat,pout);
%     figure,imagesc(modi_img);axis image;title('Orthographic Projection');truesize;
%     modi_img_rgb = repmat(modi_img,[1,1,3]);
%     movfinal(frame).cdata = modi_img_rgb; 
    movfinal(frame).cdata = modi_img;
end

[file] = writedata(movfinal);