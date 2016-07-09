%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Read audio file for processing.
[y f]= audioread('C:\Users\Admin\Documents\MATLAB\Video Evaluation\photos and videos\test_all.mp4'); %y is the signal and f is the sampling rate.
% samples=[1, 2*f]
% [yx fx]=audioread('test.mp4',samples);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Convert the audio sample to frequency domain
counter=1;
time=zeros(2,1);
NFFT = length(y);
Y = fft(y,NFFT); 
F = ((0:1/NFFT:1-1/NFFT)*f);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Display magnitude spectrum of signal
figure
plot(F(1,:),abs(Y(:,1)),'b');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Display amplitude vs time of signal
figure
ax(1) = subplot(311);
plot((0:numel(y(:,1))-1)/f,y(:,1),'b');
ylabel('Original');
grid on

maxi = max(abs(y(:,1)));
y1= abs(y(:,1))>0.4*maxi;
y4= reshape (y1,[],1);

y3= abs(y(:,1)).*y4;

ax(1) = subplot(312);
plot((0:numel(y3(:,1))-1)/f,y3(:,1),'r');
ylabel('Peak');
grid on

ax(1) = subplot(313);
plot((0:numel(y(:,1))-1)/f,abs(y(:,1)),'g');
ylabel('Original abs');
grid on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Designing band pass filter.
Fc1=2500;
Fc2=3200;
Fs=f;
h  = fdesign.bandpass('N,F3dB1,F3dB2', 10, Fc1, Fc2, Fs);
Hd = design(h, 'butter');
z=filter (Hd,y(:,1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Displaying filtered output.
figure
ax(1) = subplot(311);
plot((0:numel(z(:,1))-1)/f,abs(z(:,1)),'b');
ylabel('Filtered Original');
grid on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Filtering out noises in the output.
j=1;
for i=1:numel(y1)
    if y1(i,1)==1
        y2(j)= i/f;
        j=j+1;
    end
end
clear i;
clear j;
j=1;

%%Displaying results after eliminating noises.
a= abs(z(:,1)) > 0.05*maxi;
a= a.*z;
ax(1) = subplot(312);
plot((0:numel(a)-1)/f,abs(a),'r');
ylabel('Filtered Original without disturbances');
grid on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Identifiying buzzer beeps that are prominent >=1s
%% and storing their start and end time.
for i=1:numel(a)
    if abs(a(i,1))>0
        zz(j)= i/f;
        j=j+1;
    end
end
clc;x=0;j=0;
for i = 1: numel(zz)
    if zz(i)-x > 0.1
        j=j+1;
        x= zz(i);
        start(j)=x;
        ending(j)=x;
    else
        x= zz(i);
        if j==0
            j=j+1;
            start(j)=x;
        end
        ending(j)=x;
    end
end
clc;clear i; clear j;
j=1;
for i=1: numel(start)
    if ending(i)-start(i)<0.2
        start(i)=-1;
        ending(i)=-1;
    end
end
for i=1: numel(start)
    if start(i) > 0
        time_start(j)=start(i);
        time_end(j)=ending(i);
        
        time(counter,1)=time_start(j);
        counter=counter+1;
        time(counter,1)= time_end(j);
        counter=counter+1;
        j=j+1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Storing the time in a file.
fid = fopen('C:\Users\Admin\Documents\MATLAB\Video Evaluation\Text Files\buzzer_time.txt','wt');
[r,~]=size(time);
for ii = 1:r
    fprintf(fid,'%g\t',time(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Displaying prominent beeps.
j=1;
for i=1: numel(a)
    if j>numel(time_start)
        break;
    end
    if i>=time_start(j)*f && i<=time_end(j)*f
        a(i);
    else
        a(i)=0;
    end
    if i>time_end(j)*f
        j=j+1;
    end
end
ax(1) = subplot(313);
plot((0:numel(a)-1)/f,abs(a),'g');
ylabel('Final Output');
grid on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Identifiying beeps that are >=5s
clc;clear i; clear j;
for i=1: numel(time_start)
    if (time_end(i)-time_start(i))> 4
        time_start(i)=-1;
        time_end(i)=-1;
    end
end
j=1;k=0;
for i=1: numel(time_start)
    if time_start(i) < 0
        k=1;
        time_start_5(j)=time_start(i);
        time_end_5(j)=time_end(i);
        j=j+1;
    end
end
if k==0
    for i=1: numel(a)
        a(i)=0;
    end
else
    j=1;
    for i=1: numel(a)
        if j>numel(time_start_5)
            break;
        end
        if i>=time_start_5(j)*f & i<=time_end_5(j)*f
            a(i);
        else
            a(i)=0;
        end
        if i>time_end_5(j)*f
            j=j+1;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Displaying result with beeps >=5s.
figure
ax(1) = subplot(311);
plot((0:numel(a)-1)/f,abs(a),'g');
ylabel('Final Output 5');
grid on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%