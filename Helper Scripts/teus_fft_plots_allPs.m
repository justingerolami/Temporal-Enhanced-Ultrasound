%{
This code is for 12 plane of 9 phantoms - Jan/Feb 2020. 
%}

clear all;
rng(1);
%Required for conversion to RF
centerFreq = 6.25;
transmitFreq = 4*centerFreq;

numFeatures = [1:101];

sample1 = 215;
sample2 = 281;
element1 = 32;
element2 = 96;

%plotSample = mean([sample1,sample2]);
plotSample = 32;
element1 = 15;
element2 = 50;


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

path = "C:\Users\Justin\OneDrive - Queen's University\MSc\TeUS Focal Change Project\figures\teus_fft_plots\";
for i=1:1
    scannum = strcat(type, num2str(i));
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
    

    [RFtimeSeries1, f_phantom1, P1_phantom1] = createTSandFFTPlots_new(phantom_1_RF,plotSample,[element1:element2],50);
    [RFtimeSeries2, f_phantom2, P1_phantom2] = createTSandFFTPlots_new(phantom_2_RF,plotSample,[element1:element2],50);
    [RFtimeSeries3, f_phantom3, P1_phantom3] = createTSandFFTPlots_new(phantom_3_RF,plotSample,[element1:element2],50);
    [RFtimeSeries4, f_phantom4, P1_phantom4] = createTSandFFTPlots_new(phantom_4_RF,plotSample,[element1:element2],50);
    [RFtimeSeries5, f_phantom5, P1_phantom5] = createTSandFFTPlots_new(phantom_5_RF,plotSample,[element1:element2],50);
    [RFtimeSeries6, f_phantom6, P1_phantom6] = createTSandFFTPlots_new(phantom_6_RF,plotSample,[element1:element2],50);
    [RFtimeSeries7, f_phantom7, P1_phantom7] = createTSandFFTPlots_new(phantom_7_RF,plotSample,[element1:element2],50);
    [RFtimeSeries8, f_phantom8, P1_phantom8] = createTSandFFTPlots_new(phantom_8_RF,plotSample,[element1:element2],50);
    [RFtimeSeries9, f_phantom9, P1_phantom9] = createTSandFFTPlots_new(phantom_9_RF,plotSample,[element1:element2],50);


    f1=figure;

    sgtitle(strcat('Plane', num2str(i)));
    %0.5x
    ax1=subplot(3,3,1);
    plot(RFtimeSeries1');
    title('0.5x 23u');
    hold on;
    ax2=subplot(3,3,2);
    plot(RFtimeSeries2');
    title('0.5x 32u');
    hold on;
    ax3=subplot(3,3,3);
    plot(RFtimeSeries3');
    title('0.5x 60u');
    hold on;
    %1x
    ax4=subplot(3,3,4);
    plot(RFtimeSeries4');
    title('1x 23u');
    hold on;
    ax5=subplot(3,3,5);
    plot(RFtimeSeries5');
    title('1x 32u');
    hold on;
    ax6=subplot(3,3,6);
    plot(RFtimeSeries6');
    title('1x 60u');
    hold on;
    %2x
    ax7=subplot(3,3,7);
    plot(RFtimeSeries7');
    title('2x 23u');
    hold on;
    ax8=subplot(3,3,8);
    plot(RFtimeSeries8');
    title('2x 32u');
    hold on;
    ax9=subplot(3,3,9);
    plot(RFtimeSeries9');
    title('2x 60u');
    linkaxes([ax1,ax2,ax3,ax4,ax5,ax6,ax7,ax8,ax9], 'y');
    
    %saveas(f1,strcat(path,strcat("TeUS_plane",num2str(i)),'.png'));
    
    f2=figure;
    sgtitle(strcat('Plane', num2str(i)));
    %0.5x
    ax1=subplot(3,3,1);
    plot(f_phantom1,P1_phantom1);
    title('0.5x 23u');
    hold on;
    ax2=subplot(3,3,2);
    plot(f_phantom2,P1_phantom2);
    title('0.5x 32u');
    hold on;
    ax3=subplot(3,3,3);
    plot(f_phantom3,P1_phantom3);
    title('0.5x 60u');
    hold on;
    %1x
    ax4=subplot(3,3,4);
    plot(f_phantom4,P1_phantom4);
    title('1x 23u');
    hold on;
    ax5=subplot(3,3,5);
    plot(f_phantom5,P1_phantom5);
    title('1x 32u');
    hold on;
    ax6=subplot(3,3,6);
    plot(f_phantom6,P1_phantom6);
    title('1x 60u');
    hold on;
    %2x
    ax7=subplot(3,3,7);
    plot(f_phantom7,P1_phantom7);
    title('2x 23u');
    hold on;
    ax8=subplot(3,3,8);
    plot(f_phantom8,P1_phantom8);
    title('2x 32u');
    hold on;
    ax9=subplot(3,3,9);
    plot(f_phantom9,P1_phantom9);
    title('2x 60u');
    linkaxes([ax1,ax2,ax3,ax4,ax5,ax6,ax7,ax8,ax9], 'y');

    %saveas(f2,strcat(path,strcat("fft_plane",num2str(i)),'.png'));
end