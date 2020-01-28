function [roninLocation] = DriftCorrectedRoninPolarModel(roninInitialLocation, roninPolarSpeed, roninPolarAngle, X_Drift_Correction_Model)

% common parameter setting for this function
numRonin = size(roninPolarSpeed,2);
roninScale = X_Drift_Correction_Model(1:numRonin);
roninBias = X_Drift_Correction_Model((numRonin+1):end);


% compute drift-corrected 2D RoNIN location
roninLocation = zeros(2,numRonin);
roninLocation(:,1) = roninInitialLocation;
for k = 2:numRonin
    
    % scale and bias for each segment
    s = roninScale(k);
    b = roninBias(k);
    
    % compute delta X and Y
    deltaX = s * roninPolarSpeed(k) * cos(roninPolarAngle(k) + b);
    deltaY = s * roninPolarSpeed(k) * sin(roninPolarAngle(k) + b);
    
    % accumulated 2D RoNIN location
    roninLocation(:,k) = roninLocation(:,k-1) + [deltaX; deltaY];
end


end

