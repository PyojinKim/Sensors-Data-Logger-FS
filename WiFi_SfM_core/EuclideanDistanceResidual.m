function [residuals] = EuclideanDistanceResidual(roninInitialLocation, roninPolarSpeed, roninPolarAngle, X)

% RoNIN drift correction model
roninLocation = DriftCorrectedRoninPolarModel(roninInitialLocation, roninPolarSpeed, roninPolarAngle, X);


%%
% datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20200109090901R_WiFi_SfM';
% roninYawRotation = 35;     % degree

% some corners
residuals(1) = norm(roninLocation(:,237) - roninLocation(:,1080));
residuals(2) = norm(roninLocation(:,325) - roninLocation(:,950));
residuals(3) = norm(roninLocation(:,420) - roninLocation(:,815));


%%
% datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Asus_Tango/SFU_TASC1_8000/20200113110654R_WiFi_SfM';
% roninYawRotation = 225;   % degree
%
%
% % 8002.2 office (origin)
% residuals(1) = norm(roninLocation(:,1) - roninLocation(:,256));
% residuals(2) = norm(roninLocation(:,1) - roninLocation(:,1024));
% residuals(3) = norm(roninLocation(:,1) - roninLocation(:,1194));
%
% % ASB corners
% residuals(4) = norm(roninLocation(:,405) - roninLocation(:,874));
% residuals(5) = norm(roninLocation(:,526) - roninLocation(:,753));
%
% % TASC1 corners
% residuals(6) = norm(roninLocation(:,291) - roninLocation(:,975));
% residuals(7) = norm(roninLocation(:,975) - roninLocation(:,1073));
% residuals(8) = norm(roninLocation(:,1073) - roninLocation(:,1131));
%
% residuals(9) = norm(roninLocation(:,18) - roninLocation(:,1046));
% residuals(10) = norm(roninLocation(:,1046) - roninLocation(:,1155));


end

