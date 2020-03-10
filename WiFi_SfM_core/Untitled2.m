





% re-package RoNIN data for figures
roninLocation = [roninMovingPart(:).location];
roninFLPLocation = [roninMovingPart(:).FLPLocation];


% plot RoNIN 2D trajectory (left) & GPS trajectory on Google map (right)
figure;
plot(roninLocation(1,:),roninLocation(2,:),'m-','LineWidth',2.5); hold on; grid on; axis equal;
plot(roninFLPLocation(1,:), roninFLPLocation(2,:),'k*-','LineWidth',1.0);
xlabel('X [m]','FontName','Times New Roman','FontSize',15);
ylabel('Y [m]','FontName','Times New Roman','FontSize',15);



















% plot RoNIN moving trajectories
figure;
for k = 1:size(movingTrajectoryIndex,2)
    
    % current moving trajectory
    roninMovingResult = roninResult(movingTrajectoryIndex{k});
    roninMovingLocation = [roninMovingResult(:).location];
    movement = computeRoninTravelingDistance(roninMovingResult);
    displacement = computeRoninEndtoEndDistance(roninMovingResult);
    duration = (roninMovingResult(end).timestamp - roninMovingResult(1).timestamp);
    
    % draw moving trajectory
    subplot(2,4,k);
    plot(roninLocation(1,:),roninLocation(2,:),'k','LineWidth',1.0); hold on; grid on; axis equal;
    plot(roninMovingLocation(1,:),roninMovingLocation(2,:),'m-','LineWidth',2.5); hold off;
    title(sprintf('Moving Index: %02d',k));
    xlabel(sprintf('%.1f [s] / %.1f [m] / %.1f [m]',duration, movement, displacement));
end
set(gcf,'Units','pixels','Position',[150 60 1700 900]);  % modify figure

figure;
for k = 1:size(movingTrajectoryIndex,2)
    
    % current moving trajectory
    roninMovingResult = roninResult(movingTrajectoryIndex{k});
    roninMovingFLPLocation = [roninMovingResult(:).FLPLocation];
    duration = (roninMovingResult(end).timestamp - roninMovingResult(1).timestamp);
    if (isempty(roninMovingFLPLocation))
        continue;
    end
    
    % draw moving trajectory
    subplot(2,2,k);
    plot(roninFLPLocation(2,:), roninFLPLocation(1,:),'b','LineWidth',1.0); hold on;
    plot_google_map('maptype', 'roadmap', 'APIKey', 'AIzaSyB_uD1rGjX6MJkoQgSDyjHkbdu-b-_5Bjg');
    plot(roninMovingFLPLocation(2,:), roninMovingFLPLocation(1,:),'m','LineWidth',3.5);
    title(sprintf('Moving Index: %02d',k));
    xlabel(sprintf('%.1f [s]',duration));
end
set(gcf,'Units','pixels','Position',[150 60 1700 900]);  % modify figure

% plot RoNIN stationary points
figure;
for k = 1:size(stationaryPointIndex,2)
    
    % current stationary trajectory
    roninStationaryResult = roninResult(stationaryPointIndex{k});
    roninStationaryLocation = [roninStationaryResult(:).location];
    movement = computeRoninTravelingDistance(roninStationaryResult);
    displacement = computeRoninEndtoEndDistance(roninStationaryResult);
    duration = (roninStationaryResult(end).timestamp - roninStationaryResult(1).timestamp);
    
    % draw stationary trajectory
    subplot(1,5,k);
    plot(roninLocation(1,:),roninLocation(2,:),'k','LineWidth',1.0); hold on; grid on; axis equal;
    plot(roninStationaryLocation(1,:),roninStationaryLocation(2,:),'md','LineWidth',4.0); hold off;
    title(sprintf('Stationary Index: %02d',k));
    xlabel(sprintf('%.1f [s] / %.1f [m] / %.1f [m]',duration, movement, displacement));
end
set(gcf,'Units','pixels','Position',[150 60 1700 900]);  % modify figure

figure;
for k = 1:size(stationaryPointIndex,2)
    
    % current stationary trajectory
    roninStationaryResult = roninResult(stationaryPointIndex{k});
    roninStationaryFLPLocation = [roninStationaryResult(:).FLPLocation];
    duration = (roninStationaryResult(end).timestamp - roninStationaryResult(1).timestamp);
    
    % draw stationary trajectory
    subplot(1,5,k);
    plot(roninFLPLocation(2,:), roninFLPLocation(1,:),'b','LineWidth',1.0); hold on;
    plot_google_map('maptype', 'roadmap', 'APIKey', 'AIzaSyB_uD1rGjX6MJkoQgSDyjHkbdu-b-_5Bjg');
    plot(roninStationaryFLPLocation(2,:), roninStationaryFLPLocation(1,:),'md','LineWidth',3.5);
    title(sprintf('Stationary Index: %02d',k));
    xlabel(sprintf('%.1f [s]',duration));
end
set(gcf,'Units','pixels','Position',[150 60 1700 900]);  % modify figure
