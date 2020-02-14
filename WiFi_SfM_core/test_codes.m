

%
roninDatasetIndex = cell(1,numDatasetList);
for k = 1:numDatasetList
    roninDatasetIndex{k} = find([roninMovingPart(:).datasetIndex] == k);
end


% plot multiple RoNIN 2D trajectory
distinguishableColors = distinguishable_colors(numDatasetList);
figure; hold on; grid on; axis equal;
for k = 1:numDatasetList
    roninDatasetLocation = [roninLocation(:,roninDatasetIndex{k})];
    plot(roninDatasetLocation(1,:),roninDatasetLocation(2,:),'color',distinguishableColors(k,:),'LineWidth',2.5);
end
xlabel('x [m]','fontsize',10); ylabel('y [m]','fontsize',10); hold off;
set(gcf,'Units','pixels','Position',[900 300 800 600]);  % modify figure



%%

% plot RoNIN 2D trajectory with stationary points
distinguishableColors = distinguishable_colors(numDatasetList);
roninLocation = [roninMovingPart(:).location];



figure;
plot(roninLocation(1,:),roninLocation(2,:),'m-','LineWidth',2.0); hold on; grid on; axis equal;

k = 4
roninDatasetLocation = [roninLocation(:,roninDatasetIndex{k})];
plot(roninDatasetLocation(1,:),roninDatasetLocation(2,:),'d','color',distinguishableColors(k,:),'LineWidth',2.5);

set(gcf,'Units','pixels','Position',[900 300 800 600]);  % modify figure



%%

k = 3;


% extract RoNIN part
roninPartialResult = roninResult(stationaryPointMap(k).index);

roninLocation = [roninResult(:).location];
roninSegment = [roninPartialResult(:).location];
roninFLPLocation = [roninPartialResult(:).FLPLocation];


% plot RoNIN 2D trajectory
figure;
plot(roninLocation(1,:),roninLocation(2,:),'k-','LineWidth',1.0); hold on; grid on; axis equal;
plot(roninSegment(1,:),roninSegment(2,:),'md','LineWidth',2.5);
set(gcf,'Units','pixels','Position',[900 300 800 600]);  % modify figure


