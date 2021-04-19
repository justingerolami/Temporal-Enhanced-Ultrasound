function [Y,P1,f] = RFfft(ROI_60umTotal,Fs,n_frames)
% in case of TeUS, frame rate would be the sampling frequency Fs

%T = 1/Fs;                      % Sampling period
%t = (0:L-1)*T;                 % Time vector

RF = ROI_60umTotal;
RFPoint = squeeze(RF(1,1,:));


% RFPoint = RFPoint;
RFPoint2 = (RFPoint - repmat(min(RFPoint(1)),n_frames,1));

%then FFT
YROI_60umTotal = fft(double(RFPoint2));

Y = YROI_60umTotal;

P2 = abs(Y);
P1 = P2(1:n_frames/2+1);
P1(1:end-1) = 2*P1(1:end-1);

f = Fs*(0:(n_frames/2))/n_frames;




%{
%% Proper use of fft in MATLAB for feature analysis
% consider you have 100 frames TeUS time series with frame rate of 30Hz

ts_data = ROI_60umTotal;




% generate the time axis values
t = (0:n_frames-1)'/Fs;
% ts_data = 3*sin(2*pi*1*t)+4*cos(2*pi*3*t) + randn(size(t));

% set the number of fft element (better to be 2^n)
n_frames = 2^nextpow2(n_frames);
% IMPORTANT: zero-mean before fft (if the mean value is of importance, keep it as a separate feature
ts_data_dc = mean(ts_data);
ts_data_ac = ts_data - ts_data_dc;
% % Hamming is useful for removing ripples WHEN number of samples in fft are high
% % Note that hamming will change the amplitude of fft too
% ts_data_ac = ts_data.*hamming(n_frames);
% ts_data_ac = ts_data_ac - mean(ts_data_ac);

% calculate the complete fft (since the mean is 0, zero-pad will not change the frequency content
fft_data = fft( ts_data_ac, n_frames ); 
% only select the positive frequencies since the time domain data is real
fft_data = abs( fft_data(1:(n_frames/2+1)) );
% IMPORTANT: data scale recomended by MATLAB
% multiply intensity of all frequencies by 2, except for 0 and Nyquist
fft_data = fft_data/n_frames;
fft_data(2:end-1) = 2*fft_data(2:end-1);
% generate the frequency axis (from dc which is 0 to Nyquist limit which is fs/2)
f = (0:(n_frames/2))'*Fs/n_frames;

% Personal experience: the first element would always be near 0 since the signal is pure ac
% the dc value can be replaced as first element here (IF is one of the features)
%fft_data(1) = ts_data_dc;
%}

end
