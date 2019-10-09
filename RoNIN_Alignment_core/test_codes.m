%%

% plot horizontal position (latitude / longitude) trajectory on Google map
h = figure(10);
plot_google_map('maptype', 'roadmap', 'APIKey', 'AIzaSyB_uD1rGjX6MJkoQgSDyjHkbdu-b-_5Bjg'); hold on;
xlabel('Longitude [deg]','FontName','Times New Roman','FontSize',17);
ylabel('Latitude [deg]','FontName','Times New Roman','FontSize',17);
%axis([-122.9257 -122.9129   49.2758   49.2819])
%axis([-122.9162 -122.9078   49.2750   49.2790])
%axis([-122.9151 -122.9133   49.2764   49.2772])
%axis([-122.9156 -122.9127   49.2766   49.2779])
%axis([-122.8972 -122.8949   49.2514   49.2525])
axis([-122.8686 -122.8648   49.2338   49.2357])
set(gcf,'Units','pixels','Position',[400 200 1000 700]);  % modify figure


numData = size(deviceDataset.syncTimestamp,2);
for k = 1:numData
    %% prerequisite to visualize
    
    % current FLP information
    currentTime = deviceDataset.syncTimestamp(k);
    currentTrajectory = deviceDataset.syncFLPhorizontalPositionDegree([2 1],1:k);
    currentRadius = deviceDataset.syncFLPhorizontalPositionRadius(k);
    currentLatitude = deviceDataset.syncFLPhorizontalPositionDegree(1,k);
    currentLongitude = deviceDataset.syncFLPhorizontalPositionDegree(2,k);
    
    h_FLP_history = plot(currentTrajectory(1,:), currentTrajectory(2,:),'k','LineWidth',3);
    h_FLP_location = plot(currentLongitude, currentLatitude,'bo','LineWidth',7);
    
    xt = [currentLongitude+0.0001, currentLongitude+0.0001];
    yt = [currentLatitude+0.0002, currentLatitude+0.0001];
    str = {sprintf('time (s): %.2f', currentTime),sprintf('uncertainty (m): %.2f', currentRadius)};
    h_FLP_text = text(xt, yt, str,'FontSize',15,'FontWeight','bold');
    
    %% save current figure
    
    if (toSave)
        % save directory for MAT data
        SaveDir = [datasetPath '/IROS2020'];
        if (~exist( SaveDir, 'dir' ))
            mkdir(SaveDir);
        end
        
        % save directory for images
        SaveImDir = [SaveDir '/FLP'];
        if (~exist( SaveImDir, 'dir' ))
            mkdir(SaveImDir);
        end
        
        refresh; pause(0.01);
        saveImg = getframe(h);
        imwrite(saveImg.cdata , [SaveImDir sprintf('/%06d.png', k)]);
    end
    
    %% remove FLP plots
    
    delete(h_FLP_history)
    delete(h_FLP_location)
    delete(h_FLP_text);
end


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


