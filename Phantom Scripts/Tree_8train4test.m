%{
This is an older script that does not use folds or CV. Instead, it uses
8 planes for training and 4 planes for testing. 
%}

function [acc, sens, spec, conf_i] = Tree_8train4test(mode,trainFold, testFold)

%clear all;
rng(2);
%mode = 'all';
%mode = '0p5EdiffS';
%mode='2EdiffS';

phantomName1 = '0p5x 23u';
phantomName2 = '0p5x 32u';
phantomName3 = '0p5x 60u';
phantomName4 = '1x 23u';
phantomName5 = '1x 32u';
phantomName6 = '1x 60u';
phantomName7 = '23u 2x';
phantomName8= '32u 2x';
phantomName9= '60u 2x';

%load(trainFold);
%load(testFold);
load('train_thesis_1C200F.mat');
load('test_thesis_1C200F.mat');

%load('Jan17_RF_8train_allpeakfeatures.mat');
%load('Jan17_RF_4test_allpeakfeatures.mat');

phantomNames = {phantomName1, phantomName2, phantomName3, phantomName4, phantomName5, phantomName6 ...
    phantomName7, phantomName8, phantomName9};


if strcmp(mode, 'all')
    train_classes = [p1c;p2c; p3c; p4c; p5c; p6c;p7c;p8c;p9c];
    train_data = [ p1; p2; p3; p4;p5;p6;p7;p8;p9];
    
    test_classes = [test_p1c;test_p2c; test_p3c; test_p4c;test_p5c; test_p6c;test_p7c;test_p8c;test_p9c];
    test_data = [ test_p1; test_p2; test_p3; test_p4;test_p5;test_p6;test_p7;test_p8;test_p9];
   
    conf=zeros(9);
    
elseif strcmp(mode, '0p5EdiffS')
    train_classes = [p1c;p2c;p3c];
    train_data = [ p1; p2; p3];
    
    test_classes = [test_p1c; test_p2c; test_p3c];
    test_data = [ test_p1; test_p2; test_p3];

    phantomNames = {phantomName1, phantomName2, phantomName3 };
    conf=zeros(3);

elseif strcmp(mode, '1EdiffS')
    train_classes = [p4c;p5c;p6c];
    train_data = [ p4; p5; p6];
    
    test_classes = [test_p4c; test_p5c; test_p6c];
    test_data = [ test_p4; test_p5; test_p6];

    phantomNames = {phantomName4, phantomName5, phantomName6 };
    conf=zeros(3);
    
elseif strcmp(mode, '2EdiffS')
    train_classes = [p7c;p8c;p9c];
    train_data = [ p7; p8; p9];
    
    test_classes = [test_p7c; test_p8c; test_p9c];
    test_data = [ test_p7; test_p8; test_p9];
    
    phantomNames = {phantomName7, phantomName8, phantomName9};
    conf=zeros(3);
    
elseif strcmp(mode, '23SdiffE') 
    train_classes = [p1c;p4c;p7c];
    train_data = [ p1; p4; p7];
    
    test_classes = [test_p1c; test_p4c; test_p7c];
    test_data = [ test_p1; test_p4; test_p7];
 
    phantomNames = {phantomName1, phantomName4, phantomName7 };
    conf=zeros(3);
    
elseif strcmp(mode, '32SdiffE') 
    train_classes = [p2c;p5c;p8c];
    train_data = [ p2; p5; p8];
    
    test_classes = [test_p2c; test_p5c; test_p8c];
    test_data = [ test_p2; test_p5; test_p8];
    
    phantomNames = {phantomName2, phantomName5, phantomName8 };
    conf=zeros(3);
    
elseif strcmp(mode, '60SdiffE') 
    train_classes = [p3c;p6c;p9c];
    train_data = [ p3; p6; p9];
    
    test_classes = [test_p3c; test_p6c; test_p9c];
    test_data = [ test_p3; test_p6; test_p9];
    
    phantomNames = {phantomName3, phantomName6, phantomName9};
    conf=zeros(3);

elseif strcmp(mode,'diffEdiffS1')
    train_classes = [p1c;p5c;p9c];
    train_data = [ p1; p5; p9];
    
    test_classes = [test_p1c; test_p5c; test_p9c];
    test_data = [ test_p1; test_p5; test_p9];
    
    phantomNames = {phantomName1, phantomName5, phantomName9};
    conf=zeros(3);

elseif strcmp(mode, 'diffEdiffS2')
    train_classes = [p3c;p5c;p7c];
    train_data = [ p3; p5; p7];
    
    test_classes = [test_p3c; test_p5c; test_p7c];
    test_data = [ test_p3; test_p5; test_p7];
    
    phantomNames = {phantomName3, phantomName5, phantomName7};
    conf=zeros(3);

