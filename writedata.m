function [ filename ] = writedata( mov)

filename = 'homographyoutput/test.avi';
writerObj = VideoWriter(filename);
open(writerObj);

writeVideo(writerObj,mov);


close(writerObj);
end