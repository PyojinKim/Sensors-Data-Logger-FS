



%% analyze the RoNIN trajectory


roninLocation = [roninResult(:).location];

% plot RoNIN 2D trajectory
figure;
plot(roninLocation(1,:),roninLocation(2,:),'m-','LineWidth',2.0); hold on; grid on; axis equal;


h_plot = figure;
plot(roninLocation(1,:),roninLocation(2,:),'k-','LineWidth',2.0); hold on; grid on; axis equal;
for k = 1:numRonin
    
    plot(roninLocation(1,1:k), roninLocation(2,1:k),'m-','LineWidth',3.0);
    pause(0.1); refresh(h_plot);
    
    % save images
    % saveImg = getframe(h_plot);
    % imwrite(saveImg.cdata , sprintf('figures/%06d.png', k));
end


% vectorize RoNIN result for visualization
roninTime = [roninResult(:).timestamp];
roninLocation = [roninResult(:).location];
roninSpeed = [roninResult(:).speed];
roninOdometer = [roninResult(:).odometer];

dataWindowSize = 60;

% create figure frame for making video
h_RoNIN = figure(10);
set(h_RoNIN,'Color',[1 1 1]);
set(h_RoNIN,'Units','pixels','Position',[100 50 1800 900]);
ha1 = axes('Position',[0.04,0.06 , 0.50,0.90]); % [x_start, y_start, x_width, y_width]
ha2 = axes('Position',[0.58,0.56 , 0.40,0.40]); % [x_start, y_start, x_width, y_width]
ha3 = axes('Position',[0.58,0.06 , 0.40,0.40]); % [x_start, y_start, x_width, y_width]

for k = 16390:1:numRonin
    %%
    
    k
    
%     if (roninResult(k).isStationary)
%         continue;
%     end
    
    axes(ha1); cla;
    plot(roninLocation(1,:),roninLocation(2,:),'k-','LineWidth',1.0); hold on; grid on; axis equal;
    plot(roninLocation(1,1:k),roninLocation(2,1:k),'m-','LineWidth',2.0);
    plot(roninLocation(1,k),roninLocation(2,k),'bd','LineWidth',5);
    xlabel('x [m]','fontsize',15); ylabel('y [m]','fontsize',15);
    
    
    %%
    
    axes(ha2); cla;
    plot(roninSpeed((k-dataWindowSize):k),'m-','LineWidth',2.0); hold on; grid on; axis tight;
    plot(61, roninSpeed(k),'bd','LineWidth',5);
    ylabel('speed [m/s]','fontsize',15); ylim([0 1.2])
    
    %%
    
    axes(ha3); cla;
    plot(roninOdometer((k-dataWindowSize):k),'m-','LineWidth',2.0); hold on; grid on; axis tight;
    plot(61, roninOdometer(k),'bd','LineWidth',5);   
    ylabel('odometer [m]','fontsize',15);
    
    
    % save images
    pause(0.1); refresh;
    saveImg = getframe(h_RoNIN);
end



%%

% vectorize RoNIN result for visualization
roninTime = [roninResult(:).timestamp];
roninLocation = [roninResult(:).location];
roninVelocity = [roninResult(:).velocity];
roninSpeed = [roninResult(:).speed];

roninAcceleration = [roninResult(:).acceleration];
roninGyro = [roninResult(:).gyro];
roninGravity = [roninResult(:).gravity];
roninMagnet = [roninResult(:).magnet];

roninPressure = [roninResult(:).pressure];


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


figure;
subplot(2,1,1);
plot(roninTime, roninLocation(1,:)); grid on; axis tight;
subplot(2,1,2);
plot(roninTime, roninLocation(2,:)); grid on; axis tight;


figure;
subplot(3,1,1);
plot(roninTime, roninAcceleration(1,:)); grid on; axis tight;
subplot(3,1,2);
plot(roninTime, roninAcceleration(2,:)); grid on; axis tight;
subplot(3,1,3);
plot(roninTime, roninAcceleration(3,:)); grid on; axis tight;


figure;
subplot(3,1,1);
plot(roninTime, roninGyro(1,:)); grid on; axis tight;
subplot(3,1,2);
plot(roninTime, roninGyro(2,:)); grid on; axis tight;
subplot(3,1,3);
plot(roninTime, roninGyro(3,:)); grid on; axis tight;
















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


