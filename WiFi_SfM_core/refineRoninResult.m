function roninResult = refineRoninResult(roninResult, validRoninIndex)

% valid RoNIN index after removing RoNIN stationary motion
roninResult = roninResult(validRoninIndex);
numRonin = size(roninResult,2);


% refine invalid RoNIN result from Google FLP
FLPAccuracyThreshold = 25.0;   % meter
for k = numRonin:-1:1
    if (roninResult(k).FLPAccuracy > FLPAccuracyThreshold)
        roninResult(k) = [];
    end
end


end

