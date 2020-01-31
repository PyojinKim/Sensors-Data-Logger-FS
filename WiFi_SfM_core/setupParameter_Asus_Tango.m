

%%
datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Asus_Tango/SFU_TASC1_8000/20200113110654R_WiFi_SfM';
roninInterval = 200;          % 1 Hz
roninYawRotation = 225;   % degree


%%
datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Asus_Tango/SFU_TASC1_8000/20200114112923R_WiFi_SfM';
roninInterval = 200;          % 1 Hz
roninYawRotation = 190;   % degree


%%
datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Asus_Tango/SFU_TASC1_8000/20200124095815R_WiFi_SfM';
roninInterval = 200;          % 1 Hz
roninYawRotation = 190;   % degree


%%
datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Asus_Tango/SFU_TASC1_8000/20200128032502R_WiFi_SfM';
roninInterval = 200;          % 1 Hz
roninYawRotation = 190;   % degree


%%
datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Asus_Tango/SFU_TASC1_8000/20200130020616R_WiFi_SfM';
roninInterval = 200;          % 1 Hz
roninYawRotation = 190;   % degree








%%

% plot RoNIN 2D trajectory
figure;
roninLocation = [roninResult(:).location];
plot(roninLocation(1,:),roninLocation(2,:),'k-','LineWidth',1.0); hold on; grid on; axis equal;
set(gcf,'Units','pixels','Position',[900 300 800 600]);  % modify figure

