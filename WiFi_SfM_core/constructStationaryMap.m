function [stationaryPointMap] = constructStationaryMap(stationaryPoint, rewardThreshold)


% construct stationary point map by comparing WiFi RSSI vector
numStationaryPoint = size(stationaryPoint,2);
stationaryPointMap = struct('index',cell(1,numStationaryPoint));
count = 0;
while (true)
    
    % check stationaryPoint is empty or not
    if (isempty(stationaryPoint))
        break;
    end
    
    
    % initialize new stationary point
    count = count + 1;
    stationaryPointMap(count).index = stationaryPoint(1).index;
    stationaryPointMap(count).wifiScanRSSI = stationaryPoint(1).wifiScanRSSI;
    stationaryPoint(1) = [];
    
    
    % find similar stationary points
    for k = size(stationaryPoint,2):-1:1
        reward = computeRewardMetric(stationaryPointMap(count).wifiScanRSSI, stationaryPoint(k).wifiScanRSSI);
        if (reward >= rewardThreshold)
            stationaryPointMap(count).index = [stationaryPointMap(count).index, stationaryPoint(k).index];
            stationaryPoint(k) = [];
        end
    end
end
stationaryPointMap((count+1):end) = [];


end

