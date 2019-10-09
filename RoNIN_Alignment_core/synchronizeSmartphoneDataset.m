function [deviceDataset] = synchronizeSmartphoneDataset(rawDeviceDataset, timeInterval)
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
%   timeInterval: time resolution (second)
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
% 2019-10-10: ing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

% define reference time and data
endTimeRoNIN = rawDeviceDataset.RoNIN.timestamp(end);
endTimeFLP = rawDeviceDataset.FLP.timestamp(end);
syncTimestamp = [0.001:timeInterval:max(endTimeRoNIN,endTimeFLP)];
numData = size(syncTimestamp,2);

% synchronize & compensate magnetic field w.r.t. global frame
syncRoninPose = zeros(2,numData);
syncFLPhorizontalPositionDegree = zeros(2,numData);
syncFLPhorizontalPositionMeter = zeros(2,numData);
syncFLPhorizontalPositionRadius = zeros(1,numData);
for k = 1:numData
    
    % remove future timestamp
    currentTime = syncTimestamp(k);
    validIndexRoNIN = ((currentTime - rawDeviceDataset.RoNIN.timestamp) > 0);
    validIndexFLP = ((currentTime - rawDeviceDataset.FLP.timestamp) > 0);
    timestampRoNIN = rawDeviceDataset.RoNIN.timestamp(validIndexRoNIN);
    timestampFLP = rawDeviceDataset.FLP.timestamp(validIndexFLP);
    
    % RoNIN
    [~,indexRoNIN] = min(abs(currentTime - timestampRoNIN));
    syncRoninPose(:,k) = rawDeviceDataset.RoNIN.trajectory(:,indexRoNIN);
    
    % FLP
    [~,indexFLP] = min(abs(currentTime - timestampFLP));
    syncFLPhorizontalPositionDegree(:,k) = rawDeviceDataset.FLP.horizontalPositionDegree(1:2,indexFLP);
    syncFLPhorizontalPositionMeter(:,k) = rawDeviceDataset.FLP.horizontalPositionMeter(:,indexFLP);
    syncFLPhorizontalPositionRadius(k) = rawDeviceDataset.FLP.horizontalPositionDegree(3,indexFLP);
    
    % display current status
    fprintf('Current Status: %d / %d \n', k, numData);
end

% save the synchronized & compensated results
deviceDataset.syncTimestamp = syncTimestamp;
deviceDataset.syncRoninPose = syncRoninPose;
deviceDataset.syncFLPhorizontalPositionDegree = syncFLPhorizontalPositionDegree;
deviceDataset.syncFLPhorizontalPositionMeter = syncFLPhorizontalPositionMeter;
deviceDataset.syncFLPhorizontalPositionRadius = syncFLPhorizontalPositionRadius;

end

