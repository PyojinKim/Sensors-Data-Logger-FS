function [residuals] = EuclideanDistanceResidual_DeltaAngle(roninInitialLocation, roninPolarSpeed, roninPolarDeltaAngle, roninStationaryPointIndex, X)

% RoNIN drift correction model
roninLocation = DriftCorrectedRoninDeltaAngleModel(roninInitialLocation, roninPolarSpeed, roninPolarDeltaAngle, X);


% (1) residuals for RoNIN stationary points
residualStationaryPoint = [];
count = 0;
numStationaryPoint = size(roninStationaryPointIndex,2);
for k = 1:numStationaryPoint
    
    % concatenate Euclidean distance constraints
    stationaryPointIndex = roninStationaryPointIndex{k};
    for m = 2:size(stationaryPointIndex,2)
        count = count + 1;
        residualStationaryPoint(count) = norm(roninLocation(:,stationaryPointIndex(m)) - roninLocation(:,stationaryPointIndex(m-1)));
    end
end


% (2) residuals for bias changes in drift correction model
numRonin = size(roninPolarSpeed,2);
roninScale = X(1:numRonin);
roninBias = X((numRonin+1):end);

scaleDifference = diff(roninScale);
biasDifference = diff(roninBias);


scaleRegularization = (roninScale - 1);
biasRegularization = (roninBias - 0);


%residuals = [residualStationaryPoint, scaleRegularization, biasRegularization, scaleDifference, biasDifference].';
%residuals = [residualStationaryPoint, scaleDifference, biasDifference].';
%residuals = [residualStationaryPoint, scaleRegularization, biasRegularization].';
residuals = [residualStationaryPoint].';


end