elseif strcmp(mode, 'groupSameE')
    %trying to separate based on elasticity, should NOT work
    class1_data = [p1;p2;p3];
    class2_data = [p4;p5;p6];
    class3_data = [p7;p8;p9];
    class1_classes = 0*ones(length(class1_data),1);
    class2_classes = 1*ones(length(class2_data),1);
    class3_classes = 2*ones(length(class3_data),1);
    
    train_data = [class1_data; class2_data; class3_data];
    train_classes = [class1_classes; class2_classes; class3_classes];
    
    test_class1_data = [test_p1;test_p2;test_p3];
    test_class2_data = [test_p4;test_p5;test_p6];
    test_class3_data = [test_p7;test_p8;test_p9];
    test_class1_classes = 0*ones(length(test_class1_data),1);
    test_class2_classes = 1*ones(length(test_class2_data),1);
    test_class3_classes = 2*ones(length(test_class3_data),1);
    
    test_data = [test_class1_data; test_class2_data; test_class3_data];
    test_classes = [test_class1_classes; test_class2_classes; test_class3_classes];
    
    phantomNames = ["0p5x", "1x", "2x"];
    conf=zeros(3);
    
elseif strcmp(mode, 'groupSameS')
    %trying to separate based on scattering, should work
    class1_data = [p1;p4;p7];
    class2_data = [p2;p5;p8];
    class3_data = [p3;p6;p9];
    class1_classes = 0*ones(length(class1_data),1);
    class2_classes = 1*ones(length(class2_data),1);
    class3_classes = 2*ones(length(class3_data),1);
    
    train_data = [class1_data; class2_data; class3_data];
    train_classes = [class1_classes; class2_classes; class3_classes];
    
    test_class1_data = [test_p1;test_p4;test_p7];
    test_class2_data = [test_p2;test_p5;test_p8];
    test_class3_data = [test_p3;test_p6;test_p9];
    test_class1_classes = 0*ones(length(test_class1_data),1);
    test_class2_classes = 1*ones(length(test_class2_data),1);
    test_class3_classes = 2*ones(length(test_class3_data),1);
    
    test_data = [test_class1_data; test_class2_data; test_class3_data];
    test_classes = [test_class1_classes; test_class2_classes; test_class3_classes];
    
    phantomNames = ["23u", "32u", "60u"];
    conf=zeros(3);
end


%Shuffle the data randomly
trainDataWClasses = [train_classes train_data];
testDataWClasses = [test_classes test_data];
trainData = shuffleData(trainDataWClasses);
testData = shuffleData(testDataWClasses);

Xtr = trainData(:,2:end);
Ytr = trainData(:,1);

Xtest = testData(:,2:end);
Ytest = testData(:,1);

mdl = fitctree(Xtr, Ytr);
Ypred = predict(mdl, Xtest);
conf_i = confusionmat(Ytest, Ypred);
acc = 0;
for j = 1:length(conf_i)
    acc = acc+conf_i(j,j);
end
acc = acc/length(Xtest)*100;

%class 1
tp1 = conf_i(1,1);
fn1 = sum(conf_i(1,2:end));
fp1 = sum(conf_i(2:end,1));
tn1 = conf_i(2,2)+conf_i(3,3);
sensitivity1 = tp1/(tp1+fn1)*100;
specificity1 = tn1/(tn1+fp1)*100;

%class 2
tp2 = conf_i(2,2);
fn2 = conf_i(2,1)+conf_i(2,3);
fp2 = conf_i(1,2)+conf_i(1,3);
tn2 = conf_i(1,1)+conf_i(3,3);
sensitivity2 = tp2/(tp2+fn2)*100;
specificity2 = tn2/(tn2+fp2)*100;

%class 3
tp3 = conf_i(3,3);
fn3 = conf_i(3,1)+conf_i(3,2);
fp3 = conf_i(1,3)+conf_i(1,2);
tn3 = conf_i(1,1)+conf_i(2,2);
sensitivity3 = tp3/(tp3+fn3)*100;
specificity3 = tn3/(tn3+fp3)*100;

spec = (specificity1+specificity2+specificity3)/3;
sens = (sensitivity1+sensitivity2+sensitivity3)/3;
%sprintf("AVG Acc: %f", round(mean(acc),2))
%sprintf("STD Acc: %f", round(std(acc),2))
%sprintf("AVG Sens: %f", round(sens,2))
%sprintf("AVG Spec: %f", round(spec,2))


figure;cm1=confusionchart(conf_i, phantomNames, 'OffDiagonalColor', [0 0.4471 0.7412]);
%sortClasses(cm1,'cluster')
%title('Confusion Matrix for Final Fold');
%end