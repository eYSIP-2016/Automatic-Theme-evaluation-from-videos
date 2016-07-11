function [ inputF ] = addTrack2( inputF,y1, x1, y2, x2,track )
[r c]=size(track);
for i=1:r
    x=track(i,2);
    y=track(i,1);
    inputF(x,y,1)=0;
    inputF(x,y,1)=0;
    inputF(x,y,1)=255;
end

inputF(x1:x2,y1:y1+3,1) = 255; %top line
inputF(x1:x2,y2-3:y2,1) = 255; %bottom line
inputF(x1:x1+3,y1:y2,1) = 255; %left line
inputF(x2-3:x2,y1:y2,1) = 255; %right line

inputF(x1:x2,y1:y1+3,2) = 242; %top line
inputF(x1:x2,y2-3:y2,2) = 242; %bottom line
inputF(x1:x1+3,y1:y2,2) = 242; %left line
inputF(x2-3:x2,y1:y2,2) = 242; %right line

inputF(x1:x2,y1:y1+3,3) = 0; %top line
inputF(x1:x2,y2-3:y2,3) = 0; %bottom line
inputF(x1:x1+3,y1:y2,3) = 0; %left line
inputF(x2-3:x2,y1:y2,3) = 0; %right line

inputF((x1+x2)/2-10:(x1+x2)/2+10,(y1+y2)/2-3:(y1+y2)/2+3,1) = 255; %top line
inputF((x1+x2)/2-3:(x1+x2)/2+3,(y1+y2)/2-10:(y1+y2)/2+10,1) = 255; %left line

inputF((x1+x2)/2-10:(x1+x2)/2+10,(y1+y2)/2-3:(y1+y2)/2+3,2) = 242; %top line
inputF((x1+x2)/2-3:(x1+x2)/2+3,(y1+y2)/2-10:(y1+y2)/2+10,2) = 242; %left line

inputF((x1+x2)/2-10:(x1+x2)/2+10,(y1+y2)/2-3:(y1+y2)/2+3,3) = 0; %top line
inputF((x1+x2)/2-3:(x1+x2)/2+3,(y1+y2)/2-10:(y1+y2)/2+10,3) = 0; %left line
end

