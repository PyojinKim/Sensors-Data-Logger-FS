clc;
close all;
clear variables; %clear classes;
rand('state',0); % rand('state',sum(100*clock));
dbstop if error;

addpath('devkit_KITTI_GPS');


%% 1) select RoNIN recording data

% extract RoNIN data
expCase = 27;
setupParams_alignment_Prof_Yasu;
roninResult = extractRoninCentricData(datasetDirectory, roninInterval, roninYawRotation);


% refine invalid RoNIN result from Google FLP
FLPAccuracyThreshold = 25.0;   % meter
numRonin = size(roninResult,2);
for k = 1:numRonin
    if (roninResult(k).FLPAccuracyMeter > FLPAccuracyThreshold)
        roninResult(k).FLPLocationDegree = [];
        roninResult(k).FLPLocationMeter = [];
        roninResult(k).FLPAccuracyMeter = [];
    end
end


% detect and remove RoNIN stationary motion
speed = 0.1;             % m/s
duration = 5.0;          % sec
roninResult = detectStationaryMotion(roninResult, speed, duration);
roninResult = removeStationaryMotion(roninResult);


% re-package RoNIN data for figures
roninLocation = [roninResult.location];
roninFLPLocationDegree = [roninResult.FLPLocationDegree];


% plot RoNIN 2D trajectory (left) & GPS trajectory on Google map (right)
figure;
subplot(1,2,1);
plot(roninLocation(1,:),roninLocation(2,:),'k-','LineWidth',1.5); grid on; axis equal; axis tight;
xlabel('X [m]','FontName','Times New Roman','FontSize',15);
ylabel('Y [m]','FontName','Times New Roman','FontSize',15);
subplot(1,2,2);
plot(roninFLPLocationDegree(2,:), roninFLPLocationDegree(1,:),'b*-','LineWidth',1.0);
plot_google_map('maptype', 'roadmap', 'APIKey', 'AIzaSyB_uD1rGjX6MJkoQgSDyjHkbdu-b-_5Bjg');
xlabel('Longitude [deg]','FontName','Times New Roman','FontSize',15);
ylabel('Latitude [deg]','FontName','Times New Roman','FontSize',15);
set(gcf,'Units','pixels','Position',[150 300 1700 600]);  % modify figure


%% 2) seperate & analyze RoNIN moving trajectories

% separate RoNIN moving trajectory and stationary point
movement = 4.0;         % m
displacement = 3.5;     % m
movingTrajectoryIndex = seperateRoninMovingTrajectory(roninResult, movement, displacement);
stationaryPointIndex = seperateRoninStationaryPoint(roninResult, movingTrajectoryIndex);
numMovingTrajectory = size(movingTrajectoryIndex,2);


% convert Google FLP to meter metric
numRonin = size(roninResult,2);
isGoogleFLPInitialized = false;
for k = 1:numRonin
    
    % check Google FLP exists or not
    if (~isempty(roninResult(k).FLPLocationDegree))
        
        % define Google FLP scale, origin in meter
        if (~isGoogleFLPInitialized)
            isGoogleFLPInitialized = true;
            
            scaleRef = latToScale(roninResult(k).FLPLocationDegree(1));
            latitude = roninResult(k).FLPLocationDegree(1);
            longitude = roninResult(k).FLPLocationDegree(2);
            [XRef,YRef] = latlonToMercator(latitude, longitude, scaleRef);
        end
        
        
        % convert lat/lon coordinates (deg) to mercator coordinates (m)
        latitude = roninResult(k).FLPLocationDegree(1);
        longitude = roninResult(k).FLPLocationDegree(2);
        [X,Y] = latlonToMercator(latitude, longitude, scaleRef);
        
        X = X - XRef;
        Y = Y - YRef;
        roninResult(k).FLPLocationMeter = [X;Y];
    end
end


% extract RoNIN on moving trajectory
roninMovingPartResult = [];
for k = 1:numMovingTrajectory
    
    % assign current RoNIN moving trajectory
    RoninIO = roninResult(movingTrajectoryIndex{k});
    
    
    % nonlinear optimization with RoNIN drift correction model
    [RoninIO] = optimizeEachRoninIO(RoninIO);
    roninMovingPartResult = [roninMovingPartResult, RoninIO];
end


%%


% re-package RoNIN data for figures
roninLocation = [roninMovingPartResult.location];
roninFLPLocationMeter = [roninMovingPartResult.FLPLocationMeter];


% plot RoNIN 2D trajectory (left) & GPS trajectory on Google map (right)
h_plot = figure;
plot(roninLocation(1,:),roninLocation(2,:),'m-','LineWidth',2.5); hold on; grid on; axis equal; axis tight;
plot(roninFLPLocationMeter(1,:), roninFLPLocationMeter(2,:),'b*-','LineWidth',1.5); hold on;
xlabel('X [m]','FontName','Times New Roman','FontSize',15);
ylabel('Y [m]','FontName','Times New Roman','FontSize',15);




% plot scale and bias model parameters for RoNIN drift correction
figure;
subplot(2,1,1);
h_optimal = plot(scaleResult,'m','LineWidth',1.5); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Scale Model Parameter Index','FontName','Times New Roman','FontSize',17);
ylabel('Scale','FontName','Times New Roman','FontSize',17);
subplot(2,1,2);
plot(biasResult,'m','LineWidth',1.5); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Bias Model Parameter Index','FontName','Times New Roman','FontSize',17);
ylabel('Bias','FontName','Times New Roman','FontSize',17);
set(gcf,'Units','pixels','Position',[900 300 800 600]);  % modify figure






