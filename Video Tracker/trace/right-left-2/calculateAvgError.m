clc;clear;

[FileName,PathName] = uigetfile('*.*','Select a .mat file'); 
if FileName ==0
    return ;
end

file=strcat(PathName,FileName);

load(file);

actualY = 34.8+0.8;

observed = loc(:,3)*0.4208;

error = observed - actualY;

avgError = sum(error,1)/size(error,1)