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
type = 'fixed_p';

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

%boxplot peak teus
for i=1:1


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
    
    phantom_1_BM = log(1+abs(hilbert(phantom_1_RF)));
    phantom_2_BM = log(1+abs(hilbert(phantom_2_RF)));
    phantom_3_BM = log(1+abs(hilbert(phantom_3_RF)));
    phantom_4_BM = log(1+abs(hilbert(phantom_4_RF)));
    phantom_5_BM = log(1+abs(hilbert(phantom_5_RF)));
    phantom_6_BM = log(1+abs(hilbert(phantom_6_RF)));
    phantom_7_BM = log(1+abs(hilbert(phantom_7_RF)));
    phantom_8_BM = log(1+abs(hilbert(phantom_8_RF)));
    phantom_9_BM = log(1+abs(hilbert(phantom_9_RF)));
    
    p1 = [p1;phantom_1_BM];
    p2 = [p2;phantom_2_BM];
    p3 = [p3;phantom_3_BM];
    p4 = [p4;phantom_4_BM];
    p5 = [p5;phantom_5_BM];
    p6 = [p6;phantom_6_BM];
    p7 = [p7;phantom_7_BM];
    p8 = [p8;phantom_8_BM];
    p9 = [p9;phantom_9_BM];
end

%     figure; colormap(gray);
%     %0.5x
%     subplot(3,3,1);
%     imagesc(p1(1:512,:,1));
%     title('0.5x 23u');
%     hold on;
%     subplot(3,3,2);
%     imagesc(p2(1:512,:,1));
%     title('0.5x 32u');
%     hold on;
%     subplot(3,3,3);
%     imagesc(p3(1:512,:,1));
%     title('0.5x 60u');
%     hold on;
%     %1x
%     subplot(3,3,4);
%     imagesc(p4(1:512,:,1));
%     title('1x 23u');
%     hold on;
%     subplot(3,3,5);
%     imagesc(p5(1:512,:,1));
%     title('1x 32u');
%     hold on;
%     subplot(3,3,6);
%     imagesc(p6(1:512,:,1));
%     title('1x 60u');
%     hold on;
%     %2x
%     subplot(3,3,7);
%     imagesc(p7(1:512,:,1));
%     title('2x 23u');
%     hold on;
%     subplot(3,3,8);
%     imagesc(p8(1:512,:,1));
%     title('2x 32u');
%     hold on;
%     subplot(3,3,9);
%     imagesc(p9(1:512,:,1));
%     title('2x 60u');

    
    
    p1min = min(min(min(p1)));
    p2min = min(min(min(p2)));
    p3min = min(min(min(p3)));
    p4min = min(min(min(p4)));
    p5min = min(min(min(p5)));
    p6min = min(min(min(p6)));
    p7min = min(min(min(p7)));
    p8min = min(min(min(p8)));
    p9min = min(min(min(p9)));
    
    p1max = max(max(max(p1)));
    p2max = max(max(max(p2)));
    p3max = max(max(max(p3)));
    p4max = max(max(max(p4)));
    p5max = max(max(max(p5)));
    p6max = max(max(max(p6)));
    p7max = max(max(max(p7)));
    p8max = max(max(max(p8)));
    p9max = max(max(max(p9)));
    
    minv = min([p1min,p2min,p3min,p4min,p5min,p6min,p7min,p8min,p9min]);
    maxv = max([p1max,p2max,p3max,p4max,p5max,p6max,p7max,p8max,p9max]);
    
    phantom_1_BM = rescale(p1, 0,255,'InputMin', minv, 'InputMax', maxv);
    phantom_2_BM = rescale(p2, 0,255,'InputMin', minv, 'InputMax', maxv);
    phantom_3_BM = rescale(p3, 0,255,'InputMin', minv, 'InputMax', maxv);
    phantom_4_BM = rescale(p4, 0,255,'InputMin', minv, 'InputMax', maxv);
    phantom_5_BM = rescale(p5, 0,255,'InputMin', minv, 'InputMax', maxv);
    phantom_6_BM = rescale(p6, 0,255,'InputMin', minv, 'InputMax', maxv);
    phantom_7_BM = rescale(p7, 0,255,'InputMin', minv, 'InputMax', maxv);
    phantom_8_BM = rescale(p8, 0,255,'InputMin', minv, 'InputMax', maxv);
    phantom_9_BM = rescale(p9, 0,255,'InputMin', minv, 'InputMax', maxv);
    
    %sample1 = 1;
    %sample2 = 512;
    %element1 = 1;
    %element2=128;
    ROI_1 = phantom_1_BM(sample1:sample2, element1:element2,:);
    ROI_2 = phantom_2_BM(sample1:sample2, element1:element2,:);
    ROI_3 = phantom_3_BM(sample1:sample2, element1:element2,:);
    ROI_4 = phantom_4_BM(sample1:sample2, element1:element2,:);
    ROI_5 = phantom_5_BM(sample1:sample2, element1:element2,:);
    ROI_6 = phantom_6_BM(sample1:sample2, element1:element2,:);
    ROI_7 = phantom_7_BM(sample1:sample2, element1:element2,:);
    ROI_8 = phantom_8_BM(sample1:sample2, element1:element2,:);
    ROI_9 = phantom_9_BM(sample1:sample2, element1:element2,:);

%     ROI_1 = p1(sample1:sample2, element1:element2,:);
%     ROI_2 = p2(sample1:sample2, element1:element2,:);
%     ROI_3 = p3(sample1:sample2, element1:element2,:);
%     ROI_4 = p4(sample1:sample2, element1:element2,:);
%     ROI_5 = p5(sample1:sample2, element1:element2,:);
%     ROI_6 = p6(sample1:sample2, element1:element2,:);
%     ROI_7 = p7(sample1:sample2, element1:element2,:);
%     ROI_8 = p8(sample1:sample2, element1:element2,:);
%     ROI_9 = p9(sample1:sample2, element1:element2,:);
    
    [class_1, ~] = createClasses(ROI_1, 0);
    [class_2, ~] = createClasses(ROI_2, 1);
    [class_3, ~] = createClasses(ROI_3, 2);
    [class_4, ~] = createClasses(ROI_4, 3);
    [class_5, ~] = createClasses(ROI_5, 4);
    [class_6, ~] = createClasses(ROI_6, 5);
    [class_7, ~] = createClasses(ROI_7, 6);
    [class_8, ~] = createClasses(ROI_8, 7);
    [class_9, ~] = createClasses(ROI_9, 8);
    
    
f1=figure;
boxplot([class_1,class_2,class_3,class_4,class_5,class_6,class_7,class_8,class_9],'Labels', ...
    {'0p5x 23u', '0p5x 32u', '0p5x 60u', ...
    '1x 23u', '1x 32u', '1x 60u', ...
    '2x 23u', '2x 32u', '2x 60u'})
xtickangle(45)
title('Fixed FP B-Mode Amplitude');
ylabel('Pixel Value');
%saveas(f1,'figures/bmode_vs_rf/bmodepixelvalue.png');