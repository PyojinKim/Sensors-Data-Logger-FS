%% manual alignment for global inertial frame

switch( expCase )
    
    case 1
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Asus_Tango/SFU_TASC1_8000/20200114112923R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 190;   % degree
        
        % correction term
        yaw = 0.0;
        tx = 0.0;
        ty = 0.0;
        
    case 2
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Asus_Tango/SFU_TASC1_8000/20200124095815R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 190;   % degree
        
        % correction term
        yaw = -5.0;
        tx = 0.0;
        ty = 0.0;
        
    case 3
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Asus_Tango/SFU_TASC1_8000/20200128032502R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 190;   % degree
        
        % correction term
        yaw = 0.0;
        tx = 0.0;
        ty = 0.0;
        
    case 4
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Asus_Tango/SFU_TASC1_8000/20200130020616R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 190;   % degree
        
        % correction term
        yaw = -4.0;
        tx = 0.0;
        ty = 0.0;
        
end
