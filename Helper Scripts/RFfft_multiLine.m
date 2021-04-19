function [Y,P1,f] = RFfft_multiLine(ROI_60umTotal,Fs,L)

%T = 1/Fs;                      % Sampling period
%t = (0:L-1)*T;                 % Time vector

RF = ROI_60umTotal;
RFPoint = squeeze(RF(1,:,:));


RFPoint = RFPoint';
% RFPoint = RFPoint;
%RFPoint2 = (RFPoint - repmat(min(RFPoint(1)),L,1));
RFPoint2 = RFPoint;
%then FFT
YROI_60umTotal = fft(double(RFPoint2));

Y = YROI_60umTotal;

P2 = abs(Y);
P1 = P2(1:L/2+1,:);
P1(1:end-1) = 2*P1(1:end-1);

f = Fs*(0:(L/2))/L;

end