%% manual alignment for global inertial frame

switch( expCase )
    
    case 1
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20200109090901R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:2711;
        
    case 2
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20200121091935R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        
        
        
        
        
end
