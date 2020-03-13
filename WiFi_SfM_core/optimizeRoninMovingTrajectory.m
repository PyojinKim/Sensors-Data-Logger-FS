function [roninMovingPart, scale, bias] = optimizeRoninMovingTrajectory(roninMovingPart, roninGoogleFLPIndex, roninGoogleFLPLocation)

% check Google FLP data index
if (isempty(roninGoogleFLPIndex))
    roninMovingPart = roninMovingPart;
    numRonin = size(roninMovingPart,2);
    scale = ones(1,numRonin);
    bias = zeros(1,numRonin);
    return;
end


% convert RoNIN polar coordinate for nonlinear optimization
roninPolarResult = convertRoninPolarCoordinate(roninMovingPart);
roninPolarSpeed = [roninPolarResult(:).speed];
roninPolarAngle = [roninPolarResult(:).angle];


% scale and bias model parameters for RoNIN drift correction model
numRonin = size(roninPolarResult,2);
scale = ones(1,numRonin);
bias = zeros(1,numRonin);
startLocation = roninGoogleFLPLocation(:,1);
X_initial = [scale, bias, startLocation.'];


% run nonlinear optimization using lsqnonlin in Matlab (Levenberg-Marquardt)
options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt','Display','iter-detailed','MaxIterations',400);
[vec,resnorm,residuals,exitflag] = lsqnonlin(@(x) EuclideanDistanceResidual_GoogleFLP(roninPolarSpeed, roninPolarAngle, roninGoogleFLPIndex, roninGoogleFLPLocation, x),X_initial,[],[],options);


% optimal scale and bias model parameters for RoNIN drift correction model
X_optimized = vec;
[startLocation, scale, bias] = unpackDriftCorrectionModelParameters(X_optimized);


% drift-corrected RoNIN location
roninLocation = DriftCorrectedRoninAbsoluteAngleModel(startLocation, roninPolarSpeed, roninPolarAngle, scale, bias);
for k = 1:numRonin
    roninMovingPart(k).location = roninLocation(:,k);
end


end

