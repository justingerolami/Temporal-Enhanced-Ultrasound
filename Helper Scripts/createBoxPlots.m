function createBoxPlots(ROI_0p5x, ROI_1x, ROI_2x, ROI_1x_60u, freqPeak)

if length(freqPeak) == 1
    usedTitle = strcat('peak at', {' '}, num2str(freqPeak), 'Hz');
else
    usedTitle = "largest peaks of each phantom";
end

ROI_0p5x = ROI_0p5x(:);
ROI_1x = ROI_1x(:);
ROI_2x = ROI_2x(:);
ROI_1x_60u = ROI_1x_60u(:);

figure;
boxplot([ROI_0p5x, ROI_1x, ROI_2x, ROI_1x_60u]);
title(usedTitle);
end