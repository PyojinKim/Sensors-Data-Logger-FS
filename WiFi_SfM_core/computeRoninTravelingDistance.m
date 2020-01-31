function [travelingDistance] = computeRoninTravelingDistance(roninResult)

numRonin = size(roninResult,2);
travelingDistance = 0;
for k = 2:numRonin
    deltaLocation = roninResult(k).location - roninResult(k-1).location;
    travelingDistance = travelingDistance + norm(deltaLocation);
end


end

