%{
This is a quick script to generate GIFs of all 4 Teus/Vitus techniques
used in my thesis. 
%}

%ROI location
sample1 = 215;
sample2 = 281;
element1 = 32;
element2 = 96;

%Focal movement settings
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

%%
%TeuS Fixed FP
phantom = loadIQAndConvertToRF("0p5x_32u_fixed_p1.mat");

p1=figure;
minV = min(log(1+abs(hilbert(phantom(:)))));
maxV = max(log(1+abs(hilbert(phantom(:)))));
numFrames=200;

filename = 'thesis_teus_fixedfp.gif';
img = phantom(:,:,1);
imagesc(log(1+abs(hilbert(img))));
yticklabels(yticks/4*.246)
yticklabels(round(yticks/4*.246))
ylabel('Depth (mm)');
hold on
for i = 1:numFrames
    img = phantom(:,:,i);
    imagesc(log(1+abs(hilbert(img))));
	caxis([minV, maxV]);
    %colorbar
    title(strcat("US Frame",{' '}, num2str(i)))

    colormap(gray);
    hold on
    line([32,96],[ZFocal(1), ZFocal(1)],  'Color', 'r');
    %rectangle('Position', [32,215,64,66]);
    rectangle('Position', [32,ZFocal(1)-32,64,64]);
    drawnow;
    frame = getframe(p1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);

    
    if i == 1 
       imwrite(imind,cm,filename,'gif', 'Loopcount',4, 'DelayTime',0); 
    else 
       imwrite(imind,cm,filename,'gif','WriteMode','append', 'DelayTime',0); 
    end
    
end
%%
%TeUS Moving FP
p1=figure;
minV = min(log(1+abs(hilbert(phantom(:)))));
maxV = max(log(1+abs(hilbert(phantom(:)))));
numFrames=200;

filename = 'thesis_teus_movingfp.gif';
img = phantom(:,:,1);
imagesc(log(1+abs(hilbert(img))));
yticklabels(yticks/4*.246)
yticklabels(round(yticks/4*.246))
ylabel('Depth (mm)');
hold on
for i = 1:numFrames
    img = phantom(:,:,i);
    imagesc(log(1+abs(hilbert(img))));
	caxis([minV, maxV]);
    title(strcat("US Frame",{' '}, num2str(i)))
    %colorbar
    colormap(gray);
    hold on
    line([32,96],[ZFocal(i), ZFocal(i)],  'Color', 'r');
    %rectangle('Position', [32,215,64,66]);
    rectangle('Position', [32,ZFocal(1)-32,64,64]);
    drawnow;
    frame = getframe(p1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);

    
    if i == 1 
       imwrite(imind,cm,filename,'gif', 'Loopcount',4, 'DelayTime',0); 
    else 
       imwrite(imind,cm,filename,'gif','WriteMode','append', 'DelayTime',0); 
    end
    
end

%%
%ViTUS Dynamic ROI (moving FP)
p1=figure;
minV = min(log(1+abs(hilbert(phantom(:)))));
maxV = max(log(1+abs(hilbert(phantom(:)))));
numFrames=200;

filename = 'thesis_vitus_dynamicroi.gif';
img = phantom(:,:,1);
imagesc(log(1+abs(hilbert(img))));
yticklabels(yticks/4*.246)
yticklabels(round(yticks/4*.246))
ylabel('Depth (mm)');
hold on
for i = 1:numFrames
    img = phantom(:,:,i);
    imagesc(log(1+abs(hilbert(img))));
	caxis([minV, maxV]);
    title(strcat("US Frame",{' '}, num2str(i)))
    %colorbar
    colormap(gray);
    hold on
    line([32,96],[ZFocal(i), ZFocal(i)],  'Color', 'r');
    %rectangle('Position', [32,215,64,66]);
    rectangle('Position', [32,ZFocal(i)-32,64,64]);
    drawnow;
    frame = getframe(p1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);

    
    if i == 1 
       imwrite(imind,cm,filename,'gif', 'Loopcount',4, 'DelayTime',0); 
    else 
       imwrite(imind,cm,filename,'gif','WriteMode','append', 'DelayTime',0); 
    end
    
end

%%
%ViTUS single frame US
p1=figure;
minV = min(log(1+abs(hilbert(phantom(:)))));
maxV = max(log(1+abs(hilbert(phantom(:)))));
numFrames=200;

filename = 'thesis_vitus_singleframe.gif';
img = phantom(:,:,1);
imagesc(log(1+abs(hilbert(img))));
yticklabels(yticks/4*.246)
yticklabels(round(yticks/4*.246))
ylabel('Depth (mm)');
hold on
for i = 1:numFrames
    img = phantom(:,:,1);
    imagesc(log(1+abs(hilbert(img))));
	caxis([minV, maxV]);
    %colorbar
    title(strcat("US Frame",{' '}, num2str(1)))

    colormap(gray);
    hold on
    line([32,96],[ZFocal(1), ZFocal(1)],  'Color', 'r');
    %rectangle('Position', [32,215,64,66]);
    rectangle('Position', [32,ZFocal(i)-32,64,64]);
    drawnow;
    frame = getframe(p1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);

    
    if i == 1 
       imwrite(imind,cm,filename,'gif', 'Loopcount',4, 'DelayTime',0); 
    else 
       imwrite(imind,cm,filename,'gif','WriteMode','append', 'DelayTime',0); 
    end
    
end

    
    
