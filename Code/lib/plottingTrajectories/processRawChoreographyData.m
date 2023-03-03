function processRawChoreographyData(varargin)

    if isempty(varargin)
        close all
        clear all
        
        addpath(genpath('lib'))
        
        %Select folder to analyse the data from Choreography
        dirPath = uigetdir('../Choreography_results','select folder after Choreography processing');
    else
        dirPath=varargin{1};
    end
    
    %% LOAD CHOREOGRAPHY FILES
    [xFile, yFile, areaFile, speedFile, speedFile085,crabSpeedFile, curveFile,castFile, morpwidFile, dataSpine, cellOutlinesLarvae]=loadChoreographyFiles(dirPath);
        
    %% REORGANIZE UNIQUE LARVAE IDs
    %%table summarizing larvae properties to compare times, position and
    %%geometrical properties
    uniqueId = unique(xFile(:,1));
    
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
       
    %%%% REMOVE X BORDERS LARVAE %%%%% (most likely artifacts)
    thresholdTime=30; %sec
    borderXIds = tableSummaryFeaturesRaw.yCoordInit < 35 | tableSummaryFeaturesRaw.yCoordInit > 190;
    borderYIds = tableSummaryFeaturesRaw.xCoordInit < 10 | tableSummaryFeaturesRaw.xCoordInit > 160;
    idsFewTime= (tableSummaryFeaturesRaw.maxTime - tableSummaryFeaturesRaw.minTime) < thresholdTime;

    [tableSummaryFeatures,xFile,yFile,speedFile,speedFile085,crabSpeedFile,areaFile,dataSpine,cellOutlinesLarvae,curveFile,castFile]=removeBorderIds((borderXIds | borderYIds | idsFewTime),tableSummaryFeaturesRaw,xFile,yFile,speedFile,speedFile085,crabSpeedFile,areaFile,dataSpine,cellOutlinesLarvae,curveFile,castFile);
   
%     %%%% UNIFY LARVAE LABELS %%%%
%     file2save=fullfile(dirPath,'proofreadOrderedLarvae.mat');
%     if ~exist(file2save,'file')
%         [tableSummaryFeatures,unifiedLabels] = reorganizeUniqueIDs(tableSummaryFeaturesRaw);
%         save(fullfile(dirPath,'automaticOrderedLarvae.mat'),'unifiedLabels')
%     else
%         load(file2save,'curatedLabels')
%         unifiedLabels=curatedLabels;
%         tableSummaryFeatures=updateTableProperties(tableSummaryFeaturesRaw,curatedLabels);
%     end
    
%     %%%% UPDATE LARVAE IDs INTO FILES
%     [xFileUpdated,yFileUpdated,speedFileUpdated,dataSpineUpdated,cellOutlinesLarvaeUpdated,castFileUpdated]=updateIDsOfFiles(unifiedLabels,xFile,yFile,speedFile,dataSpine,cellOutlinesLarvae,castFile);
    
    % %%%% LOAD INIT RAW IMAGE %%%%
    % imgName = dir(fullfile(dirPath,'*.png'));
    % imgInit = imread(fullfile(imgName.folder, imgName.name));
    imgInit=ones(1728,2350);
    
    %%%% SAVE LARVAE TRAJECTORY (IMAGE SEQUENCE)
    folder2save = fullfile(dirPath,'imageSequenceLarvae');
    folder2saveRaw = fullfile(dirPath,'imageSequenceLarvaeRaw');
    
    minTimeTraj = 0; %seconds
    maxTimeTraj = 90; %seconds
    maxLengthLarvaeTrajectory = 60; %seconds
    booleanSave = 1; %save==1, not save == 0 
