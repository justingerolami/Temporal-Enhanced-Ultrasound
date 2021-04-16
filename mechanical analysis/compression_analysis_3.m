%{
This function calculates youngs modulus from the mechanical data. 
%}

function youngs = compression_analysis_3(filename)

% filename = '2x_60u_3.csv';

file = readtable(filename);

%remove the surface looking part and recovering since we
%only care about the slope of the pressure applied

file(strcmp(file.SetName,'Surface Finding'),:) = [];
file(strcmp(file.Cycle, '1-Recover'),:) = [];

diameterOfIndenter = 7 * 10^-3; %m
force = file.Force_N;
displacement = file.Displacement_mm * 10^-3; %m

% find the lenght (when the tip of the instrument touchs the surface)
force_threshold = 0.02*max(force);
ind_touch = find( force>force_threshold, 1);
P_ratio = 0.5;

% the lenght to be used for slope estimation (more interested on initial parts)
fit_length = 60;
fit_length = min( fit_length, length(force)-ind_touch );

y = force( ind_touch:ind_touch+fit_length );
x = displacement( ind_touch:ind_touch+fit_length );
%%% considering the end part
% ind_start = length(force)-fit_length;
% y = force( ind_start:end );
% x = displacement( ind_start:end );
P = polyfit(x,y,1);

youngs = (1-P_ratio^2)/(diameterOfIndenter) * P(1) * 1e-3; % [kPa]

% Plot stress strain curve
% figure;
% % scatter(x,y,25,'b','*') 
%plot(displacement,force)
% hold on;
% plot(x,P(1)*x+P(2),'r--','LineWidth',2);
%legend({'0p5x 23u', '0p5x 32u', '0p5x 60u', '1x 23u', '1x 32u', '1x 60u', '2x 23u', '2x 32u', '2x 60u'}, 'Location', 'northwest');

%xlabel('Displacement [mm]');
%ylabel('Force [N]');
%hold all;
end