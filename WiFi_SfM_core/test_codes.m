clc;
close all;
clear variables; %clear classes;
rand('state',0); % rand('state',sum(100*clock));
dbstop if error;

addpath('devkit_KITTI_GPS');


%% RoNIN

roninResult = parseRoninTextFile('ronin.txt', 100, 225);
roninResult = computeRoninVelocity(roninResult);
numRonin = size(roninResult,2);















% activity detection
speed = 0.1;     % m/s
duration = 5.0;  % sec
roninResult = detectStationaryMotion(roninResult, speed, duration);


% vectorize RoNIN result for visualization
roninTime = [roninResult(:).timestamp];
roninLocation = [roninResult(:).location];
roninVelocity = [roninResult(:).velocity];
roninSpeed = [roninResult(:).speed];


% plot RoNIN 2D trajectory
figure;
plot(roninLocation(1,:),roninLocation(2,:),'m-','LineWidth',1.0); hold on; grid on; axis equal;
for k = 1:numRonin
    if (roninResult(k).isStationary)
        plot(roninLocation(1,k), roninLocation(2,k),'bs','MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor','b');
    end
end
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',15);
xlabel('X [m]','FontName','Times New Roman','FontSize',15);
ylabel('Y [m]','FontName','Times New Roman','FontSize',15);
set(gcf,'Units','pixels','Position',[900 300 800 600]);  % modify figure




GoogleFLPResult = parseGoogleFLPTextFile('FLP.txt');
locationDegree = [GoogleFLPResult(:).locationDegree];


% plot horizontal position (latitude / longitude) trajectory on Google map
figure;
plot(locationDegree(2,:), locationDegree(1,:), 'b*-', 'LineWidth', 1); hold on;
plot_google_map('maptype', 'roadmap', 'APIKey', 'AIzaSyB_uD1rGjX6MJkoQgSDyjHkbdu-b-_5Bjg');
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',15);
xlabel('Longitude [deg]','FontName','Times New Roman','FontSize',15);
ylabel('Latitude [deg]','FontName','Times New Roman','FontSize',15);
set(gcf,'Units','pixels','Position',[900 300 800 600]);  % modify figure



%%




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


%%



k = 34563;


% create figure frame for making video
h_RoNIN = figure(10);
set(h_RoNIN,'Color',[1 1 1]);
set(h_RoNIN,'Units','pixels','Position',[100 50 1800 900]);
ha1 = axes('Position',[0.04,0.06 , 0.50,0.90]); % [x_start, y_start, x_width, y_width]
ha2 = axes('Position',[0.58,0.06 , 0.40,0.40]); % [x_start, y_start, x_width, y_width]
for k = 17500:5:numRonin
    %%
    
    axes(ha1); cla;
    plot(roninLocationTransformed(1,1:k),roninLocationTransformed(2,1:k),'m-','LineWidth',1.0); hold on; grid on; axis equal;
    plot(roninLocationTransformed(1,k),roninLocationTransformed(2,k),'bd','LineWidth',5);
    xlabel('x [m]','fontsize',15); ylabel('y [m]','fontsize',15);
    
    
    %%
    
    axes(ha2); cla;
    %     plot(roninTime(1:k), roninLocation(1,1:k),'m'); hold on; grid on; axis tight;
    %     plot(roninTime(k), roninLocation(1,k),'bd','LineWidth',5);
    
    plot(roninTime(1:k), roninSpeed(1,1:k),'m'); hold on; grid on; axis tight;
    plot(roninTime(k), roninSpeed(k),'bd','LineWidth',5);
    
    
    % save images
    pause(0.01); refresh;
    saveImg = getframe(h_RoNIN);
    
end


