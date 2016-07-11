%{
script file: Mean_shift_with_led_and_path
input: Video to be evaluated(after homography)
output: Generates text files for led on and off time and position and also calculates the deviation of the robot from the actual path
logic: The path of the robot is tracked using Mean Shift Algorithm
%}
warning off;
clc;close all;

%%
% Read Video from user
%

% string = 'Tracked_';
% 
% [FileName,PathName] = uigetfile('*.*','Select a video(.avi) file'); 
% if FileName ==0
%     return ;
% end
% 
% [~,outFolder,~] = fileparts(FileName);
% 
% file=strcat(PathName,FileName);

%% Reading video obtained from homography
file=[pwd '\' file]
[Movie,height,width,numOfFrame,frame_rate] = readVid(file);

trackedMovie = Movie;
numOfFrame
%%
% Get the patch from the initial frame. This is the object that will be
% tracked in the video.

[patchLeftTopX,patchLeftTopY,patchRightBottomX,patchRightBottomY] = readPatch(Movie,1);


%% get the parameters fron user like max iteration or threshold for similiarity of two patches
% prompt = {'Enter no of itr','Enter threshold( 0-1)'};
% dlg_title = 'Input';
% num_lines = 1;
% def = {'50','0.1'};
% answer = inputdlg(prompt,dlg_title,num_lines,def);
% max_itr=str2num(answer{1});
% Thresh = str2num(answer{2});

max_itr=50;
Thresh= 0.1;

%% extract patch
kernelType='gaussian';
%kernelType='epanechnikov';

patchHeight = patchRightBottomY - patchLeftTopY;
patchWidth = patchRightBottomX - patchLeftTopX;
patchHeight = round(patchHeight);
patchWidth = round(patchWidth);
%patch = zeros(patchHeight,patchWidth);
patch = Movie(1).cdata(patchLeftTopY:patchRightBottomY,patchLeftTopX:patchRightBottomX,:);
%% build kernel
[kernel,grad_x, grad_y] = createKernel(patchHeight,patchWidth,kernelType);

[I,map] = rgb2ind(Movie(1).cdata,1024);
length_map = length(map);
patch_ind = rgb2ind(patch,map);
%% density estimate
q_pdf = calculateDensity(patch_ind, kernel, patchHeight, patchWidth,map);
trackedMovie(1).cdata = addTrack(Movie(1).cdata,patchLeftTopX,patchLeftTopY,...
                                    patchRightBottomX,patchRightBottomY);

bCoeff = zeros(1,(numOfFrame*max_itr));
index_in =1;
iteration_Convergence_vector = zeros(size(1,numOfFrame));

%% Create array to store patch center coordinate
loc = zeros(numOfFrame,3);
loc(:,1) = 1:1:numOfFrame;
loc(1,2) = round((patchLeftTopX + patchWidth)/2);
loc(1,3) = round((patchLeftTopY + patchHeight)/2);

%% extract path from the original image of arena
[path,exim]=extractpathver2('image.jpg');
line=(0);
sum_blue_current=0;sum_blue_previous=0;
x1=loc(1,2);y1=loc(1,3);mat_p=0;mat_c=0;mat_c_thresh=0;mat_p_thresh=0;
last_led_on_frame=0;
last_led_off_frame=0;
[r,c]=size(trackedMovie(1).cdata);
differ=zeros(numOfFrame,1);% stores the difference of blue mask of consecutive frames for the purpose of LED detection  
led=zeros(1,6);% stores on and off time, and the box no. from where a no. is picked or dropped
count=1;
 
%to set an upper and lower limit to the x-coordinate and y-coordinate (so
%that the value stays within the frame size) when taking our region of
%intrestfor detecting the glow of LED
    if y1+70 > r
        y_max=r-y1;
    else
        y_max=70;
    end
    
    if x1-70 <1
        x_min= x1-1;
    else
        x_min=70;
    end
    
    if y1-70 > 1
        y_min=y1-1;
    else
        y_min=70;
    end
    
    if x1+70 >c
        x_max= c-x1;
    else
        x_max=70;
    end
    
   
for frameNo = 1:numOfFrame
    newFrame = rgb2ind(Movie(frameNo).cdata,map);
    frameNo
    [lossFlag, newPatchX, newPatchY, bCoeff, index_out,itrout] = meanShift(newFrame,...
                                    q_pdf, patchLeftTopX, patchLeftTopY, patchHeight,...
                                    patchWidth, kernel, grad_x, grad_y,...
                                    bCoeff, index_in,map,max_itr,Thresh);
                                
 
    iteration_Convergence_vector(frameNo)=itrout;                      
    x2 = patchWidth + newPatchX;
    y2 = patchHeight + newPatchY;
    [line(frameNo,1) line(frameNo,2)]=on_line(x2,y2,path);
    % Store patch center coordinate for each frame
    loc(frameNo,2) = round(newPatchX + patchWidth/2);
    loc(frameNo,3) = round(newPatchY + patchHeight/2);
                                
    if lossFlag == 1
        disp('lost');
        Message = 'lost tracking of object at_';
        Message = strcat(Message,num2str(frameNo));
        h = msgbox(Message);
        break;
    end
    
     trackedMovie(frameNo).cdata = addTrack(Movie(frameNo).cdata,newPatchX,newPatchY,x2,y2);
     x=round(newPatchX + patchWidth/2);
     y=round(newPatchY + patchHeight/2);
     current_frame = im2double(Movie(frameNo).cdata);
    %taking a region of intrest around the robot of 140*140 pixels(in case
    %the bot is not on the edge) and
    %calculating the blue mask by subtracting the blue pixel value from the red ones   
    blue_mask=current_frame(y1-y_min:y1+y_max,x1-x_min:x1+x_max,3)-current_frame(y1-y_min:y1+y_max,x1-x_min:x1+x_max,1);
    sum_blue_current=sum(sum(blue_mask));
    %difference of blue mask in th previous and the current frame
    differ(frameNo)=sum_blue_current-sum_blue_previous;
    if frameNo<=5
        fromframe=1;
    else
        fromframe=frameNo-5;
    end
    
    %large change in th blue_mask indicated the glow of an led
    %since it take 2 to 3 frame for the LED to glow with its full intensity, we sum up the difference in blue mask of last frames 
    if sum(differ(fromframe:frameNo))>700 && frameNo-last_led_on_frame>10
        last_led_on_frame=frameNo;
        fprintf('led on, frame: %d \n',frameNo);
        if frameNo > 2 
        figure,imshow(Movie(frameNo-2).cdata);
        figure,imshow(Movie(frameNo).cdata);
        time=frameNo/frame_rate;
        disp(time);
        red_mask=current_frame(y1-y_min:y1+y_max,x1-x_min:x1+x_max,1)-current_frame(y1-y_min:y1+y_max,x1-x_min:x1+x_max,3);
        [x_p,y_p]=pick_position(blue_mask,red_mask,y1-y_min,x1-x_min);
        [grid,box]=find_box_number(x_p,y_p);
        led(count,1)=time;
        led(count,2)=grid;
        led(count,3)=box;
        fprintf('position: %d %d',x_p,y_p);
        imtool(Movie(frameNo).cdata);
        end
    end
    %large negative change in blue_mask indicates the LED being turned off
    if sum(differ(fromframe:frameNo)) < -700 && frameNo-last_led_off_frame>10
        last_led_off_frame=frameNo;
        if frameNo > 2 
        fprintf('led off, frame: %d \n',frameNo);
        figure,imshow(Movie(frameNo).cdata);
        figure,imshow(Movie(frameNo-2).cdata);
        time=frameNo/frame_rate;
        disp(time);
        previous_frame = im2double(Movie(frameNo-2).cdata);
        blue_mask=previous_frame(y1-y_min:y1+y_max,x1-x_min:x1+x_max,3)-current_frame(y1-y_min:y1+y_max,x1-x_min:x1+x_max,1);
        red_mask=previous_frame(y1-y_min:y1+y_max,x1-x_min:x1+x_max,1)-current_frame(y1-y_min:y1+y_max,x1-x_min:x1+x_max,3);
        [x_p y_p]=pick_position(blue_mask,red_mask,y1-y_min,x1-x_min);
        [grid,box]=find_box_number(x_p,y_p);
        led(count,4)=time;
        led(count,5)=grid;
        led(count,6)=box;
        count=count+1;
        fprintf('position: %d %d',x_p,y_p);
        imtool(Movie(frameNo).cdata);
        end
    end
    
    if y+70 > r
        y_max=r-y;
    else
        y_max=70;
    end
    
    if x-70 <1
        x_min= x-1;
    else
        x_min=70;
    end
    if y-70 < 1
        y_min=y-1;
    else
        y_min=70;
    end
    
    if x+70>c
        x_max= c-x;
    else
        x_max=70;
    end
    
    %we store the blue mask of the current ROI according to the current position of the robot
    %this is subtracted with the blue_mask in the next frame at the same
    %position so that the difference is not due to the shift
    %in th mean of the object
    blue_mask=current_frame(y-y_min:y+y_max,x-x_min:x+x_max,3)-current_frame(y-y_min:y+y_max,x-x_min:x+x_max,1);
    sum_blue_previous=sum(sum(blue_mask));
    x1=x;
    y1=y;
    
    
    patchLeftTopX = newPatchX;
    patchLeftTopY = newPatchY;
    index_in = index_out+1;
    
    
end

%% Write tracked coordinates to file
mkdir(['Output Files/' outFolder]);
outPath = ['Output Files/' outFolder '/'];
loc = loc(2:frameNo,:);
save([outPath 'trace.mat'],'loc');
fileID = fopen([outPath 'trace.txt'],'w');
fprintf(fileID,'%d,%d,%d\r\n',loc');
fclose(fileID);

%% Write the LED on an off time and position to a file
fid = fopen([outPath 'led.txt'],'wt');
[r,~]=size(led);
for ii = 1:r
    fprintf(fid,'%g\t',led(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

%% Write the buzzer on an off time to a file
fid = fopen([outPath 'buzzer_time.txt'],'wt');
[r,~]=size(time);
for ii = 1:r
    fprintf(fid,'%g\t',time(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);

%% Write the deviation of the bot from the line in each frame to a file

fid = fopen([outPath 'line_following.txt'],'wt');
[r,~]=size(led);
for ii = 1:r
    fprintf(fid,'%g\t',line(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);


%% show video
% movie(trackedMovie);

%% save the video file

movie2avi(trackedMovie, [outPath 'TrackedMovie.avi']);

 



