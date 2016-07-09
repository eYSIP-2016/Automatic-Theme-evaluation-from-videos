%To get audio alone from the file
file='test.3gp';
hmfr1=video.MultimediaFileReader(file,'AudioOutputPort',true,'VideoOutputPort',false);
hmfr2=video.MultimediaFileReader(file,'AudioOutputPort',false,'VideoOutputPort',true);
