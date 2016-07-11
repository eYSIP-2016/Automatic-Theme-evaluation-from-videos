%{
Function name: readPatch
Input: First frame of the movie
Output: Returns the location of the robot
Logic: calls a function trackobject() that identifies the robot and 
returns its position.
%}
function [patchLeftTopX,patchLeftTopY,patchRightBottomX,patchRightBottomY] = ...
        readPatch( movie,i)    
    
    [bb]=trackobject(movie(i).cdata);
    patchLeftTopX = bb(1);
    patchLeftTopY = bb(2);
    patchRightBottomX = bb(1)+bb(3);
    patchRightBottomY = bb(2)+bb(4);
end

