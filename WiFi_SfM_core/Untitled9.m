


RoninResidual(roninInitialLocation, roninPolarSpeed, roninPolarAngle, X)

% plot RoNIN 2D trajectory
figure;
for k = 1100:numRonin
    
    cla;
    
    plot(roninLocation(1,1:k),roninLocation(2,1:k),'m-','LineWidth',1.0); hold on; grid on; axis equal;
    
    axis([-6.3346  178.4729  -36.2499  109.5096]);
    
    refresh; pause(0.3);
    k
    
end



k = 1155
h = plot(roninLocation(1,k), roninLocation(2,k),'bs','MarkerSize',10,'MarkerEdgeColor','b','MarkerFaceColor','b');



delete(h)




% plot RoNIN 2D trajectory
figure;
plot(roninLocation(1,:),roninLocation(2,:),'m-','LineWidth',1.0); hold on; grid on; axis equal;
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',15);
xlabel('X [m]','FontName','Times New Roman','FontSize',15);
ylabel('Y [m]','FontName','Times New Roman','FontSize',15);
set(gcf,'Units','pixels','Position',[900 300 800 600]);  % modify figure


