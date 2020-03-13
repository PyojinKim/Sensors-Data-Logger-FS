function [initialLocation, scale, bias] = unpackDriftCorrectionModelParameters(X_Drift_Correction_Model)

numRonin = (size(X_Drift_Correction_Model,2) - 2) / 2;
initialLocation = X_Drift_Correction_Model(end-1:end);
scale = X_Drift_Correction_Model(1:numRonin);
bias = X_Drift_Correction_Model((numRonin+1):(2*numRonin));

end

