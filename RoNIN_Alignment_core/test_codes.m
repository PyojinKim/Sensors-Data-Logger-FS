
%% videos for 'plot RoNIN 2D trajectory with magnetic field vectors'

figure(10);
for k = 1:50:numData
    figure(10); cla;
    
    % draw RoNIN trajectory
    plot3(syncRoninPose(1,1:k), syncRoninPose(2,1:k), syncRoninPose(3,1:k), 'm', 'LineWidth', 2); hold on; grid on; axis equal;
    
    % draw magnetic field vectors
    currentPosition = syncRoninPose(:,k);
    currentMagnet = syncMagnetField(:,k);
    currentMagnet = currentMagnet / norm(currentMagnet);
    plot_magnetic_field_vector(currentPosition, currentMagnet, 'b', 2.0);
    
    % draw body (sensor) frame
    plot_inertial_frame(10); view(39, 32);
    R_gb = syncDeviceOrientation(:,:,k);
    p_gb = syncRoninPose(:,k);
    plot_sensor_frame(R_gb, p_gb, 10); hold off;
    refresh; pause(0.01); k
end


%%


deviceMagnetData = rawDeviceDataset.magnet.vectorField;

% plot calibrated magnetic field X-Y-Z
figure;
subplot(3,1,1);
plot(deviceMagnetData(1,:), 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
ylabel('X [レT]','FontName','Times New Roman','FontSize',17);
subplot(3,1,2);
plot(deviceMagnetData(2,:), 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
ylabel('Y [レT]','FontName','Times New Roman','FontSize',17);
subplot(3,1,3);
plot(deviceMagnetData(3,:), 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
ylabel('Z [レT]','FontName','Times New Roman','FontSize',17);
set(gcf,'Units','pixels','Position',[100 50 1800 900]);  % modify figure





deviceWiFiTime = rawDeviceDataset.wifi.timestamp;


% plot update rate of device orientation
timeDifference = diff(deviceWiFiTime);
meanUpdateRate = (1/mean(timeDifference));
figure;
plot(deviceWiFiTime(2:end), timeDifference, 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(deviceWiFiTime) max(deviceWiFiTime) min(timeDifference) max(timeDifference)]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('Time Difference [sec]','FontName','Times New Roman','FontSize',17);
title(['Mean Update Rate: ', num2str(meanUpdateRate), ' Hz'],'FontName','Times New Roman','FontSize',17);
set(gcf,'Units','pixels','Position',[100 200 1800 900]);  % modify figure





deviceRoninTime = rawDeviceDataset.RoNIN.timestamp;
deviceRoninTrajectory = rawDeviceDataset.RoNIN.trajectory;






kStartRonin = 490160;
kEndRonin = 593500;

% plot RoNIN 2D trajectory
partialRoninTime = deviceRoninTime(kStartRonin:kEndRonin);
partialRoninTrajectory = deviceRoninTrajectory(:,kStartRonin:kEndRonin);
figure;
subplot(2,1,1);
plot(partialRoninTime, partialRoninTrajectory(1,:), 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(partialRoninTime) max(partialRoninTime) min(partialRoninTrajectory(1,:)) max(partialRoninTrajectory(1,:))]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('X [m]','FontName','Times New Roman','FontSize',17);
subplot(2,1,2);
plot(partialRoninTime, partialRoninTrajectory(2,:), 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(partialRoninTime) max(partialRoninTime) min(partialRoninTrajectory(2,:)) max(partialRoninTrajectory(2,:))]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('Y [m]','FontName','Times New Roman','FontSize',17);
set(gcf,'Units','pixels','Position',[100 200 1800 600]);  % modify figure


% RoNIN / Magnet / WiFi time synchronization
startTime = deviceRoninTime(kStartRonin);
endTime = deviceRoninTime(kEndRonin);


% magnet data time synchronization
[~, kStartMagnet] = min(abs(startTime - deviceMagnetTime));
[~, kEndMagnet] = min(abs(endTime - deviceMagnetTime));


% plot calibrated magnetic field X-Y-Z
partialMagnetTime = deviceMagnetTime(kStartMagnet:kEndMagnet);
partialMagnetData = deviceMagnetResults(:,kStartMagnet:kEndMagnet);
figure;
subplot(3,1,1);
plot(partialMagnetTime, partialMagnetData(1,:), 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(partialMagnetTime) max(partialMagnetTime) min(partialMagnetData(1,:)) max(partialMagnetData(1,:))]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('X [レT]','FontName','Times New Roman','FontSize',17);
subplot(3,1,2);
plot(partialMagnetTime, partialMagnetData(2,:), 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(partialMagnetTime) max(partialMagnetTime) min(partialMagnetData(2,:)) max(partialMagnetData(2,:))]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('Y [レT]','FontName','Times New Roman','FontSize',17);
subplot(3,1,3);
plot(partialMagnetTime, partialMagnetData(3,:), 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(partialMagnetTime) max(partialMagnetTime) min(partialMagnetData(3,:)) max(partialMagnetData(3,:))]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('Z [レT]','FontName','Times New Roman','FontSize',17);
set(gcf,'Units','pixels','Position',[100 50 1800 900]);  % modify figure


% WiFi data time synchronization
deviceWiFiScanTime = [deviceWiFiScanResults(:).timestamp];
[timeDifferenceA, kStartWiFiScan] = min(abs(startTime - deviceWiFiScanTime));
[timeDifferenceB, kEndWiFiScan] = min(abs(endTime - deviceWiFiScanTime));


% plot RoNIN 2D trajectory
partialWiFiScanTime = [];
partialWiFiScanResults = [];
for k = kStartWiFiScan:kEndWiFiScan
    partialWiFiScanTime = [deviceWiFiScanResults(k).timestamp, partialWiFiScanTime];
    partialWiFiScanResults = [deviceWiFiScanResults(k).numberOfAPs, partialWiFiScanResults];
end
figure;
plot(partialWiFiScanTime, partialWiFiScanResults, 'm*'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(partialWiFiScanTime) max(partialWiFiScanTime) min(partialWiFiScanResults) max(partialWiFiScanResults)]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('Number of APs','FontName','Times New Roman','FontSize',17);
set(gcf,'Units','pixels','Position',[100 200 1800 300]);  % modify figure


