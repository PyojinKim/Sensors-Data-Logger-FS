function [rawDeviceDataset] = loadRawSmartphoneDataset(datasetPath)
% Project:    RoNIN Alignment with Multiple Sensors
% Function:  loadRawSmartphoneDataset
%
% Description:
%   get raw RoNIN, WiFi, Magnet, game rotation vector (GRV), etc from smartphone dataset
%
% Example:
%   OUTPUT:
%   rawDeviceDataset:
%
%   INPUT:
%   datasetPath: directory of folder which includes ronin.txt / wifi.txt / magnet.txt ...
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
% 2019-10-02: Complete
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%


% common setting to read text files
delimiter = ' ';
headerlinesIn = 1;
nanoSecondToSecond = 1000000000;


%% 1) load RoNIN 2D trajectory

% import text file
textRoninData = importdata([datasetPath '/ronin.txt'], delimiter, headerlinesIn);
deviceRoninTime = textRoninData.data(:,1).';
deviceRoninTrajectory = textRoninData.data(:,[2:3]).';

% define device reference time
deviceReferenceTime = deviceRoninTime(1);
deviceReferenceTimeInNanoSecond = deviceReferenceTime * nanoSecondToSecond;
deviceRoninTime = (deviceRoninTime - deviceReferenceTime);

% save the results
rawDeviceDataset.RoNIN.timestamp = deviceRoninTime;
rawDeviceDataset.RoNIN.trajectory = deviceRoninTrajectory;


%% 2) load device orientation (game rotation vector)

% import text file
textOrientationData = importdata([datasetPath '/game_rv.txt'], delimiter, headerlinesIn);
deviceOrientationTime = textOrientationData.data(:,1).';
deviceOrientationTime = (deviceOrientationTime - deviceReferenceTimeInNanoSecond) ./ nanoSecondToSecond;
deviceOrientationData = textOrientationData.data(:,[5 2 3 4]).';
numOrientationData = size(deviceOrientationData,2);

% convert from unit quaternion to rotation matrix & roll/pitch/yaw
R_gb = zeros(3,3,numOrientationData);
rpy_gb = zeros(3,numOrientationData);
for k = 1:numOrientationData
    R_gb(:,:,k) = q2r(deviceOrientationData(:,k));
    rpy_gb(:,k) = rotmtx2angle(inv(R_gb(:,:,k)));
end

% save the results
rawDeviceDataset.grv.timestamp = deviceOrientationTime;
rawDeviceDataset.grv.orientation = deviceOrientationData;
rawDeviceDataset.grv.R_gb = R_gb;
rawDeviceDataset.grv.rpy_gb = rpy_gb;


%% 3) load calibrated magnetic field

% import text file
textMagnetData = importdata([datasetPath '/magnet.txt'], delimiter, headerlinesIn);
deviceMagnetTime = textMagnetData.data(:,1).';
deviceMagnetTime = (deviceMagnetTime - deviceReferenceTimeInNanoSecond) ./ nanoSecondToSecond;
deviceMagnetData = textMagnetData.data(:,[2 3 4]).';

% save the results
rawDeviceDataset.magnet.timestamp = deviceMagnetTime;
rawDeviceDataset.magnet.vectorField = deviceMagnetData;


%% 4) load raw magnetic field

% import text file
textRawMagnetData = importdata([datasetPath '/magnet_uncalib.txt'], delimiter, headerlinesIn);
deviceRawMagnetTime = textRawMagnetData.data(:,1).';
deviceRawMagnetTime = (deviceRawMagnetTime - deviceReferenceTimeInNanoSecond) ./ nanoSecondToSecond;
deviceRawMagnetData = textRawMagnetData.data(:,[2 3 4]).';

% save the results
rawDeviceDataset.magnet_uncalib.timestamp = deviceRawMagnetTime;
rawDeviceDataset.magnet_uncalib.vectorField = deviceRawMagnetData;


%% 5) load WiFi scan information

% parse and save text file
textWiFiData = loadWiFiScanResults([datasetPath '/wifi.txt'], deviceReferenceTime);
deviceWiFiTime = [textWiFiData(:).timestamp];
deviceWiFiNumAPs = [textWiFiData(:).numberOfAPs];
numWiFiScanData = size(textWiFiData,2);

% re-arrange data format
deviceWiFiEachAPInfo = cell(1,numWiFiScanData);
for k = 1:numWiFiScanData
    deviceWiFiEachAPInfo{k} = textWiFiData(k).eachWifiAPInfo;
end

% save the results
rawDeviceDataset.wifi.timestamp = deviceWiFiTime;
rawDeviceDataset.wifi.numberOfAPs = deviceWiFiNumAPs;
rawDeviceDataset.wifi.eachAPsInfo = deviceWiFiEachAPInfo;


%% 6) load Fused Location Provider (FLP) information

% import text file
textFLPData = importdata([datasetPath '/FLP.txt'], delimiter, headerlinesIn);
deviceFLPTime = textFLPData.data(:,1).';
deviceFLPTime = (deviceFLPTime - deviceReferenceTimeInNanoSecond) ./ nanoSecondToSecond;
deviceFLPHorizontalPosition = textFLPData.data(:,[2 3 4]).';
deviceFLPVerticalPosition = textFLPData.data(:,[5 6]).';
deviceFLPBearingAngle = textFLPData.data(:,[7 8]).';
deviceFLPSpeed= textFLPData.data(:,[9 10]).';

% save the results
rawDeviceDataset.FLP.timestamp = deviceFLPTime;
rawDeviceDataset.FLP.horizontalPosition = deviceFLPHorizontalPosition;
rawDeviceDataset.FLP.verticalPosition = deviceFLPVerticalPosition;
rawDeviceDataset.FLP.bearingAngle = deviceFLPBearingAngle;
rawDeviceDataset.FLP.speed = deviceFLPSpeed;


end







