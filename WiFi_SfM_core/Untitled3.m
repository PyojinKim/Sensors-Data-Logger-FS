



EuclideanDistanceResidual(roninInitialLocation, roninPolarSpeed, roninPolarAngle, zeros(1,2400))




roninLocation = [roninResult(:).location];

% plot RoNIN 2D trajectory
h_plot = figure;
plot(roninLocation(1,:),roninLocation(2,:),'m-','LineWidth',2.0); hold on; grid on; axis equal;


for k = 1:numRonin
    
    if (k >= 2)
        delete(h);
    end
    
    h = plot(roninLocation(1,k), roninLocation(2,k),'kd','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','k');
    
    pause(0.01); refresh(h_plot);
    
    % save images
    saveImg = getframe(h_plot);
    imwrite(saveImg.cdata , sprintf('figures/%06d.png', k));
end


% plot RoNIN 2D trajectory
figure;
plot(roninLocation(1,:),roninLocation(2,:),'m-','LineWidth',2.0); hold on; grid on; axis equal;
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',15);
xlabel('X [m]','FontName','Times New Roman','FontSize',15);
ylabel('Y [m]','FontName','Times New Roman','FontSize',15);
title('Before Optimization','FontName','Times New Roman','FontSize',15);
set(gcf,'Units','pixels','Position',[900 300 800 600]);  % modify figure



delete(h);

k = 420;
h = plot(roninLocation(1,k), roninLocation(2,k),'kd','MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor','k');




officeDesktopIndex = [1, 154, 155, 287, 300, 332, 567, 570];
officeDoorCornerIndex = [20, 136, 347, 555, 169];
officeMeetingRoomIndex = [205, 210];
corridorCorner_01_Index = [173, 250];
corridorCorner_02_Index = [179, 242];
corridorCorner_03_Index = [414, 431];
corridorCorner_04_Index = [43, 531];
toiletIndex = [94, 479, 525];



















