function [navigationIndex,propLarvInAnglGroup] = extractFeaturesPerExperiment(varargin)

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
    
    %discard those bodies detected for less than 20 seconds and remove the
    %ones appearing in the borders.

    %%%%%%%%%%%% CODE TO DO %%%%%%%%%%%%

    % navigation index (movement along X axis)
    
    %(yFile corresponds with xAxis being larger values left [patches], lower right)
    uniqueId = unique(yFile(:,1));
    difY=zeros(length(uniqueId),1);
    absY=zeros(length(uniqueId),1);
    for nId = 1:length(uniqueId)
        yFileId = yFile(ismember(yFile(:,1),uniqueId(nId)),:);
        difYMov=arrayfun(@(x,y) x-y, yFileId(1:end-1,3),yFileId(2:end,3));
        difY(nId)= sum(difYMov);
        absY(nId)= sum(abs(difYMov));
    end

    totalY = sum(absY);

    navigationIndex=sum(difY)/totalY;

    %(xFile corresponds with yAxis being larger values top, lower bottom)

    difX=zeros(size(uniqueId));
    absX=zeros(length(uniqueId),1);

    for nId = 1:length(uniqueId)
        xFileId = xFile(ismember(xFile(:,1),uniqueId(nId)),:);
        difXMov=arrayfun(@(x,y) x-y, xFileId(1:end-1,3),xFileId(2:end,3));
        difX(nId)= sum(difXMov);
        absX(nId)= sum(abs(difXMov));
    end

    %navigation index Y axis
%     navIndex = sum(difY)/sum(difX)

%% Calculate probability of orientation between 225dg and 315dg (heading odor); 45dg & 135dg (opposite to odor); 135dg & 225dg (heading top); 315dg % 45dg (heading bottom)
%orient.dat will provide the angle of the body, in degrees. Head and tail
%are not, in general, determined, so this value is only correct modulo pi.
%We will have to determinate where the head is pointing considering the two
%previous timepoints.

larvaeAngle = calculateAngleMovLarvae(xFile, yFile);

uniqRoundTime = unique(round(larvaeAngle(:,2)));
larvaeAngleRoundT = larvaeAngle;
larvaeAngleRoundT(:,2) = round(larvaeAngleRoundT(:,2));

propLarvInAnglGroup=zeros(length(uniqRoundTime),4);
allLarvaeOrientationPerSec = [];
for nSec=1:length(uniqRoundTime)
    idT=ismember(larvaeAngleRoundT(:,2),uniqRoundTime(nSec));
    uniqLabelsSec = unique(larvaeAngleRoundT(idT,1));
    
    %classify the angles in 4 groups as explained in the header (<- ; -> ; ^ ; v )
    auxLarvInGroups=zeros(length(uniqLabelsSec),4);

    for nLar = 1:length(uniqLabelsSec)
        idLar = ismember(larvaeAngleRoundT(:,1),uniqLabelsSec(nLar));
        group1 = sum(larvaeAngleRoundT(idLar & idT,3)>=225 & larvaeAngleRoundT(idLar & idT,3) < 315);
        group2 = sum(larvaeAngleRoundT(idLar & idT,3)>=45 & larvaeAngleRoundT(idLar & idT,3) < 135);
        group3 = sum(larvaeAngleRoundT(idLar & idT,3)>=135 & larvaeAngleRoundT(idLar & idT,3) < 225);
        group4 = sum(larvaeAngleRoundT(idLar & idT,3)>=315 | larvaeAngleRoundT(idLar & idT,3) < 45);
        [~,idGroup]=max([group1,group2,group3,group4]);
        auxLarvInGroups(nLar,idGroup)=1;
    end

    larvaeOrientationPerSec = [uniqLabelsSec,ones(size(uniqLabelsSec)).*uniqRoundTime(nSec),auxLarvInGroups];

    allLarvaeOrientationPerSec=[allLarvaeOrientationPerSec;larvaeOrientationPerSec];
    propLarvInAnglGroup(nSec,:)=sum(auxLarvInGroups,1)/sum(auxLarvInGroups(:));
end

figure;hold on

plot(uniqRoundTime,propLarvInAnglGroup(:,1),'-r', 'LineWidth', 2);
plot(uniqRoundTime,propLarvInAnglGroup(:,2),'-b', 'LineWidth', 2);
plot(uniqRoundTime,propLarvInAnglGroup(:,3),'-p', 'LineWidth', 2);
plot(uniqRoundTime,propLarvInAnglGroup(:,4),'-k', 'LineWidth', 2);
legend({'left','right','top','bottom'})


[~,idOrd]=sort(allLarvaeOrientationPerSec(:,1));
orderedAllLarvOrientPerSec=allLarvaeOrientationPerSec(idOrd,:);

%% Probability of larvae heading one direction and change the trajectory to another possible direction


