%{
This code is for 12 plane of 9 phantoms - Jan/Feb 2020. 
For virtual TeUS with shifting focal point. 

Creates 8 train/4 test file. Does not create folds for CV.
%}

clear all;
rng(1);
centerFreq = 6.25;
transmitFreq = 4*centerFreq;

%fft features
%numFeatures = [1:4,6:8,10:12,14:16,18:101];
%numFeatures = [5,9,13,17];
numFeatures = [1:101];

%roi info - elements only (x axis)
element1 = 32;
element2 = 96;
%how many samples in the lateral direction up and down from focal point
%center to choose.
numSamplesFromCenter = 32;

%verasonics parameters to calc FP
initialFocus = 61;
focalAmplitude = 6;
acqFrames = 200;
numberOfCycles=1;
ZFocal = zeros(1,acqFrames);
for i = 1:acqFrames
    ZFocal(i) = initialFocus + focalAmplitude*sin(2*pi*(i-1)*numberOfCycles/acqFrames);
    %ZFocal(i) = initialFocus + focalAmplitude*sin(2*pi*0.8*(i-1)*numberOfCycles/acqFrames-(pi/6));
end
plot(ZFocal)
ZFocal = ZFocal*4;
ZFocal = round(ZFocal);


%fixed and plane
%example: type='fixed_p' for fixed FP
%example: type='p' for moving FP
type = 'p';


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

