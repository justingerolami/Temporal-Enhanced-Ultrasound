%{
This is a testing script for the virtual ROI (vitus). 
This script creates the virtual ROI, provides plots, and a gif
demonstrating it. 
%}


phantom_struct = SWIOutput;
structSize = size(phantom_struct(1).Data);
numFrames = size(phantom_struct,2);
phantom_IQ = zeros([structSize numFrames]);

for fi = 1:numFrames
    phantom_IQ(:,:,fi) = phantom_struct(fi).Data;
end

phantom_I = real(phantom_IQ);
phantom_Q = imag(phantom_IQ);
centerFreq = 6.25;

IntFac = 1;
[numSamples, numLines, numFrames] = size(phantom_IQ);
phantom_RF = zeros([numSamples*IntFac, numLines, numFrames]);

for fi = 1:numFrames
    phantom_RF(:,:,fi) = IQ2RF(phantom_IQ(:,:,fi),centerFreq, IntFac);
end

initialFocus = 61;
focalAmplitude = 6;
acqFrames = 200;
numberOfCycles=4;
ZFocal = zeros(1,acqFrames);
for i = 1:acqFrames
    ZFocal(i) = initialFocus + focalAmplitude*sin(2*pi*(i-1)*numberOfCycles/acqFrames);
end

ZFocal = ZFocal*4;
ZFocal = round(ZFocal);
sample1 = 212;
sample2 = 275;
element1 = 32;
element2 = 96;
samples=32;
%phantom_RF(:,:,:) = 0;
ROI = zeros(samples*2+1, element2-element1+1, acqFrames);
for i = 1:acqFrames
    
    %phantom_RF(ZFocal(i),:,i) = 1;
    sample1 = ZFocal(i)-samples;
    sample2 = ZFocal(i)+samples;
    
    
    ROI(:,:,i) = phantom_RF(sample1:sample2, element1:element2,i);
end
RFtimeSeries = squeeze(ROI(32,:,:));
figure;
plot(RFtimeSeries');

filename = 'sampleMovingROI.gif';
p1=figure;
minV = min(log(1+abs(hilbert(phantom_1_RF(:)))));
maxV = max(log(1+abs(hilbert(phantom_1_RF(:)))));
numFrames=200;
for i = 1:numFrames
    img = phantom_1_RF(:,:,i);
    %caxis([minV, maxV]);
    imagesc((abs(hilbert(img))));    
    colormap(gray);
    hold on
    line([32,96],[ZFocal(i), ZFocal(i)],  'Color', 'r');
    rectangle('Position', [32,ZFocal(i)-32,64,64]);
    drawnow;
    frame = getframe(p1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
%     if i == 1 
%        imwrite(imind,cm,filename,'gif', 'Loopcount',1, 'DelayTime',0); 
%     else 
%        imwrite(imind,cm,filename,'gif','WriteMode','append', 'DelayTime',0); 
%     end 
end

filename='sampleMovingROI_selectedROI.gif';
p2=figure;
minV = min((abs(hilbert(ROI(:)))));
maxV = max((abs(hilbert(ROI(:)))));
numFrames=200;
for i = 1:numFrames
    img = ROI(:,:,i);
    caxis([minV, maxV]);
    imagesc((abs(hilbert(img))));    
    colormap(gray);
    hold on
    %line([1,128],[ZFocal(i), ZFocal(i)],  'Color', 'r');
    drawnow;
    frame = getframe(p2);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    %if i == 1 
       %imwrite(imind,cm,filename,'gif', 'Loopcount',1, 'DelayTime',0); 
    %else 
       %imwrite(imind,cm,filename,'gif','WriteMode','append', 'DelayTime',0); 
    %end 
end