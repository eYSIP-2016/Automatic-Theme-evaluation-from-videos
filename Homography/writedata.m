function [ filename ] = writedata( mov)

filename = 'output/test.avi';
writerObj = VideoWriter(filename);
open(writerObj);

writeVideo(writerObj,mov);


close(writerObj);
end