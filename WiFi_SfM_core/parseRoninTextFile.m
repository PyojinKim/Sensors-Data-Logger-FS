function [roninResult] = parseRoninTextFile(roninTextFile)

% common setting to read text files
delimiter = ' ';
headerlinesIn = 0;


% open RoNIN text file
textRoninData = importdata(roninTextFile, delimiter, headerlinesIn);
roninTime = textRoninData(:,1).';
roninData = textRoninData(:,[2:3]).';


% construct RoNIN trajectory results
numRonin = size(roninData,2);
roninResult = struct('timestamp', cell(1,numRonin), 'location', cell(1,numRonin));
for k = 1:numRonin
    
    % save each RoNIN location
    roninResult(k).timestamp = roninTime(k);
    roninResult(k).location = roninData(:,k);
end


end
