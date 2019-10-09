%% 1) RoNIN by IMUs

% import text file
textRoninData = importdata('ronin.txt', delimiter, headerlinesIn);
deviceRoninTime = textRoninData.data(:,1).';
deviceRoninTrajectory = textRoninData.data(:,[2:3]).';
deviceRoninTrajectory(1,:) = (deviceRoninTrajectory(1,:) - deviceRoninTrajectory(1,1));
deviceRoninTrajectory(2,:) = (deviceRoninTrajectory(2,:) - deviceRoninTrajectory(2,1));

R = angle2rotmtx([0;0;(deg2rad(0))]);
R = R(1:2,1:2);
deviceRoninTrajectory = R * deviceRoninTrajectory;

% plot RoNIN 2D trajectory
figure(11);
h_ronin = plot(deviceRoninTrajectory(1,:), deviceRoninTrajectory(2,:),'m','LineWidth',2); hold on; grid on; axis equal;
legend([h_ronin],{'RoNIN'}); hold off;
xlabel('x [m]','FontName','Times New Roman','FontSize',17);
ylabel('y [m]','FontName','Times New Roman','FontSize',17);


%% 2) Fused Location Provider by Google (FLP)

% import text file
textFLPData = importdata('FLP.txt', delimiter, headerlinesIn);
FLPTimeSec = textFLPData.data(:,1).';
FLPTimeSec = (FLPTimeSec - FLPTimeSec(1)) ./ nanoSecondToSecond;
FLPHorizontalPosition = textFLPData.data(:,[2 3 4]).';

% plot horizontal position (latitude / longitude) trajectory on Google map
figure;
plot(FLPHorizontalPosition(2,:), FLPHorizontalPosition(1,:), 'k', 'LineWidth', 3); hold on;
plot_google_map('maptype', 'roadmap', 'APIKey', 'AIzaSyB_uD1rGjX6MJkoQgSDyjHkbdu-b-_5Bjg');
legend('Fused Location Provider'); hold off;
xlabel('Longitude [deg]','FontName','Times New Roman','FontSize',17);
ylabel('Latitude [deg]','FontName','Times New Roman','FontSize',17);
set(gcf,'Units','pixels','Position',[400 200 1000 700]);  % modify figure
FLPTimeSec(end)/60


%% 3) Core Location by Apple (gps)

% import text file
textGPSData = importdata('gps.txt', delimiter, headerlinesIn);
GPSTimeSec = textGPSData.data(:,1).';
GPSTimeSec = (GPSTimeSec - GPSTimeSec(1)) ./ nanoSecondToSecond;
GPSHorizontalPosition = textGPSData.data(:,[2 3 4]).';

% plot horizontal position (latitude / longitude) trajectory on Google map
figure;
plot(GPSHorizontalPosition(2,:), GPSHorizontalPosition(1,:), 'k', 'LineWidth', 3); hold on;
plot_google_map('maptype', 'roadmap', 'APIKey', 'AIzaSyB_uD1rGjX6MJkoQgSDyjHkbdu-b-_5Bjg');
legend('Core Location'); hold off;
xlabel('Longitude [deg]','FontName','Times New Roman','FontSize',17);
ylabel('Latitude [deg]','FontName','Times New Roman','FontSize',17);
set(gcf,'Units','pixels','Position',[400 200 1000 700]);  % modify figure
GPSTimeSec(end)/60


%%

% play 3-DoF device orientation
figure(10);
L = 1; % coordinate axis length
A = [0 0 0 1; L 0 0 1; 0 0 0 1; 0 L 0 1; 0 0 0 1; 0 0 L 1].';
for k = 1:5:numData
    figure(10); cla;
    plot_inertial_frame(0.5); hold on; grid on; axis equal;
    T_gb = [R_gb(:,:,k), ones(3,1);
        zeros(1,3), 1];
    B = T_gb * A;
    plot3(B(1,1:2),B(2,1:2),B(3,1:2),'-r','LineWidth',1);   % x: red
    plot3(B(1,3:4),B(2,3:4),B(3,3:4),'-g','LineWidth',1);  % y: green
    plot3(B(1,5:6),B(2,5:6),B(3,5:6),'-b','LineWidth',1);  % z: blue
    refresh; pause(0.01); k
end


%% unbiased vs raw rotation rate comparison

% compute gyro bias difference
gyroBiasData = unbiasedGyroData - rawGyroData;

% plot gyro bias difference X-Y-Z
figure;
subplot(3,1,1);
plot(unbiasedGyroTime, gyroBiasData(1,:), 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(unbiasedGyroTime) max(unbiasedGyroTime) min(gyroBiasData(1,:)) max(gyroBiasData(1,:))]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
subplot(3,1,2);
plot(unbiasedGyroTime, gyroBiasData(2,:), 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(unbiasedGyroTime) max(unbiasedGyroTime) min(gyroBiasData(2,:)) max(gyroBiasData(2,:))]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
subplot(3,1,3);
plot(unbiasedGyroTime, gyroBiasData(3,:), 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(unbiasedGyroTime) max(unbiasedGyroTime) min(gyroBiasData(3,:)) max(gyroBiasData(3,:))]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
set(gcf,'Units','pixels','Position',[100 200 1800 900]);  % modify figure


% compute gyro bias norm
for k = 1:size(gyroBiasData,2)
    gyroBiasDataNorm(k) = norm(gyroBiasData(:,k));
end

% plot gyro bias norm
figure;
plot(unbiasedGyroTime, gyroBiasDataNorm, 'm'); hold on; grid on; axis tight;
set(gcf,'color','w'); hold off;
axis([min(unbiasedGyroTime) max(unbiasedGyroTime) min(gyroBiasDataNorm) max(gyroBiasDataNorm)]);
set(get(gcf,'CurrentAxes'),'FontName','Times New Roman','FontSize',17);
xlabel('Time [sec]','FontName','Times New Roman','FontSize',17);
ylabel('Gyro Bias','FontName','Times New Roman','FontSize',17);
set(gcf,'Units','pixels','Position',[100 200 1800 900]);  % modify figure


%%




