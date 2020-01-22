clc;
close all;
clear variables; %clear classes;
rand('state',0); % rand('state',sum(100*clock));
dbstop if error;

addpath('devkit_KITTI_GPS');


%% preprocessing RoNIN data


roninResult = parseRoninTextFile('ronin.txt', 200, 225);



numRonin = size(roninResult,2);
roninLocationTemp = zeros(2,numRonin);
roninLocationTemp(:,1) = roninResult(1).location;
for k = 2:numRonin
    
    deltaX = roninResult(k).speed * cos(roninResult(k).deltaAngle);
    deltaY = roninResult(k).speed * sin(roninResult(k).deltaAngle);
    
    roninLocationTemp(:,k) = roninLocationTemp(:,k-1) + [deltaX; deltaY];
end





% vectorize RoNIN result for visualization
roninTime = [roninResult(:).timestamp];
roninLocation = [roninResult(:).location];


% plot RoNIN 2D trajectory
figure;
plot(roninLocation(1,:),roninLocation(2,:),'m-','LineWidth',1.0); hold on; grid on; axis equal;



% plot RoNIN 2D trajectory
figure;
plot(roninLocationTemp(1,:),roninLocationTemp(2,:),'m-','LineWidth',1.0); hold on; grid on; axis equal;