train_filename =strcat("C:\Users\Justin\OneDrive - Queen's University\MSc\TeUS Focal Change Project\data\savedRF\Jan17\virtualTeUSExperiments\",'train_thesis_1C200F.mat');
test_filename =strcat("C:\Users\Justin\OneDrive - Queen's University\MSc\TeUS Focal Change Project\data\savedRF\Jan17\virtualTeUSExperiments\",'test_thesis_1C200F.mat');

%inds = randperm(12);
%the indicies used to create train/test for thesis
inds = [3,6,5,7,4,8,9,1,11,10,12,2];
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
    
    phantom_1_RF = createVirtualTeUSROI(phantom_1_RF, numSamplesFromCenter, element1, element2, ZFocal);
    phantom_2_RF = createVirtualTeUSROI(phantom_2_RF, numSamplesFromCenter, element1, element2, ZFocal);
    phantom_3_RF = createVirtualTeUSROI(phantom_3_RF, numSamplesFromCenter, element1, element2, ZFocal);
    phantom_4_RF = createVirtualTeUSROI(phantom_4_RF, numSamplesFromCenter, element1, element2, ZFocal);
    phantom_5_RF = createVirtualTeUSROI(phantom_5_RF, numSamplesFromCenter, element1, element2, ZFocal);
    phantom_6_RF = createVirtualTeUSROI(phantom_6_RF, numSamplesFromCenter, element1, element2, ZFocal);
    phantom_7_RF = createVirtualTeUSROI(phantom_7_RF, numSamplesFromCenter, element1, element2, ZFocal);
    phantom_8_RF = createVirtualTeUSROI(phantom_8_RF, numSamplesFromCenter, element1, element2, ZFocal);
    phantom_9_RF = createVirtualTeUSROI(phantom_9_RF, numSamplesFromCenter, element1, element2, ZFocal);

    phantom_1_RF = detrending(phantom_1_RF);
    phantom_2_RF = detrending(phantom_2_RF);
    phantom_3_RF = detrending(phantom_3_RF);
    phantom_4_RF = detrending(phantom_4_RF);
    phantom_5_RF = detrending(phantom_5_RF);
    phantom_6_RF = detrending(phantom_6_RF);
    phantom_7_RF = detrending(phantom_7_RF);
    phantom_8_RF = detrending(phantom_8_RF);
    phantom_9_RF = detrending(phantom_9_RF);
    
%     phantom_1_RF = phantom_1_RF(:,:,1:50);
%     phantom_2_RF = phantom_2_RF(:,:,1:50);
%     phantom_3_RF = phantom_3_RF(:,:,1:50);
%     phantom_4_RF = phantom_4_RF(:,:,1:50);
%     phantom_5_RF = phantom_5_RF(:,:,1:50);
%     phantom_6_RF = phantom_6_RF(:,:,1:50);
%     phantom_7_RF = phantom_7_RF(:,:,1:50);
%     phantom_8_RF = phantom_8_RF(:,:,1:50);
%     phantom_9_RF = phantom_9_RF(:,:,1:50);
    
    ROI_1 = generateAndSelectFreqFeatures(phantom_1_RF, numFeatures);
    ROI_2 = generateAndSelectFreqFeatures(phantom_2_RF, numFeatures);
    ROI_3 = generateAndSelectFreqFeatures(phantom_3_RF, numFeatures);
    ROI_4 = generateAndSelectFreqFeatures(phantom_4_RF, numFeatures);
    ROI_5 = generateAndSelectFreqFeatures(phantom_5_RF, numFeatures);
    ROI_6 = generateAndSelectFreqFeatures(phantom_6_RF, numFeatures);
    ROI_7 = generateAndSelectFreqFeatures(phantom_7_RF, numFeatures);
    ROI_8 = generateAndSelectFreqFeatures(phantom_8_RF, numFeatures);
    ROI_9 = generateAndSelectFreqFeatures(phantom_9_RF, numFeatures);

%     ROI_1 = normalize(ROI_1, 3, normtype);
%     ROI_2 = normalize(ROI_2, 3, normtype);
%     ROI_3 = normalize(ROI_3, 3, normtype);
%     ROI_4 = normalize(ROI_4, 3, normtype);
%     ROI_5 = normalize(ROI_5, 3, normtype);
%     ROI_6 = normalize(ROI_6, 3, normtype);
%     ROI_7 = normalize(ROI_7, 3, normtype);
%     ROI_8 = normalize(ROI_8, 3, normtype);
%     ROI_9 = normalize(ROI_9, 3, normtype);
    
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
    
    phantom_1_RF = createVirtualTeUSROI(phantom_1_RF, numSamplesFromCenter, element1, element2, ZFocal);
    phantom_2_RF = createVirtualTeUSROI(phantom_2_RF, numSamplesFromCenter, element1, element2, ZFocal);
    phantom_3_RF = createVirtualTeUSROI(phantom_3_RF, numSamplesFromCenter, element1, element2, ZFocal);
    phantom_4_RF = createVirtualTeUSROI(phantom_4_RF, numSamplesFromCenter, element1, element2, ZFocal);
    phantom_5_RF = createVirtualTeUSROI(phantom_5_RF, numSamplesFromCenter, element1, element2, ZFocal);
    phantom_6_RF = createVirtualTeUSROI(phantom_6_RF, numSamplesFromCenter, element1, element2, ZFocal);
    phantom_7_RF = createVirtualTeUSROI(phantom_7_RF, numSamplesFromCenter, element1, element2, ZFocal);
    phantom_8_RF = createVirtualTeUSROI(phantom_8_RF, numSamplesFromCenter, element1, element2, ZFocal);
    phantom_9_RF = createVirtualTeUSROI(phantom_9_RF, numSamplesFromCenter, element1, element2, ZFocal);
    
    phantom_1_RF = detrending(phantom_1_RF);
    phantom_2_RF = detrending(phantom_2_RF);
    phantom_3_RF = detrending(phantom_3_RF);
    phantom_4_RF = detrending(phantom_4_RF);
    phantom_5_RF = detrending(phantom_5_RF);
    phantom_6_RF = detrending(phantom_6_RF);
    phantom_7_RF = detrending(phantom_7_RF);
    phantom_8_RF = detrending(phantom_8_RF);
    phantom_9_RF = detrending(phantom_9_RF);
    
%     phantom_1_RF = phantom_1_RF(:,:,1:50);
%     phantom_2_RF = phantom_2_RF(:,:,1:50);
%     phantom_3_RF = phantom_3_RF(:,:,1:50);
%     phantom_4_RF = phantom_4_RF(:,:,1:50);
%     phantom_5_RF = phantom_5_RF(:,:,1:50);
%     phantom_6_RF = phantom_6_RF(:,:,1:50);
%     phantom_7_RF = phantom_7_RF(:,:,1:50);
%     phantom_8_RF = phantom_8_RF(:,:,1:50);
%     phantom_9_RF = phantom_9_RF(:,:,1:50);
    
    
    
    ROI_1 = generateAndSelectFreqFeatures(phantom_1_RF, numFeatures);
    ROI_2 = generateAndSelectFreqFeatures(phantom_2_RF, numFeatures);
    ROI_3 = generateAndSelectFreqFeatures(phantom_3_RF, numFeatures);
    ROI_4 = generateAndSelectFreqFeatures(phantom_4_RF, numFeatures);
    ROI_5 = generateAndSelectFreqFeatures(phantom_5_RF, numFeatures);
    ROI_6 = generateAndSelectFreqFeatures(phantom_6_RF, numFeatures);
    ROI_7 = generateAndSelectFreqFeatures(phantom_7_RF, numFeatures);
    ROI_8 = generateAndSelectFreqFeatures(phantom_8_RF, numFeatures);
    ROI_9 = generateAndSelectFreqFeatures(phantom_9_RF, numFeatures);
    
%     ROI_1 = normalize(ROI_1, 3, normtype);
%     ROI_2 = normalize(ROI_2, 3, normtype);
%     ROI_3 = normalize(ROI_3, 3, normtype);
%     ROI_4 = normalize(ROI_4, 3, normtype);
%     ROI_5 = normalize(ROI_5, 3, normtype);
%     ROI_6 = normalize(ROI_6, 3, normtype);
%     ROI_7 = normalize(ROI_7, 3, normtype);
%     ROI_8 = normalize(ROI_8, 3, normtype);
%     ROI_9 = normalize(ROI_9, 3, normtype);
    
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






