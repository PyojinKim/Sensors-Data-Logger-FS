clc;
close all;
clear variables; %clear classes;
rand('state',0); % rand('state',sum(100*clock));
dbstop if error;


%%

delimiter = ' ';
headerlinesIn = 0;
nanoSecondToSecond = 1000000000;


% parsing RoNIN 2D trajectory
textFileDir = '20190830040751R_pjinkim_gsn.txt';
textRoninData = importdata(textFileDir, delimiter, headerlinesIn);
deviceRoninTime = textRoninData(:,1).';
deviceRoninTrajectory = textRoninData(:,[2:3]).';

% time synchronization
deviceReferenceTime = deviceRoninTime(1);
deviceRoninTime = (deviceRoninTime - deviceReferenceTime);


figure;
plot(deviceRoninTrajectory(1,:), deviceRoninTrajectory(2,:),'m','LineWidth',2); hold on; grid on;
legend('RoNIN'); axis equal;
xlabel('x [m]','fontsize',12); ylabel('y [m]','fontsize',12); hold off;


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
    set(h,'Units','pixels','Position',[85 150 1800 900]);
    ha1 = axes('Position',[0.02,0.55 , 0.3,0.4]);
    %axis off;
    ha2 = axes('Position',[0.35,0.55 , 0.3,0.4]);
    %axis off;
    ha3 = axes('Position',[0.68,0.55 , 0.3,0.4]);
    ha4 = axes('Position',[0.02,0.05 , 0.3,0.4]);
    % axis off;
    ha5 = axes('Position',[0.35,0.05 , 0.3,0.4]);
    ha6 = axes('Position',[0.68,0.05 , 0.3,0.4]);
    grid on; hold on;
end

for k = 517000:100:size(deviceRoninTrajectory,2)
    %% update RoNIN 2D trajectory
    
    axes(ha1); cla;
    p_gb_RoNIN = deviceRoninTrajectory(1:2,1:k);
    plot(p_gb_RoNIN(1,:), p_gb_RoNIN(2,:), 'm', 'LineWidth', 2); hold on; grid on; axis equal;
    xlabel('x [m]','fontsize',12); ylabel('y [m]','fontsize',12); hold off;
    refresh; pause(0.01); k
    
    %% update WiFi scan results
    
    
    
    
    
    
    %% update magnetic field values
    
    
    
    
    %% save current figure
    
    
    
    
    
end














