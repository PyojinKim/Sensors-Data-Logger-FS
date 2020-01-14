


%%




roninResult = parseRoninTextFile('ronin.txt');
wifiScanResult = parseWiFiTextFile('wifi.txt');


location = [roninResult(:).location];



% plot horizontal position trajectory in global inertial frame (meter) - before
figure;
plot(location(1,:),location(2,:),'m-','LineWidth',1.0); grid on; axis equal;
xlabel('x [m]','fontsize',10); ylabel('y [m]','fontsize',10);


GoogleFLPResult = parseGoogleFLPTextFile('FLP.txt');
locationDegree = [GoogleFLPResult(:).locationDegree];


% plot horizontal position (latitude / longitude) trajectory on Google map
figure;
plot(locationDegree(2,:), locationDegree(1,:), 'b*-', 'LineWidth', 1); hold on;
plot_google_map('maptype', 'roadmap', 'APIKey', 'AIzaSyB_uD1rGjX6MJkoQgSDyjHkbdu-b-_5Bjg');
xlabel('Longitude [deg]','FontName','Times New Roman','FontSize',17);
ylabel('Latitude [deg]','FontName','Times New Roman','FontSize',17);





