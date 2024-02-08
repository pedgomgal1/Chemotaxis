function allVars = extractFeaturesPerExperiment(varargin)

    if isempty(varargin)
        close all
        clear all
        addpath(genpath('lib'))
        %Select folder to analyse the data from Choreography
        dirPath = uigetdir(fullfile('..','..','cephfs','choreography-results'),'select folder');
    else
        dirPath=varargin{1};
    end

if ~exist(fullfile(dirPath,'navigationResults.mat'),'file')

    %% THRESHOLDS
    thresholds.name="BO1_L2";
    %frame coordinates limit. New larvae IDs arising from outside of those limits will be discarded.
    thresholds.xBorders = [35,190];
    thresholds.yBorders = [10,160];
    thresholds.thresholdAngle = 30; %n degrees to consider a turning event
    thresholds.thresholdDistance = 0.03; % minimum distance to do not consider a larva stopped.
    thresholds.thresholdTime = 30; %minimum time a larva has to be tracked to do not discard it.
    thresholds.angLarvaeThreshold = [45,135,225,315]; % left (odour) [225, 315] ; right [45, 135]; top [135,225] ; bottom [315,45]

    %%histogram representing larvae position (thresholds)
    thresholds.hInitTime=10;%seconds
    thresholds.hMidTimes = [200 400]; %intermediate time points evaluated
    thresholds.hEndTime=590;%last frame evaluated
    thresholds.xAxisLimits=[18,216];

    %% Load files
    [xFile, yFile, areaFile, speedFile, speedFile085, crabSpeedFile,curveFile, castFile, morpwidFile, dataSpine, cellOutlinesLarvae]=loadChoreographyFiles(dirPath);

    %% Load turning or casting states from Autoencoder classifier
    pathPrediction =  strrep(dirPath,'choreography-results','behaviour-tagging-results');
    turnOrCastTable= readJSONpredictionIntoTable(fullfile(pathPrediction,'predicted.label'));
    turnOrCastStates = [turnOrCastTable.id, turnOrCastTable.t, turnOrCastTable.run_large,turnOrCastTable.cast_large,turnOrCastTable.turn_large];
