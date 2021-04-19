%{
This code is for 12 plane of 9 phantoms - Jan/Feb 2020. 

Run this code to generate the folds used for classification. 

Inds is hardcoded to a permutation that was used for all teus/vitus
experiments to ensure the same phantoms were used.
This can change for new experiments. 
%}

clear all;
rng(1);

%specify if using vitus or not. If we are, we have to generate the
%vitus using additional steps that arent included with teus
vitus=true;

%Required for conversion to RF
centerFreq = 6.25;
transmitFreq = 4*centerFreq;

%Select a permutation of 12 numbers, representing each plane of the phantom
%surface scan. Once ran once, hardcode to ensure consistancy. 
%inds = randperm(12);
inds = [7,6,12,3,10,8,11,5,4,1,2,9];
planesPerFold=2;
numFolds = length(inds)/planesPerFold;

%The fft peaks to use. Without removal, there are 101.
%numFeatures = [1:4,6:8,10:12,14:16,18:101];
%numFeatures = [5,9,13,17];
numFeatures = [1:101];

%ROI selection
sample1 = 215;
sample2 = 281;
element1 = 32;
element2 = 96;
numSamplesFromCenter = 32;

%change these for different types of datasets
%'p' or 'fixed_p'
%example: scantype='fixed_p1' for fixed FP
%example: scantype='p1' for not fixed FP
type = 'p';
initialFocus = 61;
focalAmplitude = 6;
acqFrames = 300;
numberOfCycles=1;

%focal point parameters
ZFocal = zeros(1,acqFrames);
for i = 1:acqFrames
    ZFocal(i) = initialFocus + focalAmplitude*sin(2*pi*(i-1)*numberOfCycles/acqFrames);
    %ZFocal(i) = initialFocus + focalAmplitude*sin(2*pi*0.8*(i-1)*numberOfCycles/acqFrames-(pi/6));
end
plot(ZFocal)
ZFocal = ZFocal*4;
ZFocal = round(ZFocal);

%phantoms
phantomName1 = '0p5x 23u';
phantomName2 = '0p5x 32u';
phantomName3 = '0p5x 60u';
phantomName4 = '1x 23u';
phantomName5 = '1x 32u';
phantomName6 = '1x 60u';
phantomName7 = '23u 2x';
phantomName8= '32u 2x';
phantomName9= '60u 2x';

phantomNames = {phantomName1, phantomName2, phantomName3, phantomName4, phantomName5, phantomName6 ...
    phantomName7, phantomName8, phantomName9};

