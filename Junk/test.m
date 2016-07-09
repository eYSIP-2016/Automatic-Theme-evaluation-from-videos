figure
ax(1) = subplot(311);
plot((0:numel(y1(:,1))-1)/f1,y1(:,1),'b');
ylabel('Original');
grid on
ax(1) = subplot(312);
plot((0:numel(y2)-1)/f2,y2,'g');
ylabel('Buzzer');
grid on
xlabel('Time (secs)');

% % NFFT = length(y);
% % Y = fft(y,NFFT);
% % F = ((0:1/NFFT:1-1/NFFT)*f);
% % magnitudeY = abs(Y);        % Magnitude of the FFT
% % phaseY = unwrap(angle(Y));  % Phase of the FFT
% % helperFrequencyAnalysisPlot1(F,magnitudeY,phaseY,NFFT)
% % 
% % [P1,f1] = periodogram(y,[],[],f,'power');
% % [P2,f2] = periodogram(y1,[],[],f1,'power');
% % 
% % subplot(2,1,1)
% % plot(f1,P1,'k')
% % grid
% % ylabel('P_1')
% % title('Power Spectrum')
% % 
% % subplot(2,1,2)
% % plot(f2,P2,'r')
% % grid
% % ylabel('P_2')
% % xlabel('Frequency (Hz)')