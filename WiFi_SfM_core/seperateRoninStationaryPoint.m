function [roninStationaryPointIndex] = seperateRoninStationaryPoint(roninResult, movingTrajectoryIndex)

% common parameter setting for this function
numRonin = size(roninResult,2);
numMovingTrajectory = size(movingTrajectoryIndex,2);
numStationaryPoint = (numMovingTrajectory+1);
roninStationaryPointIndex = cell(1,numStationaryPoint);


% first stationary point
nonstationaryIndex = movingTrajectoryIndex{1};
stationaryIndex = [1:(nonstationaryIndex(1)-1)];
roninStationaryPointIndex{1} = stationaryIndex;


% middle stationary point
for k = 2:numMovingTrajectory
    nonstationaryIndex1 = movingTrajectoryIndex{k-1};
    nonstationaryIndex2 = movingTrajectoryIndex{k};
    stationaryIndex = [(nonstationaryIndex1(end)+1):(nonstationaryIndex2(1)-1)];
    roninStationaryPointIndex{k} = stationaryIndex;
end


% last stationary point
nonstationaryIndex = movingTrajectoryIndex{numMovingTrajectory};
stationaryIndex = [(nonstationaryIndex(end)+1):numRonin];
roninStationaryPointIndex{numStationaryPoint} = stationaryIndex;


end