%     if ~exist(folder2save,'dir') 
%         stepTimeTrack=1;
%         mkdir(folder2save)
%         if ~isempty(outlineFile)
%             plotTrajectoryLarvae(cellOutlinesLarvaeUpdated,xFileUpdated,yFileUpdated,unique(xFile(:,1)),folder2save,imgInit,minTimeTraj,maxTimeTraj,maxLengthLarvaeTrajectory,stepTimeTrack,booleanSave)
%         else
%             plotTrajectoryLarvae([],xFileUpdated,yFileUpdated,unique(xFile(:,1)),folder2save,imgInit,minTimeTraj,maxTimeTraj,maxLengthLarvaeTrajectory,stepTimeTrack,booleanSave)
%         end
%     end
    if ~exist(folder2saveRaw,'dir') 
        stepTimeTrack=1;
        mkdir(folder2saveRaw)
        if ~isempty(cellOutlinesLarvae)       
            plotTrajectoryLarvae(cellOutlinesLarvae,xFile,yFile,unique(xFile(:,1)),folder2saveRaw,imgInit,minTimeTraj,maxTimeTraj,maxLengthLarvaeTrajectory,stepTimeTrack,booleanSave)
        else
            plotTrajectoryLarvae([],xFile,yFile,unique(xFile(:,1)),folder2saveRaw,imgInit,minTimeTraj,maxTimeTraj,maxLengthLarvaeTrajectory,stepTimeTrack,booleanSave)
        end
    end

% %Correcting some trajectories. Removing isolated trajectories appearing at
% %Y borders, and short trajectories.
% borderIds = tableSummaryFeatures.xCoordInit < 10 | tableSummaryFeatures.xCoordInit > 160;
%[tableSummaryFeaturesFiltered,xFileUpdated,yFileUpdated,speedFileUpdated,dataSpineUpdated,cellOutlinesLarvaeUpdated,castFileUpdated]=removeBorderIds(borderIds,tableSummaryFeatures,xFileUpdated,yFileUpdated,speedFileUpdated,dataSpineUpdated,cellOutlinesLarvaeUpdated,castFileUpdated);
% 
% 
% %%%% PLOT LARVAE TRAJECTORIES %%%%
% minTimeTraj = 600; %sec
% maxTimeTraj = 600; %sec
% maxLengthLarvaeTrajectory = 600; %sec
% booleanSave = 0;
% 
% ids2check = (tableSummaryFeaturesFiltered.maxTime - tableSummaryFeaturesFiltered.minTime)<maxTimeTraj*(0.7);
% 
% if ~isempty(outlineFile)
%     plotTrajectoryLarvae(cellOutlinesLarvaeUpdated,xFileUpdated,yFileUpdated,tableSummaryFeaturesFiltered.id(ids2check),'',imgInit,minTimeTraj,maxTimeTraj,maxLengthLarvaeTrajectory,booleanSave)
% else
%     plotTrajectoryLarvae([],xFileUpdated,yFileUpdated,tableSummaryFeaturesFiltered.id(ids2check),'',imgInit,minTimeTraj,maxTimeTraj,maxLengthLarvaeTrajectory,booleanSave)
% end
% 
% 
% %%%% MANUALLY CORRECT LARVAE TRAJECTORIES & SAVE %%%%
% 
% if ~isempty(outlineFile)
%     [tableSummaryFeaturesFiltered,xFileUpdated,yFileUpdated,cellOutlinesLarvaeUpdated,dataSpineUpdated]=correctManuallyTrajectories(tableSummaryFeaturesFiltered,xFileUpdated,yFileUpdated,cellOutlinesLarvaeUpdated,dataSpineUpdated,imgInit,minTimeTraj,maxTimeTraj,maxLengthLarvaeTrajectory,booleanSave);
%     save(fullfile(dirPath,'choreographyData_Postprocessed.mat'),'xFileUpdated','yFileUpdated','speedFileUpdated','castFileUpdated','tableSummaryFeaturesFiltered','dataSpineUpdated','cellOutlinesLarvaeUpdated')
%     
% else
%     [tableSummaryFeaturesFiltered,xFileUpdated,yFileUpdated,~,~]=correctManuallyTrajectories(tableSummaryFeaturesFiltered,xFileUpdated,yFileUpdated,[],[],imgInit,minTimeTraj,maxTimeTraj,maxLengthLarvaeTrajectory,booleanSave);
%     save(fullfile(dirPath,'choreographyData_Postprocessed.mat'),'xFileUpdated','yFileUpdated','speedFileUpdated','tableSummaryFeaturesFiltered')
% end



