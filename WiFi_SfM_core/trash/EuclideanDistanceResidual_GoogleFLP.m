function [residuals] = EuclideanDistanceResidual_GoogleFLP(roninPolarSpeed, roninPolarAngle, roninGoogleFLPIndex, roninGoogleFLPLocation, X)

% RoNIN drift correction model
[initialLocation, scale, bias] = unpackDriftCorrectionModelParameters(X);
roninLocation = DriftCorrectedRoninAbsoluteAngleModel(initialLocation, roninPolarSpeed, roninPolarAngle, scale, bias);


% (1) residuals for Google FLP location
roninEstimatedLocation = roninLocation(:,roninGoogleFLPIndex);
roninLocationError = (roninEstimatedLocation - roninGoogleFLPLocation);
residualGoogleFLP = vecnorm(roninLocationError);


% (2) residuals for scale/bias changes in RoNIN drift correction model
scaleRegularization = (scale - 1);
biasDifference = diff(bias);


% (3) final residuals for nonlinear optimization
residuals = [residualGoogleFLP, scaleRegularization, biasDifference].';
%residuals = [residualGoogleFLP].';


end

