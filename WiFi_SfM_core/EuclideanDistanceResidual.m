function [residuals] = EuclideanDistanceResidual(roninInitialLocation, roninPolarSpeed, roninPolarAngle, X)

% RoNIN drift correction model
roninLocation = DriftCorrectedRoninAbsoluteAngleModel(roninInitialLocation, roninPolarSpeed, roninPolarAngle, X);
%roninLocation = DriftCorrectedRoninDeltaAngleModel(roninInitialLocation, roninPolarSpeed, roninPolarDeltaAngle, X);


%%
% datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Asus_Tango/SFU_TASC1_8000/20200114112923R_WiFi_SfM';
% roninYawRotation = 190;     % degree


residuals(1) = norm(roninLocation(:,1) - roninLocation(:,149));
residuals(2) = norm(roninLocation(:,149) - roninLocation(:,150));
residuals(3) = norm(roninLocation(:,150) - roninLocation(:,284));
residuals(4) = norm(roninLocation(:,284) - roninLocation(:,285));
residuals(5) = norm(roninLocation(:,285) - roninLocation(:,501));

residuals(6) = norm(roninLocation(:,58) - roninLocation(:,59));
residuals(7) = norm(roninLocation(:,59) - roninLocation(:,83));
residuals(8) = norm(roninLocation(:,83) - roninLocation(:,84));
residuals(9) = norm(roninLocation(:,84) - roninLocation(:,442));
residuals(10) = norm(roninLocation(:,442) - roninLocation(:,443));

residuals(11) = norm(roninLocation(:,202) - roninLocation(:,203));






% % 8002.2 office (origin)
% residuals(1) = norm(roninLocation(:,1) - roninLocation(:,154));
% residuals(2) = norm(roninLocation(:,1) - roninLocation(:,155));
% residuals(3) = norm(roninLocation(:,1) - roninLocation(:,287));
% residuals(4) = norm(roninLocation(:,1) - roninLocation(:,300));
% residuals(5) = norm(roninLocation(:,1) - roninLocation(:,332));
% residuals(6) = norm(roninLocation(:,1) - roninLocation(:,567));
% residuals(7) = norm(roninLocation(:,1) - roninLocation(:,570));
%
% % TASC1 corners
% residuals(8) = norm(roninLocation(:,20) - roninLocation(:,136));
% residuals(9) = norm(roninLocation(:,136) - roninLocation(:,347));
% residuals(10) = norm(roninLocation(:,347) - roninLocation(:,555));
% residuals(11) = norm(roninLocation(:,555) - roninLocation(:,169));
%
% residuals(12) = norm(roninLocation(:,173) - roninLocation(:,250));
% residuals(13) = norm(roninLocation(:,414) - roninLocation(:,431));
% residuals(14) = norm(roninLocation(:,179) - roninLocation(:,242));
% residuals(15) = norm(roninLocation(:,205) - roninLocation(:,210));
% residuals(16) = norm(roninLocation(:,94) - roninLocation(:,479));
% residuals(17) = norm(roninLocation(:,479) - roninLocation(:,525));
% residuals(18) = norm(roninLocation(:,43) - roninLocation(:,531));


%%
% datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20200109090901R_WiFi_SfM';
% roninYawRotation = 35;     % degree
%
%
% % some corners
% residuals(1) = norm(roninLocation(:,237) - roninLocation(:,1080));
% residuals(2) = norm(roninLocation(:,325) - roninLocation(:,950));
% residuals(3) = norm(roninLocation(:,420) - roninLocation(:,815));


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

