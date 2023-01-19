function [navigationIndex_Xaxis,navigationIndex_Yaxis,propLarvInAnglGroup,matrixProbOrientation,transitionMatrixOrientation,binsXdistributionInitEnd,...
    avgSpeedRoundT, stdSpeedRoundT, semSpeedRoundT,avgMeanSpeed,avgStdSpeed,avgSemSpeed,...
    avgSpeed085RoundT, stdSpeed085RoundT, semSpeed085RoundT,avgMeanSpeed085,avgStdSpeed085,avgSemSpeed085,...
    avgSpeedPerOrientation,stdSpeedPerOrientation,avgSpeed085PerOrientation,stdSpeed085PerOrientation,...
    meanAngularSpeedPerT,stdAngularSpeedPerT,avgMeanAngularSpeed,avgStdAngularSpeed,angularSpeed,...
    avgAngularSpeedPerOrientation,stdAngularSpeedPerOrientation] = extractFeaturesPerExperiment(varargin)

    if isempty(varargin)
        close all
        clear all
        addpath(genpath('lib'))
        %Select folder to analyse the data from Choreography
        dirPath = uigetdir('../Choreography_results','select folder');
    else
        dirPath=varargin{1};
    end

if ~exist(fullfile(dirPath,'navigationResults.mat'),'file')

    %select the folder to load
    [xFile, yFile, areaFile, speedFile, speedFile085, castFile, morpwidFile, dataSpine, cellOutlinesLarvae]=loadChoreographyFiles(dirPath);
    
    %discard those bodies detected for less than 20 seconds and remove the
    %ones appearing in the borders.

    %% Navigation index (movement along X axis from yFile and along Y axis from xFile)
    
    %(xFile corresponds with yAxis being larger values top, lower bottom)
    %(yFile corresponds with xAxis being larger values left [patches], lower right)

    navigationIndex_Xaxis=calculateNavigationIndex(yFile);
    navigationIndex_Yaxis=calculateNavigationIndex(xFile);


    %% Calculate probability of orientation between 225dg and 315dg (heading odor); 45dg & 135dg (opposite to odor); 135dg & 225dg (heading top); 315dg % 45dg (heading bottom)
    %orient.dat will provide the angle of the body, in degrees. Head and tail
    %are not, in general, determined, so this value is only correct modulo pi.
    %We will have to determinate where the head is pointing considering the two
    %previous timepoints.
    
    % left - rigth - top - bottom orientationGroups
    [propLarvInAnglGroup,orderedAllLarvOrientPerSec,larvaeAngle] = calculateLarvaeOrientations(xFile,yFile);

    %% Probability of larvae heading one direction and change the trajectory to another possible direction
    [matrixProbOrientation,transitionMatrixOrientation]=calculateProbabilityOfOrientation(orderedAllLarvOrientPerSec);
    
    
    %% Calculate histogram of space occupied at the beginning and at the end (only X axis, from 180 to 2160) - Check timePoint=10s and 600s
    initTime=10;
    endTime=590;
    xAxisLimits=[18,216];
    
    binsXdistributionInitEnd=calculatePositionDistributionXaxis(initTime, endTime,xAxisLimits,yFile);
    
    %% Speed (per second and in average)
    
    [avgSpeedRoundT, stdSpeedRoundT, semSpeedRoundT,avgMeanSpeed,avgStdSpeed,avgSemSpeed] = calculateAverageSpeed(speedFile);
    [avgSpeed085RoundT, stdSpeed085RoundT, semSpeed085RoundT,avgMeanSpeed085,avgStdSpeed085,avgSemSpeed085] = calculateAverageSpeed(speedFile085);

    
    %% Average speed when larvae are pointing the odor patches (oriented btw 45-315 degrees) and avoiding them (oriented btw 135-225 degrees).

    [avgSpeedPerOrientation,stdSpeedPerOrientation]=calculateAvgSpeedPerOrientation(speedFile,orderedAllLarvOrientPerSec);
    [avgSpeed085PerOrientation,stdSpeed085PerOrientation]=calculateAvgSpeedPerOrientation(speedFile085,orderedAllLarvOrientPerSec);

    %% Average angular speed
    %angular change between 2 consecutive time points.
    [meanAngularSpeedPerT,stdAngularSpeedPerT,avgStdAngularSpeed,avgMeanAngularSpeed,angularSpeed]  = calculateAngularSpeed (larvaeAngle);
    [avgAngularSpeedPerOrientation,stdAngularSpeedPerOrientation]=calculateAvgSpeedPerOrientation(angularSpeed,orderedAllLarvOrientPerSec);
    

    save(fullfile(dirPath,'navigationResults.mat'),'navigationIndex_Xaxis','navigationIndex_Yaxis','propLarvInAnglGroup',...,
                'matrixProbOrientation','transitionMatrixOrientation','binsXdistributionInitEnd','avgSpeedRoundT', 'stdSpeedRoundT', 'semSpeedRoundT','avgMeanSpeed','avgStdSpeed','avgSemSpeed',...
                'avgSpeed085RoundT', 'stdSpeed085RoundT', 'semSpeed085RoundT','avgMeanSpeed085','avgStdSpeed085','avgSemSpeed085','avgSpeedPerOrientation','stdSpeedPerOrientation',...,
                'avgSpeed085PerOrientation','stdSpeed085PerOrientation','meanAngularSpeedPerT','stdAngularSpeedPerT','avgStdAngularSpeed','avgMeanAngularSpeed','angularSpeed',...
                'avgAngularSpeedPerOrientation','stdAngularSpeedPerOrientation')

