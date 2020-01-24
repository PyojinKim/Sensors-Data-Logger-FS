function [roninResult] = removeStationaryMotion(roninResult)

isRoninStationary = [roninResult(:).isStationary];
roninResult(isRoninStationary) = [];

end

