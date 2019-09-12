clc;
close all;
clear variables; %clear classes;
rand('state',0); % rand('state',sum(100*clock));
dbstop if error;


%%

delimiter = ' ';
headerlinesIn = 0;

% parsing device orientation text
textFileDir = '20190906101032R_pjinkim_gsn.txt';
textRoninTrajectoryData = importdata(textFileDir, delimiter, headerlinesIn);
roninTrajectory = textRoninTrajectoryData(:,[1:2]).';


figure;
plot(roninTrajectory(1,:), roninTrajectory(2,:),'m','LineWidth',2); hold on; grid on;
legend('RoNIN'); axis equal;
xlabel('x [m]','fontsize',12); ylabel('y [m]','fontsize',12); hold off;


















