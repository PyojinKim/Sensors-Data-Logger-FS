clc;
close all;
clear variables; %clear classes;
rand('state',0); % rand('state',sum(100*clock));
dbstop if error;


%% common setting to read text files

delimiter = ' ';
headerlinesIn = 1;
nanoSecondToSecond = 1000000000;


%% 1)

% parse wifi.txt file
[wifiScanResult] = parseWiFiTextFile('wifi.txt');


% vectorize WiFi RSSI for each WiFi scan
[wifiScanRSSI,~] = vectorizeWiFiRSSI(wifiScanResult);







coeff = pca(wifiScanRSSI(1).RSSI)




%%










