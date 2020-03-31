clc;
close all;
clear variables; %clear classes;
rand('state',0); % rand('state',sum(100*clock));
dbstop if error;

addpath('devkit_KITTI_GPS');


%% 1) load RoNIN IO data

% load RoNIN IO data
numDatasetList = 28;
datasetRoninIO = cell(1,numDatasetList);
for k = 1:numDatasetList
    
    % extract RoNIN data
    expCase = k;
    setupParams_alignment_Prof_Yasu;
    RoninIO = extractRoninCentricData(datasetDirectory, roninInterval, roninYawRotation, 25.0);
    
    
    % detect and remove RoNIN stationary motion
    speed = 0.1;             % m/s
    duration = 5.0;          % sec
    RoninIO = detectStationaryMotion(RoninIO, speed, duration);
    RoninIO = removeStationaryMotion(RoninIO);
    RoninIO = RoninIO(validRoninIndex);
    
    
    % save RoNIN IO
    datasetRoninIO{k} = RoninIO;
    k
end


% unify Google FLP inertial frame in meter
datasetRoninIO = unifyGoogleFLPMeterFrame(datasetRoninIO);


% Google FLP visualization
for k = 1:numDatasetList
    
    % current RoNIN IO data
    RoninIO = datasetRoninIO{k};
    RoninIOLocation = [RoninIO.FLPLocationMeter];
    
    
    % plot RoNIN IO location
    distinguishableColors = distinguishable_colors(numDatasetList);
    figure(10); hold on; grid on; axis equal; axis tight;
    plot(RoninIOLocation(1,:),RoninIOLocation(2,:),'*-','color',distinguishableColors(k,:),'LineWidth',1.5); grid on; axis equal;
    xlabel('X [m]','FontName','Times New Roman','FontSize',15);
    ylabel('Y [m]','FontName','Times New Roman','FontSize',15);
    set(gcf,'Units','pixels','Position',[150 60 1700 900]);  % modify figure
end


%% 2) optimize each RoNIN IO against Google FLP

% divide Ronin IO into Ronin IO moving / stationary part
movement = 4.0;         % m
displacement = 3.5;     % m
datasetRoninIOMovingTrajectory = cell(1,numDatasetList);
datasetRoninIOStationaryPoint = cell(1,numDatasetList);
for k = 1:numDatasetList
    
    % current RoNIN IO data
    RoninIO = datasetRoninIO{k};
    
    
    % extract RoNIN moving trajectory
    movingTrajectoryIndex = seperateRoninMovingTrajectory(RoninIO, movement, displacement);
    numMovingTrajectory = size(movingTrajectoryIndex,2);
    RoninIOMovingTrajectory = cell(1,numMovingTrajectory);
    for m = 1:numMovingTrajectory
        RoninIOMovingTrajectory{m} = RoninIO(movingTrajectoryIndex{m});
    end
    datasetRoninIOMovingTrajectory{k} = RoninIOMovingTrajectory;
    
    
    % extract RoNIN stationary point
    stationaryPointIndex = seperateRoninStationaryPoint(RoninIO, movingTrajectoryIndex);
    numStationaryPoint = size(stationaryPointIndex,2);
    RoninIOStationaryPoint = cell(1,numStationaryPoint);
    for m = 1:numStationaryPoint
        RoninIOStationaryPoint{m} = RoninIO(stationaryPointIndex{m});
    end
    datasetRoninIOStationaryPoint{k} = RoninIOStationaryPoint;
    k
end


% optimize RoNIN IO moving trajectory
for k = 1:numDatasetList
    
    % current RoNIN IO moving trajectory
    RoninIOMovingTrajectory = datasetRoninIOMovingTrajectory{k};
    numMovingTrajectory = size(RoninIOMovingTrajectory,2);
    
    
    % nonlinear optimization with RoNIN drift correction model
    for m = 1:numMovingTrajectory
        RoninIOMovingTrajectory{m} = optimizeEachRoninIO(RoninIOMovingTrajectory{m});
    end
    datasetRoninIOMovingTrajectory{k} = RoninIOMovingTrajectory;
    k
end


% visualize RoNIN IO stationary point
for k = 1:numDatasetList
    
    % current RoNIN IO stationary point
    RoninIOStationaryPoint = datasetRoninIOStationaryPoint{k};
    
    
    
    
end

%%



for k = 1:numDatasetList
    
    RoninIOStationaryPoint = datasetRoninIOStationaryPoint{k};
    
    
    % plot RoNIN stationary points
    for m = 1:size(RoninIOStationaryPoint,2)
        
        % current moving trajectory
        RoninIO = RoninIOStationaryPoint{m};
        RoninIOLocation = [RoninIO.FLPLocationMeter];
        if (isempty(RoninIOLocation))
            continue;
        end
        
        
        % plot RoNIN IO location
        distinguishableColors = distinguishable_colors(numDatasetList);
        figure(10); hold on; grid on; axis equal; axis tight;
        plot(RoninIOLocation(1,:),RoninIOLocation(2,:),'.','color',distinguishableColors(k,:),'LineWidth',1.5); grid on; axis equal;
        xlabel('X [m]','FontName','Times New Roman','FontSize',15);
        ylabel('Y [m]','FontName','Times New Roman','FontSize',15);
        set(gcf,'Units','pixels','Position',[150 60 1700 900]);  % modify figure
    end
    set(gcf,'Units','pixels','Position',[150 60 1700 900]);  % modify figure
end




%%

for k = 1:numDatasetList
    
    RoninIOStationaryPoint = datasetRoninIOStationaryPoint{k};
    
    
    % plot RoNIN stationary points
    for m = 1:size(RoninIOStationaryPoint,2)
        
        % current moving trajectory
        RoninIO = RoninIOStationaryPoint{m};
        RoninIOFLPLocationDegree = [RoninIO.FLPLocationDegree];
        if (isempty(RoninIOFLPLocationDegree))
            continue;
        end
        
        
        % plot RoNIN IO location
        distinguishableColors = distinguishable_colors(numDatasetList);
        figure(10); hold on;
        plot(RoninIOFLPLocationDegree(2,:),RoninIOFLPLocationDegree(1,:),'*','color',distinguishableColors(k,:),'LineWidth',1.5);
        xlabel('Longitude [deg]','FontName','Times New Roman','FontSize',17);
        ylabel('Latitude [deg]','FontName','Times New Roman','FontSize',17);
        set(gcf,'Units','pixels','Position',[150 60 1700 900]);  % modify figure
    end
    set(gcf,'Units','pixels','Position',[150 60 1700 900]);  % modify figure
end
plot_google_map('maptype', 'roadmap', 'APIKey', 'AIzaSyB_uD1rGjX6MJkoQgSDyjHkbdu-b-_5Bjg');















