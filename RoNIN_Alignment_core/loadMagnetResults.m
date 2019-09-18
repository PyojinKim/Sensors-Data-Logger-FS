function [deviceMagnetTime, deviceMagnetResults] = loadMagnetResults(deviceMagnetTextFile, deviceRoninTime, deviceReferenceTime)

% common setting to read text files
delimiter = ' ';
headerlinesIn = 1;
nanoSecondToSecond = 1000000000;


% parsing calibrated magnetic field text
textMagnetData = importdata(deviceMagnetTextFile, delimiter, headerlinesIn);
deviceMagnetTime = textMagnetData.data(:,1).';
deviceMagnetTime = (deviceMagnetTime - (deviceReferenceTime * nanoSecondToSecond)) ./ nanoSecondToSecond;
deviceMagnetResults = textMagnetData.data(:,[2 3 4]).';


% % RoNIN and magnet data time synchronization
% numRoninData = size(deviceRoninTime,2);
% deviceMagnetTime = zeros(1,numRoninData);
% deviceMagnetResults = zeros(3,numRoninData);
% for k = 1:numRoninData
%
%     % utilize only the past magnet measurements
%     currentTime = deviceRoninTime(k);
%     pastMagnetIndex = find((currentTime - magnetTime) >=0);
%
%     % save the current time and magnet data
%     deviceMagnetTime(k) = currentTime;
%     deviceMagnetResults(:,k) = magnetData(:,pastMagnetIndex(end));
% end

end

