function [roninResult] = parseIMUTextFile(roninResult, datasetDirectory)

% common parameter setting for this function
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


% transform IMU measurements in the global (inertial) frame
for k = 1:numRonin
    R_gb = roninResult(k).R_gb;
    roninResult(k).acceleration = R_gb * roninResult(k).acceleration;
    roninResult(k).gyro = R_gb * roninResult(k).gyro;
    roninResult(k).gravity = R_gb * roninResult(k).gravity;
    roninResult(k).magnet = R_gb * roninResult(k).magnet;
end


end

