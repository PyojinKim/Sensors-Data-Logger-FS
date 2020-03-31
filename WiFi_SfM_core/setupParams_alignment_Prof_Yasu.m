%% manual alignment for global inertial frame

switch( expCase )
    
    case 1
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20191211120034R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:4171;
        
    case 2
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20191212091905R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:6588;
        
    case 3
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20191213092310R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:5356;
        
    case 4
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20191216102716R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:2009;
        
    case 5
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20191217092830R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:2233;
        
    case 6
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20191218101306R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:9158;
        
    case 7
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20191219100730R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:3183;
        
    case 8
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20191220110037R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:4291;
        
    case 9
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20200106014640R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:2023;
        
    case 10
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20200107091503R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:7622;
        
    case 11
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20200108112257R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:5959;
        
    case 12
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20200109090901R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion (partial)
        validRoninIndex = 1:2600;
        
    case 13
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20200110095525R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:4028;
        
    case 14
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20200113093600R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion (partial)
        validRoninIndex = 1:3120;
        
    case 15
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20200114104643R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:3540;
        
    case 16
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20200116091923R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:6564;
        
    case 17
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20200117094121R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:5839;
        
    case 18
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20200120113658R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:2543;
        
    case 19
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20200121091935R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:7660;
        
    case 20
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20200123091630R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:7114;
        
    case 21
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20200124092153R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:12780;
        
    case 22
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20200128105904R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:3160;
        
    case 23
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20200129092100R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:4991;
        
    case 24
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20200130091304R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:5287;
        
    case 25
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20200131092145R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:4376;
        
    case 26
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20200205092720R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:2981;
        
    case 27
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20200206091600R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:8904;
        
    case 28
        datasetDirectory = 'G:/Smartphone_Dataset/4_WiFi_SfM/Prof_Yasu/20200207101556R_WiFi_SfM';
        roninInterval = 200;          % 1 Hz
        roninYawRotation = 0;       % degree
        
        % valid RoNIN index after removing RoNIN stationary motion
        validRoninIndex = 1:7146;
        
end


% The 1¢¶
%
% The 1

