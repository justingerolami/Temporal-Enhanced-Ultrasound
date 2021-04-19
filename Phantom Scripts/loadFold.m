%{
This function loads the folds of data for each of the specified types.
Loaded data contains 9 X and y for each phantom. 
%}

function [p1,p2,p3,p4,p5,p6,p7,p8,p9, ...
    p1c,p2c,p3c,p4c,p5c,p6c,p7c,p8c,p9c] = loadFold(foldnum,type)

if strcmp(type,'moving')
    load(strcat('fold_', num2str(foldnum), '.mat'));
elseif strcmp(type,'fixed')
    load(strcat('fold_', num2str(foldnum), '_fixed.mat'));
elseif strcmp(type,'dROI')
    load(strcat('dROI_vitus_fold_', num2str(foldnum),'.mat'));
elseif strcmp(type,'fixed_dROI')
    load(strcat('fixed_dROI_vitus_fold_', num2str(foldnum),'.mat'));
elseif strcmp(type,'sf_vitus_200F_4C')
    load(strcat('sf_vitus_200F_4C_fold_', num2str(foldnum),'.mat'));
elseif strcmp(type,'sf_vitus_200F_1C')
    load(strcat('sf_vitus_200F_1C_fold_', num2str(foldnum),'.mat'));
elseif strcmp(type,'sf_vitus_300F_1C')
    load(strcat('sf_vitus_300F_1C_fold_', num2str(foldnum),'.mat'));
else
    disp("ERROR LOADING FOLDS"); 
end
end