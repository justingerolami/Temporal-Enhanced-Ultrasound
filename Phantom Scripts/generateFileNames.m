%{
This function takes the scan type and phantom names and returns
the .mat file of that phantom's data.
%}

function [f1,f2,f3,f4,f5,f6,f7,f8,f9] = generateFileNames(scantype, phantomName1,phantomName2,phantomName3,phantomName4,phantomName5,phantomName6,phantomName7,phantomName8,phantomName9)
    f1 = strcat(strrep(phantomName1, ' ', '_'),'_',scantype,'.mat');
    f2 = strcat(strrep(phantomName2, ' ', '_'),'_',scantype,'.mat');
    f3 = strcat(strrep(phantomName3, ' ', '_'),'_',scantype,'.mat');
    f4 = strcat(strrep(phantomName4, ' ', '_'),'_',scantype,'.mat');
    f5 = strcat(strrep(phantomName5, ' ', '_'),'_',scantype,'.mat');
    f6 = strcat(strrep(phantomName6, ' ', '_'),'_',scantype,'.mat');
    f7 = strcat(strrep(phantomName7, ' ', '_'),'_',scantype,'.mat');
    f8 = strcat(strrep(phantomName8, ' ', '_'),'_',scantype,'.mat');
    f9 = strcat(strrep(phantomName9, ' ', '_'),'_',scantype,'.mat');
end