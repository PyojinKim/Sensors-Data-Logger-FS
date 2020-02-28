clc;
close all;
clear variables; %clear classes;
rand('state',0); % rand('state',sum(100*clock));
dbstop if error;

addpath('devkit_KITTI_GPS');


%% 1) read RoNIN and Google FLP data


numDatasetList = 14;
datasetGoogleFLPResult = cell(1,numDatasetList);
for k = 1:numDatasetList
    
    % extract RoNIN data
    expCase = k;
    setupParams_alignment_Prof_Yasu;
    roninResult = extractRoninOnlyData(datasetDirectory, roninInterval, roninYawRotation);
    
    
    % detect and remove RoNIN stationary motion
    speed = 0.1;             % m/s
    duration = 5.0;          % sec
    roninResult = detectStationaryMotion(roninResult, speed, duration);
    roninResult = removeStationaryMotion(roninResult);
    roninResult = roninResult(validRoninIndex);
    
    
    % separate RoNIN moving trajectory part
    movement = 4.0;        % m
    displacement = 3.5;     % m
    movingTrajectoryIndex = seperateRoninMovingTrajectory(roninResult, movement, displacement);
    
    
    % separate Google FLP moving trajectory part
    GoogleFLPResult = [];
    for m = 1:size(movingTrajectoryIndex,2)
        roninMovingPart = roninResult(movingTrajectoryIndex{m});
        roninMovingFLPLocation = [roninMovingPart(:).FLPLocation];
        GoogleFLPResult = [GoogleFLPResult, roninMovingFLPLocation];
    end
    
    
    % save Google FLP results
    datasetGoogleFLPResult{k} = GoogleFLPResult;
end


% convert lat/lon coordinates (deg) to mercator coordinates (m)
scale = latToScale(datasetGoogleFLPResult{1}(1,1));
latitude = datasetGoogleFLPResult{1}(1,1);
longitude = datasetGoogleFLPResult{1}(2,1);
[X_origin,Y_origin] = latlonToMercator(latitude, longitude, scale);

datasetGoogleFLPMeterResult = cell(1,numDatasetList);
for k = 1:numDatasetList
    latitude = datasetGoogleFLPResult{k}(1,:);
    longitude = datasetGoogleFLPResult{k}(2,:);
    [X,Y] = latlonToMercator(latitude, longitude, scale);
    
    X = X - X_origin;
    Y = Y - Y_origin;
    datasetGoogleFLPMeterResult{k} = [X;Y];
end


% plot multiple Google FLP results on Google Map
distinguishableColors = distinguishable_colors(numDatasetList);
figure; hold on;
for k = 1:numDatasetList
    GoogleFLPResult = datasetGoogleFLPResult{k};
    plot(GoogleFLPResult(2,:), GoogleFLPResult(1,:),'color',distinguishableColors(k,:),'LineWidth',2.5);
end
plot_google_map('maptype', 'roadmap', 'APIKey', 'AIzaSyB_uD1rGjX6MJkoQgSDyjHkbdu-b-_5Bjg');
set(gcf,'Units','pixels','Position',[150 60 1700 900]);  % modify figure


% plot multiple Google FLP results in meter
figure; hold on; grid on; axis equal;
for k = 1:numDatasetList
    GoogleFLPMeterResult = datasetGoogleFLPMeterResult{k};
    plot(GoogleFLPMeterResult(1,:), GoogleFLPMeterResult(2,:),'color',distinguishableColors(k,:),'LineWidth',2.5);
end
xlabel('X [m]','FontName','Times New Roman','FontSize',15);
ylabel('Y [m]','FontName','Times New Roman','FontSize',15);
set(gcf,'Units','pixels','Position',[150 60 1700 900]);  % modify figure



% % remove invalid Google FLP data
% for k = 1:numDatasetList
%
%     GoogleFLPMeterResult = datasetGoogleFLPMeterResult{k};
%
%     numGoogleFLP = size(GoogleFLPMeterResult,2);
%     invalidIndex = [];
%     temp = zeros(1,numGoogleFLP);
%     for m = 2:numGoogleFLP
%
%
%         temp(m) = norm(GoogleFLPMeterResult(:,m) - GoogleFLPMeterResult(:,m-1));
%
%     end
%
%     invalidIndex = (temp > 25.0);
%
%     GoogleFLPMeterResult(:,invalidIndex) = [];
%
%
%
%
% end







