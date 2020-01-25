function [pressureResult] = parsePressureTextFile(pressureTextFile)

% common setting to read text files
delimiter = ' ';
headerlinesIn = 1;
nanoSecondToSecond = 1000000000;


% open pressureic field text file
textPressureData = importdata(pressureTextFile, delimiter, headerlinesIn);
pressureTime = textPressureData.data(:,1).';
pressureTime = pressureTime ./ nanoSecondToSecond;
pressureData = textPressureData.data(:,2).';


% construct pressure results
numPressure = size(pressureData,2);
pressureResult = struct('timestamp', cell(1,numPressure), 'pressure', cell(1,numPressure));
for k = 1:numPressure
    
    % save each calibrated pressureic field information
    pressureResult(k).timestamp = pressureTime(k);
    pressureResult(k).pressure = pressureData(k);
end


end

