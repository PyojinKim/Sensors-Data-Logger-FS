clc;
close all;
clear variables; %clear classes;
rand('state',0); % rand('state',sum(100*clock));
dbstop if error;

addpath('devkit_KITTI_GPS');


%% 1) read RoNIN and Google FLP data


numDatasetList = 11;
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



% plot multiple Google FLP results
distinguishableColors = distinguishable_colors(numDatasetList);
figure; hold on;
for k = 1:numDatasetList
    GoogleFLPResult = datasetGoogleFLPResult{k};
    plot(GoogleFLPResult(2,:), GoogleFLPResult(1,:),'color',distinguishableColors(k,:),'LineWidth',2.5);
end
plot_google_map('maptype', 'roadmap', 'APIKey', 'AIzaSyB_uD1rGjX6MJkoQgSDyjHkbdu-b-_5Bjg');
set(gcf,'Units','pixels','Position',[150 60 1700 900]);  % modify figure












