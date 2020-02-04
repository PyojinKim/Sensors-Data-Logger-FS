function [roninMovingPart] = extractRoninMovingTrajectory(roninResult, movingTrajectoryIndex, stationaryPointMap)

%
roninMovingPart = [];
numMovingTrajectory = size(movingTrajectoryIndex,2);
for k = 1:numMovingTrajectory
    
    % current RoNIN moving index
    movingIndex = movingTrajectoryIndex{k};
    headIndex = movingIndex(1);
    tailIndex = movingIndex(end);
    
    
    % label head stationary point index
    mapIndex = checkStationaryPointMap((headIndex-1), stationaryPointMap);
    roninResult(headIndex).isStationary = 1;
    roninResult(headIndex).stationaryPointIndex = mapIndex;
    
    
    % label tail stationary point index
    mapIndex = checkStationaryPointMap((tailIndex+1), stationaryPointMap);
    roninResult(tailIndex).isStationary = 1;
    roninResult(tailIndex).stationaryPointIndex = mapIndex;
    
    
    % extract RoNIN on moving trajectory
    roninPartialResult = roninResult(movingIndex);
    roninMovingPart = [roninMovingPart, roninPartialResult];
end


% label dummy stationary point index
numRonin = size(roninMovingPart,2);
for k = 1:numRonin
    if (isempty(roninMovingPart(k).stationaryPointIndex))
        roninMovingPart(k).stationaryPointIndex = -100;
    end
end


end