nOrientStages = 4; % left - rigth - top - bottom
matrixProb = zeros(nOrientStages,nOrientStages);
uniqLabels = unique(orderedAllLarvOrientPerSec(:,1));
for nLar = 1:length(uniqLabels)
    idsLab = ismember(orderedAllLarvOrientPerSec(:,1),uniqLabels(nLar));
    larvOrientPerSec = orderedAllLarvOrientPerSec(idsLab,3:end);
    auxCellMatrix=mat2cell(larvOrientPerSec,ones(size(larvOrientPerSec,1),1) ,4);
    auxChangPosition =cellfun(@(x,y) [find(x),find(y)],auxCellMatrix(1:end-1,:),auxCellMatrix(2:end,:),'UniformOutput',false);
    for nT=1:size(auxChangPosition,1)
        subIndAux = [auxChangPosition{nT}];
        matrixProb(subIndAux(1),subIndAux(2))=matrixProb(subIndAux(1),subIndAux(2))+1;    
    end

end

%TRANSITION MATRIX - MARKOV CHAIN
matrixProb2 = matrixProb./sum(matrixProb);

%% Speed (per second and in average)
% 
%     %Only measure the time intervals when the larva is not stacked. 
%     speedFileRoundT = speedFile;
%     speedFileRoundT(:,2) = round(speedFile(:,2));
%     uniqRoundTime = unique(round(speedFile(:,2)));
% 
% %     uniqLabels = unique(speedFileRoundT(:,1));
% %     figure;
% %     hold on
% %     for nLab=1:length(uniqLabels)
% %         idsLab = ismember(speedFileRoundT(:,1),uniqLabels(nLab));
% %         auxSpeedFileRoundT= speedFileRoundT(idsLab,:);
% %         auxUniqRoundTime = unique(round(auxSpeedFileRoundT(:,2)));
% %         auxAvgSpeedRoundT=arrayfun(@(x) mean(auxSpeedFileRoundT(ismember(auxSpeedFileRoundT(:,2),x),3)),auxUniqRoundTime);
% %         plot(auxUniqRoundTime,auxAvgSpeedRoundT, 'LineWidth', 2);
% %     end
%     
%     
%     % uniqTime = unique(speedFile(:,2));
%     % avgSpeed=arrayfun(@(x) mean(speedFile(ismember(speedFile(:,2),x),3)),uniqTime);
%     % plot(uniqTime,avgSpeed)
%     
%     
%     avgSpeedRoundT=arrayfun(@(x) mean(speedFileRoundT(ismember(speedFileRoundT(:,2),x),3)),uniqRoundTime);
%     %semSpeedRoundT=arrayfun(@(x) std(speedFileRoundT(ismember(speedFileRoundT(:,2),x),3))/sqrt(sum(ismember(speedFileRoundT(:,2),x))),uniqRoundTime);
%     stdSpeedRoundT=arrayfun(@(x) std(speedFileRoundT(ismember(speedFileRoundT(:,2),x),3)),uniqRoundTime);
% 
%     curve1 = avgSpeedRoundT + stdSpeedRoundT;
%     curve2 = avgSpeedRoundT - stdSpeedRoundT;
%     x2 = [uniqRoundTime', fliplr(uniqRoundTime')];
%     inBetween = [curve1', fliplr(curve2')];
%     fill(x2, inBetween, 'r','FaceAlpha',0.3);
%     hold on;
%     plot(uniqRoundTime,avgSpeedRoundT,'r', 'LineWidth', 2);
% 
%     avgMeanSpeedWholeExp = mean(avgSpeedRoundT);
%     avgStdSpeedWholeExp = mean(stdSpeedRoundT);
% 
%     %Average speed when larvae are pointing the odor patches (oriented btw 45-315 degrees) and avoiding them (oriented btw 135-225 degrees).
% 
% 
% 
%     %capture indexes of larvae when are oriented between 315dg and 45dg
%     %(heading the odor patches)
% 
%     %capture indexes of larvae when are oriented between 135dg and 225dg
%     %(avoiding the odor patches)
% 
%     %Average speed when larvae are pointing the opposite side of odor
%     %patches.
% 
%     %% average angular speed
%     %%USE ANGULAR.DAT TO CALCULATE
% 
%     %% measure number of casting in average
%     [averageNumberOfCastings]=calculateAverageNumberOfCastings(castFile,xFile,yFile);
%     
%     %% calculate how many times the larva change the trajectory left-right and right-left
%     
%     %WE CANNOT USE DIR TO THIS% I'LL MEASURE DIRECTION MOVEMENT
%     %I'LL MEASURE THE TOTAL CHANGES OF DIRECTION (
%     % calculateAverageChangeOfDirection()
%     
%     %% Proportion of displacement left - right
%     
%     %% Proportion of larvae heading the odor side (use automatic ID tracked larvae [summary table] to don't have repetitions).
%     
%     %plot trajectories
%     



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