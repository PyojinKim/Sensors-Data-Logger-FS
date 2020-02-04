function [stationaryPointMap] = constructStationaryMap(stationaryPoint, rewardThreshold)


%
numStationaryPoint = size(stationaryPoint,2);
stationaryPointMap = struct('index',cell(1,numStationaryPoint));


% first stationary point
stationaryPointMap(1).index = stationaryPoint(1).index;
stationaryPointMap(1).wifiScanRSSI = stationaryPoint(1).wifiScanRSSI;
stationaryPoint(1) = [];
for k = size(stationaryPoint,2):-1:1
    reward = computeRewardMetric(stationaryPointMap(1).wifiScanRSSI, stationaryPoint(k).wifiScanRSSI);
    if (reward >= rewardThreshold)
        stationaryPointMap(1).index = [stationaryPointMap(1).index, stationaryPoint(k).index];
        stationaryPoint(k) = [];
    end
end


% second stationary point
stationaryPointMap(2).index = stationaryPoint(1).index;
stationaryPointMap(2).wifiScanRSSI = stationaryPoint(1).wifiScanRSSI;
stationaryPoint(1) = [];
for k = size(stationaryPoint,2):-1:1
    reward = computeRewardMetric(stationaryPointMap(2).wifiScanRSSI, stationaryPoint(k).wifiScanRSSI);
    if (reward >= rewardThreshold)
        stationaryPointMap(2).index = [stationaryPointMap(2).index, stationaryPoint(k).index];
        stationaryPoint(k) = [];
    end
end


% third stationary point
stationaryPointMap(3).index = stationaryPoint(1).index;
stationaryPointMap(3).wifiScanRSSI = stationaryPoint(1).wifiScanRSSI;
stationaryPoint(1) = [];


stationaryPointMap(4:end) = [];


end

