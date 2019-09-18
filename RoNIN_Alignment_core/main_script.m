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


setupParams_Smartphone_Dataset;


% load smartphone dataset data
rawDeviceDataset = loadRawSmartphoneDataset(datasetPath);


% time




%% load ground truth data


% ground truth trajectory in ICL NUIM dataset
R_gc_true = zeros(3,3,M);
p_gc_true = zeros(3,M);
T_gc_true = cell(1,M);
for k = 1:M
    % camera body frame
    R_gc_true(:,:,k) = q2r(ICLNUIMdataset.vicon.q_gc_Sync(:,k));
    p_gc_true(:,k) = ICLNUIMdataset.vicon.p_gc_Sync(:,k);
    T_gc_true{k} = [ R_gc_true(:,:,k), p_gc_true(:,k);
        zeros(1,3),           1; ];
end
if (toVisualize)
    figure; hold on; axis equal;
    L = 0.1; % coordinate axis length
    A = [0 0 0 1; L 0 0 1; 0 0 0 1; 0 L 0 1; 0 0 0 1; 0 0 L 1]';
    
    for k = 1:10:M
        T = T_gc_true{k};
        B = T * A;
        plot3(B(1,1:2),B(2,1:2),B(3,1:2),'-r','LineWidth',1); % x: red
        plot3(B(1,3:4),B(2,3:4),B(3,3:4),'-g','LineWidth',1); % y: green
        plot3(B(1,5:6),B(2,5:6),B(3,5:6),'-b','LineWidth',1); % z: blue
    end
    plot3(p_gc_true(1,:),p_gc_true(2,:),p_gc_true(3,:),'k','LineWidth',2);
    
    title('ground truth trajectory of cam0 frame')
    xlabel('x'); ylabel('y'); zlabel('z');
end





%%


figure;
plot(deviceRoninTrajectory(1,:), deviceRoninTrajectory(2,:),'m','LineWidth',2); hold on; grid on;
legend('RoNIN'); axis equal;
xlabel('x [m]','fontsize',12); ylabel('y [m]','fontsize',12); hold off;

figure;
subplot(2,1,1);
plot(deviceRoninTime, deviceRoninTrajectory(1,:), 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(deviceRoninTime) max(deviceRoninTime) min(deviceRoninTrajectory(1,:)) max(deviceRoninTrajectory(1,:))]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('X [m]','FontName','Times New Roman','FontSize',17);
subplot(2,1,2);
plot(deviceRoninTime, deviceRoninTrajectory(2,:), 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(deviceRoninTime) max(deviceRoninTime) min(deviceRoninTrajectory(2,:)) max(deviceRoninTrajectory(2,:))]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('Y [m]','FontName','Times New Roman','FontSize',17);
set(gcf,'Units','pixels','Position',[100 200 1800 900]);  % modify figure


%%

% parsing device WiFi scan results
[deviceWiFiScanResults] = loadWiFiScanResults('20190830040751R_pjinkim_wifi.txt', deviceReferenceTime);


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














