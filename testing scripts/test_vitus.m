%%

%{
This is a testing script which generates a moving ROI (vitus) on 2 phantoms
and applies a decision tree model for classification. 

%}

clear all;
rng(1);

%Transducer parameters
centerFreq = 6.25;
transmitFreq = 4*centerFreq;

%The types of phantoms used
phantomName1 = '0p5x 23u';
phantomName2 = '0p5x 32u';
phantomName3 = '0p5x 60u';
phantomName4 = '1x 23u';
phantomName5 = '1x 32u';
phantomName6 = '1x 60u';
phantomName7 = '23u 2x';
phantomName8= '32u 2x';
phantomName9= '60u 2x';

%Phantoms and planes used for classification
phantomNames = {phantomName1, phantomName3};
scantype1='p2';
scantype2='p5';

%How many fft features do we want to use
numFeatures = [1:101];

%Selects the location of the ROI. SamplesFromCenter is the number of
%samples to select above and below the center of the axial direction. 
numSamplesFromCenter = 32;
element1 = 32;
element2 = 96;

%verasonics parameters for focal point
initialFocus = 61;
focalAmplitude = 6;
acqFrames = 200;
numberOfCycles=4;
ZFocal = zeros(1,acqFrames);
for i = 1:acqFrames
    ZFocal(i) = initialFocus + focalAmplitude*sin(2*pi*(i-1)*numberOfCycles/acqFrames);
    
end
ZFocal = ZFocal*4;
%ZFocal = ZFocal+50;
ZFocal = round(ZFocal);

f1 = strcat(strrep(phantomName1, ' ', '_'),'_',scantype1,'.mat');
f2 = strcat(strrep(phantomName3, ' ', '_'),'_',scantype1,'.mat');
f12 = strcat(strrep(phantomName1, ' ', '_'),'_',scantype2,'.mat');
f22 = strcat(strrep(phantomName3, ' ', '_'),'_',scantype2,'.mat');

phantom_1_RF = loadIQAndConvertToRF(f1);
phantom_2_RF = loadIQAndConvertToRF(f2);
%phantom_1_RF = detrend(phantom_1_RF);
%phantom_2_RF = detrend(phantom_2_RF);

phantom_12_RF = loadIQAndConvertToRF(f12);
phantom_22_RF = loadIQAndConvertToRF(f22);
%phantom_12_RF = detrend(phantom_12_RF);
%phantom_22_RF = detrend(phantom_22_RF);

%%

%Creates the virtual ROI
mROI_1 = createVirtualTeUSROI(phantom_1_RF, numSamplesFromCenter, element1, element2, ZFocal);
mROI_2 = createVirtualTeUSROI(phantom_2_RF, numSamplesFromCenter, element1, element2,ZFocal);

mROI_1 = detrend(mROI_1);
mROI_2 = detrend(mROI_2);
FFTMap_1_peaks = generateAndSelectFreqFeatures(mROI_1, numFeatures);
FFTMap_2_peaks = generateAndSelectFreqFeatures(mROI_2, numFeatures);


mROI_12 = createVirtualTeUSROI(phantom_12_RF, numSamplesFromCenter, element1, element2,ZFocal);
mROI_22 = createVirtualTeUSROI(phantom_22_RF, numSamplesFromCenter, element1, element2,ZFocal);

mROI_12 = detrend(mROI_12);
mROI_22 = detrend(mROI_22);
FFTMap_12_peaks = generateAndSelectFreqFeatures(mROI_12, numFeatures);
FFTMap_22_peaks = generateAndSelectFreqFeatures(mROI_22, numFeatures);
%%
%phantom 1 figures
%Need gif, time series, fft
createFocalGif(mROI_1, strcat(strrep(phantomName1, ' ', '_'),'_',scantype1,'.gif'))
createTSandFFTPlots_new(mROI_1, numSamplesFromCenter, 32:64, 50);

%phantom 2
createFocalGif(mROI_2, strcat(strrep(phantomName2, ' ', '_'),'_',scantype1,'.gif'));
createTSandFFTPlots_new(mROI_1, numSamplesFromCenter, [1:65], 50);


%phantom 12
createFocalGif(mROI_12, strcat(strrep(phantomName1, ' ', '_'),'_',scantype2,'.gif'));
createTSandFFTPlots_new(mROI_12, numSamplesFromCenter, [1:65], 50);

%phantom 22
createFocalGif(mROI_22, strcat(strrep(phantomName2, ' ', '_'),'_',scantype2,'.gif'));
createTSandFFTPlots_new(mROI_22, numSamplesFromCenter, [1:65], 50);

%%
[p1, p1c] = createClasses(mROI_1, 0);
[p2, p2c] = createClasses(mROI_2, 1);

[test_p1, test_p1c] = createClasses(mROI_12, 0);
[test_p2, test_p2c] = createClasses(mROI_22, 1);

train_data = [p1;p2];
train_classes = [p1c;p2c];

test_data = [test_p1; test_p2];
test_classes = [test_p1c; test_p2c];

conf=zeros(2);

%%
%Shuffle the data randomly
trainDataWClasses = [train_classes train_data];
testDataWClasses = [test_classes test_data];
trainData = shuffleData(trainDataWClasses);
testData = shuffleData(testDataWClasses);

Xtr = trainData(:,2:end);
Ytr = trainData(:,1);

Xtest = testData(:,2:end);
Ytest = testData(:,1);

%mdl = fitcdiscr(Xtr,Ytr, 'DiscrimType', 'linear');
mdl = fitctree(Xtr, Ytr);
Ypred = predict(mdl, Xtest);

conf_i = confusionmat(Ytest, Ypred);
accTotal = 0;
for j = 1:length(conf_i)
    accTotal = accTotal+conf_i(j,j);
end
accTotal = accTotal/length(Xtest)*100;

sprintf("AVG Acc: %f", round(mean(accTotal),2))
sprintf("STD Acc: %f", round(std(accTotal),2))

figure;cm1=confusionchart(conf_i, phantomNames, 'OffDiagonalColor', [0 0.4471 0.7412]);
sortClasses(cm1,'cluster')
title('Confusion Matrix');