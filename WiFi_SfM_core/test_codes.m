clc;
close all;
clear variables; %clear classes;
rand('state',0); % rand('state',sum(100*clock));
dbstop if error;

addpath('devkit_KITTI_GPS');


%%




roninResult = parseRoninTextFile('ronin.txt');
wifiScanResult = parseWiFiTextFile('wifi.txt');


%



roninLocation = [roninResult(:).location];



% plot horizontal position trajectory in global inertial frame (meter) - before
figure;
plot(roninLocation(1,:),roninLocation(2,:),'m-','LineWidth',1.0); grid on; axis equal;
xlabel('x [m]','fontsize',10); ylabel('y [m]','fontsize',10);


GoogleFLPResult = parseGoogleFLPTextFile('FLP.txt');
locationDegree = [GoogleFLPResult(:).locationDegree];


% plot horizontal position (latitude / longitude) trajectory on Google map
figure;
plot(locationDegree(2,:), locationDegree(1,:), 'b*-', 'LineWidth', 1); hold on;
plot_google_map('maptype', 'roadmap', 'APIKey', 'AIzaSyB_uD1rGjX6MJkoQgSDyjHkbdu-b-_5Bjg');
xlabel('Longitude [deg]','FontName','Times New Roman','FontSize',17);
ylabel('Latitude [deg]','FontName','Times New Roman','FontSize',17);



%%

dataInterval = 100;
roninTime = [roninResult(:).timestamp];
roninLocation = [roninResult(:).location];



% plot update rate of device orientation
timeDifference = diff(roninTime);
meanUpdateRate = (1/mean(timeDifference));
figure;
plot(roninTime(2:end), timeDifference, 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(roninTime) max(roninTime) min(timeDifference) max(timeDifference)]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('Time Difference [sec]','FontName','Times New Roman','FontSize',17);
title(['Mean Update Rate: ', num2str(meanUpdateRate), ' Hz'],'FontName','Times New Roman','FontSize',17);
set(gcf,'Units','pixels','Position',[100 200 1800 900]);  % modify figure





% plot 2D RoNIN location
figure;
subplot(2,1,1);
plot(roninTime, roninLocation(1,:),'m'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(roninTime) max(roninTime) min(roninLocation(1,:)) max(roninLocation(1,:))]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('X [m]','FontName','Times New Roman','FontSize',17);
subplot(2,1,2);
plot(roninTime, roninLocation(2,:),'m'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(roninTime) max(roninTime) min(roninLocation(2,:)) max(roninLocation(2,:))]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('Y [m]','FontName','Times New Roman','FontSize',17);
set(gcf,'Units','pixels','Position',[100 200 1800 900]);  % modify figure





