



datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Asus_Tango/SFU_TASC1_8000/20200113110654R_WiFi_SfM';
roninInterval = 200;          % 1 Hz
roninYawRotation = 225;   % degree


function [roninResult] = extractRoninCentricData(datasetDirectory, roninInterval, roninYawRotation)

% parse ronin.txt file
roninResult = parseRoninTextFile([datasetDirectory '/ronin.txt'], roninInterval, roninYawRotation);
roninResult = computeRoninVelocity(roninResult);


% detect and remove RoNIN stationary motion
speed = 0.1;      % m/s
duration = 5.0;   % sec
roninResult = detectStationaryMotion(roninResult, speed, duration);
roninResult = removeStationaryMotion(roninResult);


% RoNIN parameters
numRonin = size(roninResult,2);


% parse acce.txt file / find the closest acceleration
acceResult = parseAcceTextFile([datasetDirectory '/acce.txt']);
acceTime = [acceResult(:).timestamp];
for k = 1:numRonin
    [timeDifference, indexAcce] = min(abs(roninResult(k).timestamp - acceTime));
    if (timeDifference < 0.5)
        roninResult(k).acceleration = acceResult(indexAcce).acceleration;
    end
end
clear acceResult acceTime;


% parse gyro.txt file / find the closest gyro
gyroResult = parseGyroTextFile([datasetDirectory '/gyro.txt']);
gyroTime = [gyroResult(:).timestamp];
for k = 1:numRonin
    [timeDifference, indexGyro] = min(abs(roninResult(k).timestamp - gyroTime));
    if (timeDifference < 0.5)
        roninResult(k).gyro = gyroResult(indexGyro).gyro;
    end
end
clear gyroResult gyroTime;


% parse gravity.txt file / find the closest gravity
gravityResult = parseGravityTextFile([datasetDirectory '/gravity.txt']);
gravityTime = [gravityResult(:).timestamp];
for k = 1:numRonin
    [timeDifference, indexGravity] = min(abs(roninResult(k).timestamp - gravityTime));
    if (timeDifference < 0.5)
        roninResult(k).gravity = gravityResult(indexGravity).gravity;
    end
end
clear gravityResult gravityTime;


% parse magnet.txt file / find the closest magnet
magnetResult = parseMagnetTextFile([datasetDirectory '/magnet.txt']);
magnetTime = [magnetResult(:).timestamp];
for k = 1:numRonin
    [timeDifference, indexMagnet] = min(abs(roninResult(k).timestamp - magnetTime));
    if (timeDifference < 0.5)
        roninResult(k).magnet = magnetResult(indexMagnet).magnet;
    end
end
clear magnetResult magnetTime;


% parse game_rv.txt file / find the closest R_gb
gameRVResult = parseGameRVTextFile([datasetDirectory '/game_rv.txt']);
gameRVTime = [gameRVResult(:).timestamp];
for k = 1:numRonin
    [timeDifference, indexGameRV] = min(abs(roninResult(k).timestamp - gameRVTime));
    if (timeDifference < 0.5)
        roninResult(k).R_gb = gameRVResult(indexGameRV).R_gb;
    end
end
clear gameRVResult gameRVTime;


% parse pressure.txt file / find the closest pressure
pressureResult = parsePressureTextFile([datasetDirectory '/pressure.txt']);
pressureTime = [pressureResult(:).timestamp];
for k = 1:numRonin
    [timeDifference, indexPressure] = min(abs(roninResult(k).timestamp - pressureTime));
    if (timeDifference < 0.5)
        roninResult(k).pressure = pressureResult(indexPressure).pressure;
    end
end
clear pressureResult pressureTime;


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


