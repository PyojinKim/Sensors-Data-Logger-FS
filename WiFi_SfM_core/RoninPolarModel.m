function [roninLocation] = RoninPolarModel(roninInitialLocation, roninPolarSpeed, roninPolarAngle, X)

numRonin = size(roninPolarSpeed,2);
roninScale = X(1:numRonin);
roninBias = X((numRonin+1):end);

roninLocation = zeros(2,numRonin);
roninLocation(:,1) = roninInitialLocation;
for k = 2:numRonin
    
    %
    s = roninScale(k);
    b = roninBias(k);
    
    deltaX = s * roninPolarSpeed(k) * cos(roninPolarAngle(k) + b);
    deltaY = s * roninPolarSpeed(k) * sin(roninPolarAngle(k) + b);
    
    roninLocation(:,k) = roninLocation(:,k-1) + [deltaX; deltaY];
end


end

