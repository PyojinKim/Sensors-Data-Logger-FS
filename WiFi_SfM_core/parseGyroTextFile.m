function [gyroResult] = parseGyroTextFile(gyroTextFile)

% common setting to read text files
delimiter = ' ';
headerlinesIn = 1;
nanoSecondToSecond = 1000000000;


% open calibrated gyro text file
textGyroData = importdata(gyroTextFile, delimiter, headerlinesIn);
gyroTime = textGyroData.data(:,1).';
gyroTime = gyroTime ./ nanoSecondToSecond;
gyroData = textGyroData.data(:,[2 3 4]).';


% construct calibrated gyro results
numGyro = size(gyroData,2);
gyroResult = struct('timestamp', cell(1,numGyro), 'gyro', cell(1,numGyro));
for k = 1:numGyro
    
    % save each calibrated gyro
    gyroResult(k).timestamp = gyroTime(k);
    gyroResult(k).gyro = gyroData(:,k);
end


end

