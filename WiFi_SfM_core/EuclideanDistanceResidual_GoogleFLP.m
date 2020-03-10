function [residuals] = EuclideanDistanceResidual_GoogleFLP(roninInitialLocation, roninPolarSpeed, roninPolarAngle, roninGoogleFLPIndex, roninGoogleFLPLocation, X)

% RoNIN drift correction model
roninLocation = DriftCorrectedRoninAbsoluteAngleModel(roninInitialLocation, roninPolarSpeed, roninPolarAngle, X);


% (1) residuals for Google FLP location
roninEstimatedLocation = roninLocation(:,roninGoogleFLPIndex);
roninLocationError = (roninEstimatedLocation - roninGoogleFLPLocation);
residualGoogleFLP = vecnorm(roninLocationError);


% (2) residuals for scale/bias changes in RoNIN drift correction model
numRonin = size(roninPolarSpeed,2);
roninScale = X(1:numRonin);
roninBias = X((numRonin+1):end);

scaleRegularization = (roninScale - 1);
biasDifference = diff(roninBias);


% (3) final residuals for nonlinear optimization
residuals = [residualGoogleFLP, scaleRegularization, biasDifference].';
%residuals = [residualGoogleFLP].';


end

