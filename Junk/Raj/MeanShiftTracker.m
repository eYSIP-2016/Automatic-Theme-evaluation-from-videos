warning off;
clc; clear;

%%
% Read Video
%take video from user
string = 'Tracked_';

[FileName,PathName] = uigetfile('*.*','Select a video(.avi) file'); 
if FileName ==0
    return ;
end

[~,outFolder,~] = fileparts(FileName);

file=strcat(PathName,FileName);
[Movie,height,width,numOfFrame] = readVid(file);
trackedMovie = Movie;
numOfFrame
%%
% Get the patch from the initial frame
% this patch will be tracked in the consecutive frames
[patchLeftTopX,patchLeftTopY,patchRightBottomX,patchRightBottomY,track] = readPatch(Movie,1);
%% get the parameters fron user like max iteration or threshold for similiarity of two patches
prompt = {'Enter no of itr','Enter threshold( 0-1)'};
dlg_title = 'Input';
num_lines = 1;
def = {'50','0.1'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
max_itr=str2num(answer{1});
Thresh = str2num(answer{2});

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
figure, imshow(Movie(1).cdata);
title('for extracting path');
[path,exim]=extractpathver2('image.jpg');
figure,imshow(exim);
title('extracted path');
imtool(Movie(1).cdata);
line=[0];
for frameNo = 2: numOfFrame
%for frameNo = 2: 2 % only for two frames
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
%     trackedMovie(frameNo).cdata = addTrack2(Movie(frameNo).cdata,newPatchX,newPatchY,x2,y2,path);
    trackedMovie(frameNo).cdata = addTrack2(Movie(frameNo).cdata,newPatchX,newPatchY,x2,y2,path);
    if line(frameNo,1)==0
        figure,imshow(Movie(frameNo).cdata);
    end
    patchLeftTopX = newPatchX;
    patchLeftTopY = newPatchY;
    index_in = index_out+1;
    %% some variation changing this patch as original patch
%     patch = Movie(frameNo).cdata(patchLeftTopY:y2,patchLeftTopX:x2,:);
%     patch_ind = rgb2ind(patch,map);
%     q_pdf = calculateDensity(patch_ind, kernel, patchHeight, patchWidth,map);
    
end

%% Write tracked coordinates to file
mkdir(['trace/' outFolder]);
outPath = ['trace/' outFolder '/'];
loc = loc(2:frameNo,:);
save([outPath outFolder '.mat'],'loc');
fileID = fopen([outPath outFolder '.txt'],'w');
fprintf(fileID,'%d,%d,%d\r\n',loc');
fclose(fileID);
% [track_difference lost_frame_no]=min_distance(track,loc);

%% show video
movie(trackedMovie);
% if lost_frame_no > 1
% imshow(trackedMovie(lost_frame_no).cdata);
% title(strcat('Frame at which bot lost its path - frame no:', num2str(lost_frame_no)));
% end
%% save the video file

savePath = 'trackedVideo/';
mkdir([savePath outFolder ]);
savePath=strcat(savePath,outFolder);
FileName=strcat(outFolder,'.avi');
file=strcat(string,FileName);
file=strcat(savePath,['/' file]);
movie2avi(trackedMovie, file);
%% plot sequence 50th frame
%% use subplot code from http://www.mathworks.com/matlabcentral/fileexchange/3696-subaxis-subplot
% figure('name','plot sequence')
% fram_icr = floor(numOfFrame/25);
% for i = 1:25
%     subaxis(5,5,i, 'Spacing', 0.03, 'Padding', 0, 'Margin', 0);
%     imshow(trackedMovie((i-1)*fram_icr+1).cdata);
%     axis tight
%     axis off
% end
% %%plot a curve iteration vs frameindex;
% figure('name','graph of frameindex vs iteration to converge'); 
% plot(iteration_Convergence_vector);
% xlabel('frameindex');
% ylabel('iteration');
 



