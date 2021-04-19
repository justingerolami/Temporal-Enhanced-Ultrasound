function [RFtimeSeries, f_phantom, P1_phantom] = createTSandFFTPlots_new(phantom,xi,yi,Fs)
[numSamples, numLines, numFrames] = size(phantom);

RFtimeSeries = squeeze(phantom(xi,yi,:));
[Y_0p5x,P1_phantom,f_phantom] = RFfft_multiLine(phantom(xi,yi,:),Fs,numFrames);
P1_phantom(1) = 0; 

% figure;
% plot(RFtimeSeries');
% xlabel('Time (s)');
% ylabel('US RF Amplitude (a.u.)');
% figure;
% plot(f_phantom,P1_phantom);
% xlabel('Frequency (Hz)');
% ylabel('US RF Amplitude (a.u.)');
end