vid=VideoReader('video_9.mp4');
for frame =1:vid.NumberOfFrames
     frame
     data = read(vid, frame);
     [aa ab ac]=trackobject(data);
end
