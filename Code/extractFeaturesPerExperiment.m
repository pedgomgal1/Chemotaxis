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
        globalConstants.RigName='BO1';
        globalConstants.golayFilterStepsWindow = 11; % (11 in L2) number of time steps window to apply goloy filter
        globalConstants.accumAngleThreshold = 45; %accumulative angle to capture a turning event
        globalConstants.timeTurningThreshold = 6; %time to accum a differential angle enough to be classified as a turning event.
        globalConstants.distanceThresholdForTurning = 0.125; % (0.125 in L2)-(1 in 72h)maximum distance between two consecutive center of mass to be included into a turning event. If distance is larger, those timepoints are considered as run 
        %frame coordinates limit. New larvae IDs arising from outside of those limits will be discarded.
        globalConstants.xBorders = [35,190];
        globalConstants.yBorders = [10,160];
        % globalConstants.thresholdAngle = 30; %n degrees to consider a turning event
        globalConstants.thresholdDistance = 0.015; % (0.015 in L2)-(0.25 in 72h) minimum distance to do not consider a larva stopped.
        globalConstants.thresholdTime = 30; %minimum time a larva has to be tracked to do not discard it.
        globalConstants.angLarvaeThreshold = [45,135,225,315]; % left (odour) [225, 315] ; right [45, 135]; top [135,225] ; bottom [315,45]
    
        %%histogram representing larvae position (thresholds)
        globalConstants.hInitTime=10;%seconds
        globalConstants.hMidTimes = [200 400]; %intermediate time points evaluated
        globalConstants.hEndTime=590;%last frame evaluated
        globalConstants.xAxisLimits=[18,216];
        globalConstants.nTPoints = 0:600;

    
        %% Load files
        [xFile, yFile, areaFile, speedFile, speedFile085, crabSpeedFile,curveFile, castFile, morpwidFile, dataSpine, cellOutlinesLarvae]=loadChoreographyFiles(dirPath);
    
    %     %% Load turning or casting states from Autoencoder classifier
    %     pathPrediction =  strrep(dirPath,'choreography-results','behaviour-tagging-results');
    %     turnOrCastTable= readJSONpredictionIntoTable(fullfile(pathPrediction,'predicted.label'));
    %     turnOrCastStates = [turnOrCastTable.id, turnOrCastTable.t, turnOrCastTable.run_large,turnOrCastTable.cast_large,turnOrCastTable.turn_large];
        turnOrCastStates=[];
        
        %% Filtering VALID larvae %%
        % consider only the larvae remaining at least 30 seconds and do not appearing in the borders of the plate (possible
        %artifacts) and discard those new larva IDs showing up in the borders of the plate %%%
        
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
        borderXIds = tableSummaryFeaturesRaw.yCoordInit < globalConstants.xBorders(1) | tableSummaryFeaturesRaw.yCoordInit > globalConstants.xBorders(2);
        borderYIds = tableSummaryFeaturesRaw.xCoordInit < globalConstants.yBorders(1) | tableSummaryFeaturesRaw.xCoordInit > globalConstants.yBorders(2);
        idsFewTime= (tableSummaryFeaturesRaw.maxTime - tableSummaryFeaturesRaw.minTime) < globalConstants.thresholdTime;
    
        [tableSummaryFeatures,xFile,yFile,speedFile,speedFile085,crabSpeedFile,areaFile,dataSpine,cellOutlinesLarvae,curveFile,castFile,turnOrCastStates]=removeBorderIds((borderXIds | borderYIds | idsFewTime),tableSummaryFeaturesRaw,xFile,yFile,speedFile,speedFile085,crabSpeedFile,areaFile,dataSpine,cellOutlinesLarvae,curveFile,castFile,turnOrCastStates);
    

        %% Plot larvae trajectory
        fileParts=strsplit(dirPath,{'/','\'});
        partialSharedDir = fullfile(fileParts{end-2},fileParts{end-1},fileParts{end});
        fileName = [fileParts{end} '@' fileParts{end-2} '@' globalConstants.RigName '@' fileParts{end-1} '@.png'];
        dirImageInit=fullfile('..','..','cephfs','tracking-results',partialSharedDir,fileName);
        try 
            imgInit = imread(dirImageInit);
        catch
            imgInit = zeros(1728,2350);
        end
        minTime = 0; maxTime=600; % time window to plot the larvae trajectories
        maxLengthLarvaeTrajectory =maxTime; % number of seconds to keep the larvae halo
        stepTimeTrack =maxTime; %number of seconds per tracking step
        booleanSave =1 ;
        plotTrajectoryLarvae(cellOutlinesLarvae,xFile,yFile,tableSummaryFeatures.id,dirPath,imgInit,minTime,maxTime,maxLengthLarvaeTrajectory,stepTimeTrack,booleanSave)

    
        %% Navigation index (movement along X axis from yFile and along Y axis from xFile)
        %(xFile corresponds with yAxis being larger values bottom, lower top)
        %(yFile corresponds with xAxis being larger values right, lower left [patches]
    
        %% Calculate Navigation index - avg speed across X axis / avg speed %%%
        [allVars.navigationIndex_roundT,allVars.distanceIndex_Xaxis_roundT, allVars.distanceIndex_Yaxis_roundT,~,~,~,~,~,~]=calculateNavigationIndex(yFile,xFile, globalConstants.golayFilterStepsWindow); % if positive, larvae tend to travel to the left, if negative toward the right side. 0 unbiased.
        
        %% Calculate probability of orientation between 225dg and 315dg (heading odor); 45dg & 135dg (opposite to odor); 135dg & 225dg (heading top); 315dg % 45dg (heading bottom)
        %orient.dat will provide the angle of the body, in degrees. Head and tail
        %are not, in general, determined, so this value is only correct modulo pi.
        %We will have to determinate where the head is pointing considering the two
        %previous timepoints.
        
        % left - rigth - top - bottom orientationGroups
        %%(Deprecated because of shaky larvae contours) CALCULATE LARVAE ANGLE USING SPINE DATA. ANGLE BETWEEN HEAD AND TAIL POINTS
        %% CALCULATE LARVAE ANGLE BASED ON CENTROID IN ROUND TIMEPOINTS AFTER GOLAY FILTER APPLICATION (SMOOTHING SHAKY ARTEFACTUAL TRAJECTORY)
        [avgXFilePerRoundTFile, avgYFilePerRoundTFile,allVars.propLarvInAnglGroup_perT,orderedAllLarvOrientPerSec,larvaeAngle,~,~,~] = calculateLarvaeOrientations(xFile,yFile,dataSpine,globalConstants.angLarvaeThreshold,globalConstants.golayFilterStepsWindow);
       
        % idToChange = ismember(larvaeAngle(:,1:2),anglesTail2Head_RoundT(:,1:2),'rows');
        % idToMatch = ismember(anglesTail2Head_RoundT(:,1:2),larvaeAngle(:,1:2),'rows');
        % larvaeAngle(idToChange,:)=anglesTail2Head_RoundT(idToMatch,:);
        % larvaeAngle=sortrows(larvaeAngle);
    
        %% Probability of larvae heading one direction and change the trajectory to another direction
        nOrientStages = 4; %left - rigth - top - bottom
        varNames = {'current_LEFT','current_RIGHT','current_UP','current_DOWN'};
        rowNames = {'next_LEFT','next_RIGHT','next_UP','next_DOWN'};
        [allVars.matrixProbOrientation,allVars.transitionMatrixOrientation]=calculateProbabilityOfOrientation(orderedAllLarvOrientPerSec,nOrientStages,varNames,rowNames);
    
        %% Calculate proportion of run-stop-turning states [THIS SECTION WILL CHANGE WHEN THE MACHINE LEARNING APPROACH FOR BEHAVIOURAL CLASSIFICATION IS SET UP. WE WILL CAPTURE: RUN, STOP, TURN, CASTING]
        [orderedLarvaePerStatesRunStopTurn,accumAnglePerTurning,durationTurningEvents,angleBeforeAndAfterTurn,durationStopEvents,anglePreStop] = calculateTurningRate(larvaeAngle,avgXFilePerRoundTFile, avgYFilePerRoundTFile,globalConstants);
        
        %Turn probability regarding orientation to odor source (Gomez-Marin 2011,
        %Nat. Commns). Considering time spent for the larvae per orientation.

        %orientation prior stop and prior and after turning events
        turn_right = angleBeforeAndAfterTurn>=globalConstants.angLarvaeThreshold(1) & angleBeforeAndAfterTurn < globalConstants.angLarvaeThreshold(2);
        turn_top = angleBeforeAndAfterTurn>=globalConstants.angLarvaeThreshold(2) & angleBeforeAndAfterTurn < globalConstants.angLarvaeThreshold(3);
        turn_left = angleBeforeAndAfterTurn>=globalConstants.angLarvaeThreshold(3) & angleBeforeAndAfterTurn < globalConstants.angLarvaeThreshold(4);
        turn_bottom = angleBeforeAndAfterTurn>=globalConstants.angLarvaeThreshold(4) | angleBeforeAndAfterTurn < globalConstants.angLarvaeThreshold(1);

        stop_right = anglePreStop>=globalConstants.angLarvaeThreshold(1) & anglePreStop < globalConstants.angLarvaeThreshold(2);
        stop_top = anglePreStop>=globalConstants.angLarvaeThreshold(2) & anglePreStop < globalConstants.angLarvaeThreshold(3);
        stop_left = anglePreStop>=globalConstants.angLarvaeThreshold(3) & anglePreStop < globalConstants.angLarvaeThreshold(4);
        stop_bottom = anglePreStop>=globalConstants.angLarvaeThreshold(4) | anglePreStop < globalConstants.angLarvaeThreshold(1);

        allVars.propOrientationPriorTurning = [sum(turn_left(:,1))/size(turn_left,1),sum(turn_right(:,1))/size(turn_right,1),sum(turn_top(:,1))/size(turn_top,1),sum(turn_bottom(:,1))/size(turn_bottom,1)];
        allVars.propOrientationAfterTurning = [sum(turn_left(:,2))/size(turn_left,1),sum(turn_right(:,2))/size(turn_right,1),sum(turn_top(:,2))/size(turn_top,1),sum(turn_bottom(:,2))/size(turn_bottom,1)];
        allVars.propOrientationStop = [sum(stop_left)/size(stop_left,1),sum(stop_right(:,1))/size(stop_left,1),sum(stop_top(:,1))/size(stop_left,1),sum(stop_bottom(:,1))/size(stop_left,1)];

        uniqRoundTime = unique(orderedLarvaePerStatesRunStopTurn(:,2));
        allVars.proportionLarvaeRunPerT = arrayfun(@(x) sum(orderedLarvaePerStatesRunStopTurn(ismember(orderedLarvaePerStatesRunStopTurn(:,2),x),3))/sum(ismember(orderedLarvaePerStatesRunStopTurn(:,2),x)),uniqRoundTime);
        allVars.proportionLarvaeStopPerT = arrayfun(@(x) sum(orderedLarvaePerStatesRunStopTurn(ismember(orderedLarvaePerStatesRunStopTurn(:,2),x),4))/sum(ismember(orderedLarvaePerStatesRunStopTurn(:,2),x)),uniqRoundTime);
        allVars.proportionLarvaeTurnPerT = arrayfun(@(x) sum(orderedLarvaePerStatesRunStopTurn(ismember(orderedLarvaePerStatesRunStopTurn(:,2),x),5))/sum(ismember(orderedLarvaePerStatesRunStopTurn(:,2),x)),uniqRoundTime);

        nMovStages = 3; % run - stop - turn
        varNames = {'current_RUN','current_STOP','current_TURN'};
        rowNames = {'next_RUN','next_STOP','next_TURN'};
        [allVars.matrixProbMotionStates,allVars.transitionMatrixMotionStates]=calculateProbabilityOfOrientation(orderedLarvaePerStatesRunStopTurn,nMovStages,varNames,rowNames);
    
        %Proportion of turnings depending on the larvae orientation
        [allVars.runRatePerOrient,allVars.stopRatePerOrient,allVars.turningRatePerOrient] = calculateTurningRatePerOrientation(orderedLarvaePerStatesRunStopTurn,orderedAllLarvOrientPerSec);
       
        %% Calculate histogram of space occupied at the beginning, at an intermediate timepoint of the experiment (300seg) and at the end (only X axis, from 180 to 2160) - Check timePoint=10s, 300 and 590s
        allVars.binsXdistributionInitEnd=calculatePositionDistributionXaxis(globalConstants.hInitTime, globalConstants.hMidTimes, globalConstants.hEndTime,globalConstants.xAxisLimits,yFile,tableSummaryFeatures,globalConstants.xBorders,globalConstants.yBorders);
    
        
        %% Average larvae length
        allVars.averageLarvaeLength = calculateAverageLarvaeLength(dataSpine);
    
        %% Speed (per second and in average)
        %speed from X,Y
        uniqueId = unique(avgXFilePerRoundTFile(:,1));
        posIds = arrayfun(@(x) find(avgXFilePerRoundTFile(:,1)==x), uniqueId,'UniformOutput',false);
        speedFromXYGolay = cellfun(@(x) [0;sqrt((avgXFilePerRoundTFile(x(1:end-1),3)-avgXFilePerRoundTFile(x(2:end),3)).^2 + (avgYFilePerRoundTFile(x(1:end-1),3)-avgYFilePerRoundTFile(x(2:end),3)).^2)],posIds,'UniformOutput',false);
        speedFromXYGolayNormalized=[avgXFilePerRoundTFile(:,1:2),vertcat(speedFromXYGolay{:})./allVars.averageLarvaeLength];
        speedFromXYGolay=[avgXFilePerRoundTFile(:,1:2),vertcat(speedFromXYGolay{:})];

        [allVars.avgSpeedRoundTGolay, allVars.stdSpeedRoundTGolay, allVars.semSpeedRoundTGolay,allVars.avgMeanSpeedGolay,allVars.avgStdSpeedGolay,allVars.avgSemSpeedGolay,~,~,~,~,~,~,~,~] = calculateAverageSpeedAndAcceleration(speedFromXYGolay);
        [allVars.avgSpeedRoundTGolayNormalized, allVars.stdSpeedRoundTGolayNormalized, allVars.semSpeedRoundTGolayNormalized,allVars.avgMeanSpeedGolayNormalized,allVars.avgStdSpeedGolayNormalized,allVars.avgSemSpeedGolayNormalized,~,~,~,~,~,~,~,~] = calculateAverageSpeedAndAcceleration(speedFromXYGolayNormalized);

        % %speed from speed file from choreography
        % [allVars.avgSpeedRoundT, allVars.stdSpeedRoundT, allVars.semSpeedRoundT,allVars.avgMeanSpeed,allVars.avgStdSpeed,allVars.avgSemSpeed,~,~,~,~,~,~,~,~] = calculateAverageSpeedAndAcceleration(speedFile);

        % ---------------------------------------------------------------
        % The MSD and DAC features are hard to calculate because we do
        % not track properly the larvae IDs across the whole experiment.
        % Some larvae dissapear, other appear (they could be the same [or not])
        % ---------------------------------------------------------------
        % %% Calculate the Mean Squared Displacement (MSD) (Jakubowski B.R. et al. 2012). 
        % %The MSD is proportional to the average area covered in a given amount of time, τ, by a large number of particles starting from the same spatiotemporal origin and having the same statistical behavior
        % % Calculate mean squared displacement (MSD) for each time point
        % %% Calculate directional autocorrelation (DAC) 
       
        %% Calculate tortuosity based on (Loveless et al. 2019, PLoS Comput Biol.) T = 1 - D/L
        allVars.meanTortuosity=calculateTortuosity(avgXFilePerRoundTFile,avgYFilePerRoundTFile);
        %we could try to calculate the fractal dimension, as in the
        %previous research article, however, don't think provide any
        %valuable information complementary to other quantifications.
       

        %% Calculate crawling agility and reorientation agility based on (Günther, M. et al. 2016, Scientific Reports), basically, speed at every state (running forward or turning)
        %calculate speed in turn and run
        %how long the larvae take in individual casting states. How long the larvae take to abandon the a zone twice the length of the larvae?    
        allVars.turningRatePerMinute = (length(durationTurningEvents)/size(larvaeAngle,1))*60;
        allVars.averageAccumAnglePerTurn = array2table([mean(accumAnglePerTurning), std(accumAnglePerTurning), mean(durationTurningEvents),std(durationTurningEvents)],'VariableNames',{'mean_accumAngle','std_accumAngle','mean_durationTurn','std_durationTurn'});
        allVars.stoppingRatePerMinute = (length(durationStopEvents)/size(larvaeAngle,1))*60;

        meanSpeedRun = mean(speedFromXYGolay(orderedLarvaePerStatesRunStopTurn(:,3)==1,3));
        stdSpeedRun = std(speedFromXYGolay(orderedLarvaePerStatesRunStopTurn(:,3)==1,3));
        meanSpeedTurning = mean(speedFromXYGolay(orderedLarvaePerStatesRunStopTurn(:,5)==1,3));
        stdSpeedTurning = std(speedFromXYGolay(orderedLarvaePerStatesRunStopTurn(:,5)==1,3));
        allVars.larvaeAgility = array2table([meanSpeedRun,stdSpeedRun,meanSpeedTurning,stdSpeedTurning],'VariableNames',{'meanSpeed_Run','stdSpeed_Run','meanSpeed_Turning','stdSpeed_Turning'});

        meanSpeedRunNormalized = mean(speedFromXYGolayNormalized(orderedLarvaePerStatesRunStopTurn(:,3)==1,3));
        stdSpeedRunNormalized = std(speedFromXYGolayNormalized(orderedLarvaePerStatesRunStopTurn(:,3)==1,3));
        meanSpeedTurningNormalized = mean(speedFromXYGolayNormalized(orderedLarvaePerStatesRunStopTurn(:,5)==1,3));
        stdSpeedTurningNormalized = std(speedFromXYGolayNormalized(orderedLarvaePerStatesRunStopTurn(:,5)==1,3));
        allVars.larvaeAgilityNormalized = array2table([meanSpeedRunNormalized,stdSpeedRunNormalized,meanSpeedTurningNormalized,stdSpeedTurningNormalized],'VariableNames',{'meanSpeed_Run','stdSpeed_Run','meanSpeed_Turning','stdSpeed_Turning'});

        %% Average speed when larvae are pointing the odor patches (oriented btw 45-315 degrees) and avoiding them (oriented btw 135-225 degrees).
        %[allVars.avgSpeedPerOrientation,allVars.stdSpeedPerOrientation]=calculateAvgSpeedPerOrientation(speedFile,orderedAllLarvOrientPerSec);
        [allVars.avgSpeedPerOrientationGolay,allVars.stdSpeedPerOrientationGolay]=calculateAvgSpeedPerOrientation(speedFromXYGolay,orderedAllLarvOrientPerSec);


        %% Average angular speed
        %angular change between 2 consecutive time points.
        [allVars.meanAngularSpeedPerT,allVars.stdAngularSpeedPerT,allVars.semAngularSpeedPerT,allVars.avgStdAngularSpeed,allVars.avgMeanAngularSpeed,allVars.avgSemAngularSpeed,allVars.angularSpeed,~,~]  = calculateAngularSpeed (larvaeAngle);
        [allVars.avgAngularSpeedPerOrientation,allVars.stdAngularSpeedPerOrientation]=calculateAvgSpeedPerOrientation(allVars.angularSpeed,orderedAllLarvOrientPerSec);
    
        % %% Curve (per second and in average). Basically, angular speed from choreography
        % [allVars.avgCurveRoundT, allVars.stdCurveRoundT, allVars.semCurveRoundT,allVars.avgMeanCurve,allVars.avgStdCurve,allVars.avgSemCurve,~,~,~,~,~,~,~,~] = calculateAverageSpeedAndAcceleration(curveFile);
        % [allVars.avgCurvePerOrientation,allVars.stdCurvePerOrientation]=calculateAvgSpeedPerOrientation(curveFile,orderedAllLarvOrientPerSec);

        %Consider larvae that remains at least 60 seconds
        save(fullfile(dirPath,'navigationResults.mat'),'allVars','tableSummaryFeatures','globalConstants')

    else
        load(fullfile(dirPath,'navigationResults.mat'),'allVars');
    end

end