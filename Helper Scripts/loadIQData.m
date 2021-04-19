%This function takes a filename and loads the IQ data from it
%returns the IQ data, and optionally the I (real) part and Q(imaginary)
%part

%Last Modified 10/21/2019 - Justin Gerolami

function [phantom_IQ, phantom_I, phantom_Q] = loadIQData(filename)
    phantom = load(filename);
    phantom_struct = phantom.SWIOutput;
    
    structSize = size(phantom_struct(1).Data);
    numFrames = size(phantom_struct,2);

    phantom_IQ = zeros([structSize numFrames]);
    
    for fi = 1:numFrames
        phantom_IQ(:,:,fi) = phantom_struct(fi).Data;
    end
    
    phantom_I = real(phantom_IQ);
    phantom_Q = imag(phantom_IQ);
end