fold=1;
for i=1:planesPerFold:12
    %Store plane i and i+i in empty array
    %Reset each iteration
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

    %Plane i
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
    
    if vitus
        phantom_1_RF = createVirtualTeUSROI(phantom_1_RF, numSamplesFromCenter, element1, element2, ZFocal);
        phantom_2_RF = createVirtualTeUSROI(phantom_2_RF, numSamplesFromCenter, element1, element2, ZFocal);
        phantom_3_RF = createVirtualTeUSROI(phantom_3_RF, numSamplesFromCenter, element1, element2, ZFocal);
        phantom_4_RF = createVirtualTeUSROI(phantom_4_RF, numSamplesFromCenter, element1, element2, ZFocal);
        phantom_5_RF = createVirtualTeUSROI(phantom_5_RF, numSamplesFromCenter, element1, element2, ZFocal);
        phantom_6_RF = createVirtualTeUSROI(phantom_6_RF, numSamplesFromCenter, element1, element2, ZFocal);
        phantom_7_RF = createVirtualTeUSROI(phantom_7_RF, numSamplesFromCenter, element1, element2, ZFocal);
        phantom_8_RF = createVirtualTeUSROI(phantom_8_RF, numSamplesFromCenter, element1, element2, ZFocal);
        phantom_9_RF = createVirtualTeUSROI(phantom_9_RF, numSamplesFromCenter, element1, element2, ZFocal);
    end
    
    phantom_1_RF = detrending(phantom_1_RF);
    phantom_2_RF = detrending(phantom_2_RF);
    phantom_3_RF = detrending(phantom_3_RF);
    phantom_4_RF = detrending(phantom_4_RF);
    phantom_5_RF = detrending(phantom_5_RF);
    phantom_6_RF = detrending(phantom_6_RF);
    phantom_7_RF = detrending(phantom_7_RF);
    phantom_8_RF = detrending(phantom_8_RF);
    phantom_9_RF = detrending(phantom_9_RF);
    
    if vitus        
        ROI_1 = generateAndSelectFreqFeatures(phantom_1_RF, numFeatures);
        ROI_2 = generateAndSelectFreqFeatures(phantom_2_RF, numFeatures);
        ROI_3 = generateAndSelectFreqFeatures(phantom_3_RF, numFeatures);
        ROI_4 = generateAndSelectFreqFeatures(phantom_4_RF, numFeatures);
        ROI_5 = generateAndSelectFreqFeatures(phantom_5_RF, numFeatures);
        ROI_6 = generateAndSelectFreqFeatures(phantom_6_RF, numFeatures);
        ROI_7 = generateAndSelectFreqFeatures(phantom_7_RF, numFeatures);
        ROI_8 = generateAndSelectFreqFeatures(phantom_8_RF, numFeatures);
        ROI_9 = generateAndSelectFreqFeatures(phantom_9_RF, numFeatures);
    end
    


    if ~vitus
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
    end
    
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
    
    %Plane i+1
    scannum = strcat(type, num2str(inds(i+1)));
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
    
    if vitus
        phantom_1_RF = createVirtualTeUSROI(phantom_1_RF, numSamplesFromCenter, element1, element2, ZFocal);
        phantom_2_RF = createVirtualTeUSROI(phantom_2_RF, numSamplesFromCenter, element1, element2, ZFocal);
        phantom_3_RF = createVirtualTeUSROI(phantom_3_RF, numSamplesFromCenter, element1, element2, ZFocal);
        phantom_4_RF = createVirtualTeUSROI(phantom_4_RF, numSamplesFromCenter, element1, element2, ZFocal);
        phantom_5_RF = createVirtualTeUSROI(phantom_5_RF, numSamplesFromCenter, element1, element2, ZFocal);
        phantom_6_RF = createVirtualTeUSROI(phantom_6_RF, numSamplesFromCenter, element1, element2, ZFocal);
        phantom_7_RF = createVirtualTeUSROI(phantom_7_RF, numSamplesFromCenter, element1, element2, ZFocal);
        phantom_8_RF = createVirtualTeUSROI(phantom_8_RF, numSamplesFromCenter, element1, element2, ZFocal);
        phantom_9_RF = createVirtualTeUSROI(phantom_9_RF, numSamplesFromCenter, element1, element2, ZFocal);
    end
    
    phantom_1_RF = detrending(phantom_1_RF);
    phantom_2_RF = detrending(phantom_2_RF);
    phantom_3_RF = detrending(phantom_3_RF);
    phantom_4_RF = detrending(phantom_4_RF);
    phantom_5_RF = detrending(phantom_5_RF);
    phantom_6_RF = detrending(phantom_6_RF);
    phantom_7_RF = detrending(phantom_7_RF);
    phantom_8_RF = detrending(phantom_8_RF);
    phantom_9_RF = detrending(phantom_9_RF);
    
    if vitus        
        ROI_1 = generateAndSelectFreqFeatures(phantom_1_RF, numFeatures);
        ROI_2 = generateAndSelectFreqFeatures(phantom_2_RF, numFeatures);
        ROI_3 = generateAndSelectFreqFeatures(phantom_3_RF, numFeatures);
        ROI_4 = generateAndSelectFreqFeatures(phantom_4_RF, numFeatures);
        ROI_5 = generateAndSelectFreqFeatures(phantom_5_RF, numFeatures);
        ROI_6 = generateAndSelectFreqFeatures(phantom_6_RF, numFeatures);
        ROI_7 = generateAndSelectFreqFeatures(phantom_7_RF, numFeatures);
        ROI_8 = generateAndSelectFreqFeatures(phantom_8_RF, numFeatures);
        ROI_9 = generateAndSelectFreqFeatures(phantom_9_RF, numFeatures);
    end
    


    if ~vitus
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
    end
    
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
    
    fold_filename =strcat("C:\Users\Justin\OneDrive - Queen's University\MSc\TeUS Focal Change Project\data\savedRF\Jan17\",'sf_vitus_300F_1C_fold_',num2str(fold),'.mat');
    save(fold_filename,'p1','p1c','p2','p2c','p3','p3c','p4','p4c','p5','p5c','p6','p6c','p7','p7c','p8','p8c','p9','p9c');
    fold=fold+1;
end
