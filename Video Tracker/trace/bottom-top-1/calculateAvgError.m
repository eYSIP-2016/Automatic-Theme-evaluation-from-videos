clc;clear;

[FileName,PathName] = uigetfile('*.*','Select a .mat file'); 
if FileName ==0
    return ;
end

file=strcat(PathName,FileName);

load(file);

% 140 cm
actualX = 4*34.8+0.8;

observed = loc(:,2)*0.4208;

error = observed - actualX;

avgError = sum(error,1)/size(error,1)