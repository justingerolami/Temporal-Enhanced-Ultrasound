%%Script to use on verasonics machine after scanning.
%Uses SWIOutput and plots RF line, timeseries, and FFT of a line
%Check quality of the plots to make sure there was no movement

%Required for conversion to RF
centerFreq = 6.25;
transmitFreq = 4*centerFreq;
Fs = 50;

elements='32';
amplitude='6';
framerate='50';
scanversion='1';
focalChange=true;
oldNames = false;




phantom_struct = SWIOutput;
structSize = size(phantom_struct(1).Data);
numFrames = size(phantom_struct,2);

phantom_IQ = zeros([structSize numFrames]);


for fi = 1:numFrames
    phantom_IQ(:,:,fi) = phantom_struct(fi).Data;

end

phantom_I = real(phantom_IQ);


phantom_Q = imag(phantom_IQ);


%phantom_RF = phantom_I; 
%phantom_1x_RF = phantom_1x_I ;
%phantom_2x_RF=phantom_2x_I ;
%phantom_1x_60u_RF = phantom_1x_60u_I;



%Section 3
%Convert the TeUS IQ Data to TeUS RF Data
IntFac = 1;
[numSamples, numLines, numFrames] = size(phantom_IQ);

phantom_RF = zeros([numSamples*IntFac, numLines, numFrames]);


for fi = 1:numFrames
    phantom_RF(:,:,fi) = IQ2RF(phantom_IQ(:,:,fi),centerFreq, IntFac);

end



%detrending - remove mean
phantom_RF = detrend(phantom_RF);



%Section 5
%looking at the time series in the time domain and  frequency domain

%Frequency (framerate)
Fs = 50;
xi=215;
yi=32:96;



RFtimeSeries_phantom_0p5x = squeeze(phantom_RF(xi,yi,:));
[Y_0p5x,P1_0p5x,f_0p5x] = RFfft_multiLine(phantom_RF(xi,yi,:),Fs,numFrames);
P1_0p5x(1) = 0; 

figure;
plot(RFtimeSeries_phantom_0p5x');

figure;
plot(f_0p5x,P1_0p5x);


Fr = 1;
line = 64;
rf = phantom_RF(:,line,Fr);


minRF = min(rf);
maxRF = max(rf);


minv = round(min([minRF]));
maxv = round(max([maxRF]));

figure;
plot(rf);
ylim([minv maxv]);

figure;imagesc(log(1+abs(hilbert(phantom_RF(:,:,1)))));colormap(gray);
