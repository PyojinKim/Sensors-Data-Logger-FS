function [acceResult] = parseAcceTextFile(acceTextFile)

% common setting to read text files
delimiter = ' ';
headerlinesIn = 1;
nanoSecondToSecond = 1000000000;


% open calibrated acceleration text file
textAcceData = importdata(acceTextFile, delimiter, headerlinesIn);
acceTime = textAcceData.data(:,1).';
acceTime = acceTime ./ nanoSecondToSecond;
acceData = textAcceData.data(:,[2 3 4]).';


% construct calibrated acceleration results
numAcce = size(acceData,2);
acceResult = struct('timestamp', cell(1,numAcce), 'acceleration', cell(1,numAcce));
for k = 1:numAcce
    
    % save each calibrated acce
    acceResult(k).timestamp = acceTime(k);
    acceResult(k).acceleration = acceData(:,k);
end


end

