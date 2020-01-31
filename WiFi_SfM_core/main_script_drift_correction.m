clc;
close all;
clear variables; %clear classes;
rand('state',0); % rand('state',sum(100*clock));
dbstop if error;

addpath('devkit_KITTI_GPS');


%% preprocessing RoNIN data

% dataset path and upsampling parameter for RoNIN
datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Asus_Tango/SFU_TASC1_8000/20200114112923R_WiFi_SfM';
roninInterval = 200;          % 1 Hz
roninYawRotation = 190;   % degree


% extract RoNIN centric data
roninResult = extractRoninDataOnly(datasetDirectory, roninInterval, roninYawRotation);


% detect and remove RoNIN stationary motion
speed = 0.1;             % m/s
duration = 5.0;          % sec
roninResult = detectStationaryMotion(roninResult, speed, duration);
roninResult = removeStationaryMotion(roninResult);


% separate RoNIN moving trajectory
displacement = 3.0;    % m
movingTrajectoryIndex = seperateRoninMovingTrajectory(roninResult, displacement);





roninLocation = [roninResult(:).location];
lineSegmentIndex = movingTrajectoryIndex{7};
roninLineSegment = [roninResult(lineSegmentIndex).location];

% plot RoNIN 2D trajectory
figure;
plot(roninLocation(1,:),roninLocation(2,:),'k-','LineWidth',1.0); hold on; grid on; axis equal;
plot(roninLineSegment(1,:),roninLineSegment(2,:),'m-','LineWidth',2.5);
set(gcf,'Units','pixels','Position',[900 300 800 600]);  % modify figure








%%




% convert RoNIN polar coordinate for nonlinear optimization
roninPolarResult = convertRoninPolarCoordinate(roninResult);
roninInitialLocation = roninPolarResult(1).location;
roninPolarSpeed = [roninPolarResult(:).speed];
roninPolarDeltaAngle = [roninPolarResult(:).deltaAngle];


% scale and bias model parameters for RoNIN drift correction
numRonin = size(roninPolarResult,2);
roninScale = ones(1,numRonin);
roninBias = zeros(1,numRonin);
X_initial = [roninScale, roninBias];
roninLocation = DriftCorrectedRoninPolarModel(roninInitialLocation, roninPolarSpeed, roninPolarDeltaAngle, X_initial);


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
[vec,resnorm,residuals,exitflag] = lsqnonlin(@(x) EuclideanDistanceResidual(roninInitialLocation, roninPolarSpeed, roninPolarDeltaAngle, x),X_initial,[],[],options);


% optimal scale and bias model parameters for RoNIN drift correction
X_optimized = vec;
roninResidual = EuclideanDistanceResidual(roninInitialLocation, roninPolarSpeed, roninPolarDeltaAngle, X_optimized);
roninLocation = DriftCorrectedRoninPolarModel(roninInitialLocation, roninPolarSpeed, roninPolarDeltaAngle, X_optimized);


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






