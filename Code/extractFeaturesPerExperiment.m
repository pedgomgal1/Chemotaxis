function [navigationIndex_Xaxis,navigationIndex_Yaxis,propLarvInAnglGroup,matrixProbOrientation,transitionMatrixOrientation,matrixProbMotionStates,transitionMatrixMotionStates,binsXdistributionInitEnd,...
    avgSpeedRoundT, stdSpeedRoundT, semSpeedRoundT,avgMeanSpeed,avgStdSpeed,avgSemSpeed,...
    avgSpeed085RoundT, stdSpeed085RoundT, semSpeed085RoundT,avgMeanSpeed085,avgStdSpeed085,avgSemSpeed085,...
    avgCrabSpeedRoundT, stdCrabSpeedRoundT, semCrabSpeedRoundT,avgMeanCrabSpeed,avgStdCrabSpeed,avgSemCrabSpeed,...
    avgAreaRoundT, stdAreaRoundT, semAreaRoundT,avgMeanArea,avgStdArea,avgSemArea,...
    avgCurveRoundT, stdCurveRoundT, semCurveRoundT,avgMeanCurve,avgStdCurve,avgSemCurve,...
    avgSpeedPerOrientation,stdSpeedPerOrientation,avgSpeed085PerOrientation,stdSpeed085PerOrientation, ...
    avgCrabSpeedPerOrientation,stdCrabSpeedPerOrientation,avgCurvePerOrientation,stdCurvePerOrientation,...
    meanAngularSpeedPerT,stdAngularSpeedPerT,semAngularSpeedPerT,avgMeanAngularSpeed,avgSemAngularSpeed,avgStdAngularSpeed,angularSpeed,...
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

%if ~exist(fullfile(dirPath,'navigationResults.mat'),'file')

    %select the folder to load
    [xFile, yFile, areaFile, speedFile, speedFile085, crabSpeedFile,curveFile, castFile, morpwidFile, dataSpine, cellOutlinesLarvae]=loadChoreographyFiles(dirPath);

    %%% Filtering VALID larvae %%%
    % consider only the larvae reamining at least 30 seconds and do not appearing in the borders of the plate (possible
    %artifacts) %%%

    thresholdTime = 30; % 30 seg
    uniqueId=unique(xFile(:,1));

    minTimesPerID = arrayfun(@(x) min(xFile(xFile(:,1)==x,2)), uniqueId);
    initCoordXLarvae = arrayfun(@(x,y) xFile(xFile(:,2)==x & xFile(:,1)==y,3),minTimesPerID,uniqueId);
    initCoordYLarvae = arrayfun(@(x,y) yFile(yFile(:,2)==x & yFile(:,1)==y,3),minTimesPerID,uniqueId);
    maxTimesPerID = arrayfun(@(x) max(xFile(xFile(:,1)==x,2)), uniqueId);
    lastCoordXLarvae = arrayfun(@(x,y) mean(xFile(xFile(:,2)==x & xFile(:,1)==y,3)),maxTimesPerID,uniqueId);
    lastCoordYLarvae = arrayfun(@(x,y) mean(yFile(yFile(:,2)==x & yFile(:,1)==y,3)),maxTimesPerID,uniqueId);
    medianAreaLarvae = arrayfun(@(x) median(areaFile(areaFile(:,1)==x,3)), uniqueId);
    morpwidLarvae = arrayfun(@(x) median(morpwidFile(morpwidFile(:,1)==x,3)), uniqueId);
    
    [angleInitVector,angleLastVector]=calculateInitAndLastDirectionPerID(xFile,yFile,minTimesPerID,maxTimesPerID,uniqueId);
    
    tableSummaryFeaturesRaw = array2table([uniqueId,minTimesPerID,maxTimesPerID,initCoordXLarvae,lastCoordXLarvae,initCoordYLarvae,lastCoordYLarvae,angleInitVector,angleLastVector,medianAreaLarvae,morpwidLarvae],'VariableNames',{'id','minTime','maxTime','xCoordInit','xCoordEnd','yCoordInit','yCoordEnd','directionLarvaInit','directionLarvaLast','area','morpWidth'});
    
    
    %%%% REMOVE X BORDERS LARVAE %%%%% (most likely artifacts)
    borderXIds = tableSummaryFeaturesRaw.yCoordInit < 35 | tableSummaryFeaturesRaw.yCoordInit > 190;
    borderYIds = tableSummaryFeaturesRaw.xCoordInit < 10 | tableSummaryFeaturesRaw.xCoordInit > 160;
    idsFewTime= (tableSummaryFeaturesRaw.maxTime - tableSummaryFeaturesRaw.minTime) < thresholdTime;

    [tableSummaryFeatures,xFile,yFile,speedFile,speedFile085,crabSpeedFile,areaFile,dataSpine,cellOutlinesLarvae,curveFile,castFile]=removeBorderIds((borderXIds | borderYIds | idsFewTime),tableSummaryFeaturesRaw,xFile,yFile,speedFile,speedFile085,crabSpeedFile,areaFile,dataSpine,cellOutlinesLarvae,curveFile,castFile);


    %% Navigation index (movement along X axis from yFile and along Y axis from xFile)
    
    %(xFile corresponds with yAxis being larger values top, lower bottom)
    %(yFile corresponds with xAxis being larger values right, loewer left [patches]
    navigationIndex_Xaxis=calculateNavigationIndex(yFile);
    navigationIndex_Yaxis=calculateNavigationIndex(xFile);


    %% Calculate probability of orientation between 225dg and 315dg (heading odor); 45dg & 135dg (opposite to odor); 135dg & 225dg (heading top); 315dg % 45dg (heading bottom)
    %orient.dat will provide the angle of the body, in degrees. Head and tail
    %are not, in general, determined, so this value is only correct modulo pi.
    %We will have to determinate where the head is pointing considering the two
    %previous timepoints.
    
    % left - rigth - top - bottom orientationGroups
    %% CALCULATE LARVAE ANGLE USING SPINE DATA. ANGLE BETWEEN HEAD AND TAIL POINTS
    [propLarvInAnglGroup,orderedAllLarvOrientPerSec,larvaeAngle,anglesTail2Head_RoundT,~,posTailLarvae_RoundT] = calculateLarvaeOrientations(xFile,yFile,dataSpine);

    idToChange = ismember(larvaeAngle(:,2),anglesTail2Head_RoundT(:,2),'rows');
    larvaeAngle(idToChange,:)=anglesTail2Head_RoundT;

    %% Probability of larvae heading one direction and change the trajectory to another possible direction
    nOrientStages = 4; % left - rigth - top - bottom
    [matrixProbOrientation,transitionMatrixOrientation]=calculateProbabilityOfOrientation(orderedAllLarvOrientPerSec,nOrientStages);

    %% Calculate percentage of reorientation points/ turning rate (when > 45 degrees), and proportion of run-turning states 
    thresholdAngle = 30; %degrees
    thresholdDistance = 0.03; 
    [orderedLarvaePerStatesRunStopTurn] = calculateTurningRate(larvaeAngle,posTailLarvae_RoundT,thresholdAngle,thresholdDistance);
    nMovStages = 3; % run - stop - turn
    [matrixProbMotionStates,transitionMatrixMotionStates]=calculateProbabilityOfOrientation(orderedLarvaePerStatesRunStopTurn,nMovStages);

    %% Calculate crawling agility and reorientation agility based on (Günther, M. et al. 2016, Scientific Reports), basically, speed at every state (running forward or turning)

    
    %%%% ----- DANIEL ------ %%%%
    %% Calculate the Mean Squared Displacement (MSD) (Jakubowski B.R. et al. 2012). 
    %The MSD is proportional to the average area covered in a given amount of time, τ, by a large number of particles starting from the same spatiotemporal origin and having the same statistical behavior

    %% Calculate directional autocorrelation (DAC) 
   
    
    
    %% Calculate histogram of space occupied at the beginning and at the end (only X axis, from 180 to 2160) - Check timePoint=10s and 600s
    initTime=10;
    midTime =300;
    endTime=590;
    xAxisLimits=[18,216];
    
    binsXdistributionInitEnd=calculatePositionDistributionXaxis(initTime, midTime, endTime,xAxisLimits,yFile);
    
    
    %% Speed (per second and in average)
    [avgSpeedRoundT, stdSpeedRoundT, semSpeedRoundT,avgMeanSpeed,avgStdSpeed,avgSemSpeed,~,~,~,~,~,~,~,~] = calculateAverageSpeedAndAcceleration(speedFile);
    [avgSpeed085RoundT, stdSpeed085RoundT, semSpeed085RoundT,avgMeanSpeed085,avgStdSpeed085,avgSemSpeed085,~,~,~,~,~,~,~,~] = calculateAverageSpeedAndAcceleration(speedFile085);
    [avgCrabSpeedRoundT, stdCrabSpeedRoundT, semCrabSpeedRoundT,avgMeanCrabSpeed,avgStdCrabSpeed,avgSemCrabSpeed,~,~,~,~,~,~,~,~] = calculateAverageSpeedAndAcceleration(crabSpeedFile);

    
    %% Average speed when larvae are pointing the odor patches (oriented btw 45-315 degrees) and avoiding them (oriented btw 135-225 degrees).
    [avgSpeedPerOrientation,stdSpeedPerOrientation]=calculateAvgSpeedPerOrientation(speedFile,orderedAllLarvOrientPerSec);
    [avgSpeed085PerOrientation,stdSpeed085PerOrientation]=calculateAvgSpeedPerOrientation(speedFile085,orderedAllLarvOrientPerSec);
    [avgCrabSpeedPerOrientation,stdCrabSpeedPerOrientation]=calculateAvgSpeedPerOrientation(crabSpeedFile,orderedAllLarvOrientPerSec);

    %% Average angular speed
    %angular change between 2 consecutive time points.
    [meanAngularSpeedPerT,stdAngularSpeedPerT,semAngularSpeedPerT,avgStdAngularSpeed,avgMeanAngularSpeed,avgSemAngularSpeed,angularSpeed,~,~]  = calculateAngularSpeed (larvaeAngle);
    [avgAngularSpeedPerOrientation,stdAngularSpeedPerOrientation]=calculateAvgSpeedPerOrientation(angularSpeed,orderedAllLarvOrientPerSec);
    
    %% Area (per second and in average)
    [avgAreaRoundT, stdAreaRoundT, semAreaRoundT,avgMeanArea,avgStdArea,avgSemArea,~,~,~,~,~,~,~,~] = calculateAverageSpeedAndAcceleration(areaFile);

    %% Curve (per second and in average)
    [avgCurveRoundT, stdCurveRoundT, semCurveRoundT,avgMeanCurve,avgStdCurve,avgSemCurve,~,~,~,~,~,~,~,~] = calculateAverageSpeedAndAcceleration(curveFile);
    [avgCurvePerOrientation,stdCurvePerOrientation]=calculateAvgSpeedPerOrientation(curveFile,orderedAllLarvOrientPerSec);


    %% Consider larvae that remains at least 60 seconds
    save(fullfile(dirPath,'navigationResults.mat'),'navigationIndex_Xaxis','navigationIndex_Yaxis','propLarvInAnglGroup',...,
                'matrixProbOrientation','transitionMatrixOrientation','matrixProbMotionStates','transitionMatrixMotionStates','binsXdistributionInitEnd','avgSpeedRoundT', 'stdSpeedRoundT', 'semSpeedRoundT','avgMeanSpeed','avgStdSpeed','avgSemSpeed',...
                'avgSpeed085RoundT', 'stdSpeed085RoundT', 'semSpeed085RoundT','avgMeanSpeed085','avgStdSpeed085','avgSemSpeed085', ...
                'avgCrabSpeedRoundT', 'stdCrabSpeedRoundT', 'semCrabSpeedRoundT','avgMeanCrabSpeed','avgStdCrabSpeed','avgSemCrabSpeed',...
                'avgAreaRoundT', 'stdAreaRoundT', 'semAreaRoundT','avgMeanArea','avgStdArea','avgSemArea',...
                'avgCurveRoundT', 'stdCurveRoundT', 'semCurveRoundT','avgMeanCurve','avgStdCurve','avgSemCurve',...
                'avgSpeedPerOrientation','stdSpeedPerOrientation','avgSpeed085PerOrientation','stdSpeed085PerOrientation',...
                'avgCrabSpeedPerOrientation','stdCrabSpeedPerOrientation','avgCurvePerOrientation','stdCurvePerOrientation',...
                'meanAngularSpeedPerT','stdAngularSpeedPerT','semAngularSpeedPerT','avgStdAngularSpeed','avgMeanAngularSpeed',...
                'avgSemAngularSpeed','angularSpeed','avgAngularSpeedPerOrientation','stdAngularSpeedPerOrientation')

    
% else
%      load(fullfile(dirPath,'navigationResults.mat'));
% end

%%%%%% POSSIBLE IDEAS TO IMPLEMENT IN FUTURE %%%%%%

  %%% I don't trust in the accuracy of castFile because the larvae are pretty small and this parameter is high sensity.  
%   %% measure number of casting in average
%      [averageNumberOfCastingsTotal, averageNumberOfCastsWhen]=calculateAverageNumberOfCastings(castFile,xFile,yFile);        


    %% GLOBAL PHENOTYPE MEASUREMENT %%
    
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