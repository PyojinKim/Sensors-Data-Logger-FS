function [roninResult] = detectStationaryMotion(roninResult, thresholdSpeed, duration)

% common parameter setting for this function
numRonin = size(roninResult,2);
roninTime = [roninResult(:).timestamp];


% detect RoNIN stationary motion
for k = 1:numRonin
    
    % find the previous time & index
    currentTime = roninResult(k).timestamp;
    previousTime = currentTime - duration;
    [timeDifference, index] = min(abs(previousTime - roninTime));
    if (timeDifference < 0.5)
        currentIndex = k;
        previousIndex = index;
    else
        roninResult(k).isStationary = false;
        continue;
    end
    
    
    % test RoNIN speed in the duration range
    numSpeedData = (currentIndex - previousIndex + 1);
    roninSpeed = [roninResult(previousIndex:currentIndex).speed];
    isRoninStationary = (roninSpeed < thresholdSpeed);
    if (sum(isRoninStationary) == numSpeedData)
        roninResult(k).isStationary = true;
    else
        roninResult(k).isStationary = false;
    end
end


% heuristic (pre-defined) RoNIN stationary motion
for k = 1:6
    roninResult(k).isStationary = true;
end


end

