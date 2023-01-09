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

filesChoreography = dir(fullfile(dirPath,'*.dat'));
outlineFile = dir(fullfile(dirPath,'*.outline'));
spineFile = dir(fullfile(dirPath,'*.spine'));

fileNames={filesChoreography.name};
splittedNames = cellfun(@(x) strsplit(x,'.'),fileNames,'UniformOutput',false);
featureName = cellfun(@(x) x{2},splittedNames,'UniformOutput',false); 


%% Load larvae spine and outlines
%load larvae properties
idArea = cellfun(@(x) strcmp(x,'area'),featureName);
idCast = cellfun(@(x) strcmp(x,'cast'),featureName);
idSpeed = cellfun(@(x) strcmp(x,'speed'),featureName);
idX = cellfun(@(x) strcmp(x,'x'),featureName);
idY = cellfun(@(x) strcmp(x,'y'),featureName);

areaFile = readtable(fullfile(filesChoreography(idArea).folder,filesChoreography(idArea).name));
areaFile=table2array(areaFile(:,2:5));
speedFile = readtable(fullfile(filesChoreography(idSpeed).folder,filesChoreography(idSpeed).name));
speedFile=table2array(speedFile(:,2:5));
xFile = readtable(fullfile(filesChoreography(idX).folder,filesChoreography(idX).name));
xFile=table2array(xFile(:,2:5));
yFile = readtable(fullfile(filesChoreography(idY).folder,filesChoreography(idY).name));
yFile=table2array(yFile(:,2:5));

if ~isempty(outlineFile)
    if ~exist(fullfile(outlineFile(1).folder,'rawlarvaeOutlines.mat'),'file')    
        cellOutlinesLarvae=parseOutlinesFile(outlineFile(1).folder,outlineFile(1).name);
    else
        load(fullfile(outlineFile(1).folder,'rawlarvaeOutlines.mat'),'cellOutlinesLarvae');
    end
    uniqueIdOutline=unique(vertcat(cellOutlinesLarvae{:,1}));
    
    dataSpine = load(fullfile(spineFile(1).folder,spineFile(1).name));
    dataSpine=dataSpine(:,2:end);

    idMorpwidth = cellfun(@(x) strcmp(x,'morpwidth'),featureName);
    morpwidFile = readtable(fullfile(filesChoreography(idMorpwidth).folder,filesChoreography(idMorpwidth).name));
    morpwidFile=table2array(morpwidFile(:,2:end));
    castFile = readtable(fullfile(filesChoreography(idCast).folder,filesChoreography(idCast).name));
    castFile=table2array(castFile(:,2:end));
else
    dataSpine=[];
    castFile = [];
    cellOutlinesLarvae=[];
    morpwidFile = areaFile;
end

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

[angleInitVector,angleLastVector]=calculateInitAndLastDirectionPerID(xFile,yFile,minTimesPerID,maxTimesPerID,uniqueId);

tableSummaryFeaturesRaw = array2table([uniqueId,minTimesPerID,maxTimesPerID,initCoordXLarvae,lastCoordXLarvae,initCoordYLarvae,lastCoordYLarvae,angleInitVector,angleLastVector,medianAreaLarvae,morpwidLarvae],'VariableNames',{'id','minTime','maxTime','xCoordInit','xCoordEnd','yCoordInit','yCoordEnd','directionLarvaInit','directionLarvaLast','area','morpWidth'});

%%%%% REMOVE X BORDERS LARVAE %%%%% (most likely artifacts)
borderIds = tableSummaryFeaturesRaw.yCoordInit < 35 | tableSummaryFeaturesRaw.yCoordInit > 190;
[tableSummaryFeaturesRaw,xFile,yFile,speedFile,dataSpine,cellOutlinesLarvae,castFile]=removeBorderIds(borderIds,tableSummaryFeaturesRaw,xFile,yFile,speedFile,dataSpine,cellOutlinesLarvae,castFile);

%%%% UNIFY LARVAE LABELS %%%%
file2save=fullfile(dirPath,'proofreadOrderedLarvae.mat');
if ~exist(file2save,'file')
    [tableSummaryFeatures,unifiedLabels] = reorganizeUniqueIDs(tableSummaryFeaturesRaw);
    save(fullfile(dirPath,'automaticOrderedLarvae.mat'),'unifiedLabels')
else
    load(file2save,'curatedLabels')
    unifiedLabels=curatedLabels;
    tableSummaryFeatures=updateTableProperties(tableSummaryFeaturesRaw,curatedLabels);
end

%%%% UPDATE LARVAE IDs INTO FILES
[xFileUpdated,yFileUpdated,speedFileUpdated,dataSpineUpdated,cellOutlinesLarvaeUpdated,castFileUpdated]=updateIDsOfFiles(unifiedLabels,xFile,yFile,speedFile,dataSpine,cellOutlinesLarvae,castFile);

% %%%% LOAD INIT RAW IMAGE %%%%
% imgName = dir(fullfile(dirPath,'*.png'));
% imgInit = imread(fullfile(imgName.folder, imgName.name));
imgInit=ones(1728,2350);

%%%% SAVE LARVAE TRAJECTORY (IMAGE SEQUENCE)
folder2save = fullfile(filesChoreography(1).folder,'imageSequenceLarvae');
folder2saveRaw = fullfile(filesChoreography(1).folder,'imageSequenceLarvaeRaw');

minTimeTraj = 0; %seconds
maxTimeTraj = 600; %seconds
maxLengthLarvaeTrajectory = 60; %seconds
booleanSave = 1; %save==1, not save == 0 
if ~exist(folder2save,'dir') 
    stepTimeTrack=1;
    mkdir(folder2save)
    if ~isempty(outlineFile)
        plotTrajectoryLarvae(cellOutlinesLarvaeUpdated,xFileUpdated,yFileUpdated,unique(xFile(:,1)),folder2save,imgInit,minTimeTraj,maxTimeTraj,maxLengthLarvaeTrajectory,stepTimeTrack,booleanSave)
    else
        plotTrajectoryLarvae([],xFileUpdated,yFileUpdated,unique(xFile(:,1)),folder2save,imgInit,minTimeTraj,maxTimeTraj,maxLengthLarvaeTrajectory,stepTimeTrack,booleanSave)
    end
end
if ~exist(folder2saveRaw,'dir') 
    stepTimeTrack=5;
    mkdir(folder2saveRaw)
    if ~isempty(outlineFile)       
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



