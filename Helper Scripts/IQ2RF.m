function out=IQ2RF(iq,f_rf, IntFac)

I= real(iq);
Q = imag(iq);

fs= 4*f_rf;
%IntFac = 4;
fs_int = fs*IntFac;

% Initialize
BmodeNumSamples = size(Q,1);
BmodeNumLines = size(Q,2);
IdataInt = zeros(BmodeNumSamples*IntFac, BmodeNumLines);
QdataInt = zeros(BmodeNumSamples*IntFac, BmodeNumLines);
out = zeros(BmodeNumSamples*IntFac, BmodeNumLines);
t = [0:1/fs_int:((BmodeNumSamples*IntFac)-1)/fs_int];

% Interpolate I/Q and reconstruct RF
for i=1:BmodeNumLines
    IdataInt(:,i) = interp(I(:,i), IntFac);
    QdataInt(:,i) = interp(Q(:,i), IntFac);
    out(:,i) =  real(sqrt(IdataInt(:,i).^2 + QdataInt(:,i).^2) .* sin(2*pi*f_rf*t' + atan2(QdataInt(:,i),IdataInt(:,i))));
end