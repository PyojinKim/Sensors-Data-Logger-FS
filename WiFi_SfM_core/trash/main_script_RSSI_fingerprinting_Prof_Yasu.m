clc;
close all;
clear variables; %clear classes;
rand('state',0); % rand('state',sum(100*clock));
dbstop if error;

addpath('devkit_KITTI_GPS');


%% 1) build consistent WiFi RSSI vector and Google FLP in global inertial frame

% load dataset lists
expCase = 2;
setupParams_WiFi_SfM;
datasetList = loadDatasetList(datasetPath);


% load unique WiFi RSSID Map
load([datasetPath '/uniqueWiFiAPsBSSID.mat']);


% load labeled WiFi scan result
numDatasetList = size(datasetList,1);
datasetWiFiScanResult = cell(1,numDatasetList);
for k = 1:numDatasetList
    
    % extract WiFi centric data with Google FLP
    datasetDirectory = [datasetPath '/' datasetList(k).name];
    wifiScanResult = extractWiFiCentricData(datasetDirectory, uniqueWiFiAPsBSSID);
    
    % save WiFi scan result
    datasetWiFiScanResult{k} = wifiScanResult;
end


% convert lat/lon coordinates (deg) to mercator coordinates (m)
wifiScanResult = datasetWiFiScanResult{1};
GoogleFLPResult = [wifiScanResult(:).FLPLocation];

scale = latToScale(GoogleFLPResult(1,1));
latitude = GoogleFLPResult(1,1);
longitude = GoogleFLPResult(2,1);
[X_origin,Y_origin] = latlonToMercator(latitude, longitude, scale);
for k = 1:numDatasetList
    
    % Google FLP location in meter
    wifiScanResult = datasetWiFiScanResult{k};
    GoogleFLPLocationDegree = [wifiScanResult(:).FLPLocation];
    latitude = GoogleFLPLocationDegree(1,:);
    longitude = GoogleFLPLocationDegree(2,:);
    
    [X,Y] = latlonToMercator(latitude, longitude, scale);
    X = X - X_origin;
    Y = Y - Y_origin;
    GoogleFLPLocationMeter = [X;Y];
    
    
    % save Google FLP conversion result
    for m = 1:size(wifiScanResult,2)
        wifiScanResult(m).FLPLocation = GoogleFLPLocationMeter(:,m);
        wifiScanResult(m).FLPLocationDegree = GoogleFLPLocationDegree(:,m);
    end
    datasetWiFiScanResult{k} = wifiScanResult;
end


% plot Google FLP location with WiFi RSSI scan location together
distinguishableColors = distinguishable_colors(numDatasetList);
figure; hold on;
for k = 1:numDatasetList
    wifiScanLocation = [datasetWiFiScanResult{k}.FLPLocationDegree];
    plot(wifiScanLocation(2,:), wifiScanLocation(1,:),'d','color',distinguishableColors(k,:),'LineWidth',2.5);
end
plot_google_map('maptype', 'roadmap', 'APIKey', 'AIzaSyB_uD1rGjX6MJkoQgSDyjHkbdu-b-_5Bjg');
set(gcf,'Units','pixels','Position',[150 60 1700 900]);  % modify figure


% plot multiple Google FLP results in meter
figure; hold on; grid on; axis equal;
for k = 1:numDatasetList
    wifiScanLocation = [datasetWiFiScanResult{k}.FLPLocation];
    plot(wifiScanLocation(1,:), wifiScanLocation(2,:),'d','color',distinguishableColors(k,:),'LineWidth',2.5);
end
xlabel('X [m]','FontName','Times New Roman','FontSize',15);
ylabel('Y [m]','FontName','Times New Roman','FontSize',15);
set(gcf,'Units','pixels','Position',[150 60 1700 900]);  % modify figure


%% 2) RSSI Fingerprinting Localization with query RSSI vector

% construct WiFi fingerprint database
wifiFingerprintDatabase = [];
numDataset = size(datasetWiFiScanResult,2);
for k = 1:(numDataset - 1)
    wifiFingerprintDatabase = [wifiFingerprintDatabase, datasetWiFiScanResult{k}];
end


% choose test WiFi scan dataset for WiFi localization
testWiFiScanResult = datasetWiFiScanResult{numDataset};
numTestWiFiScan = size(testWiFiScanResult,2);
for queryIndex = 1:numTestWiFiScan
    
    % current RSSI vector and true position from Tango VIO
    queryRSSI = testWiFiScanResult(queryIndex).RSSI;
    trueLocation = testWiFiScanResult(queryIndex).trueLocation;
    
    % query RSSI vector against WiFi fingerprint database
    [queryLocation, maxRewardIndex, rewardResult] = queryWiFiRSSI(queryRSSI, wifiFingerprintDatabase);
    
    % save the query result
    testWiFiScanResult(queryIndex).queryLocation = queryLocation;
    testWiFiScanResult(queryIndex).maxRewardIndex = maxRewardIndex;
    testWiFiScanResult(queryIndex).rewardResult = rewardResult;
    testWiFiScanResult(queryIndex).errorLocation = norm(queryLocation - trueLocation);
end



































%% 1) read RoNIN and Google FLP data


numDatasetList = 14;
datasetGoogleFLPResult = cell(1,numDatasetList);


k = 3


