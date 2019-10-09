

%%

% plot horizontal position (latitude / longitude) trajectory on Google map
h = figure(10);
plot_google_map('maptype', 'roadmap', 'APIKey', 'AIzaSyB_uD1rGjX6MJkoQgSDyjHkbdu-b-_5Bjg'); hold on;
xlabel('Longitude [deg]','FontName','Times New Roman','FontSize',17);
ylabel('Latitude [deg]','FontName','Times New Roman','FontSize',17);
%axis([-122.9257 -122.9129   49.2758   49.2819])
%axis([-122.9162 -122.9078   49.2750   49.2790])
%axis([-122.9151 -122.9133   49.2764   49.2772])
%axis([-122.9156 -122.9127   49.2766   49.2779])
%axis([-122.8972 -122.8949   49.2514   49.2525])
axis([-122.8686 -122.8648   49.2338   49.2357])
set(gcf,'Units','pixels','Position',[400 200 1000 700]);  % modify figure


numData = size(deviceDataset.syncTimestamp,2);
for k = 1:numData
    %% prerequisite to visualize
    
    % current FLP information
    currentTime = deviceDataset.syncTimestamp(k);
    currentTrajectory = deviceDataset.syncFLPhorizontalPositionDegree([2 1],1:k);
    currentRadius = deviceDataset.syncFLPhorizontalPositionRadius(k);
    currentLatitude = deviceDataset.syncFLPhorizontalPositionDegree(1,k);
    currentLongitude = deviceDataset.syncFLPhorizontalPositionDegree(2,k);
    
    h_FLP_history = plot(currentTrajectory(1,:), currentTrajectory(2,:),'k','LineWidth',3);
    h_FLP_location = plot(currentLongitude, currentLatitude,'bo','LineWidth',7);
    
    xt = [currentLongitude+0.0001, currentLongitude+0.0001];
    yt = [currentLatitude+0.0002, currentLatitude+0.0001];
    str = {sprintf('time (s): %.2f', currentTime),sprintf('uncertainty (m): %.2f', currentRadius)};
    h_FLP_text = text(xt, yt, str,'FontSize',15,'FontWeight','bold');
    
    %% save current figure
    
    if (toSave)
        % save directory for MAT data
        SaveDir = [datasetPath '/IROS2020'];
        if (~exist( SaveDir, 'dir' ))
            mkdir(SaveDir);
        end
        
        % save directory for images
        SaveImDir = [SaveDir '/FLP'];
        if (~exist( SaveImDir, 'dir' ))
            mkdir(SaveImDir);
        end
        
        refresh; pause(0.01);
        saveImg = getframe(h);
        imwrite(saveImg.cdata , [SaveImDir sprintf('/%06d.png', k)]);
    end
    
    %% remove FLP plots
    
    delete(h_FLP_history)
    delete(h_FLP_location)
    delete(h_FLP_text);
end













