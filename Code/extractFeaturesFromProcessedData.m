%% INDIVIDUAL MEASUREMENTS %%

%select the file to process
[fileName, pathFile]=uigetfile('select file containing processed tracking information','*.mat');
load(fullfile(pathFile,fileName))

%% calculate average speed. 
%Only measure the time intervals when the larva is not stacked. 


%% measure number of casting in average
[averageNumberOfCastings]=calculateAverageNumberOfCastings(updatedCastFile,xFile,yFile);

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