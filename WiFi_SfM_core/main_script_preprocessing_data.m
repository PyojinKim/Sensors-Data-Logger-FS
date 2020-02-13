clc;
close all;
clear variables; %clear classes;
rand('state',0); % rand('state',sum(100*clock));
dbstop if error;


%% 1) manual RoNIN alignment for global (consistent) inertial frame

% reference (global) RoNIN inertial frame
expCase = 1;
setupParams_alignment_SFU_TASC1_8000;
roninReference = parseRoninTextFile([datasetDirectory '/ronin.txt'], roninInterval, roninYawRotation);
roninReferencePath = [roninReference(:).location];


% test RoNIN data
expCase = 2;
setupParams_alignment_SFU_TASC1_8000;
roninTest = parseRoninTextFile([datasetDirectory '/ronin.txt'], roninInterval, roninYawRotation);
roninTestPath = [roninTest(:).location];


% transform RoNIN test path
R = angle2rotmtx([0;0;(deg2rad(yaw))]);
t = [tx; ty];
roninTestTransformedPath = R(1:2,1:2) * roninTestPath;
roninTestTransformedPath = roninTestTransformedPath + t;


% plot RoNIN 2D trajectory
figure;
plot(roninReferencePath(1,:),roninReferencePath(2,:),'k-','LineWidth',2.0); hold on; grid on; axis equal;
plot(roninTestTransformedPath(1,:),roninTestTransformedPath(2,:),'m-','LineWidth',2.0);
set(gcf,'Units','pixels','Position',[900 300 800 600]);  % modify figure


%% 2) build unique BSSID map for RSSI vectorization

% load dataset lists (Android Sensors-Data-Logger App from ASUS Tango)
expCase = 1;
setupParams_WiFi_SfM;
datasetList = dir(datasetPath);
datasetList(1:2) = [];


% parse all wifi.txt files
numDatasetList = size(datasetList,1);
datasetWiFiScanResult = cell(1,numDatasetList);
for k = 1:numDatasetList
    
    % parse wifi.txt file
    wifiTextFile = [datasetPath '/' datasetList(k).name '/wifi.txt'];
    wifiScanResult = parseWiFiTextFile(wifiTextFile);
    
    % save WiFi scan result
    datasetWiFiScanResult{k} = wifiScanResult;
end


% extract all recorded WiFi BSSID
tempWiFiAPsBSSID = strings(100000000,1);
count = 0;
for k = 1:numDatasetList
    
    % current WiFi scan result
    currentWiFiScanResult = datasetWiFiScanResult{k};
    numWiFiScan = size(currentWiFiScanResult,2);
    for m = 1:numWiFiScan
        
        % current number of APs
        numWiFiAPs = currentWiFiScanResult(m).numberOfAPs;
        for n = 1:numWiFiAPs
            
            % save current WiFi BSSID
            currentBSSID = convertCharsToStrings(currentWiFiScanResult(m).wifiAPsResult(n).BSSID);
            count = count + 1;
            tempWiFiAPsBSSID(count) = currentBSSID;
        end
    end
end
tempWiFiAPsBSSID((count+1):end) = [];


% find unique WiFi BSSID
uniqueWiFiAPsBSSID = unique(tempWiFiAPsBSSID);
numUniqueBSSID = size(uniqueWiFiAPsBSSID,1);


% save unique WiFi BSSID list (WiFi BSSID Map)
save([datasetPath '/uniqueWiFiAPsBSSID.mat'],'uniqueWiFiAPsBSSID');



