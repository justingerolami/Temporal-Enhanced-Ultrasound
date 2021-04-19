function phantom_RF = loadIQAndConvertToRF(file)

centerFreq = 6.25;
phantom_IQ = loadIQData(file);

IntFac = 1;
[numSamples, numLines, numFrames] = size(phantom_IQ);
phantom_RF = zeros([numSamples*IntFac, numLines, numFrames]);

for fi = 1:numFrames
    phantom_RF(:,:,fi) = IQ2RF(phantom_IQ(:,:,fi),centerFreq, IntFac);
end
end