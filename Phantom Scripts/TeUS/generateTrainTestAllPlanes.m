%{
This code is for 12 plane of 9 phantoms - Jan/Feb 2020. 

This script creates the training and testing data (8 planes train, 4 test)
using all planes of all phantoms. 

Note: This script does not create folds for CV. 
%}

clear all;
rng(1);
%Required for conversion to RF
centerFreq = 6.25;
transmitFreq = 4*centerFreq;


%inds = randperm(12);
inds = [7,6,12,3,10,8,11,5,4,1,2,9];

%fft peaks to use
numFeatures = [1:101];

%ROI info
sample1 = 215;
sample2 = 281;
element1 = 32;
element2 = 96;

%what US scan type
%example: scantype='fixed_p1' for fixed FP
%example: scantype='p1' for not fixed FP
type = 'fixed_p';

%phantoms to use
phantomName1 = '0p5x 23u';
phantomName2 = '0p5x 32u';
phantomName3 = '0p5x 60u';
phantomName4 = '1x 23u';
phantomName5 = '1x 32u';
phantomName6 = '1x 60u';
phantomName7 = '23u 2x';
phantomName8= '32u 2x';
phantomName9= '60u 2x';

p1=[];
p1c=[];
p2=[];
p2c=[];
p3=[];
p3c=[];
p4=[];
p4c=[];
p5=[];
p5c=[];
p6=[];
p6c=[];
p7=[];
p7c=[];
p8=[];
p8c=[];
p9=[];
p9c=[];

phantomNames = {phantomName1, phantomName2, phantomName3, phantomName4, phantomName5, phantomName6 ...
    phantomName7, phantomName8, phantomName9};