% extract RoNIN data
expCase = k;
setupParams_alignment_Prof_Yasu;
roninResult = extractRoninOnlyData(datasetDirectory, roninInterval, roninYawRotation);


% detect and remove RoNIN stationary motion
speed = 0.1;             % m/s
duration = 5.0;          % sec
roninResult = detectStationaryMotion(roninResult, speed, duration);
roninResult = removeStationaryMotion(roninResult);
roninResult = roninResult(validRoninIndex);


% separate RoNIN moving trajectory part
movement = 4.0;        % m
displacement = 3.5;     % m
movingTrajectoryIndex = seperateRoninMovingTrajectory(roninResult, movement, displacement);


% separate Google FLP moving trajectory part
GoogleFLPResult = [];
GoogleFLPAccuracy = [];
for m = 1:size(movingTrajectoryIndex,2)
    roninMovingPart = roninResult(movingTrajectoryIndex{m});
    roninMovingFLPLocation = [roninMovingPart(:).FLPLocation];
    roninMovingFLPAccuracy = [roninMovingPart(:).FLPAccuracy];
    
    GoogleFLPResult = [GoogleFLPResult, roninMovingFLPLocation];
    GoogleFLPAccuracy = [GoogleFLPAccuracy, roninMovingFLPAccuracy];
end


% convert lat/lon coordinates (deg) to mercator coordinates (m)
scale = latToScale(GoogleFLPResult(1,1));
latitude = GoogleFLPResult(1,:);
longitude = GoogleFLPResult(2,:);
[X,Y] = latlonToMercator(latitude, longitude, scale);
GoogleFLPRadius = cell(1,size(GoogleFLPResult,2));
for k = 1:size(GoogleFLPResult,2)
    [lon, lat] = convertAccuracyDegree(X(k), Y(k), GoogleFLPAccuracy(k), scale);
    GoogleFLPRadius{k} = [lon; lat];
end


% plot multiple Google FLP results on Google Map
figure; hold on;
plot(GoogleFLPResult(2,:), GoogleFLPResult(1,:),'m*-','LineWidth',2.5);
for k = 1:size(GoogleFLPResult,2)
    temp = GoogleFLPRadius{k};
    plot(temp(1,:), temp(2,:), 'b--','LineWidth',0.5);
end
plot_google_map('maptype', 'roadmap', 'APIKey', 'AIzaSyB_uD1rGjX6MJkoQgSDyjHkbdu-b-_5Bjg');
set(gcf,'Units','pixels','Position',[150 60 1700 900]);  % modify figure











k = 121
temp = GoogleFLPRadius{k};
plot(temp(1,:), temp(2,:), 'm-','LineWidth',2.5);



% convert lat/lon coordinates (deg) to mercator coordinates (m)
scale = latToScale(datasetGoogleFLPResult{1}(1,1));
latitude = datasetGoogleFLPResult{1}(1,1);
longitude = datasetGoogleFLPResult{1}(2,1);
[X_origin,Y_origin] = latlonToMercator(latitude, longitude, scale);

datasetGoogleFLPMeterResult = cell(1,numDatasetList);
for k = 1:numDatasetList
    latitude = datasetGoogleFLPResult{k}(1,:);
    longitude = datasetGoogleFLPResult{k}(2,:);
    [X,Y] = latlonToMercator(latitude, longitude, scale);
    
    X = X - X_origin;
    Y = Y - Y_origin;
    datasetGoogleFLPMeterResult{k} = [X;Y];
end


% plot multiple Google FLP results on Google Map
distinguishableColors = distinguishable_colors(numDatasetList);
figure; hold on;
for k = 1:numDatasetList
    GoogleFLPResult = datasetGoogleFLPResult{k};
    plot(GoogleFLPResult(2,:), GoogleFLPResult(1,:),'color',distinguishableColors(k,:),'LineWidth',2.5);
end
plot_google_map('maptype', 'roadmap', 'APIKey', 'AIzaSyB_uD1rGjX6MJkoQgSDyjHkbdu-b-_5Bjg');
set(gcf,'Units','pixels','Position',[150 60 1700 900]);  % modify figure


% plot multiple Google FLP results in meter
figure; hold on; grid on; axis equal;
for k = 1:numDatasetList
    GoogleFLPMeterResult = datasetGoogleFLPMeterResult{k};
    plot(GoogleFLPMeterResult(1,:), GoogleFLPMeterResult(2,:),'color',distinguishableColors(k,:),'LineWidth',2.5);
end
xlabel('X [m]','FontName','Times New Roman','FontSize',15);
ylabel('Y [m]','FontName','Times New Roman','FontSize',15);
set(gcf,'Units','pixels','Position',[150 60 1700 900]);  % modify figure



% % remove invalid Google FLP data
% for k = 1:numDatasetList
%
%     GoogleFLPMeterResult = datasetGoogleFLPMeterResult{k};
%
%     numGoogleFLP = size(GoogleFLPMeterResult,2);
%     invalidIndex = [];
%     temp = zeros(1,numGoogleFLP);
%     for m = 2:numGoogleFLP
%
%
%         temp(m) = norm(GoogleFLPMeterResult(:,m) - GoogleFLPMeterResult(:,m-1));
%
%     end
%
%     invalidIndex = (temp > 25.0);
%
%     GoogleFLPMeterResult(:,invalidIndex) = [];
%
%
%
%
% end







