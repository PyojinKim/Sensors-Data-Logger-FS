


%%

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



%%


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
    subplot(2,5,k);
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
    subplot(2,5,k);
    plot(roninFLPLocation(2,:), roninFLPLocation(1,:),'b','LineWidth',1.0); hold on;
    plot_google_map('maptype', 'roadmap', 'APIKey', 'AIzaSyB_uD1rGjX6MJkoQgSDyjHkbdu-b-_5Bjg');
    plot(roninMovingFLPLocation(2,:), roninMovingFLPLocation(1,:),'m','LineWidth',3.5);
    title(sprintf('Moving Index: %02d',k));
    xlabel(sprintf('%.1f [s]',duration));
end
set(gcf,'Units','pixels','Position',[150 60 1700 900]);  % modify figure


%%


% plot RoNIN moving trajectories
figure; hold on; grid on; axis equal;
for k = 1:size(movingTrajectoryIndex,2)
    
    % current moving trajectory
    roninMovingResult = roninResult(movingTrajectoryIndex{k});
    roninMovingLocation = [roninMovingResult(:).location];

    % draw moving trajectory
    plot(roninMovingLocation(1,:),roninMovingLocation(2,:),'m-','LineWidth',2.5);
end
set(gcf,'Units','pixels','Position',[150 60 1700 900]);  % modify figure

% plot RoNIN moving trajectories
figure; hold on; grid on; axis equal;
for k = 1:size(movingTrajectoryIndex,2)
    
    % current moving trajectory
    roninMovingResult = roninResult(movingTrajectoryIndex{k});
    roninMovingFLPLocation = [roninMovingResult(:).FLPLocation];
    if (isempty(roninMovingFLPLocation))
        continue;
    end
    

    % draw moving trajectory
    plot(roninMovingFLPLocation(1,:),roninMovingFLPLocation(2,:),'b*-','LineWidth',1.5);
end
set(gcf,'Units','pixels','Position',[150 60 1700 900]);  % modify figure




% re-package RoNIN data for figures
roninLocation = [roninMovingPart(:).location];
roninFLPLocation = [roninMovingPart(:).FLPLocation];


% plot RoNIN 2D trajectory (left) & GPS trajectory on Google map (right)
h_plot = figure;
plot(roninLocation(1,:),roninLocation(2,:),'m-','LineWidth',2.5); hold on; grid on; axis equal; axis tight;
plot(roninFLPLocation(1,:), roninFLPLocation(2,:),'b*-','LineWidth',1.5); hold on;
xlabel('X [m]','FontName','Times New Roman','FontSize',15);
ylabel('Y [m]','FontName','Times New Roman','FontSize',15);






% re-package RoNIN data for figures
roninLocation = [roninResult(:).location];
roninFLPLocation = [roninResult(:).FLPLocation];


% plot RoNIN 2D trajectory (left) & GPS trajectory on Google map (right)
h_plot = figure;
plot(roninLocation(1,:),roninLocation(2,:),'m-','LineWidth',2.5); hold on; grid on; axis equal; axis tight;
plot(roninFLPLocation(1,:), roninFLPLocation(2,:),'b*-','LineWidth',1.0); hold on;
xlabel('X [m]','FontName','Times New Roman','FontSize',15);
ylabel('Y [m]','FontName','Times New Roman','FontSize',15);




%%













%%



for k = 1:size(roninMovingPart,2)
    if (~isempty(roninMovingPart(k).FLPLocation))
        locationDifference = (roninMovingPart(k).FLPLocation - roninMovingPart(k).location);
        break;
    end
end

for k = 1:size(roninMovingPart,2)
    roninMovingPart(k).location = roninMovingPart(k).location + locationDifference;
end















%%

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
















