function [mapIndex] = checkStationaryPointMap(testIndex, stationaryPointMap)


% check test index in stationary point map
numStationaryPointMap = size(stationaryPointMap,2);
for k = 1:numStationaryPointMap
    if (sum(testIndex == stationaryPointMap(k).index))
        
        mapIndex = k;
        break;
    else
        mapIndex = [];
    end
end


end

