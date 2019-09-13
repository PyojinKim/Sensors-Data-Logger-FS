function [deviceWiFiScanResults] = loadWiFiScanResults(deviceWiFiTextFile, deviceReferenceTime)

% open wifi text file
textWifiFileID = fopen(deviceWiFiTextFile);
tline = fgetl(textWifiFileID);


% construct wifi scan results
nanoSecondToSecond = 1000000000;
deviceWiFiScanResults = struct('timestamp', cell(1, 10000), 'numberOfAPs', cell(1, 10000), 'eachWifiAPInfo', cell(1, 10000));
numberOfWifiScan = 0;
while (true)
    
    % read the current number of APs
    numberOfWifiScan = numberOfWifiScan + 1;
    tline = fgetl(textWifiFileID);
    numberOfAPs = str2double(tline);
    
    % check end of the text file
    if (isnan(numberOfAPs))
        break;
    end
    
    % save each AP information per wifi scan
    eachWifiAPInfo = struct('timestamp', cell(1, numberOfAPs), 'BSSID', cell(1, numberOfAPs), 'RSSI', cell(1, numberOfAPs));
    for k = 1:numberOfAPs
        
        % read each AP information
        eachWifiAPResult = strsplit(fgetl(textWifiFileID), char(9));
        eachWifiAPInfo(k).timestamp = (str2double(eachWifiAPResult{1}) / nanoSecondToSecond) - deviceReferenceTime;
        eachWifiAPInfo(k).BSSID = eachWifiAPResult{2};
        eachWifiAPInfo(k).RSSI = str2double(eachWifiAPResult{3});
    end
    
    % summarize wifi scan information
    deviceWiFiScanResults(numberOfWifiScan).timestamp = mean([eachWifiAPInfo(:).timestamp]);
    deviceWiFiScanResults(numberOfWifiScan).numberOfAPs = numberOfAPs;
    deviceWiFiScanResults(numberOfWifiScan).eachWifiAPInfo = eachWifiAPInfo;
end
deviceWiFiScanResults(numberOfWifiScan:end) = [];


% close wifi text file
fclose(textWifiFileID);


end

