function FFTMap_peaks = generateAndSelectFreqFeatures(phantom, numFeatures)
Fs=50;
[numSamples, numLines, numFrames] = size(phantom);
FFTMap = zeros([numSamples, numLines, numFrames/2+1]);

for xi = 1:numSamples
    for yi = 1:numLines
        [Y_1,P1_1,f_1] = RFfft(phantom(xi,yi,:),Fs,numFrames);
        FFTMap(xi,yi,:) = P1_1;
    end  
end


%Section 7
%Select the peak frequencies and harmonics

%find what location the peaks (1,2,3,4 Hz) occur at
%figure; plot(f_1); %9,17,25,33
%figure; imagesc(FFTMap_1(:,:,9));
FFTMap_peaks = FFTMap(:,:,numFeatures);
