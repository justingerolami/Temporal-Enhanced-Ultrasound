function bmodeRFData(phantom, fNum)

figure;
subplot(1,2,1);
imagesc(abs(hilbert(phantom_0p5x_RF(:,:,fNum))));
colormap(gray);
title('Normal');

subplot(1,2,2);
imagesc(log(1+abs(hilbert(phantom_1x_RF(:,:,fNum)))));
colormap(gray);
title('Log');

end