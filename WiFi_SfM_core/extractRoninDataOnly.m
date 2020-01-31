function [roninResult] = extractRoninDataOnly(datasetDirectory, roninInterval, roninYawRotation)

% parse ronin.txt file / compute RoNIN velocity and speed
roninResult = parseRoninTextFile([datasetDirectory '/ronin.txt'], roninInterval, roninYawRotation);
roninResult = computeRoninVelocity(roninResult);
numRonin = size(roninResult,2);


% parse wifi.txt file / find the closest wifi scan
wifiScanResult = parseWiFiTextFile([datasetDirectory '/wifi.txt']);
wifiScanTime = [wifiScanResult(:).timestamp];
for k = 1:numRonin
    [timeDifference, indexWifi] = min(abs(roninResult(k).timestamp - wifiScanTime));
    if (timeDifference < 0.5)
        roninResult(k).wifiAPsResult = wifiScanResult(indexWifi).wifiAPsResult;
    end
end
clear wifiScanResult wifiScanTime;


% parse FLP.txt file / find the closest Google FLP
GoogleFLPResult = parseGoogleFLPTextFile([datasetDirectory '/FLP.txt']);
GoogleFLPTime = [GoogleFLPResult(:).timestamp];
for k = 1:numRonin
    [timeDifference, indexGoogleFLP] = min(abs(roninResult(k).timestamp - GoogleFLPTime));
    if (timeDifference < 0.5)
        roninResult(k).FLPLocation = GoogleFLPResult(indexGoogleFLP).locationDegree;
        roninResult(k).FLPAccuracy = GoogleFLPResult(indexGoogleFLP).accuracyMeter;
    end
end
clear GoogleFLPResult GoogleFLPTime;


end


