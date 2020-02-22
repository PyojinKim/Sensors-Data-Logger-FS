function [roninMovingTrajectoryIndex] = seperateRoninMovingTrajectory(roninResult, movingDistanceThreshold, endtoEndDistanceThreshold)

% common parameter setting for this function
numRonin = size(roninResult,2);


% find RoNIN non-stationary index
nonstationarySegmentIndex = [];
roninNonstationaryIndex = cell(1,100);
numNonstationarySegment = 0;
for k = 1:numRonin
    
    % check RoNIN moving motion
    if (~roninResult(k).isStationary)
        nonstationarySegmentIndex = [nonstationarySegmentIndex, k];
    else
        
        % check end point of RoNIN moving motion
        if (isempty(nonstationarySegmentIndex))
            continue;
        else
            numNonstationarySegment = numNonstationarySegment + 1;
            roninNonstationaryIndex{numNonstationarySegment} = nonstationarySegmentIndex;
            nonstationarySegmentIndex = [];
        end
    end
end
roninNonstationaryIndex((numNonstationarySegment+1):end) = [];


% refine RoNIN moving trajectory index
roninMovingTrajectoryIndex = cell(1,100);
numMovingTrajectory = 0;
for k = 1:numNonstationarySegment
    
    % extract RoNIN non-stationary part
    nonstationaryIndex = roninNonstationaryIndex{k};
    roninPartialResult = roninResult(nonstationaryIndex);
    
    % check RoNIN moving/end to end distances
    movingDistance = computeRoninTravelingDistance(roninPartialResult);
    endtoEndDistance = computeRoninEndtoEndDistance(roninPartialResult);
    if ((movingDistance >= movingDistanceThreshold) && (endtoEndDistance >= endtoEndDistanceThreshold))
        numMovingTrajectory = numMovingTrajectory + 1;
        roninMovingTrajectoryIndex{numMovingTrajectory} = nonstationaryIndex;
    end
end
roninMovingTrajectoryIndex((numMovingTrajectory+1):end) = [];


end

