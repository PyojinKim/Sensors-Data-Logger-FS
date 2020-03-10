function [roninMovingPart, roninScale, roninBias] = optimizeRoninMovingTrajectory(roninMovingPart, roninGoogleFLPIndex, roninGoogleFLPLocation)

% convert RoNIN polar coordinate for nonlinear optimization
roninPolarResult = convertRoninPolarCoordinate(roninMovingPart);
roninInitialLocation = roninPolarResult(1).location;
roninPolarSpeed = [roninPolarResult(:).speed];
roninPolarAngle = [roninPolarResult(:).angle];


% scale and bias model parameters for RoNIN drift correction model
numRonin = size(roninPolarResult,2);
roninScale = ones(1,numRonin);
roninBias = zeros(1,numRonin);
X_initial = [roninScale, roninBias];


% run nonlinear optimization using lsqnonlin in Matlab (Levenberg-Marquardt)
options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt','Display','iter-detailed');
[vec,resnorm,residuals,exitflag] = lsqnonlin(@(x) EuclideanDistanceResidual_GoogleFLP(roninInitialLocation, roninPolarSpeed, roninPolarAngle, roninGoogleFLPIndex, roninGoogleFLPLocation, x),X_initial,[],[],options);


% optimal scale and bias model parameters for RoNIN drift correction model
X_optimized = vec;
roninScale = X_optimized(1:numRonin);
roninBias = X_optimized((numRonin+1):end);


% drift-corrected RoNIN location
roninLocation = DriftCorrectedRoninAbsoluteAngleModel(roninInitialLocation, roninPolarSpeed, roninPolarAngle, X_optimized);
for k = 1:numRonin
    roninMovingPart(k).location = roninLocation(:,k);
end


end