%     turnOrCastStates=[];
    
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
    borderXIds = tableSummaryFeaturesRaw.yCoordInit < thresholds.xBorders(1) | tableSummaryFeaturesRaw.yCoordInit > thresholds.xBorders(2);
    borderYIds = tableSummaryFeaturesRaw.xCoordInit < thresholds.yBorders(1) | tableSummaryFeaturesRaw.xCoordInit > thresholds.yBorders(2);
    idsFewTime= (tableSummaryFeaturesRaw.maxTime - tableSummaryFeaturesRaw.minTime) < thresholds.thresholdTime;

    [tableSummaryFeatures,xFile,yFile,speedFile,speedFile085,crabSpeedFile,areaFile,dataSpine,cellOutlinesLarvae,curveFile,castFile,turnOrCastStates]=removeBorderIds((borderXIds | borderYIds | idsFewTime),tableSummaryFeaturesRaw,xFile,yFile,speedFile,speedFile085,crabSpeedFile,areaFile,dataSpine,cellOutlinesLarvae,curveFile,castFile,turnOrCastStates);


    %% Navigation index (movement along X axis from yFile and along Y axis from xFile)
    %(xFile corresponds with yAxis being larger values bottom, lower top)
    %(yFile corresponds with xAxis being larger values right, lower left [patches]

    %% HAVE TO CALCULATE THE PROPER NAVIGATION INDEX - AVERAGE SPEED ACROSS X AXIS / AVERAGE SPEED %%%
    allVars.navigationIndex_Xaxis=calculateNavigationIndex(yFile); % if positive, larvae tend to travel to the left, if negative toward the right side
    allVars.navigationIndex_Yaxis=calculateNavigationIndex(xFile); % if positive, larvae tend to travel to the top part, if negative toward the bottom



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
    [allVars.propLarvInAnglGroup,orderedAllLarvOrientPerSec,larvaeAngle,anglesTail2Head_RoundT,~,posTailLarvae_RoundT] = calculateLarvaeOrientations(xFile,yFile,dataSpine);

    idToChange = ismember(larvaeAngle(:,1:2),anglesTail2Head_RoundT(:,1:2),'rows');
    idToMatch = ismember(anglesTail2Head_RoundT(:,1:2),larvaeAngle(:,1:2),'rows');
    larvaeAngle(idToChange,:)=anglesTail2Head_RoundT(idToMatch,:);
    larvaeAngle=sortrows(larvaeAngle);

    %% Probability of larvae heading one direction and change the trajectory to another direction
    nOrientStages = 4; %left - rigth - top - bottom
    [allVars.matrixProbOrientation,allVars.transitionMatrixOrientation]=calculateProbabilityOfOrientation(orderedAllLarvOrientPerSec,nOrientStages);

    %% Calculate proportion of run-stop-turning states [THIS SECTION WILL CHANGE WHEN THE MACHINE LEARNING APPROACH FOR BEHAVIOURAL CLASSIFICATION IS SET UP. WE WILL CAPTURE: RUN, STOP, TURN, CASTING]
    
    [orderedLarvaePerStatesRunStopTurn] = calculateTurningRate(anglesTail2Head_RoundT,posTailLarvae_RoundT,thresholds.thresholdAngle,thresholds.thresholdDistance);
    [orderedLarvaePerStatesRunStopTurnCast,orientationBeforeAfter_casting,orientationBeforeAfter_turning] = discriminateTurningAndCasting(orderedLarvaePerStatesRunStopTurn,turnOrCastStates,thresholds.thresholdAngle,larvaeAngle);
    
    %orientation prior and after casting
    cast_right = orientationBeforeAfter_casting>=thresholds.angLarvaeThreshold(1) & orientationBeforeAfter_casting < thresholds.angLarvaeThreshold(2);
    cast_top = orientationBeforeAfter_casting>=thresholds.angLarvaeThreshold(2) & orientationBeforeAfter_casting < thresholds.angLarvaeThreshold(3);
    cast_left = orientationBeforeAfter_casting>=thresholds.angLarvaeThreshold(3) & orientationBeforeAfter_casting < thresholds.angLarvaeThreshold(4);
    cast_bottom = orientationBeforeAfter_casting>=thresholds.angLarvaeThreshold(4) | orientationBeforeAfter_casting < thresholds.angLarvaeThreshold(1);

    allVars.propOrientationPriorCasting = [sum(cast_left(:,1))/size(cast_left,1),sum(cast_right(:,1))/size(cast_right,1),sum(cast_top(:,1))/size(cast_top,1),sum(cast_bottom(:,1))/size(cast_bottom,1)];
    allVars.propOrientationAfterCasting = [sum(cast_left(:,2))/size(cast_left,1),sum(cast_right(:,2))/size(cast_right,1),sum(cast_top(:,2))/size(cast_top,1),sum(cast_bottom(:,2))/size(cast_bottom,1)];

    %orientation prior and after casting + turning
    orientationCastingPlusTurning =  [orientationBeforeAfter_casting;orientationBeforeAfter_turning];

    castTurn_right = orientationCastingPlusTurning>=thresholds.angLarvaeThreshold(1) & orientationCastingPlusTurning < thresholds.angLarvaeThreshold(2);
    castTurn_top = orientationCastingPlusTurning>=thresholds.angLarvaeThreshold(2) & orientationCastingPlusTurning < thresholds.angLarvaeThreshold(3);
    castTurn_left = orientationCastingPlusTurning>=thresholds.angLarvaeThreshold(3) & orientationCastingPlusTurning < thresholds.angLarvaeThreshold(4);
    castTurn_bottom = orientationCastingPlusTurning>=thresholds.angLarvaeThreshold(4) | orientationCastingPlusTurning < thresholds.angLarvaeThreshold(1);

    allVars.propOrientationPriorCastingOrTurning = [sum(castTurn_left(:,1))/size(castTurn_left,1),sum(castTurn_right(:,1))/size(castTurn_right,1),sum(castTurn_top(:,1))/size(castTurn_top,1),sum(castTurn_bottom(:,1))/size(castTurn_bottom,1)];
    allVars.propOrientationAfterCastingOrTurning = [sum(castTurn_left(:,2))/size(castTurn_left,1),sum(castTurn_right(:,2))/size(castTurn_right,1),sum(castTurn_top(:,2))/size(castTurn_top,1),sum(castTurn_bottom(:,2))/size(castTurn_bottom,1)];


    %non-selected behaviour to run
    emptyIdx = sum(orderedLarvaePerStatesRunStopTurnCast(:,3:end),2)==0;
    orderedLarvaePerStatesRunStopTurnCast(emptyIdx,3)=1;

    uniqRoundTime = unique(orderedLarvaePerStatesRunStopTurn(:,2));
    allVars.proportionLarvaeRunPerT = arrayfun(@(x) sum(orderedLarvaePerStatesRunStopTurnCast(ismember(orderedLarvaePerStatesRunStopTurnCast(:,2),x),3))/sum(ismember(orderedLarvaePerStatesRunStopTurnCast(:,2),x)),uniqRoundTime);
    allVars.proportionLarvaeStopPerT = arrayfun(@(x) sum(orderedLarvaePerStatesRunStopTurnCast(ismember(orderedLarvaePerStatesRunStopTurnCast(:,2),x),4))/sum(ismember(orderedLarvaePerStatesRunStopTurnCast(:,2),x)),uniqRoundTime);
    allVars.proportionLarvaeTurnPerT = arrayfun(@(x) sum(orderedLarvaePerStatesRunStopTurnCast(ismember(orderedLarvaePerStatesRunStopTurnCast(:,2),x),5))/sum(ismember(orderedLarvaePerStatesRunStopTurnCast(:,2),x)),uniqRoundTime);
    allVars.proportionLarvaeCastingPerT = arrayfun(@(x) sum(orderedLarvaePerStatesRunStopTurnCast(ismember(orderedLarvaePerStatesRunStopTurnCast(:,2),x),6))/sum(ismember(orderedLarvaePerStatesRunStopTurnCast(:,2),x)),uniqRoundTime);
    
    nMovStages = 4; % run - stop - turn - cast
    [allVars.matrixProbMotionStates,allVars.transitionMatrixMotionStates]=calculateProbabilityOfOrientation(orderedLarvaePerStatesRunStopTurnCast,nMovStages);

    %Proportion of turnings depending on the larvae orientation
    [allVars.runRatePerOrient,allVars.stopRatePerOrient,allVars.turningRatePerOrient] = calculateTurningRatePerOrientation(orderedLarvaePerStatesRunStopTurn,orderedAllLarvOrientPerSec);

    %% Calculate crawling agility and reorientation agility based on (Günther, M. et al. 2016, Scientific Reports), basically, speed at every state (running forward or turning)
    %calculate speed in turn and run
    %how long the larvae take in indivudual casting states. How long the larvae take to abandon the a zone twice the length of the larvae?    

    %% Calculate histogram of space occupied at the beginning, at an intermediate timepoint of the experiment (300seg) and at the end (only X axis, from 180 to 2160) - Check timePoint=10s, 300 and 590s
    allVars.binsXdistributionInitEnd=calculatePositionDistributionXaxis(thresholds.hInitTime, thresholds.hMidTimes, thresholds.hEndTime,thresholds.xAxisLimits,yFile,tableSummaryFeatures,thresholds.xBorders,thresholds.yBorders);


    %% Speed (per second and in average)
    [allVars.avgSpeedRoundT, allVars.stdSpeedRoundT, allVars.semSpeedRoundT,allVars.avgMeanSpeed,allVars.avgStdSpeed,allVars.avgSemSpeed,~,~,~,~,~,~,~,~] = calculateAverageSpeedAndAcceleration(speedFile);
    [allVars.avgSpeed085RoundT, allVars.stdSpeed085RoundT, allVars.semSpeed085RoundT,allVars.avgMeanSpeed085,allVars.avgStdSpeed085,allVars.avgSemSpeed085,~,~,~,~,~,~,~,~] = calculateAverageSpeedAndAcceleration(speedFile085);
    [allVars.avgCrabSpeedRoundT, allVars.stdCrabSpeedRoundT, allVars.semCrabSpeedRoundT,allVars.avgMeanCrabSpeed,allVars.avgStdCrabSpeed,allVars.avgSemCrabSpeed,~,~,~,~,~,~,~,~] = calculateAverageSpeedAndAcceleration(crabSpeedFile);


    %% Average speed when larvae are pointing the odor patches (oriented btw 45-315 degrees) and avoiding them (oriented btw 135-225 degrees).
    [allVars.avgSpeedPerOrientation,allVars.stdSpeedPerOrientation]=calculateAvgSpeedPerOrientation(speedFile,orderedAllLarvOrientPerSec);
    [allVars.avgSpeed085PerOrientation,allVars.stdSpeed085PerOrientation]=calculateAvgSpeedPerOrientation(speedFile085,orderedAllLarvOrientPerSec);
    [allVars.avgCrabSpeedPerOrientation,allVars.stdCrabSpeedPerOrientation]=calculateAvgSpeedPerOrientation(crabSpeedFile,orderedAllLarvOrientPerSec);

    %% Average angular speed
    %angular change between 2 consecutive time points.
    [allVars.meanAngularSpeedPerT,allVars.stdAngularSpeedPerT,allVars.semAngularSpeedPerT,allVars.avgStdAngularSpeed,allVars.avgMeanAngularSpeed,allVars.avgSemAngularSpeed,allVars.angularSpeed,~,~]  = calculateAngularSpeed (larvaeAngle);
    [allVars.avgAngularSpeedPerOrientation,allVars.stdAngularSpeedPerOrientation]=calculateAvgSpeedPerOrientation(allVars.angularSpeed,orderedAllLarvOrientPerSec);

    %% Area (per second and in average)
    [allVars.avgAreaRoundT, allVars.stdAreaRoundT, allVars.semAreaRoundT,allVars.avgMeanArea,allVars.avgStdArea,allVars.avgSemArea,~,~,~,~,~,~,~,~] = calculateAverageSpeedAndAcceleration(areaFile);

    % Average larvae length
    allVars.averageLarvaeLength = calculateAverageLarvaeLength(dataSpine);

    % collectDataForViky(dirPath,allVars.averageLarvaeLength,xFile,yFile,larvaeAngle,speedFile,orderedLarvaePerStatesRunStopTurnCast)

    %% Curve (per second and in average)
    [allVars.avgCurveRoundT, allVars.stdCurveRoundT, allVars.semCurveRoundT,allVars.avgMeanCurve,allVars.avgStdCurve,allVars.avgSemCurve,~,~,~,~,~,~,~,~] = calculateAverageSpeedAndAcceleration(curveFile);
    [allVars.avgCurvePerOrientation,allVars.stdCurvePerOrientation]=calculateAvgSpeedPerOrientation(curveFile,orderedAllLarvOrientPerSec);


    C%onsider larvae that remains at least 60 seconds
    save(fullfile(dirPath,'navigationResults.mat'),'allVars','tableSummaryFeatures','thresholds')

else
    load(fullfile(dirPath,'navigationResults.mat'));
end



end