function [navigationIndex_Xaxis,navigationIndex_Yaxis,propLarvInAnglGroup,matrixProbOrientation,transitionMatrixOrientation,matrixProbMotionStates,transitionMatrixMotionStates,binsXdistributionInitEnd,...
    avgSpeedRoundT, stdSpeedRoundT, semSpeedRoundT,avgMeanSpeed,avgStdSpeed,avgSemSpeed,...
    avgSpeed085RoundT, stdSpeed085RoundT, semSpeed085RoundT,avgMeanSpeed085,avgStdSpeed085,avgSemSpeed085,...
    avgCrabSpeedRoundT, stdCrabSpeedRoundT, semCrabSpeedRoundT,avgMeanCrabSpeed,avgStdCrabSpeed,avgSemCrabSpeed,...
    avgAreaRoundT, stdAreaRoundT, semAreaRoundT,avgMeanArea,avgStdArea,avgSemArea,...
    avgCurveRoundT, stdCurveRoundT, semCurveRoundT,avgMeanCurve,avgStdCurve,avgSemCurve,...
    avgSpeedPerOrientation,stdSpeedPerOrientation,avgSpeed085PerOrientation,stdSpeed085PerOrientation, ...
    avgCrabSpeedPerOrientation,stdCrabSpeedPerOrientation,avgCurvePerOrientation,stdCurvePerOrientation,...
    meanAngularSpeedPerT,stdAngularSpeedPerT,semAngularSpeedPerT,avgMeanAngularSpeed,avgSemAngularSpeed,avgStdAngularSpeed,angularSpeed,...
    avgAngularSpeedPerOrientation,stdAngularSpeedPerOrientation,runRatePerOrient,stopRatePerOrient,turningRatePerOrient,averageLarvaeLength,tableSummaryFeatures] = extractFeaturesPerExperiment(varargin)


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

    %% Load files
    [xFile, yFile, areaFile, speedFile, speedFile085, crabSpeedFile,curveFile, castFile, morpwidFile, dataSpine, cellOutlinesLarvae]=loadChoreographyFiles(dirPath);

    %% Filtering VALID larvae %%
    % consider only the larvae remaining at least 30 seconds and do not appearing in the borders of the plate (possible
    %artifacts) and discard those appearing in the borders %%%
    
    uniqueId=unique(xFile(:,1));

    %Creating a summary table with basic larvae properties
    minTimesPerID = arrayfun(@(x) min(xFile(xFile(:,1)==x,2)), uniqueId);
    initCoordXLarvae = arrayfun(@(x,y) xFile(xFile(:,2)==x & xFile(:,1)==y,3),minTimesPerID,uniqueId);
    initCoordYLarvae = arrayfun(@(x,y) yFile(yFile(:,2)==x & yFile(:,1)==y,3),minTimesPerID,uniqueId);
    maxTimesPerID = arrayfun(@(x) max(xFile(xFile(:,1)==x,2)), uniqueId);
    lastCoordXLarvae = arrayfun(@(x,y) mean(xFile(xFile(:,2)==x & xFile(:,1)==y,3)),maxTimesPerID,uniqueId);
    lastCoordYLarvae = arrayfun(@(x,y) mean(yFile(yFile(:,2)==x & yFile(:,1)==y,3)),maxTimesPerID,uniqueId);
    medianAreaLarvae = arrayfun(@(x) median(areaFile(areaFile(:,1)==x,3)), uniqueId);
    morpwidLarvae = arrayfun(@(x) median(morpwidFile(morpwidFile(:,1)==x,3)), uniqueId);
    medianSpeedLarvae = arrayfun(@(x) median(speedFile085(speedFile085(:,1)==x,3)), uniqueId);
    perc80SpeedLarvae = arrayfun(@(x) prctile(speedFile085(speedFile085(:,1)==x,3),80), uniqueId);
    maxSpeedLarvae = arrayfun(@(x) max(speedFile085(speedFile085(:,1)==x,3)), uniqueId);
    
    [angleInitVector,angleLastVector]=calculateInitAndLastDirectionPerID(xFile,yFile,minTimesPerID,maxTimesPerID,uniqueId);
    tableSummaryFeaturesRaw = array2table([uniqueId,minTimesPerID,maxTimesPerID,initCoordXLarvae,lastCoordXLarvae,initCoordYLarvae,lastCoordYLarvae,angleInitVector,angleLastVector,medianAreaLarvae,morpwidLarvae,maxSpeedLarvae,perc80SpeedLarvae,medianSpeedLarvae],'VariableNames',{'id','minTime','maxTime','xCoordInit','xCoordEnd','yCoordInit','yCoordEnd','directionLarvaInit','directionLarvaLast','area','morpWidth','maxSpeed','perc80Speed','medianSpeed'});
    
    % remove larvae in borders (most likely artifacts)
    thresholdTime = 30; % 30 seg
    borderXIds = tableSummaryFeaturesRaw.yCoordInit < 35 | tableSummaryFeaturesRaw.yCoordInit > 190;
    borderYIds = tableSummaryFeaturesRaw.xCoordInit < 10 | tableSummaryFeaturesRaw.xCoordInit > 160;
    idsFewTime= (tableSummaryFeaturesRaw.maxTime - tableSummaryFeaturesRaw.minTime) < thresholdTime;

    [tableSummaryFeatures,xFile,yFile,speedFile,speedFile085,crabSpeedFile,areaFile,dataSpine,cellOutlinesLarvae,curveFile,castFile]=removeBorderIds((borderXIds | borderYIds | idsFewTime),tableSummaryFeaturesRaw,xFile,yFile,speedFile,speedFile085,crabSpeedFile,areaFile,dataSpine,cellOutlinesLarvae,curveFile,castFile);


    %% Navigation index (movement along X axis from yFile and along Y axis from xFile)
    %(xFile corresponds with yAxis being larger values bottom, lower top)
    %(yFile corresponds with xAxis being larger values right, lower left [patches]

    navigationIndex_Xaxis=calculateNavigationIndex(yFile); % if positive, larvae tend to travel through the left, if negative toward the right side
    navigationIndex_Yaxis=calculateNavigationIndex(xFile); % if positive, larvae tend to travel toward the top part, if negative toward the bottom

    %%%% ----- DANIEL TO FILL ------ %%%%
    %% Calculate the Mean Squared Displacement (MSD) (Jakubowski B.R. et al. 2012). 
    %The MSD is proportional to the average area covered in a given amount of time, τ, by a large number of particles starting from the same spatiotemporal origin and having the same statistical behavior

    %% Calculate directional autocorrelation (DAC) 


    %% Calculate probability of orientation between 225dg and 315dg (heading odor); 45dg & 135dg (opposite to odor); 135dg & 225dg (heading top); 315dg % 45dg (heading bottom)
    %orient.dat will provide the angle of the body, in degrees. Head and tail
    %are not, in general, determined, so this value is only correct modulo pi.
    %We will have to determinate where the head is pointing considering the two
    %previous timepoints.
    
    % left - rigth - top - bottom orientationGroups
    %% CALCULATE LARVAE ANGLE USING SPINE DATA. ANGLE BETWEEN HEAD AND TAIL POINTS
    [propLarvInAnglGroup,orderedAllLarvOrientPerSec,larvaeAngle,anglesTail2Head_RoundT,~,posTailLarvae_RoundT] = calculateLarvaeOrientations(xFile,yFile,dataSpine);

    idToChange = ismember(larvaeAngle(:,1:2),anglesTail2Head_RoundT(:,1:2),'rows');
    idToMatch = ismember(anglesTail2Head_RoundT(:,1:2),larvaeAngle(:,1:2),'rows');
    larvaeAngle(idToChange,:)=anglesTail2Head_RoundT(idToMatch,:);
    larvaeAngle=sortrows(larvaeAngle);

    %% Probability of larvae heading one direction and change the trajectory to another direction
    nOrientStages = 4; %left - rigth - top - bottom
    [matrixProbOrientation,transitionMatrixOrientation]=calculateProbabilityOfOrientation(orderedAllLarvOrientPerSec,nOrientStages);

    %% Calculate proportion of run-stop-turning states [THIS SECTION WILL CHANGE WHEN THE MACHINE LEARNING APPROACH FOR BEHAVIOURAL CLASSIFICATION IS SET UP. WE WILL CAPTURE: RUN, STOP, TURN, CASTING]
    thresholdAngle = 30; %degrees
    thresholdDistance = 0.03; 
    [orderedLarvaePerStatesRunStopTurn] = calculateTurningRate(anglesTail2Head_RoundT,posTailLarvae_RoundT,thresholdAngle,thresholdDistance);
    nMovStages = 3; % run - stop - turn
    [matrixProbMotionStates,transitionMatrixMotionStates]=calculateProbabilityOfOrientation(orderedLarvaePerStatesRunStopTurn,nMovStages);

    %Proportion of turnings depending on the larvae orientation
    [runRatePerOrient,stopRatePerOrient,turningRatePerOrient] = calculateTurningRatePerOrientation(orderedLarvaePerStatesRunStopTurn,orderedAllLarvOrientPerSec);

    %% Calculate crawling agility and reorientation agility based on (Günther, M. et al. 2016, Scientific Reports), basically, speed at every state (running forward or turning)
    %calculate speed in turn and run
    %how long the larvae take in indivudual casting states. How long the larvae take to abandon the a zone twice the length of the larvae?    
    
    %% Calculate histogram of space occupied at the beginning, at and intermediate timepoint of the experiment (300seg) and at the end (only X axis, from 180 to 2160) - Check timePoint=10s and 600s
    initTime=10;
    midTime =300;
    endTime=590;
    xAxisLimits=[18,216];
    xBorders=[30,190];
    yBorders=[10,160];
    
    binsXdistributionInitEnd=calculatePositionDistributionXaxis(initTime, midTime, endTime,xAxisLimits,yFile,tableSummaryFeatures,xBorders,yBorders);
    
    
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

    %% Average larvae length
    averageLarvaeLength = calculateAverageLarvaeLength(dataSpine);

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
                'avgSemAngularSpeed','angularSpeed','avgAngularSpeedPerOrientation','stdAngularSpeedPerOrientation',...
                'runRatePerOrient','stopRatePerOrient','turningRatePerOrient','tableSummaryFeatures','averageLarvaeLength')

    
else
    load(fullfile(dirPath,'navigationResults.mat'));

end

%%%%%% Work on progress - RANDOM FOREST %%%%%%

  %%% I don't trust in the accuracy of castFile because the larvae are pretty small and this parameter is high sensity.  
%   %% measure number of casting in average
%      [averageNumberOfCastingsTotal, averageNumberOfCastsWhen]=calculateAverageNumberOfCastings(castFile,xFile,yFile);        



end