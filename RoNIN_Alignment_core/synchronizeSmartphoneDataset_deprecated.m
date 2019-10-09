function [deviceDataset] = synchronizeSmartphoneDataset(rawDeviceDataset, kStartMagnet, kEndMagnet)
% Project:    RoNIN Alignment with Multiple Sensors
% Function:  synchronizeSmartphoneDataset
%
% Description:
%   get synchronized & compensated smartphone dataset
%
% Example:
%   OUTPUT:
%   deviceDataset:
%
%   INPUT:
%   rawDeviceDataset: result from loadRawSmartphoneDataset function
%
%
% NOTE:
%   Copyright 2019 GrUVi Lab @ Simon Fraser University
%
% Author: Pyojin Kim
% Email: pjinkim1215@gmail.com
% Website: http://pyojinkim.me/
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% log:
% 2019-09-25: Complete
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

% magnet reference time and data
syncTimestamp = rawDeviceDataset.magnet.timestamp(kStartMagnet:kEndMagnet);
numMagnetData = size(syncTimestamp,2);

% synchronize & compensate magnetic field w.r.t. global frame
timeDifferenceThreshold = 0.01;
syncRoninPose = zeros(2,numMagnetData);
syncDeviceOrientation = zeros(3,3,numMagnetData);
syncMagnetField = zeros(3,numMagnetData);
syncRawMagnetField = zeros(3,numMagnetData);
for k = 1:numMagnetData
    
    % current reference magnet time
    currentTime = syncTimestamp(k);
    
    % RoNIN
    [timeDifference, roninIndex] = min(abs(currentTime - rawDeviceDataset.RoNIN.timestamp));
    if (timeDifference < timeDifferenceThreshold)
        syncRoninPose(:,k) = rawDeviceDataset.RoNIN.trajectory(:,roninIndex);
    end
    
    % device orientation
    [timeDifference, orientationIndex] = min(abs(currentTime - rawDeviceDataset.grv.timestamp));
    if (timeDifference < timeDifferenceThreshold)
        syncDeviceOrientation(:,:,k) = rawDeviceDataset.grv.R_gb(:,:,orientationIndex);
        R_gb = rawDeviceDataset.grv.R_gb(:,:,orientationIndex);
    end
    
    % calibrated magnetic field
    [timeDifference, magnetIndex] = min(abs(currentTime - rawDeviceDataset.magnet.timestamp));
    if (timeDifference < timeDifferenceThreshold)
        syncMagnetField(:,k) = R_gb * rawDeviceDataset.magnet.vectorField(:,magnetIndex);
    end
    
    % raw magnetic field
    [timeDifference, rawMagnetIndex] = min(abs(currentTime - rawDeviceDataset.magnet_uncalib.timestamp));
    if (timeDifference < timeDifferenceThreshold)
        syncRawMagnetField(:,k) = R_gb * rawDeviceDataset.magnet_uncalib.vectorField(:,rawMagnetIndex);
    end
    fprintf('Current Status: %d / %d \n', k, numMagnetData);
end

% save the synchronized & compensated results
deviceDataset.syncTimestamp = syncTimestamp;
deviceDataset.syncRoninPose = syncRoninPose;
deviceDataset.syncDeviceOrientation = syncDeviceOrientation;
deviceDataset.syncMagnetField = syncMagnetField;
deviceDataset.syncRawMagnetField = syncRawMagnetField;

end

