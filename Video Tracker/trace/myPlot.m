
[FileName,PathName] = uigetfile('*.*','Select a .mat file'); 
if FileName ==0
    return ;
end

file=strcat(PathName,FileName);

load(file);

figure(4),
plot(loc(:,1),loc(:,2));
xlabel('frame');
ylabel('x-coordinate');
saveas(gcf,[PathName 'xframe.jpg'], 'jpg');

figure(5),
plot(loc(:,1),loc(:,3));
xlabel('frame');
ylabel('y-coordinate');
saveas(gcf,[PathName 'yframe.jpg'], 'jpg');

figure(6),
plot(loc(:,2),loc(:,3));
xlabel('x-coordinate');
ylabel('y-coordinate');
saveas(gcf,[PathName 'xy-line-plot.jpg'], 'jpg');

figure(7),
scatter(loc(:,2),loc(:,3));
xlabel('x-coordinate');
ylabel('y-coordinate');
saveas(gcf,[PathName 'scatter-plot.jpg'], 'jpg');