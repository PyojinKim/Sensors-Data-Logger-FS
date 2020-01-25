function [gravityResult] = parseGravityTextFile(gravityTextFile)

% common setting to read text files
delimiter = ' ';
headerlinesIn = 1;
nanoSecondToSecond = 1000000000;


% open gravity text file
textGravityData = importdata(gravityTextFile, delimiter, headerlinesIn);
gravityTime = textGravityData.data(:,1).';
gravityTime = gravityTime ./ nanoSecondToSecond;
gravityData = textGravityData.data(:,[2 3 4]).';


% construct gravity results
numGravity = size(gravityData,2);
gravityResult = struct('timestamp', cell(1,numGravity), 'gravity', cell(1,numGravity));
for k = 1:numGravity
    
    % save each gravity
    gravityResult(k).timestamp = gravityTime(k);
    gravityResult(k).gravity = gravityData(:,k);
end


end

