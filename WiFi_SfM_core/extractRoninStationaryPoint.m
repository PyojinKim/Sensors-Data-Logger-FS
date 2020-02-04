function [stationaryPoint] = extractRoninStationaryPoint(roninResult, stationaryPointIndex, uniqueWiFiAPsBSSID)

% extract RoNIN stationary point
numStationaryPoint = size(stationaryPointIndex,2);
stationaryPoint = struct('index',cell(1,numStationaryPoint));
for k = 1:numStationaryPoint
    
    % extract RoNIN on stationary point
    stationaryIndex = stationaryPointIndex{k};
    roninPartialResult = roninResult(stationaryIndex);
    numRoninPartial = size(roninPartialResult,2);
    
    
    % WiFi RSSI vector construction
    wifiScanResult = struct('timestamp', cell(1,numRoninPartial));
    numWiFiScan = 0;
    for m = 1:numRoninPartial
        if (isempty(roninPartialResult(m).wifiAPsResult))
            continue;
        else
            numWiFiScan = numWiFiScan + 1;
            wifiScanResult(numWiFiScan).timestamp = roninPartialResult(m).timestamp;
            wifiScanResult(numWiFiScan).wifiAPsResult = roninPartialResult(m).wifiAPsResult;
            wifiScanResult(numWiFiScan).numberOfAPs = size(roninPartialResult(m).wifiAPsResult,2);
        end
    end
    wifiScanResult((numWiFiScan+1):end) = [];
    wifiScanResult = vectorizeWiFiRSSI(wifiScanResult, uniqueWiFiAPsBSSID);
    wifiScanRSSI = max([wifiScanResult(:).RSSI],[],2);
    
    
    % save RoNIN index and WiFi RSSI vector
    stationaryPoint(k).index = [stationaryIndex(1), stationaryIndex(end)];
    stationaryPoint(k).wifiScanRSSI = wifiScanRSSI;
end


end

