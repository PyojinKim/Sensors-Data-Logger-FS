function [roninResult] = removeStationaryMotion(roninResult)

numRonin = size(roninResult,2);
invalidRoninIndex = false(1,numRonin);
for k = 1:numRonin
    
    % check stationary motion, WiFi APs, Google FLP
    if (roninResult(k).isStationary && isempty(roninResult(k).wifiAPsResult) && isempty(roninResult(k).FLPLocationDegree))
        invalidRoninIndex(k) = 1;
    end
end
roninResult(invalidRoninIndex) = [];

% isRoninStationary = [roninResult(:).isStationary];
% roninResult(isRoninStationary) = [];

end

