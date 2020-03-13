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
roninResult = extractRoninOnlyData(datasetDirectory, roninInterval, roninYawRotation);


% refine invalid RoNIN result from Google FLP
FLPAccuracyThreshold = 25.0;   % meter
numRonin = size(roninResult,2);
for k = 1:numRonin
    if (roninResult(k).FLPAccuracy > FLPAccuracyThreshold)
        roninResult(k).FLPLocation = [];
        roninResult(k).FLPAccuracy = [];
    end
end


% detect and remove RoNIN stationary motion
speed = 0.1;             % m/s
duration = 5.0;          % sec
roninResult = detectStationaryMotion(roninResult, speed, duration);
roninResult = removeStationaryMotion(roninResult);


% re-package RoNIN data for figures
roninLocation = [roninResult(:).location];
roninFLPLocation = [roninResult(:).FLPLocation];


% plot RoNIN 2D trajectory (left) & GPS trajectory on Google map (right)
figure;
subplot(1,2,1);
plot(roninLocation(1,:),roninLocation(2,:),'k-','LineWidth',1.5); grid on; axis equal; axis tight;
xlabel('X [m]','FontName','Times New Roman','FontSize',15);
ylabel('Y [m]','FontName','Times New Roman','FontSize',15);
subplot(1,2,2);
plot(roninFLPLocation(2,:), roninFLPLocation(1,:),'b*-','LineWidth',1.0);
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
    if (~isempty(roninResult(k).FLPLocation))
        
        % define Google FLP scale, origin in meter
        if (~isGoogleFLPInitialized)
            isGoogleFLPInitialized = true;
            
            scaleRef = latToScale(roninResult(k).FLPLocation(1));
            latitude = roninResult(k).FLPLocation(1);
            longitude = roninResult(k).FLPLocation(2);
            [XRef,YRef] = latlonToMercator(latitude, longitude, scaleRef);
        end
        
        
        % convert lat/lon coordinates (deg) to mercator coordinates (m)
        latitude = roninResult(k).FLPLocation(1);
        longitude = roninResult(k).FLPLocation(2);
        [X,Y] = latlonToMercator(latitude, longitude, scaleRef);
        
        X = X - XRef;
        Y = Y - YRef;
        roninResult(k).FLPLocation = [X;Y];
    end
end


% extract RoNIN on moving trajectory
roninMovingPartResult = [];
scaleResult = [];
biasResult = [];
for k = 1:numMovingTrajectory
    
    % assign current RoNIN moving trajectory
    roninMovingPart = roninResult(movingTrajectoryIndex{k});
    
    
    % Google FLP constraints
    roninGoogleFLPIndex = [];
    for m = 1:size(roninMovingPart,2)
        if (~isempty(roninMovingPart(m).FLPLocation))
            roninGoogleFLPIndex = [roninGoogleFLPIndex, m];
        end
    end
    roninGoogleFLPLocation = [roninMovingPart(:).FLPLocation];
    
    
    % if there is no Google FLP constraint
    if (isempty(roninGoogleFLPIndex))
        continue;
    end
    
    
    % nonlinear optimization with RoNIN drift correction model
    [roninMovingPart, scale, bias] = optimizeRoninMovingTrajectory(roninMovingPart, roninGoogleFLPIndex, roninGoogleFLPLocation);
    roninMovingPartResult = [roninMovingPartResult, roninMovingPart];
    scaleResult = [scaleResult, scale];
    biasResult = [biasResult, bias];
end


temp = [];
for k = 1:numMovingTrajectory
    temp = [temp, [roninMovingPartResult{k}.location]];
end



% plot RoNIN 2D trajectory (left) & GPS trajectory on Google map (right)
h_plot = figure;
plot(temp(1,:),temp(2,:),'m-','LineWidth',2.5); hold on; grid on; axis equal; axis tight;



plot(roninFLPLocation(1,:), roninFLPLocation(2,:),'b*-','LineWidth',1.0); hold on;
xlabel('X [m]','FontName','Times New Roman','FontSize',15);
ylabel('Y [m]','FontName','Times New Roman','FontSize',15);











