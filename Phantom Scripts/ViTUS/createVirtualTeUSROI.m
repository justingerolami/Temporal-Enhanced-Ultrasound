%{
This function creates the virtual roi for ViTUS. The returned value,
movingROI, is a 3d mat with the 3rd dimension representing the frames of
data.

If the 3rd dimension is i, then vitus is created over each of the captured
frames. If it is 1, then SF_vitus is created using on the first frame.
%}

function movingROI = createVirtualTeUSROI(phantom_RF, numSamplesFromCenter, element1, element2,ZFocal)

acqFrames = length(ZFocal);
movingROI = zeros(2*numSamplesFromCenter+1, element2-element1+1, acqFrames);

for i = 1:acqFrames
    sample1 = ZFocal(i)-numSamplesFromCenter;
    sample2 = ZFocal(i)+numSamplesFromCenter;
    
    %change the 3rd dimension of phantom_RF to 1 to use single-frame ViTUS
    movingROI(:,:,i) = phantom_RF(sample1:sample2, element1:element2,1);
end

end