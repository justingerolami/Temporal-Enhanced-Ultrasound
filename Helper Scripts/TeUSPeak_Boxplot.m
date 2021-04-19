%{
This code is for creating boxplots based off peak signal / bmode val
%}
clear all;

%Required for conversion to RF
centerFreq = 6.25;
transmitFreq = 4*centerFreq;

%numFeatures = [1:4,6:8,10:12,14:16,18:101];
%numFeatures = [5,9,13,17];
%numFeatures = [1:101];
numFeatures = [5];
sample1 = 215;
sample2 = 281;
element1 = 32;
element2 = 96;

%fixed and plane
%example: scantype='fixed_p1' for fixed FP
%example: scantype='p1' for not fixed FP
%scantype1='fixed_p4';
%scantype2='fixed_p9';
%scantype1='p4';
%scantype2='p9';

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
type = 'p';


%boxplot peak teus
for i=1:12
    %Store plane i and i+i in empty array
    %Reset each iteration
    p1=[];
    p2=[];
    p3=[];
    p4=[];
    p5=[];
    p6=[];
    p7=[];
    p8=[];
    p9=[];

    %Plane i
    scannum = strcat(type, num2str((i)));
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
    
    phantom_1_RF = detrend(phantom_1_RF);
    phantom_2_RF = detrend(phantom_2_RF);
    phantom_3_RF = detrend(phantom_3_RF);
    phantom_4_RF = detrend(phantom_4_RF);
    phantom_5_RF = detrend(phantom_5_RF);
    phantom_6_RF = detrend(phantom_6_RF);
    phantom_7_RF = detrend(phantom_7_RF);
    phantom_8_RF = detrend(phantom_8_RF);
    phantom_9_RF = detrend(phantom_9_RF);
    
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
    
    [class_1, ~] = createClasses(ROI_1, 0);
    [class_2, ~] = createClasses(ROI_2, 1);
    [class_3, ~] = createClasses(ROI_3, 2);
    [class_4, ~] = createClasses(ROI_4, 3);
    [class_5, ~] = createClasses(ROI_5, 4);
    [class_6, ~] = createClasses(ROI_6, 5);
    [class_7, ~] = createClasses(ROI_7, 6);
    [class_8, ~] = createClasses(ROI_8, 7);
    [class_9, ~] = createClasses(ROI_9, 8);
    
    p1 = [p1;class_1];
    p2 = [p2;class_2];
    p3 = [p3;class_3];
    p4 = [p4;class_4];
    p5 = [p5;class_5];
    p6 = [p6;class_6];
    p7 = [p7;class_7];
    p8 = [p8;class_8];
    p9 = [p9;class_9];
end

f1=figure;
boxplot([p1,p2,p3,p4,p5,p6,p7,p8,p9],'Labels', ...
    {'0p5x 23u', '0p5x 32u', '0p5x 60u', ...
    '1x 23u', '1x 32u', '1x 60u', ...
    '2x 23u', '2x 32u', '2x 60u'})
xtickangle(45)
title('TeUS Peak Amplitude @ 1Hz');
ylabel('TeUS Amplitude');
saveas(f1,'figures/bmode_vs_rf/teuspeakamplitude.png');