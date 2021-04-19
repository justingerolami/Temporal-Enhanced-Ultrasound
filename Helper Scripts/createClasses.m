function [class,classes] = createClasses(ROI, classNum)

[numSamples, numLines, numFeatures] = size(ROI);
class = reshape(ROI, [numSamples*numLines, numFeatures]);
classes = classNum * ones(length(class),1);

end