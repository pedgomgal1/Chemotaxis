function extractFeaturesPerExperiment(dirPath)

    if isempty(varargin)
        close all
        clear all
        addpath(genpath('lib'))
        %Select folder to analyse the data from Choreography
        dirPath = uigetdir('../Choreography_results','select folder');
    else
        dirPath=varargin{1};
    end
    %select the folder to load
    [xFile, yFile, areaFile, speedFile, castFile, morpwidFile, dataSpine, cellOutlinesLarvae]=loadChoreographyFiles(dirPath);
    
    %%%%%%%%% CALCULATE FEATURES OF INDIVIDUAL EXPERIMENT %%%%%%%%%

    %% Speed (per second and in average)

    %Only measure the time intervals when the larva is not stacked. 
    speedFileRoundT = speedFile;
    speedFileRoundT(:,2) = round(speedFile(:,2));
    uniqRoundTime = unique(round(speedFile(:,2)));
    
    % uniqTime = unique(speedFile(:,2));
    % avgSpeed=arrayfun(@(x) mean(speedFile(ismember(speedFile(:,2),x),3)),uniqTime);
    % plot(uniqTime,avgSpeed)
    
    avgSpeedRoundT=arrayfun(@(x) mean(speedFileRoundT(ismember(speedFileRoundT(:,2),x),3)),uniqRoundTime);
    plot(uniqRoundTime,avgSpeedRoundT)
    mean(avgSpeedRoundT);

    %Average speed when larvae are pointing the odor patches.

    %Average speed when larvae are pointing the opposite side of odor
    %patches.

    
    %% measure number of casting in average
    [averageNumberOfCastings]=calculateAverageNumberOfCastings(castFile,xFile,yFile);
    
    %% calculate how many times the larva change the trajectory left-right and right-left
    % calculateAverageChangeOfDirection()
    
    %% Proportion of displacement left - right
    
    %% Proportion of larvae heading the odor.
    
    %plot trajectories
    
    
    %% GLOBAL PHENOTYPE MEASUREMENT %%
    
    
    
    
    %Calculate average speed
    
    averageSpeedLarvae = arrayfun(@(x) mean(speedFileUpdated(speedFileUpdated(:,2)==x,4)), uniqueId);
    mean(averageSpeedLarvae,'omitnan')
    
    %Polar histogram with trajectories
    angleInitFinalPoint = atan2(tableSummaryFeaturesFiltered.xCoordEnd - tableSummaryFeaturesFiltered.xCoordInit, tableSummaryFeaturesFiltered.yCoordEnd - tableSummaryFeaturesFiltered.yCoordInit);
    distInitFinalPoint = pdist2([tableSummaryFeaturesFiltered.xCoordInit, tableSummaryFeaturesFiltered.yCoordInit],[tableSummaryFeaturesFiltered.xCoordEnd, tableSummaryFeaturesFiltered.yCoordEnd]);
    distBetwPairs = diag(distInitFinalPoint);
    
    h1=figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
    p=polarhistogram(angleInitFinalPoint,12);
    labels = findall(gca,'type','text');
    set(labels,'visible','off');
    set(gca,'FontSize', 24,'FontName','Helvetica','GridAlpha',1);
    rticks([])
    
    % lines = findall(gca,'type','line');
    % set(lines,'visible','off');
    
    h2=figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
    [x,y] = pol2cart(angleInitFinalPoint,distBetwPairs./max(distBetwPairs));
    compass(x,y)
    labels = findall(gca,'type','text');
    set(labels,'visible','off');
    rticks([])
    
    
    %polar plot
    
    % joinUniqueIDLarve()
    % removeFakeLarvae()
    
    %findLarvaeFollowingGradient
    %calculateAgilityIndex
    %calculateLarvaeSpeed
end