clc;
close all;
clear variables; %clear classes;
rand('state',0); % rand('state',sum(100*clock));
dbstop if error;

addpath('devkit_KITTI_GPS');


%% 1) select RoNIN recording data

% extract RoNIN data
expCase = 1;
setupParams_alignment_Prof_Yasu;
roninResult = extractRoninOnlyData(datasetDirectory, roninInterval, roninYawRotation);


% detect and remove RoNIN stationary motion
speed = 0.1;             % m/s
duration = 5.0;          % sec
roninResult = detectStationaryMotion(roninResult, speed, duration);
roninResult = removeStationaryMotion(roninResult);
roninResult = roninResult(validRoninIndex);


% re-package RoNIN data for figures
roninLocation = [roninResult(:).location];
roninFLPLocation = [roninResult(:).FLPLocation];


% plot RoNIN 2D trajectory (left) & GPS trajectory on Google map (right)
figure;
subplot(1,2,1);
plot(roninLocation(1,:),roninLocation(2,:),'k-','LineWidth',1.5); grid on;
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
displacement = 4.0;    % m
movingTrajectoryIndex = seperateRoninMovingTrajectory(roninResult, displacement);
stationaryPointIndex = seperateRoninStationaryPoint(roninResult, movingTrajectoryIndex);



k = 19;

% plot

roninMovingLocation = [roninResult(movingTrajectoryIndex{k}).location];

computeRoninTravelingDistance(roninResult(movingTrajectoryIndex{k}))
computeRoninEndtoEndDistance(roninResult(movingTrajectoryIndex{k}))

figure;
subplot(1,2,1);
plot(roninLocation(1,:),roninLocation(2,:),'k','LineWidth',1.0); hold on; grid on; axis equal;
plot(roninMovingLocation(1,:),roninMovingLocation(2,:),'m-','LineWidth',2.5);





for i = 1:batchSize
    if pairLabel(i) == 1
        s = "similar";
    else
        s = "dissimilar";
    end
    subplot(2,5,i)
    imshow([pairImage1(:,:,:,i) pairImage2(:,:,:,i)]);
    title(s)
end






















