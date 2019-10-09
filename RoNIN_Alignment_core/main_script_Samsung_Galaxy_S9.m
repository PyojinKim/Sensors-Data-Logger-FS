clc;
close all;
clear variables; %clear classes;
rand('state',0); % rand('state',sum(100*clock));
dbstop if error;


%% basic setup for RoNIN Alignment Project

% choose the experiment case
% Smartphone dataset (1~XX)
expCase = 1;

% are figures drawn?
% 1 : yes, draw figures to see current status
% 0 : no, just run RoNIN Alignment Project
toVisualize = 1;

% are data results saved?
% 1 : yes, save the variables and results
% 0 : no, just run RoNIN Alignment Project
toSave = 1;


setupParams_Samsung_Galaxy_S9_Dataset;


% load & synchronize smartphone dataset data (RoNIN / Magnet / WiFi / FLP)
rawDeviceDataset = loadRawSmartphoneDataset(datasetPath);
deviceDataset = synchronizeSmartphoneDataset(rawDeviceDataset, 0.5);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

kStartFLP = 1;
kEndFLP = 450;
startTime = rawDeviceDataset.FLP.timestamp(kStartFLP);
endTime = rawDeviceDataset.FLP.timestamp(kEndFLP);

Longitude = rawDeviceDataset.FLP.horizontalPositionDegree(2,kStartFLP:kEndFLP);
Latitude = rawDeviceDataset.FLP.horizontalPositionDegree(1,kStartFLP:kEndFLP);

% plot horizontal position (latitude / longitude) trajectory on Google map
figure;
plot(Longitude, Latitude, 'k.', 'LineWidth', 3); hold on;
plot_google_map('maptype', 'roadmap', 'APIKey', 'AIzaSyB_uD1rGjX6MJkoQgSDyjHkbdu-b-_5Bjg');
legend('Fused Location Provider (FLP)'); hold off;
xlabel('Longitude [deg]','FontName','Times New Roman','FontSize',17);
ylabel('Latitude [deg]','FontName','Times New Roman','FontSize',17);

% plot horizontal position (m) trajectory
FLPTrajectory = rawDeviceDataset.FLP.horizontalPositionMeter(:,kStartFLP:kEndFLP);
FLPTrajectory(1,:) = (FLPTrajectory(1,:) - FLPTrajectory(1,1));
FLPTrajectory(2,:) = (FLPTrajectory(2,:) - FLPTrajectory(2,1));
figure;
h_FLP = plot(FLPTrajectory(1,:), FLPTrajectory(2,:),'k','LineWidth',2); hold on; grid on; axis equal;
plot_inertial_frame(5.0); legend([h_FLP],{'FLP'});
xlabel('x [m]','fontsize',12); ylabel('y [m]','fontsize',12); hold off;


% RoNIN data time synchronization
[~, kStartRoNIN] = min(abs(startTime - rawDeviceDataset.RoNIN.timestamp));
[~, kEndRoNIN] = min(abs(endTime - rawDeviceDataset.RoNIN.timestamp));

roninTrajectory = rawDeviceDataset.RoNIN.trajectory(:,kStartRoNIN:kEndRoNIN);
roninTrajectory(1,:) = (roninTrajectory(1,:) - roninTrajectory(1,1));
roninTrajectory(2,:) = (roninTrajectory(2,:) - roninTrajectory(2,1));

% plot RoNIN 2D trajectory
figure(11);
h_ronin = plot(roninTrajectory(1,:), roninTrajectory(2,:),'m','LineWidth',2); hold on; grid on; axis equal;
plot_inertial_frame(5.0); legend([h_ronin],{'RoNIN'});
xlabel('x [m]','fontsize',12); ylabel('y [m]','fontsize',12); hold off;






rawDeviceDataset.RoNIN.timestamp(kStartRoNIN)
rawDeviceDataset.RoNIN.timestamp(kEndRoNIN)







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

deviceDataset = synchronizeSmartphoneDataset(rawDeviceDataset, kStartMagnet, kEndMagnet);

% various variables from deviceDataset
numData = size(deviceDataset.syncTimestamp,2);
syncTimestamp = deviceDataset.syncTimestamp;
syncRoninPose = [deviceDataset.syncRoninPose; zeros(1,numData)];
syncDeviceOrientation = deviceDataset.syncDeviceOrientation;
syncMagnetField = deviceDataset.syncMagnetField;


%% plot RoNIN 2D trajectory with magnetic field vectors

% plot RoNIN 2D trajectory
figure(11);
h_ronin = plot3(syncRoninPose(1,:), syncRoninPose(2,:), syncRoninPose(3,:),'m','LineWidth',2); hold on; grid on; axis equal;

