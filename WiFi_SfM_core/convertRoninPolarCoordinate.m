function [roninPolarResult] = convertRoninPolarCoordinate(roninResult)

% new RoNIN polar coordinate with 1 Hz upsampling
numRonin = size(roninResult,2);
roninPolarResult(1).location = roninResult(1).location;
roninPolarResult(1).speed = 0.0;
roninPolarResult(1).angle = 0.0;
for k = 2:numRonin
    
    % compute speed & angle
    deltaTime = 1.0;
    deltaLocation = (roninResult(k).location - roninResult(k-1).location);
    speed = norm(deltaLocation / deltaTime);
    angle = atan2(deltaLocation(2), deltaLocation(1));
    
    
    % save each RoNIN speed & angle
    roninPolarResult(k).location = roninResult(k).location;
    roninPolarResult(k).speed = speed;
    roninPolarResult(k).angle = angle;
end


% % compute
% roninPolarResult(1).deltaAngle = 0;
% roninPolarResult(2).deltaAngle = 0;
% for k = 3:numRonin
%     roninPolarResult(k).deltaAngle = roninPolarResult(k).angle - roninPolarResult(k-1).angle;
% end


end

