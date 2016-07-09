%{
function name: readPatch
input: First frame of the movie
output: Returns the location of the robot
%}
function [patchLeftTopX,patchLeftTopY,patchRightBottomX,patchRightBottomY] = ...
        readPatch( movie,i)    
    
    [im1 im2 bb]=trackobject(movie(i).cdata);
    patchLeftTopX = bb(1);
    patchLeftTopY = bb(2);
    patchRightBottomX = bb(1)+bb(3);
    patchRightBottomY = bb(2)+bb(4);
end

