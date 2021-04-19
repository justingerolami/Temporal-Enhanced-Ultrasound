%Script to display bmode image from the real part of IQ data at frame n
%Display bmode image of 1 frame

function bmodeIQData(phantom, fNum)
figure;
subplot(1,2,1);
imagesc(abs(phantom(:,:,fNum)));
colormap(gray);
title('Normal');

subplot(1,2,2);
imagesc(log(1+abs(phantom_1x_I(:,:,fNum))));
colormap(gray);
title('Log');
end