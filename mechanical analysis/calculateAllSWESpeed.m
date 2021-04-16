%{
This function calculates youngs modulus for all phantoms using the
shearwave elastography data. 
%}

phantomName1 = '0p5x 23u';
phantomName2 = '0p5x 32u';
phantomName3 = '0p5x 60u';
phantomName4 = '1x 23u';
phantomName5 = '1x 32u';
phantomName6 = '1x 60u';
phantomName7 = '23u 2x';
phantomName8= '32u 2x';
phantomName9= '60u 2x';

phantomNames = {phantomName1, phantomName2, phantomName3, phantomName4, phantomName5, phantomName6 ...
    phantomName7, phantomName8, phantomName9};
type = 'SW_p';


phantom_1_SW = [];
phantom_2_SW = [];
phantom_3_SW = [];
phantom_4_SW = [];
phantom_5_SW = [];
phantom_6_SW = [];
phantom_7_SW = [];
phantom_8_SW = [];
phantom_9_SW = [];

    
for i=1:12
    scannum = strcat(type, num2str((i)));
    [phantom_1_file,phantom_2_file,phantom_3_file,phantom_4_file, ...
         phantom_5_file,phantom_6_file,phantom_7_file,phantom_8_file, ...
           phantom_9_file] = generateFileNames(scannum,phantomName1,...
              phantomName2,phantomName3,phantomName4,phantomName5,...
                 phantomName6,phantomName7,phantomName8,phantomName9);
    
    phantom_1_SW = [phantom_1_SW; getSWESpeed(phantom_1_file)];
    phantom_2_SW = [phantom_2_SW; getSWESpeed(phantom_2_file)];
    phantom_3_SW = [phantom_3_SW; getSWESpeed(phantom_3_file)];
    phantom_4_SW = [phantom_4_SW; getSWESpeed(phantom_4_file)];
    phantom_5_SW = [phantom_5_SW; getSWESpeed(phantom_5_file)];
    phantom_6_SW = [phantom_6_SW; getSWESpeed(phantom_6_file)];
    phantom_7_SW = [phantom_7_SW; getSWESpeed(phantom_7_file)];
    phantom_8_SW = [phantom_8_SW; getSWESpeed(phantom_8_file)];
    phantom_9_SW = [phantom_9_SW; getSWESpeed(phantom_9_file)];

end

P_ratio = 0.5;
phantom_1 = phantom_1_SW.^2 * 2 * (1+P_ratio);
phantom_2 = phantom_2_SW.^2 * 2 * (1+P_ratio);
phantom_3 = phantom_3_SW.^2 * 2 * (1+P_ratio);
phantom_4 = phantom_4_SW.^2 * 2 * (1+P_ratio);
phantom_5 = phantom_5_SW.^2 * 2 * (1+P_ratio);
phantom_6 = phantom_6_SW.^2 * 2 * (1+P_ratio);
phantom_7 = phantom_7_SW.^2 * 2 * (1+P_ratio);
phantom_8 = phantom_8_SW.^2 * 2 * (1+P_ratio);
phantom_9 = phantom_9_SW.^2 * 2 * (1+P_ratio);


sprintf("0p5x 23u: mean=%.2f, std=%.2f", [mean(phantom_1), std(phantom_1)])
sprintf("0p5x 32u: mean=%.2f, std=%.2f", [mean(phantom_2), std(phantom_2)])
sprintf("0p5x 60u: mean=%.2f, std=%.2f", [mean(phantom_3), std(phantom_3)])
sprintf("0p5x mean=%.2f", mean([phantom_1;phantom_2;phantom_3]))

sprintf("1x 23u: mean=%.2f, std=%.2f", [mean(phantom_4), std(phantom_4)])
sprintf("1x 32u: mean=%.2f, std=%.2f", [mean(phantom_5), std(phantom_5)])
sprintf("1x 60u: mean=%.2f, std=%.2f", [mean(phantom_6), std(phantom_6)])
sprintf("1x mean=%.2f", mean(([phantom_4;phantom_5;phantom_6])))

sprintf("2x 23u: mean=%.2f, std=%.2f", [mean(phantom_7), std(phantom_7)])
sprintf("2x 32u: mean=%.2f, std=%.2f", [mean(phantom_8), std(phantom_8)])
sprintf("2x 60u: mean=%.2f, std=%.2f", [mean(phantom_9), std(phantom_9)])
sprintf("2x mean=%.2f", mean(([phantom_7;phantom_8;phantom_9])))

f = figure; boxplot([phantom_1, phantom_2, phantom_3, ...
    phantom_4, phantom_5, phantom_6, ...
    phantom_7, phantom_8, phantom_9], 'Labels', ...
    phantomNames)
title('SWE Youngs Modulus');
xtickangle(45)
%saveas(f, 'savedPlots/SWE.png');