% plot magnetic field vectors
for k = 1:50:numData
    currentPosition = syncRoninPose(:,k);
    currentMagnet = syncMagnetField(:,k);
    currentMagnet = currentMagnet / norm(currentMagnet);
    h_magnet = plot_magnetic_field_vector(currentPosition, currentMagnet, 'b', 2.0);
end
plot_inertial_frame(5.0); legend([h_ronin h_magnet],{'RoNIN', 'Magnetic Field'}); view(34,29);
xlabel('x [m]','fontsize',12); ylabel('y [m]','fontsize',12); zlabel('z [m]','fontsize',12); hold off;


%% plot RoNIN 2D trajectory

% plot RoNIN trajectory X-Y
figure;
subplot(2,1,1);
plot(syncTimestamp, syncRoninPose(1,:), 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(syncTimestamp) max(syncTimestamp) min(syncRoninPose(1,:)) max(syncRoninPose(1,:))]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('X [m]','FontName','Times New Roman','FontSize',17);
subplot(2,1,2);
plot(syncTimestamp, syncRoninPose(2,:), 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(syncTimestamp) max(syncTimestamp) min(syncRoninPose(2,:)) max(syncRoninPose(2,:))]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('Y [m]','FontName','Times New Roman','FontSize',17);
set(gcf,'Units','pixels','Position',[100 50 1000 900]);  % modify figure


%% plot calibrated magnetic field in global (reference) frame

% plot calibrated magnetic field X-Y-Z
figure;
subplot(3,1,1);
plot(syncTimestamp, syncMagnetField(1,:), 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(syncTimestamp) max(syncTimestamp) min(syncMagnetField(1,:)) max(syncMagnetField(1,:))]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('X [¥ìT]','FontName','Times New Roman','FontSize',17);
subplot(3,1,2);
plot(syncTimestamp, syncMagnetField(2,:), 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(syncTimestamp) max(syncTimestamp) min(syncMagnetField(2,:)) max(syncMagnetField(2,:))]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('Y [¥ìT]','FontName','Times New Roman','FontSize',17);
subplot(3,1,3);
plot(syncTimestamp, syncMagnetField(3,:), 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(syncTimestamp) max(syncTimestamp) min(syncMagnetField(3,:)) max(syncMagnetField(3,:))]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('Z [¥ìT]','FontName','Times New Roman','FontSize',17);
set(gcf,'Units','pixels','Position',[100 50 1000 900]);  % modify figure


%%


toVisualize = true;

% make figures to visualize current status
if (toVisualize)
    % create figure
    h = figure(10);
    set(h,'Color',[1 1 1]);
    set(h,'Units','pixels','Position',[60 150 1850 900]);
    ha1 = axes('Position',[0.02,0.55 , 0.3,0.4]);
    %axis off;
    ha2 = axes('Position',[0.35,0.55 , 0.3,0.4]);
    %axis off;
    ha3 = axes('Position',[0.68,0.55 , 0.3,0.4]);
    ha4 = axes('Position',[0.02,0.05 , 0.3,0.4]);
    %axis off;
    ha5 = axes('Position',[0.35,0.05 , 0.3,0.4]);
    ha6 = axes('Position',[0.68,0.05 , 0.3,0.4]);
    grid on; hold on;
end

for k = 517000:50:size(deviceRoninTrajectory,2)
    
    
    currentTime = deviceRoninTime(k);
    [timeDifference, deviceWiFiIndex] = min(abs(currentTime - [deviceWiFiScanResults(:).timestamp]));
    
    isPast = currentTime > deviceWiFiScanResults(deviceWiFiIndex).timestamp;
    numberOfAPs = deviceWiFiScanResults(deviceWiFiIndex).numberOfAPs;
    
    
    %% update RoNIN 2D trajectory
    
    axes(ha6); cla;
    % draw moving trajectory
    p_gb_RoNIN = deviceRoninTrajectory(1:2,1:k);
    plot(p_gb_RoNIN(1,:), p_gb_RoNIN(2,:), 'm', 'LineWidth', 2); hold on; grid on; axis equal;
    
    
    if (timeDifference <= 3)
        text(p_gb_RoNIN(1,end), p_gb_RoNIN(2,end), sprintf('Time Difference: %.2f', timeDifference), 'FontSize',14);
        text(p_gb_RoNIN(1,end), p_gb_RoNIN(2,end) - 1, sprintf('Number of APs: %d', numberOfAPs), 'FontSize',14);
    end
    
    xlabel('X [m]','fontsize',10); ylabel('Y [m]','fontsize',10); hold off;
    title('RoNIN 2D estimated trajectory');
    refresh; pause(0.01); k
    
    
    
    %% update WiFi scan results
    
    
    
    %% update magnetic field values
    
    
    
    
    %% save current figure
    
    
end














