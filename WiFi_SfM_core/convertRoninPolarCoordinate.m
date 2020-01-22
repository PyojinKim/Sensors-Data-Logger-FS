function [roninResult] = convertRoninPolarCoordinate(roninResult)

% append RoNIN speed & angle results
numRonin = size(roninResult,2);
for k = 2:numRonin
    
    % compute speed & angle
    deltaTime = (roninResult(k).timestamp - roninResult(k-1).timestamp);
    deltaLocation = (roninResult(k).location - roninResult(k-1).location);
    deltaAngle = atan2(deltaLocation(2), deltaLocation(1));
    
    % save each RoNIN speed & angle
    roninResult(k).speed = norm(deltaLocation / deltaTime);
    roninResult(k).deltaAngle = deltaAngle;
end


end

