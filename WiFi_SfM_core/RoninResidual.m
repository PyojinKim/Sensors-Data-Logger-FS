function [residuals] = RoninResidual(roninInitialLocation, roninPolarSpeed, roninPolarAngle, X)


roninLocation = RoninPolarModel(roninInitialLocation, roninPolarSpeed, roninPolarAngle, X);

% 8002.2 office
residuals(1) = norm(roninLocation(:,1) - roninLocation(:,256));
residuals(2) = norm(roninLocation(:,1) - roninLocation(:,1024));
residuals(3) = norm(roninLocation(:,1) - roninLocation(:,1194));

% ASB corners
residuals(4) = norm(roninLocation(:,405) - roninLocation(:,874));
residuals(5) = norm(roninLocation(:,526) - roninLocation(:,753));

% TASC1 corners
residuals(6) = norm(roninLocation(:,291) - roninLocation(:,975));
residuals(7) = norm(roninLocation(:,975) - roninLocation(:,1073));
residuals(8) = norm(roninLocation(:,1073) - roninLocation(:,1131));

residuals(9) = norm(roninLocation(:,18) - roninLocation(:,1046));
residuals(10) = norm(roninLocation(:,1046) - roninLocation(:,1155));


end

