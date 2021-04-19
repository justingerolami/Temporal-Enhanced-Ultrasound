%{
The main experiment script for my thesis.

This script will loop through all phantom property comparisons 
and perform k-fold CV (k=5) for a specified type of Teus/vitus.

Results are saved as a table
%}

rng(2);
mode={'0p5EdiffS', '1EdiffS', '2EdiffS', '23SdiffE', '32SdiffE', '60SdiffE'};
numFolds = 5;

data = cell(30,6);
headers = {'Mode', 'Fold', 'Acc', 'Sens', 'Spec','ConfMat'};

resultsTab = cell2table(data);
resultsTab.Properties.VariableNames = headers;

foldsToUse = nchoosek(1:numFolds,numFolds-1);

%type can be moving, fixed, dROI, fixed_dROI, sf_vitus, fixed_sf_vitus
type='sf_vitus_300F_1C';
for i = 1:length(mode)
    for j = 1:numFolds
        [acc, sens, spec, conf] = Tree_Folds(mode{i},foldsToUse(j,:), 6, type);
        resultsTab{j+numFolds*(i-1),:} = [mode(i), j, acc, sens, spec, conf];
    end
end

tab = resultsTab;
avgs=[];
count=1;
for i=1:numFolds:height(tab)
    av = mean(cell2mat(tab.Acc(i:i+numFolds-1)));
    st = std(cell2mat(tab.Acc(i:i+numFolds-1)));
    avgs(count,1)=av;
    avgs(count,2)=st;
    count=count+1;
end
