% This function will read a video and return the information of that video
%%
function [ mov,height,width,numOfFrame,frame_rate ] = readVid(file)
        obj = VideoReader(file);
        width = obj.Width;
        height = obj.Height;
        disp('read');
        frame_rate=obj.FrameRate;
        
%         obj = mmread(file);
%         height = obj.Height;
%         width = obj.Width;
        numOfFrame =obj.NumberOfFrames;
        mov = struct('cdata',zeros(height,width,3,'uint8'),...
            'colormap',[]);
        for k = 1 : numOfFrame
             [mov(k).cdata] = read(obj, k);
        end
end

