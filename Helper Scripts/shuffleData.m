function tempData = shuffleData(datain)
[m,n] = size(datain) ;
idx = randperm(m);
tempData = zeros(size(datain));

for i = 1:length(datain)
    tempData(i,:) = datain(idx(i),:);
end

shuffledData = tempData(:,:);
end