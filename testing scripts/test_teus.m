%%

%{
This is a testing script for fixed/moving focal point TeUS data. 
This script does not generate a virtual ROI. 
The purpose of this script is to compare this method against ViTUS
(test_vitus.m). 
%}

clear all;
rng(1);
centerFreq = 6.25;
transmitFreq = 4*centerFreq;

phantomName1 = '0p5x 23u';
phantomName2 = '0p5x 32u';
phantomName3 = '0p5x 60u';
phantomName4 = '1x 23u';
phantomName5 = '1x 32u';
phantomName6 = '1x 60u';
phantomName7 = '23u 2x';
phantomName8= '32u 2x';
phantomName9= '60u 2x';
phantomNames = {phantomName1, phantomName3};

scantype1='fixed_p2';
scantype2='fixed_p5';

f1 = strcat(strrep(phantomName1, ' ', '_'),'_',scantype1,'.mat');
f2 = strcat(strrep(phantomName3, ' ', '_'),'_',scantype1,'.mat');
f12 = strcat(strrep(phantomName1, ' ', '_'),'_',scantype2,'.mat');
f22 = strcat(strrep(phantomName3, ' ', '_'),'_',scantype2,'.mat');

numFeatures = [1:101];
numSamplesFromCenter = 64;
element1 = 32;
element2 = 96;

phantom_1_RF = loadIQAndConvertToRF(f1);
phantom_2_RF = loadIQAndConvertToRF(f2);
%phantom_1_RF = detrend(phantom_1_RF);
%phantom_2_RF = detrend(phantom_2_RF);

phantom_12_RF = loadIQAndConvertToRF(f12);
phantom_22_RF = loadIQAndConvertToRF(f22);
%phantom_12_RF = detrend(phantom_12_RF);
%phantom_22_RF = detrend(phantom_22_RF);

%%
ROI_1 = phantom_1_RF(244-numSamplesFromCenter:244+numSamplesFromCenter, element1:element2, :);
ROI_2 = phantom_2_RF(244-numSamplesFromCenter:244+numSamplesFromCenter, element1:element2, :);

ROI_1 = detrend(ROI_1);
ROI_2 = detrend(ROI_2);
FFTMap_1_peaks = generateAndSelectFreqFeatures(ROI_1, numFeatures);
FFTMap_2_peaks = generateAndSelectFreqFeatures(ROI_2, numFeatures);


ROI_12 = phantom_12_RF(244-numSamplesFromCenter:244+numSamplesFromCenter, element1:element2, :);
ROI_22 = phantom_22_RF(244-numSamplesFromCenter:244+numSamplesFromCenter, element1:element2, :);

ROI_12 = detrend(ROI_12);
ROI_22 = detrend(ROI_22);
FFTMap_12_peaks = generateAndSelectFreqFeatures(ROI_12, numFeatures);
FFTMap_22_peaks = generateAndSelectFreqFeatures(ROI_22, numFeatures);
%%
%phantom 1 figures
%Need gif, time series, fft
createFocalGif(phantom_1_RF, strcat(strrep(phantomName1, ' ', '_'),'_',scantype1,'.gif'))
createTSandFFTPlots_new(ROI_1, numSamplesFromCenter, [1:65], 50);

%phantom 2
createFocalGif(ROI_2, strcat(strrep(phantomName2, ' ', '_'),'_',scantype1,'.gif'));
createTSandFFTPlots_new(ROI_1, numSamplesFromCenter, [1:65], 50);


%phantom 12
createFocalGif(ROI_12, strcat(strrep(phantomName1, ' ', '_'),'_',scantype2,'.gif'));
createTSandFFTPlots_new(ROI_12, numSamplesFromCenter, [1:65], 50);

%phantom 22
createFocalGif(ROI_22, strcat(strrep(phantomName2, ' ', '_'),'_',scantype2,'.gif'));
createTSandFFTPlots_new(ROI_22, numSamplesFromCenter, [1:65], 50);

%%
[p1, p1c] = createClasses(ROI_1, 0);
[p2, p2c] = createClasses(ROI_2, 1);

[test_p1, test_p1c] = createClasses(ROI_12, 0);
[test_p2, test_p2c] = createClasses(ROI_22, 1);

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