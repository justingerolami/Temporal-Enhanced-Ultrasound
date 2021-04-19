function output = detrending(phantom)

[numSamples,numLines,numFrames] = size(phantom);
detrendedPhantom = phantom;
meanVal = mean(phantom,3);
%imagesc(meanVal);
meanVal3d = repmat(meanVal, [1,1,numFrames]);
detrendedPhantom = phantom - meanVal3d;

%linear detrending
% for i = 1:numSamples
%     for j = 1:numLines
%         detrendedPhantom(i,j,:) = detrend(squeeze(phantom(i,j,:)),1);
%     end
% end
output = detrendedPhantom;

% std3d = std(phantom,[],3);
% std3d = repmat(std3d, [1,1,numFrames]);
% detrendedPhantom = detrendedPhantom./std3d;
% output=detrendedPhantom;

% 
% hammingwindow = hamming(200,'periodic');
% hammingwindow_r = permute(hammingwindow, [3,2,1]);
% 
% ham_rep = repmat(hammingwindow_r, [numSamples, numLines]);
% 
% hamming_phantom = detrendedPhantom .* ham_rep;
end