% plot horizontal position (latitude / longitude) trajectory on Google map
figure;
plot(roninFLPLocation(2,:), roninFLPLocation(1,:), 'b*-', 'LineWidth', 1); hold on;
plot_google_map('maptype', 'roadmap', 'APIKey', 'AIzaSyB_uD1rGjX6MJkoQgSDyjHkbdu-b-_5Bjg');
axis([-122.9151 -122.9133   49.2762   49.2773]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',15);
xlabel('Longitude [deg]','FontName','Times New Roman','FontSize',15);
ylabel('Latitude [deg]','FontName','Times New Roman','FontSize',15);
set(gcf,'Units','pixels','Position',[900 300 800 600]);  % modify figure




roninLocation = [roninResult(:).location];
roninLineSegment = [roninResult(mapIndex3).location];

% plot RoNIN 2D trajectory
figure;
plot(roninLocation(1,:),roninLocation(2,:),'k-','LineWidth',1.0); hold on; grid on; axis equal;
plot(roninLineSegment(1,:),roninLineSegment(2,:),'dm','LineWidth',2.5);
set(gcf,'Units','pixels','Position',[900 300 800 600]);  % modify figure




%%


% convert RoNIN polar coordinate for nonlinear optimization
roninPolarResult = convertRoninPolarCoordinate(roninMovingPart);
roninInitialLocation = roninPolarResult(1).location;
roninPolarSpeed = [roninPolarResult(:).speed];
roninPolarDeltaAngle = [roninPolarResult(:).deltaAngle];


% scale and bias model parameters for RoNIN drift correction
numRonin = size(roninPolarResult,2);
roninScale = ones(1,numRonin);
roninBias = zeros(1,numRonin);
X_initial = [roninScale, roninBias];
roninLocation = DriftCorrectedRoninDeltaAngleModel(roninInitialLocation, roninPolarSpeed, roninPolarDeltaAngle, X_initial);


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
tic
[vec,resnorm,residuals,exitflag] = lsqnonlin(@(x) EuclideanDistanceResidual_DeltaAngle(roninInitialLocation, roninPolarSpeed, roninPolarDeltaAngle, roninStationaryPointIndex, x),X_initial,[],[],options);
toc


% optimal scale and bias model parameters for RoNIN drift correction
X_optimized = vec;
roninResidual = EuclideanDistanceResidual_DeltaAngle(roninInitialLocation, roninPolarSpeed, roninPolarDeltaAngle, roninStationaryPointIndex, X_optimized);
roninLocation = DriftCorrectedRoninDeltaAngleModel(roninInitialLocation, roninPolarSpeed, roninPolarDeltaAngle, X_optimized);


% plot RoNIN 2D trajectory after nonlinear optimization
figure;
plot(roninLocation(1,:),roninLocation(2,:),'m-','LineWidth',2.0); hold on; grid on; axis equal;
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',15);
xlabel('X [m]','FontName','Times New Roman','FontSize',15);
ylabel('Y [m]','FontName','Times New Roman','FontSize',15);
title('After Optimization','FontName','Times New Roman','FontSize',15);
set(gcf,'Units','pixels','Position',[900 300 800 600]);  % modify figure


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


% datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Asus_Tango/SFU_TASC1_8000/20200114112923R_WiFi_SfM';
% roninYawRotation = 190;     % degree


residuals(1) = norm(roninLocation(:,1) - roninLocation(:,149));
residuals(2) = norm(roninLocation(:,149) - roninLocation(:,150));
residuals(3) = norm(roninLocation(:,150) - roninLocation(:,284));
residuals(4) = norm(roninLocation(:,284) - roninLocation(:,285));
residuals(5) = norm(roninLocation(:,285) - roninLocation(:,501));

residuals(6) = norm(roninLocation(:,58) - roninLocation(:,59));
residuals(7) = norm(roninLocation(:,59) - roninLocation(:,83));
residuals(8) = norm(roninLocation(:,83) - roninLocation(:,84));
residuals(9) = norm(roninLocation(:,84) - roninLocation(:,442));
residuals(10) = norm(roninLocation(:,442) - roninLocation(:,443));

residuals(11) = norm(roninLocation(:,202) - roninLocation(:,203));


% % 8002.2 office (origin)
% residuals(1) = norm(roninLocation(:,1) - roninLocation(:,154));
% residuals(2) = norm(roninLocation(:,1) - roninLocation(:,155));
% residuals(3) = norm(roninLocation(:,1) - roninLocation(:,287));
% residuals(4) = norm(roninLocation(:,1) - roninLocation(:,300));
% residuals(5) = norm(roninLocation(:,1) - roninLocation(:,332));
% residuals(6) = norm(roninLocation(:,1) - roninLocation(:,567));
% residuals(7) = norm(roninLocation(:,1) - roninLocation(:,570));
%
% % TASC1 corners
% residuals(8) = norm(roninLocation(:,20) - roninLocation(:,136));
% residuals(9) = norm(roninLocation(:,136) - roninLocation(:,347));
% residuals(10) = norm(roninLocation(:,347) - roninLocation(:,555));
% residuals(11) = norm(roninLocation(:,555) - roninLocation(:,169));
%
% residuals(12) = norm(roninLocation(:,173) - roninLocation(:,250));
% residuals(13) = norm(roninLocation(:,414) - roninLocation(:,431));
% residuals(14) = norm(roninLocation(:,179) - roninLocation(:,242));
% residuals(15) = norm(roninLocation(:,205) - roninLocation(:,210));
% residuals(16) = norm(roninLocation(:,94) - roninLocation(:,479));
% residuals(17) = norm(roninLocation(:,479) - roninLocation(:,525));
% residuals(18) = norm(roninLocation(:,43) - roninLocation(:,531));


%%
% datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20200109090901R_WiFi_SfM';
% roninYawRotation = 35;     % degree
%
%
% % some corners
% residuals(1) = norm(roninLocation(:,237) - roninLocation(:,1080));
% residuals(2) = norm(roninLocation(:,325) - roninLocation(:,950));
% residuals(3) = norm(roninLocation(:,420) - roninLocation(:,815));


%%
% datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Asus_Tango/SFU_TASC1_8000/20200113110654R_WiFi_SfM';
% roninYawRotation = 225;   % degree
%
%
% % 8002.2 office (origin)
% residuals(1) = norm(roninLocation(:,1) - roninLocation(:,256));
% residuals(2) = norm(roninLocation(:,1) - roninLocation(:,1024));
% residuals(3) = norm(roninLocation(:,1) - roninLocation(:,1194));
%
% % ASB corners
% residuals(4) = norm(roninLocation(:,405) - roninLocation(:,874));
% residuals(5) = norm(roninLocation(:,526) - roninLocation(:,753));
%
% % TASC1 corners
% residuals(6) = norm(roninLocation(:,291) - roninLocation(:,975));
% residuals(7) = norm(roninLocation(:,975) - roninLocation(:,1073));
% residuals(8) = norm(roninLocation(:,1073) - roninLocation(:,1131));
%
% residuals(9) = norm(roninLocation(:,18) - roninLocation(:,1046));
% residuals(10) = norm(roninLocation(:,1046) - roninLocation(:,1155));


