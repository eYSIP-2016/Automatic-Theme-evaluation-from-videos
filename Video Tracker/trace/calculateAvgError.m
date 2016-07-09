[FileName,PathName] = uigetfile('*.*','Select a .mat file'); 
if FileName ==0
    return ;
end

file=strcat(PathName,FileName);

load(file);