%{
This function will calculate the shear speed from the shearwave data
collected. This value can be used later to calculate youngs modulus.
%}

function speed = getSWESpeed(swefile)
save=false;
%clc; clear;
%load '1x_23u_SW_p1.mat'
% load 'e0p5x_s23um_center_0psi_SWE_50wv.mat'

load(swefile);
ImgData_matrix = IQData{2,1};
size(ImgData_matrix);

ImgData_matrix = squeeze(ImgData_matrix(:,:,1,:));

%figure; imagesc(abs(ImgData_matrix(:,:,1)));

active_area = sum(abs(ImgData_matrix),3); 
x_active = sum(active_area,2)>0;
xStart = find(x_active,1,'first');
xEnd = find(x_active,1,'last');
y_active = sum(active_area,1)>0;
yStart = find(y_active,1,'first');
yEnd = find(y_active,1,'last');

%segment out the SWI region
ImgData_matrixFull = ImgData_matrix;
ImgData_matrixFull_first = real(ImgData_matrixFull(:,:,1));

ImgData_matrix = ImgData_matrix(xStart:xEnd,yStart:yEnd,:);

%figure; imagesc(abs(ImgData_matrix(:,:,1)));

ImgDimension = size(ImgData_matrix);
axialLength = ImgDimension(1);
lateralLength = ImgDimension(2);
timeFrames = ImgDimension(3);


%1.2 directly use complex number calculation

c = 1540; %speed of  sound in tissue
fc = 6.25e6; % Hz

% aj - speckle tracking to measure the speed of wave propagation
for di = 2:timeFrames

    cpData = ImgData_matrix(:,:,di - 1);
    cData = ImgData_matrix(:,:,di);
    
    cproduct = cpData .* conj(cData);
    disp(:,:,di-1) =  c / (4 * pi * fc )* angle(cproduct);
 
end

%figure;
%imagesc(log(abs(eps+disp(:,:,15))));


%%%%%%%%%%%%%%%%%%%%%%%%%% use more 
% dispMean = squeeze(mean(disp(20:60,:,:)));
dispMean = squeeze(mean(disp(20:ImgDimension(1)-20,:,:)));
if save
    f1 = figure('visible', 'off');
    imagesc(dispMean(:,1:end)')
    colorbar
    saveas(f1, strcat('savedPlots/',swefile(1:end-4), '_dispMean.png'));
end
    % aj plot
% figure;
% n_plot = 5;
% for i=1:n_plot
%     subplot(n_plot,1,i);
%     plot(dispMean(:,4*i));
% end


%1.3 gaussian curve fitting
%automatically extract peaks


startFrame = 2;
steps = 1;
% endFrame = 20;

wave_profile = sum(abs(dispMean));
wave_profile_smoothed = smooth(wave_profile);
frames = 1:length(wave_profile);
%figure; plot(frames,wave_profile,frames,wave_profile_smoothed)

intensity_tresh = min(wave_profile_smoothed)+ 0.2*range(wave_profile_smoothed);
%hold on;
%plot(frames,intensity_tresh*ones(size(frames)));
%hold off;

[~,ind] = min(abs(wave_profile_smoothed-intensity_tresh));
endFrame = frames(ind)-1;
%%%%%%%%%%%%%%%%%%%%%%%%%%

swePositions = zeros(endFrame - startFrame + 1 ,1);

myX = [];
for i = startFrame:steps:endFrame

%%%%%%%%%%%%%%%%%%%%%%%%%% select only one side of the propagation plot
% halfLineValues = dispMean(1:100,i);
halfLineValues = dispMean(1: round(size(dispMean,1)/2) ,i);
% halfLineValues = dispMean(round(size(dispMean,1)/2) :end,i);


%plot(halfLineValues)

% Npoints = 100;
% for i = 1:Npoints
%     if(halfLineValues(i) <= 0)
%         halfLineValues(i) = 0;
%     end
% end


%%%%%%%%%%%%%%%%%%%%%%%%%% select only one side of the propagation plot
% x = (1:100)';
x = (1:length(halfLineValues))';
y = halfLineValues;

f = fit(x,y,'gauss3');
parameters = coeffvalues(f);
myX = [myX;parameters];
swePositions(i - startFrame + 1) = parameters(2);

% figure;
% plot(halfLineValues)
% hold on
% plot(f,x,y)
% 
% xlabel('Position','fontSize',28)
% ylabel('Amplitude (m)','fontSize',28)

end




%1.4 calculate the shear wave speed
% aj propagation of the peak
% figure
% plot(swePositions)

detectFreq = 6.25 * (1e6); %MHz
speedOfsound = 1540; %mm/s
spatialWV =  speedOfsound / detectFreq * 0.5; %%%%%%%%%%% this should be the lateral dimension of pixels

detectTime = 100 * (1e-6); %%%%%%%%%%% this should be 1/frame_rate


spatialPos = swePositions * spatialWV * 100 / 100;

nPoints = size(swePositions,1);

timeVector = ((1:1:nPoints) *  detectTime)';

%plot(timeVector,spatialPos)



% eliminating the outliers
ind_outlier = isoutlier(spatialPos,'movmedian',7, 'ThresholdFactor', 1);
%figure; plot(timeVector(~ind_outlier),spatialPos(~ind_outlier))
%title('after outlier removal')

timeVector(ind_outlier) = [];
spatialPos(ind_outlier) = [];

X = [ones(length(timeVector),1) timeVector];
b = X\spatialPos;

if save
    f2 = figure('visible', 'off');
    %f2=figure;
    yCalc2 = X*b;
    plot(timeVector,yCalc2,'--')
    xlabel('time (s)')
    ylabel('Position (m)')
    hold on
    plot(timeVector,spatialPos,'*')
    hold off
    set(gca,'fontSize',15)

    saveas(f2, strcat('savedPlots/',swefile(1:end-4), '_fit.png'));
end
%plot(spatialPos)

% Only needed for deleting points manually
%{

outlierIndex = [10];

timeVector(outlierIndex) = [];
spatialPos(outlierIndex) = [];

X = [ones(length(timeVector),1) timeVector];

b = X\spatialPos

figure;
yCalc2 = X*b;
plot(timeVector,yCalc2,'--')
xlabel('time (s)')
ylabel('Position (m)')
hold on
plot(timeVector,spatialPos,'*')
hold off
set(gca,'fontSize',15)


% %%
% % save results
% eval(strcat('e',elasticity,'_s',particleSize,'_',position,'_0psi_SWE_',location ,'.','startFrame = startFrame;'));
% eval(strcat('e',elasticity,'_s',particleSize,'_',position,'_0psi_SWE_',location ,'.','endFrame = endFrame;'));
% 
% eval(strcat('e',elasticity,'_s',particleSize,'_',position,'_0psi_SWE_',location ,'.','b= b;'));
% 
% eval(strcat('e',elasticity,'_s',particleSize,'_',position,'_0psi_SWE_',location ,'.','timeVector = timeVector;'));
% eval(strcat('e',elasticity,'_s',particleSize,'_',position,'_0psi_SWE_',location ,'.','spatialPos= spatialPos;'));
% 
% filename = strcat('e',elasticity,'_s',particleSize,'_',position,'_0psi_SWE_',location);
% 
% fileToSave = 'C:\Users\sli\Desktop\Data\2018April06_elasticity phantoms\pooledResults_swe';
% 
% save(fileToSave,filename,'-append')
%}
speed = b(2);
close all;
end


