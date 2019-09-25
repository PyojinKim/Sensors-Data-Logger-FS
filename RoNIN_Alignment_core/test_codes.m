



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
ylabel('X [μT]','FontName','Times New Roman','FontSize',17);
subplot(3,1,2);
plot(partialMagnetTime, partialMagnetData(2,:), 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(partialMagnetTime) max(partialMagnetTime) min(partialMagnetData(2,:)) max(partialMagnetData(2,:))]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('Y [μT]','FontName','Times New Roman','FontSize',17);
subplot(3,1,3);
plot(partialMagnetTime, partialMagnetData(3,:), 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(partialMagnetTime) max(partialMagnetTime) min(partialMagnetData(3,:)) max(partialMagnetData(3,:))]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('Z [μT]','FontName','Times New Roman','FontSize',17);
set(gcf,'Units','pixels','Position',[100 200 1800 900]);  % modify figure


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




% plot the














%% common setting to read text files

delimiter = ' ';
headerlinesIn = 1;
nanoSecondToSecond = 1000000000;


%% 9) calibrated magnetic field

% parsing calibrated magnetic field text
textFileDir = '20190830040751R_pjinkim_magnet.txt';
textMagnetData = importdata(textFileDir, delimiter, headerlinesIn);
magnetTime = textMagnetData.data(:,1).';
magnetTime = (magnetTime - magnetTime(1)) ./ nanoSecondToSecond;
magnetData = textMagnetData.data(:,[2 3 4]).';

% plot calibrated magnetic field X-Y-Z
figure;
subplot(3,1,1);
plot(magnetTime, magnetData(1,:), 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(magnetTime) max(magnetTime) min(magnetData(1,:)) max(magnetData(1,:))]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('X [microT]','FontName','Times New Roman','FontSize',17);
subplot(3,1,2);
plot(magnetTime, magnetData(2,:), 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(magnetTime) max(magnetTime) min(magnetData(2,:)) max(magnetData(2,:))]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('Y [microT]','FontName','Times New Roman','FontSize',17);
subplot(3,1,3);
plot(magnetTime, magnetData(3,:), 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(magnetTime) max(magnetTime) min(magnetData(3,:)) max(magnetData(3,:))]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('Z [microT]','FontName','Times New Roman','FontSize',17);
set(gcf,'Units','pixels','Position',[100 200 1800 900]);  % modify figure

% plot calibrated magnetic field update rate
timeDifference = diff(magnetTime);
meanUpdateRate = (1/mean(timeDifference));
figure;
plot(magnetTime(2:end), timeDifference, 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(magnetTime) max(magnetTime) min(timeDifference) max(timeDifference)]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('Time Difference [sec]','FontName','Times New Roman','FontSize',17);
title(['Mean Update Rate: ', num2str(meanUpdateRate), ' Hz'],'FontName','Times New Roman','FontSize',17);
set(gcf,'Units','pixels','Position',[100 200 1800 900]);  % modify figure


%% 10) raw magnetic field

% parsing raw magnetic field text
textFileDir = '20190830040751R_pjinkim_magnet_uncalib.txt';
textRawMagnetData = importdata(textFileDir, delimiter, headerlinesIn);
rawMagnetTime = textRawMagnetData.data(:,1).';
rawMagnetTime = (rawMagnetTime - rawMagnetTime(1)) ./ nanoSecondToSecond;
rawMagnetData = textRawMagnetData.data(:,[2 3 4]).';

% plot raw magnetic field X-Y-Z
figure;
subplot(3,1,1);
plot(rawMagnetTime, rawMagnetData(1,:), 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(rawMagnetTime) max(rawMagnetTime) min(rawMagnetData(1,:)) max(rawMagnetData(1,:))]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('X [microT]','FontName','Times New Roman','FontSize',17);
subplot(3,1,2);
plot(rawMagnetTime, rawMagnetData(2,:), 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(rawMagnetTime) max(rawMagnetTime) min(rawMagnetData(2,:)) max(rawMagnetData(2,:))]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('Y [microT]','FontName','Times New Roman','FontSize',17);
subplot(3,1,3);
plot(rawMagnetTime, rawMagnetData(3,:), 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(rawMagnetTime) max(rawMagnetTime) min(rawMagnetData(3,:)) max(rawMagnetData(3,:))]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('Z [microT]','FontName','Times New Roman','FontSize',17);
set(gcf,'Units','pixels','Position',[100 200 1800 900]);  % modify figure

% plot raw magnetic field update rate
timeDifference = diff(rawMagnetTime);
meanUpdateRate = (1/mean(timeDifference));
figure;
plot(rawMagnetTime(2:end), timeDifference, 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(rawMagnetTime) max(rawMagnetTime) min(timeDifference) max(timeDifference)]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('Time Difference [sec]','FontName','Times New Roman','FontSize',17);
title(['Mean Update Rate: ', num2str(meanUpdateRate), ' Hz'],'FontName','Times New Roman','FontSize',17);
set(gcf,'Units','pixels','Position',[100 200 1800 900]);  % modify figure








