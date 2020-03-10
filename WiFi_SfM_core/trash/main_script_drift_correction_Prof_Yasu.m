clc;
close all;
clear variables; %clear classes;
rand('state',0); % rand('state',sum(100*clock));
dbstop if error;

addpath('devkit_KITTI_GPS');


%% 1) read RoNIN data

% load dataset lists
expCase = 10;
setupParams_alignment_Prof_Yasu;


% load unique WiFi RSSID Map
load([datasetPath '/uniqueWiFiAPsBSSID.mat']);


% extract RoNIN data
roninResult = extractRoninOnlyData(datasetDirectory, roninInterval, roninYawRotation);


% detect and remove RoNIN stationary motion
speed = 0.1;             % m/s
duration = 5.0;          % sec
roninResult = detectStationaryMotion(roninResult, speed, duration);
roninResult = removeStationaryMotion(roninResult);


%% 2) identify RoNIN moving/stationary points

% separate RoNIN moving trajectory and stationary point
movement = 4.0;         % m
displacement = 3.5;     % m
movingTrajectoryIndex = seperateRoninMovingTrajectory(roninResult, movement, displacement);
stationaryPointIndex = seperateRoninStationaryPoint(roninResult, movingTrajectoryIndex);


% construct stationary points map
rewardThreshold = 0.25;
stationaryPoint = extractRoninStationaryPoint(roninResult, stationaryPointIndex, uniqueWiFiAPsBSSID);
stationaryPointMap = constructStationaryMap(stationaryPoint, rewardThreshold);


% extract RoNIN moving trajectory from RoNIN result
roninMovingPart = extractRoninMovingTrajectory(roninResult, movingTrajectoryIndex, stationaryPointMap);
numStationaryPointMap = size(stationaryPointMap,2);
roninStationaryPointIndex = cell(1,numStationaryPointMap);
for k = 1:numStationaryPointMap
    roninStationaryPointIndex{k} = find([roninMovingPart(:).stationaryPointIndex] == k);
end


% plot RoNIN 2D trajectory with stationary points
distinguishableColors = distinguishable_colors(numStationaryPointMap);
roninLocation = [roninMovingPart(:).location];
figure;
plot(roninLocation(1,:),roninLocation(2,:),'m-','LineWidth',2.0); hold on; grid on; axis equal;
for k = 1:numStationaryPointMap
    roninStationaryLocation = [roninLocation(:,roninStationaryPointIndex{k})];
    plot(roninStationaryLocation(1,:),roninStationaryLocation(2,:),'d','color',distinguishableColors(k,:),'LineWidth',2.5);
end
set(gcf,'Units','pixels','Position',[900 300 800 600]);  % modify figure


%% 3) optimization with RoNIN stationary points

% convert RoNIN polar coordinate for nonlinear optimization
roninPolarResult = convertRoninPolarCoordinate(roninMovingPart);
roninInitialLocation = roninPolarResult(1).location;
roninPolarSpeed = [roninPolarResult(:).speed];
roninPolarAngle = [roninPolarResult(:).angle];


% scale and bias model parameters for RoNIN drift correction
numRonin = size(roninPolarResult,2);
roninScale = ones(1,numRonin);
roninBias = zeros(1,numRonin);
X_initial = [roninScale, roninBias];
roninLocation = DriftCorrectedRoninAbsoluteAngleModel(roninInitialLocation, roninPolarSpeed, roninPolarAngle, X_initial);


% plot RoNIN 2D trajectory before nonlinear optimization
figure;
plot(roninLocation(1,:),roninLocation(2,:),'m-','LineWidth',2.0); hold on; grid on; axis equal;
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',15);
xlabel('X [m]','FontName','Times New Roman','FontSize',15);
ylabel('Y [m]','FontName','Times New Roman','FontSize',15);
title('Before Optimization','FontName','Times New Roman','FontSize',15);
set(gcf,'Units','pixels','Position',[900 300 800 600]);  % modify figure


% run nonlinear optimization using lsqnonlin in Matlab (Levenberg-Marquardt)
options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt','Display','iter-detailed');
[vec,resnorm,residuals,exitflag] = lsqnonlin(@(x) EuclideanDistanceResidual(roninInitialLocation, roninPolarSpeed, roninPolarAngle, roninStationaryPointIndex, x),X_initial,[],[],options);


% optimal scale and bias model parameters for RoNIN drift correction
X_optimized = vec;
roninResidual = EuclideanDistanceResidual(roninInitialLocation, roninPolarSpeed, roninPolarAngle, roninStationaryPointIndex, X_optimized);
roninLocation = DriftCorrectedRoninAbsoluteAngleModel(roninInitialLocation, roninPolarSpeed, roninPolarAngle, X_optimized);


% plot RoNIN 2D trajectory after nonlinear optimization
figure;
plot(roninLocation(1,:),roninLocation(2,:),'m-','LineWidth',2.0); hold on; grid on; axis equal;
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',15);
xlabel('X [m]','FontName','Times New Roman','FontSize',15);
ylabel('Y [m]','FontName','Times New Roman','FontSize',15);
title('After Optimization','FontName','Times New Roman','FontSize',15);
set(gcf,'Units','pixels','Position',[900 300 800 600]);  % modify figure


%%

roninScaleInitial = X_initial(1:numRonin);
roninBiasInitial = X_initial((numRonin+1):end);

roninScaleOptimal = X_optimized(1:numRonin);
roninBiasOptimal = X_optimized((numRonin+1):end);


% plot scale and bias model parameters for RoNIN drift correction
figure;
subplot(2,1,1);
h_initial = plot(roninScaleInitial,'k','LineWidth',1.5); hold on; grid on;
h_optimal = plot(roninScaleOptimal,'m','LineWidth',1.5); axis tight;
set(gcf,'color','w'); hold off;
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Scale Model Parameter Index','FontName','Times New Roman','FontSize',17);
ylabel('Scale','FontName','Times New Roman','FontSize',17);
legend('Initial','Optimal');
subplot(2,1,2);
plot(roninBiasInitial,'k','LineWidth',1.5); hold on; grid on;
plot(roninBiasOptimal,'m','LineWidth',1.5); axis tight;
set(gcf,'color','w'); hold off;
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Bias Model Parameter Index','FontName','Times New Roman','FontSize',17);
ylabel('Bias','FontName','Times New Roman','FontSize',17);
set(gcf,'Units','pixels','Position',[900 300 800 600]);  % modify figure