else
    load(fullfile(dirPath,'navigationResults.mat'));
end

%%%%%% POSSIBLE IDEAS TO IMPLEMENT IN FUTURE %%%%%%

%   %%% I don't trust in the accuracy of castFile because the larvae are pretty small and this parameter is high sensity.  
%   %% measure number of casting in average
%      [averageNumberOfCastingsTotal, averageNumberOfCastsWhen]=calculateAverageNumberOfCastings(castFile,xFile,yFile);        


%     %% GLOBAL PHENOTYPE MEASUREMENT %%
%     
      %%%% consider only the larvae reamining at least 100 seconds %%%%

%     minTimesPerID = arrayfun(@(x) min(xFile(xFile(:,1)==x,2)), uniqueId);
%     initCoordXLarvae = arrayfun(@(x,y) xFile(xFile(:,2)==x & xFile(:,1)==y,3),minTimesPerID,uniqueId);
%     initCoordYLarvae = arrayfun(@(x,y) yFile(yFile(:,2)==x & yFile(:,1)==y,3),minTimesPerID,uniqueId);
%     maxTimesPerID = arrayfun(@(x) max(xFile(xFile(:,1)==x,2)), uniqueId);
%     lastCoordXLarvae = arrayfun(@(x,y) mean(xFile(xFile(:,2)==x & xFile(:,1)==y,3)),maxTimesPerID,uniqueId);
%     lastCoordYLarvae = arrayfun(@(x,y) mean(yFile(yFile(:,2)==x & yFile(:,1)==y,3)),maxTimesPerID,uniqueId);
%     medianAreaLarvae = arrayfun(@(x) median(areaFile(areaFile(:,1)==x,3)), uniqueId);
%     morpwidLarvae = arrayfun(@(x) median(morpwidFile(morpwidFile(:,1)==x,3)), uniqueId);
%     
%     [angleInitVector,angleLastVector]=calculateInitAndLastDirectionPerID(xFile,yFile,minTimesPerID,maxTimesPerID,uniqueId);
%     
%     tableSummaryFeaturesRaw = array2table([uniqueId,minTimesPerID,maxTimesPerID,initCoordXLarvae,lastCoordXLarvae,initCoordYLarvae,lastCoordYLarvae,angleInitVector,angleLastVector,medianAreaLarvae,morpwidLarvae],'VariableNames',{'id','minTime','maxTime','xCoordInit','xCoordEnd','yCoordInit','yCoordEnd','directionLarvaInit','directionLarvaLast','area','morpWidth'});
     %%%%% REMOVE X BORDERS LARVAE %%%%% (most likely artifacts)
%        borderIds = tableSummaryFeaturesRaw.yCoordInit < 35 | tableSummaryFeaturesRaw.yCoordInit > 190;
%     [tableSummaryFeaturesRaw,xFile,yFile,speedFile,dataSpine,cellOutlinesLarvae,castFile]=removeBorderIds(borderIds,tableSummaryFeaturesRaw,xFile,yFile,speedFile,dataSpine,cellOutlinesLarvae,castFile);
% %Correcting some trajectories. Removing isolated trajectories appearing at
% %Y borders, and short trajectories.
% borderIds = tableSummaryFeatures.xCoordInit < 10 | tableSummaryFeatures.xCoordInit > 160;
%[tableSummaryFeaturesFiltered,xFileUpdated,yFileUpdated,speedFileUpdated,dataSpineUpdated,cellOutlinesLarvaeUpdated,castFileUpdated]=removeBorderIds(borderIds,tableSummaryFeatures,xFileUpdated,yFileUpdated,speedFileUpdated,dataSpineUpdated,cellOutlinesLarvaeUpdated,castFileUpdated);




%     %Polar histogram with trajectories (USING AUTOMATIC ID TRACKED LARVAE)
%     angleInitFinalPoint = atan2(tableSummaryFeaturesFiltered.xCoordEnd - tableSummaryFeaturesFiltered.xCoordInit, tableSummaryFeaturesFiltered.yCoordEnd - tableSummaryFeaturesFiltered.yCoordInit);
%     distInitFinalPoint = pdist2([tableSummaryFeaturesFiltered.xCoordInit, tableSummaryFeaturesFiltered.yCoordInit],[tableSummaryFeaturesFiltered.xCoordEnd, tableSummaryFeaturesFiltered.yCoordEnd]);
%     distBetwPairs = diag(distInitFinalPoint);
%     
%     h1=figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
%     p=polarhistogram(angleInitFinalPoint,12);
%     labels = findall(gca,'type','text');
%     set(labels,'visible','off');
%     set(gca,'FontSize', 24,'FontName','Helvetica','GridAlpha',1);
%     rticks([])
%     
%     % lines = findall(gca,'type','line');
%     % set(lines,'visible','off');
%     
%     h2=figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
%     [x,y] = pol2cart(angleInitFinalPoint,distBetwPairs./max(distBetwPairs));
%     compass(x,y)
%     labels = findall(gca,'type','text');
%     set(labels,'visible','off');
%     rticks([])
%     
%     
%     %polar plot
% 
%     
%     %findLarvaeFollowingGradient
%     %calculateAgilityIndex
%     %calculateLarvaeSpeed
end