train_filename =strcat("C:\Users\Justin\OneDrive - Queen's University\MSc\TeUS Focal Change Project\data\savedRF\Jan17\",'fixed_detrendTest_train.mat');
test_filename =strcat("C:\Users\Justin\OneDrive - Queen's University\MSc\TeUS Focal Change Project\data\savedRF\Jan17\",'fixed_detrendTest_test.mat');

%training data - 8 planes
for i=1:8
    scannum = strcat(type, num2str(inds(i)));
    [phantom_1_file,phantom_2_file,phantom_3_file,phantom_4_file, ...
         phantom_5_file,phantom_6_file,phantom_7_file,phantom_8_file, ...
           phantom_9_file] = generateFileNames(scannum,phantomName1,...
              phantomName2,phantomName3,phantomName4,phantomName5,...
                 phantomName6,phantomName7,phantomName8,phantomName9);
    
    phantom_1_RF = loadIQAndConvertToRF(phantom_1_file);
    phantom_2_RF = loadIQAndConvertToRF(phantom_2_file);
    phantom_3_RF = loadIQAndConvertToRF(phantom_3_file);
    phantom_4_RF = loadIQAndConvertToRF(phantom_4_file);
    phantom_5_RF = loadIQAndConvertToRF(phantom_5_file);
    phantom_6_RF = loadIQAndConvertToRF(phantom_6_file);
    phantom_7_RF = loadIQAndConvertToRF(phantom_7_file);
    phantom_8_RF = loadIQAndConvertToRF(phantom_8_file);
    phantom_9_RF = loadIQAndConvertToRF(phantom_9_file);
    
    phantom_1_RF = detrending(phantom_1_RF);
    phantom_2_RF = detrending(phantom_2_RF);
    phantom_3_RF = detrending(phantom_3_RF);
    phantom_4_RF = detrending(phantom_4_RF);
    phantom_5_RF = detrending(phantom_5_RF);
    phantom_6_RF = detrending(phantom_6_RF);
    phantom_7_RF = detrending(phantom_7_RF);
    phantom_8_RF = detrending(phantom_8_RF);
    phantom_9_RF = detrending(phantom_9_RF);
    
    FFTMap_1_peaks = generateAndSelectFreqFeatures(phantom_1_RF, numFeatures);
    FFTMap_2_peaks = generateAndSelectFreqFeatures(phantom_2_RF, numFeatures);
    FFTMap_3_peaks = generateAndSelectFreqFeatures(phantom_3_RF, numFeatures);
    FFTMap_4_peaks = generateAndSelectFreqFeatures(phantom_4_RF, numFeatures);
    FFTMap_5_peaks = generateAndSelectFreqFeatures(phantom_5_RF, numFeatures);
    FFTMap_6_peaks = generateAndSelectFreqFeatures(phantom_6_RF, numFeatures);
    FFTMap_7_peaks = generateAndSelectFreqFeatures(phantom_7_RF, numFeatures);
    FFTMap_8_peaks = generateAndSelectFreqFeatures(phantom_8_RF, numFeatures);
    FFTMap_9_peaks = generateAndSelectFreqFeatures(phantom_9_RF, numFeatures);

    ROI_1 = FFTMap_1_peaks(sample1:sample2, element1:element2,:);
    ROI_2 = FFTMap_2_peaks(sample1:sample2, element1:element2,:);
    ROI_3 = FFTMap_3_peaks(sample1:sample2, element1:element2,:);
    ROI_4 = FFTMap_4_peaks(sample1:sample2, element1:element2,:);
    ROI_5 = FFTMap_5_peaks(sample1:sample2, element1:element2,:);
    ROI_6 = FFTMap_6_peaks(sample1:sample2, element1:element2,:);
    ROI_7 = FFTMap_7_peaks(sample1:sample2, element1:element2,:);
    ROI_8 = FFTMap_8_peaks(sample1:sample2, element1:element2,:);
    ROI_9 = FFTMap_9_peaks(sample1:sample2, element1:element2,:);
    
    [class_1, classes_1] = createClasses(ROI_1, 0);
    [class_2, classes_2] = createClasses(ROI_2, 1);
    [class_3, classes_3] = createClasses(ROI_3, 2);
    [class_4, classes_4] = createClasses(ROI_4, 3);
    [class_5, classes_5] = createClasses(ROI_5, 4);
    [class_6, classes_6] = createClasses(ROI_6, 5);
    [class_7, classes_7] = createClasses(ROI_7, 6);
    [class_8, classes_8] = createClasses(ROI_8, 7);
    [class_9, classes_9] = createClasses(ROI_9, 8);
    
    p1 = [p1;class_1];
    p1c = [p1c; classes_1];
    p2 = [p2;class_2];
    p2c = [p2c; classes_2];
    p3 = [p3;class_3];
    p3c = [p3c; classes_3];
    p4 = [p4;class_4];
    p4c = [p4c; classes_4];
    p5 = [p5;class_5];
    p5c = [p5c; classes_5];
    p6 = [p6;class_6];
    p6c = [p6c; classes_6];
    p7 = [p7;class_7];
    p7c = [p7c; classes_7];
    p8 = [p8;class_8];
    p8c = [p8c; classes_8];
    p9 = [p9;class_9];
    p9c = [p9c; classes_9];
end

save(train_filename,'p1','p1c','p2','p2c','p3','p3c','p4','p4c','p5','p5c','p6','p6c','p7','p7c','p8','p8c','p9','p9c');

test_p1=[];
test_p1c=[];
test_p2=[];
test_p2c=[];
test_p3=[];
test_p3c=[];
test_p4=[];
test_p4c=[];
test_p5=[];
test_p5c=[];
test_p6=[];
test_p6c=[];
test_p7=[];
test_p7c=[];
test_p8=[];
test_p8c=[];
test_p9=[];
test_p9c=[];

%testing data - 4 planes
for i=9:12
    scannum = strcat(type, num2str(inds(i)));
    [phantom_1_file,phantom_2_file,phantom_3_file,phantom_4_file, ...
         phantom_5_file,phantom_6_file,phantom_7_file,phantom_8_file, ...
           phantom_9_file] = generateFileNames(scannum,phantomName1,...
              phantomName2,phantomName3,phantomName4,phantomName5,...
                 phantomName6,phantomName7,phantomName8,phantomName9);
    
    phantom_1_RF = loadIQAndConvertToRF(phantom_1_file);
    phantom_2_RF = loadIQAndConvertToRF(phantom_2_file);
    phantom_3_RF = loadIQAndConvertToRF(phantom_3_file);
    phantom_4_RF = loadIQAndConvertToRF(phantom_4_file);
    phantom_5_RF = loadIQAndConvertToRF(phantom_5_file);
    phantom_6_RF = loadIQAndConvertToRF(phantom_6_file);
    phantom_7_RF = loadIQAndConvertToRF(phantom_7_file);
    phantom_8_RF = loadIQAndConvertToRF(phantom_8_file);
    phantom_9_RF = loadIQAndConvertToRF(phantom_9_file);
    
    phantom_1_RF = detrending(phantom_1_RF);
    phantom_2_RF = detrending(phantom_2_RF);
    phantom_3_RF = detrending(phantom_3_RF);
    phantom_4_RF = detrending(phantom_4_RF);
    phantom_5_RF = detrending(phantom_5_RF);
    phantom_6_RF = detrending(phantom_6_RF);
    phantom_7_RF = detrending(phantom_7_RF);
    phantom_8_RF = detrending(phantom_8_RF);
    phantom_9_RF = detrending(phantom_9_RF);
    
    FFTMap_1_peaks = generateAndSelectFreqFeatures(phantom_1_RF, numFeatures);
    FFTMap_2_peaks = generateAndSelectFreqFeatures(phantom_2_RF, numFeatures);
    FFTMap_3_peaks = generateAndSelectFreqFeatures(phantom_3_RF, numFeatures);
    FFTMap_4_peaks = generateAndSelectFreqFeatures(phantom_4_RF, numFeatures);
    FFTMap_5_peaks = generateAndSelectFreqFeatures(phantom_5_RF, numFeatures);
    FFTMap_6_peaks = generateAndSelectFreqFeatures(phantom_6_RF, numFeatures);
    FFTMap_7_peaks = generateAndSelectFreqFeatures(phantom_7_RF, numFeatures);
    FFTMap_8_peaks = generateAndSelectFreqFeatures(phantom_8_RF, numFeatures);
    FFTMap_9_peaks = generateAndSelectFreqFeatures(phantom_9_RF, numFeatures);

    ROI_1 = FFTMap_1_peaks(sample1:sample2, element1:element2,:);
    ROI_2 = FFTMap_2_peaks(sample1:sample2, element1:element2,:);
    ROI_3 = FFTMap_3_peaks(sample1:sample2, element1:element2,:);
    ROI_4 = FFTMap_4_peaks(sample1:sample2, element1:element2,:);
    ROI_5 = FFTMap_5_peaks(sample1:sample2, element1:element2,:);
    ROI_6 = FFTMap_6_peaks(sample1:sample2, element1:element2,:);
    ROI_7 = FFTMap_7_peaks(sample1:sample2, element1:element2,:);
    ROI_8 = FFTMap_8_peaks(sample1:sample2, element1:element2,:);
    ROI_9 = FFTMap_9_peaks(sample1:sample2, element1:element2,:);
    
    [class_1, classes_1] = createClasses(ROI_1, 0);
    [class_2, classes_2] = createClasses(ROI_2, 1);
    [class_3, classes_3] = createClasses(ROI_3, 2);
    [class_4, classes_4] = createClasses(ROI_4, 3);
    [class_5, classes_5] = createClasses(ROI_5, 4);
    [class_6, classes_6] = createClasses(ROI_6, 5);
    [class_7, classes_7] = createClasses(ROI_7, 6);
    [class_8, classes_8] = createClasses(ROI_8, 7);
    [class_9, classes_9] = createClasses(ROI_9, 8);
    
    test_p1 = [test_p1;class_1];
    test_p1c = [test_p1c; classes_1];
    test_p2 = [test_p2;class_2];
    test_p2c = [test_p2c; classes_2];
    test_p3 = [test_p3;class_3];
    test_p3c = [test_p3c; classes_3];
    test_p4 = [test_p4;class_4];
    test_p4c = [test_p4c; classes_4];
    test_p5 = [test_p5;class_5];
    test_p5c = [test_p5c; classes_5];
    test_p6 = [test_p6;class_6];
    test_p6c = [test_p6c; classes_6];
    test_p7 = [test_p7;class_7];
    test_p7c = [test_p7c; classes_7];
    test_p8 = [test_p8;class_8];
    test_p8c = [test_p8c; classes_8];
    test_p9 = [test_p9;class_9];
    test_p9c = [test_p9c; classes_9];

end

save(test_filename,'test_p1','test_p1c','test_p2','test_p2c','test_p3','test_p3c','test_p4','test_p4c',...
    'test_p5','test_p5c','test_p6','test_p6c','test_p7','test_p7c','test_p8','test_p8c','test_p9','test_p9c');






