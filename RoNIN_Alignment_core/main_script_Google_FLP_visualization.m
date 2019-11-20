clc;
close all;
clear variables; %clear classes;
rand('state',0); % rand('state',sum(100*clock));
dbstop if error;


%% common setting to read text files

delimiter = ' ';
headerlinesIn = 1;
nanoSecondToSecond = 1000000000;


%% 1) Fused Location Provider by Google (FLP)

addpath('devkit_KITTI_GPS');

% import FLP text file
textFLPData = importdata('FLP.txt', delimiter, headerlinesIn);
FLPTimeSec = textFLPData.data(:,1).';
FLPTimeSec = (FLPTimeSec - FLPTimeSec(1)) ./ nanoSecondToSecond;
FLPHorizontalPositionDegree = textFLPData.data(:,[2 3]).';
FLPHorizontalAccuracyMeter = textFLPData.data(:,4).';
numData = size(FLPHorizontalPositionDegree,2);

% convert lat/lon coordinates (deg) to mercator coordinates (m)
scale = latToScale(FLPHorizontalPositionDegree(1,1));
latitude = FLPHorizontalPositionDegree(1,:);
longitude = FLPHorizontalPositionDegree(2,:);
[X,Y] = latlonToMercator(latitude, longitude, scale);
FLPHorizontalPositionMeter = [X;Y];

% plot horizontal position (latitude / longitude) trajectory on Google map
figure;
plot(FLPHorizontalPositionDegree(2,:), FLPHorizontalPositionDegree(1,:), 'k*-', 'LineWidth', 1); hold on;
plot_google_map('maptype', 'roadmap', 'APIKey', 'AIzaSyB_uD1rGjX6MJkoQgSDyjHkbdu-b-_5Bjg');


%% 2) Google FLP video clip

% plot horizontal position (latitude / longitude) trajectory on Google map
h = figure(10);
plot_google_map('maptype', 'roadmap', 'APIKey', 'AIzaSyB_uD1rGjX6MJkoQgSDyjHkbdu-b-_5Bjg'); hold on;
xlabel('Longitude [deg]','FontName','Times New Roman','FontSize',17);
ylabel('Latitude [deg]','FontName','Times New Roman','FontSize',17);

%axis([-122.8968 -122.8944   49.2504   49.2519]) % 20191111_01_Lougheed_Mall_Tango
%axis([-122.8969 -122.8943   49.2503   49.2518]) % 20191111_02_Lougheed_Mall_Tango
%axis([-122.8967 -122.8944   49.2504   49.2518]) % 20191111_02_Lougheed_Mall_Galaxy_S9
%axis([-122.8966 -122.8945   49.2507   49.2519]) % 20191111_03_Lougheed_Mall_Tango
%axis([-122.8968 -122.8943   49.2506   49.2521]) % 20191111_03_Lougheed_Mall_Galaxy_S9
%axis([-122.8946 -122.8928   49.2518   49.2531]) % 20191117_01_Save_On_Foods
%axis([127.0570  127.0617   37.5100   37.5135]) % 20191031_02_COEX_Seoul_Galaxy_S9
axis([-122.9217 -122.9083   49.2747   49.2808]) % 20191004_05_SFU_Home_Galaxy_S9

set(gcf,'Units','pixels','Position',[400 200 1000 700]);  % modify figure


for k = 1:numData
    %% prerequisite to visualize
    
    % current FLP information
    currentTime = FLPTimeSec(k);
    currentLatitude = FLPHorizontalPositionDegree(1,k);
    currentLongitude = FLPHorizontalPositionDegree(2,k);
    currentRadius = FLPHorizontalAccuracyMeter(k);
    currentTrajectory = FLPHorizontalPositionDegree([2 1],1:k);
    
    % draw moving trajectory
    h_FLP_history = plot(currentTrajectory(1,:), currentTrajectory(2,:), 'k*-', 'LineWidth', 1);
    h_FLP_location = plot(currentLongitude, currentLatitude,'bo','LineWidth',7);
    
    % draw uncertainty radius on lat/lon
    currentPositionMeterX = FLPHorizontalPositionMeter(1,k);
    currentPositionMeterY = FLPHorizontalPositionMeter(2,k);
    [lon, lat] = convertAccuracyDegree(currentPositionMeterX, currentPositionMeterY, currentRadius, scale);
    h_FLP_radius = plot(lon, lat, 'b','LineWidth',3);
    
    % draw text information
    xt = [currentLongitude+0.00010, currentLongitude+0.00010];
    yt = [currentLatitude+0.00015, currentLatitude+0.00010];
    str = {sprintf('time (s): %.2f', currentTime),sprintf('uncertainty (m): %.2f', currentRadius)};
    h_FLP_text = text(xt, yt, str,'FontSize',15,'FontWeight','bold');
    
    
    %% save current figure
    
    if (true)
        % save directory for MAT data
        SaveDir = [pwd '\temp'];
        if (~exist( SaveDir, 'dir' ))
            mkdir(SaveDir);
        end
        
        % save directory for images
        SaveImDir = [SaveDir '/FLP'];
        if (~exist( SaveImDir, 'dir' ))
            mkdir(SaveImDir);
        end
        
        refresh; pause(0.5);
        saveImg = getframe(h);
        imwrite(saveImg.cdata , [SaveImDir sprintf('/%06d.png', k)]);
    end
    
    %% remove FLP plots
    
    delete(h_FLP_history);
    delete(h_FLP_location);
    delete(h_FLP_radius);
    delete(h_FLP_text);
end



