function [wifiScanResult] = extractWiFiCentricData(datasetDirectory, uniqueWiFiAPsBSSID)

% parse wifi.txt file / vectorize WiFi RSSI for each WiFi scan
wifiScanResult = parseWiFiTextFile([datasetDirectory '/wifi.txt']);
wifiScanResult = vectorizeWiFiRSSI(wifiScanResult, uniqueWiFiAPsBSSID);
wifiScanResult = filterWiFiRSSI(wifiScanResult, -100);
numWiFiScan = size(wifiScanResult,2);


% parse FLP.txt file / find the closest Google FLP
GoogleFLPResult = parseGoogleFLPTextFile([datasetDirectory '/FLP.txt']);
GoogleFLPTime = [GoogleFLPResult(:).timestamp];
maximumTimeDifference = 2.0;   % second
for k = 1:numWiFiScan
    [timeDifference, indexGoogleFLP] = min(abs(wifiScanResult(k).timestamp - GoogleFLPTime));
    if (timeDifference <= maximumTimeDifference)
        wifiScanResult(k).FLPLocation = GoogleFLPResult(indexGoogleFLP).locationDegree;
        wifiScanResult(k).FLPAccuracy = GoogleFLPResult(indexGoogleFLP).accuracyMeter;
    end
end


% refine invalid WiFi scan result
FLPAccuracyThreshold = 25.0;   % meter
for k = numWiFiScan:-1:1
    if (isempty(wifiScanResult(k).FLPAccuracy) || (wifiScanResult(k).FLPAccuracy > FLPAccuracyThreshold))
        wifiScanResult(k) = [];
    end
end


end

