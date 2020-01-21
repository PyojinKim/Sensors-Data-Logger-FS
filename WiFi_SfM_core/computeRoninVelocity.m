function [outputArg1,outputArg2] = computeRoninVelocity(roninResult)

% compute velocity from location, time data
roninTime = [roninResult(:).timestamp];
roninLocation = [roninResult(:).location];

timeDifference = diff(roninTime);
locationDifference = diff(roninLocation,1,2);





numRonin = size(roninResult,2);






end

