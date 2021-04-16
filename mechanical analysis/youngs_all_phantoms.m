%{
This script calculates youngs modulus from the mechanical testing data for
all phantoms. 
%}

%0p5x elasticity
e0p5x_23u_1 = compression_analysis_3('0p5x_23u_1.csv');
e0p5x_23u_2 = compression_analysis_3('0p5x_23u_2.csv');
e0p5x_23u_3 = compression_analysis_3('0p5x_23u_3.csv');

e0p5x_32u_1 = compression_analysis_3('0p5x_32u_1.csv');
e0p5x_32u_2 = compression_analysis_3('0p5x_32u_2.csv');
e0p5x_32u_3 = compression_analysis_3('0p5x_32u_3.csv');

%i think this is the one that broke
e0p5x_60u_1 = compression_analysis_3('0p5x_60u_1.csv');
e0p5x_60u_2 = compression_analysis_3('0p5x_60u_2.csv');
e0p5x_60u_3 = compression_analysis_3('0p5x_60u_3.csv');


%1x elasticity
e1x_23u_1 = compression_analysis_3('1x_23u_1.csv');
e1x_23u_2 = compression_analysis_3('1x_23u_2.csv');
e1x_23u_3 = compression_analysis_3('1x_23u_3.csv');


e1x_32u_1 = compression_analysis_3('1x_32u_1.csv');
e1x_32u_2 = compression_analysis_3('1x_32u_2.csv');
e1x_32u_3 = compression_analysis_3('1x_32u_3.csv');

e1x_60u_1 = compression_analysis_3('1x_60u_1.csv');
e1x_60u_2 = compression_analysis_3('1x_60u_2.csv');
e1x_60u_3 = compression_analysis_3('1x_60u_3.csv');


%2x elasticity
e2x_23u_1 = compression_analysis_3('2x_23u_1.csv');
e2x_23u_2 = compression_analysis_3('2x_23u_2.csv');
e2x_23u_3 = compression_analysis_3('2x_23u_3.csv');

e2x_32u_1 = compression_analysis_3('2x_32u_1.csv');
e2x_32u_2 = compression_analysis_3('2x_32u_2.csv');
e2x_32u_3 = compression_analysis_3('2x_32u_3.csv');

e2x_60u_1 = compression_analysis_3('2x_60u_1.csv');
e2x_60u_2 = compression_analysis_3('2x_60u_2.csv');
e2x_60u_3 = compression_analysis_3('2x_60u_3.csv');


e0p5x_23u = [e0p5x_23u_1; e0p5x_23u_2; e0p5x_23u_3];
e0p5x_32u = [e0p5x_32u_1; e0p5x_32u_2; e0p5x_32u_3];
e0p5x_60u = [e0p5x_60u_1; e0p5x_60u_2; e0p5x_60u_3];
e1x_23u = [e1x_23u_1; e1x_23u_2; e1x_23u_3];
e1x_32u = [e1x_32u_1; e1x_32u_2; e1x_32u_3];
e1x_60u = [e1x_60u_1; e1x_60u_2; e1x_60u_3];
e2x_23u = [e2x_23u_1; e2x_23u_2; e2x_23u_3];
e2x_32u = [e2x_32u_1; e2x_32u_2; e2x_32u_3];
e2x_60u = [e2x_60u_1; e2x_60u_2; e2x_60u_3];

f = figure; boxplot([e0p5x_23u, e0p5x_32u, e0p5x_60u, ...
    e1x_23u, e1x_32u, e1x_60u, ...
    e2x_23u, e2x_32u, e2x_60u], 'Labels', ...
    {'0p5x 23u', '0p5x 32u', '0p5x 60u', ...
    '1x 23u', '1x 32u', '1x 60u', ...
    '2x 23u', '2x 32u', '2x 60u'})
xtickangle(45)
xlabel('Phantoms');
ylabel("Young's moduli [kPa]");
title('Mechanical Testing Youngs Modulus');
%saveas(f,'savedPlots/mechanical.png');

sprintf("0p5x 23u: mean=%.2f, std=%.2f", [mean(e0p5x_23u), std(e0p5x_23u)])
sprintf("0p5x 32u: mean=%.2f, std=%.2f", [mean(e0p5x_32u), std(e0p5x_32u)])
sprintf("0p5x 60u: mean=%.2f, std=%.2f", [mean(e0p5x_60u), std(e0p5x_60u)])
sprintf("0p5x mean=%.2f", mean(([e0p5x_23u; e0p5x_32u; e0p5x_60u])))
sprintf("0p5x std=%.2f", std([e0p5x_23u; e0p5x_32u; e0p5x_60u]))


sprintf("1x 23u: mean=%.2f, std=%.2f", [mean(e1x_23u), std(e1x_23u)])
sprintf("1x 32u: mean=%.2f, std=%.2f", [mean(e1x_32u), std(e1x_32u)])
sprintf("1x 60u: mean=%.2f, std=%.2f", [mean(e1x_60u), std(e1x_60u)])
sprintf("1x mean=%.2f", mean(([e1x_23u; e1x_32u; e1x_60u])))
sprintf("1x std=%.2f", std(([e1x_23u; e1x_32u; e1x_60u])))

sprintf("2x 23u: mean=%.2f, std=%.2f", [mean(e2x_23u), std(e2x_23u)])
sprintf("2x 32u: mean=%.2f, std=%.2f", [mean(e2x_32u), std(e2x_32u)])
sprintf("2x 60u: mean=%.2f, std=%.2f", [mean(e2x_60u), std(e2x_60u)])
sprintf("2x mean=%.2f", mean(([e2x_23u; e2x_32u; e2x_60u])))
sprintf("2x std=%.2f", std(([e2x_23u; e2x_32u; e2x_60u])))
