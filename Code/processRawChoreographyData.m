close all
clear all

addpath(genpath('lib'))

%Select folder to analyse the data from Choreography
dirPath = uigetdir('select folder after Choreography processing');

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
% idSpeed = cellfun(@(x) strcmp(x,'speed'),featureName);
idX = cellfun(@(x) strcmp(x,'x'),featureName);
idY = cellfun(@(x) strcmp(x,'y'),featureName);

areaFile = load(fullfile(filesChoreography(idArea).folder,filesChoreography(idArea).name));
% speedFile = load(fullfile(filesChoreography(idSpeed).folder,filesChoreography(idSpeed).name));
xFile = load(fullfile(filesChoreography(idX).folder,filesChoreography(idX).name));
yFile = load(fullfile(filesChoreography(idY).folder,filesChoreography(idY).name));

if ~isempty(outlineFile)
    if ~exist(fullfile(outlineFile(1).folder,'rawlarvaeOutlines.mat'),'file')    
        cellOutlinesLarvae=parseOutlinesFile(outlineFile(1).folder,outlineFile(1).name);
    else
        load(fullfile(outlineFile(1).folder,'rawlarvaeOutlines.mat'),'cellOutlinesLarvae');
    end
    uniqueIdOutline=unique(vertcat(cellOutlinesLarvae{:,1}));
    
    dataSpine = load(fullfile(spineFile(1).folder,spineFile(1).name));
    idMorpwidth = cellfun(@(x) strcmp(x,'morpwidth'),featureName);
    morpwidFile = load(fullfile(filesChoreography(idMorpwidth).folder,filesChoreography(idMorpwidth).name));
    castFile = load(fullfile(filesChoreography(idCast).folder,filesChoreography(idCast).name));


else
    dataSpine=[];
    castFile = [];
    cellOutlinesLarvae=[];
    morpwidFile = areaFile;
end

%% REORGANIZE UNIQUE LARVAE IDs
%%table summarizing larvae properties to compare times, position and
%%geometrical properties
uniqueId = unique(xFile(:,2));

minTimesPerID = arrayfun(@(x) min(xFile(xFile(:,2)==x,3)), uniqueId);
initCoordXLarvae = arrayfun(@(x,y) mean(xFile(xFile(:,3)==x & xFile(:,2)==y,4)),minTimesPerID,uniqueId);
initCoordYLarvae = arrayfun(@(x,y) mean(yFile(yFile(:,3)==x & yFile(:,2)==y,4)),minTimesPerID,uniqueId);
maxTimesPerID = arrayfun(@(x) max(xFile(xFile(:,2)==x,3)), uniqueId);
lastCoordXLarvae = arrayfun(@(x,y) mean(xFile(xFile(:,3)==x & xFile(:,2)==y,4)),maxTimesPerID,uniqueId);
lastCoordYLarvae = arrayfun(@(x,y) mean(yFile(yFile(:,3)==x & yFile(:,2)==y,4)),maxTimesPerID,uniqueId);
medianAreaLarvae = arrayfun(@(x) median(areaFile(areaFile(:,2)==x,4)), uniqueId);
morpwidLarvae = arrayfun(@(x) median(morpwidFile(morpwidFile(:,2)==x,4)), uniqueId);


tableSummaryFeatures = array2table([uniqueId,minTimesPerID,maxTimesPerID,initCoordXLarvae,lastCoordXLarvae,initCoordYLarvae,lastCoordYLarvae,medianAreaLarvae,morpwidLarvae],'VariableNames',{'id','minTime','maxTime','xCoordInit','xCoordEnd''yCoordInit','yCoordEnd','area','morpWidth'});

%%%%% REMOVE X BORDERS LARVAE %%%%% (most likely artifacts)
borderIds = tableSummaryFeatures.xCoordInit < 20 | tableSummaryFeatures.xCoordInit > 210;
idsBoder2remove = tableSummaryFeatures.id(borderIds);
tableSummaryFeatures(borderIds,:) = [];
xFile(ismember(xFile(:,2),idsBoder2remove),:)=[];
yFile(ismember(yFile(:,2),idsBoder2remove),:)=[];


%%%% UNIFY LARVAE LABELS %%%%
[tableSummaryFeatures,orderedLarvae] = reorganizeUniqueIDs(tableSummaryFeatures);
[xFileUpdated]=updateLabelsFile(orderedLarvae,xFile);
[yFileUpdated]=updateLabelsFile(orderedLarvae,yFile);

if ~isempty(outlineFile)
    [dataSpineUpdated]=updateLabelsFile(orderedLarvae,dataSpine);
    [cellOutlinesLarvaeUpdated]=updateOutlinesFile(orderedLarvae,cellOutlinesLarvae);
    castFile(ismember(castFile(:,2),idsBoder2remove),:)=[];

    dataSpineUpdated(ismember(dataSpineUpdated(:,2),idsBoder2remove),:)=[];
    cellOutlinesLarvaeUpdated(ismember(vertcat(cellOutlinesLarvaeUpdated{:,1}),idsBoder2remove),:)=[];
    castFileUpdated =updateOutlinesFile(orderedLarvae,castFile);
end

%%%% LOAD INIT RAW IMAGE %%%%
imgName = dir(fullfile(dirPath,'*.png'));
imgInit = imread(fullfile(imgName.folder, imgName.name));




%%%% SAVE LARVAE TRAJECTORY (IMAGE SEQUENCE)
% if ~exist(fullfile(xFile(1).folder,'temporalImageSequenceLarvae'),'file') 
%     minTimeTraj = 0; %seconds
%     maxTimeTraj = 600; %seconds
%     maxLengthLarvaeTrajectory = 60; %seconds
%     booleanSave = 1; %save==1, not save == 0 
%     folder2save = fullfile(xFile(1).folder,'temporalImageSequenceLarvae');
%     mkdir(folder2save)
%     if ~isempty(outlineFile)
%         plotTrajectoryLarvae(cellOutlinesLarvaeUpdated,dataSpineUpdated,xFileUpdated,yFileUpdated,unique(xFile(:,2)),folder2save,imgInit,minTimeTraj,maxTimeTraj,maxLengthLarvaeTrajectory,booleanSave)
%     else
%         plotTrajectoryLarvae([],[],xFileUpdated,yFileUpdated,unique(xFile(:,2)),folder2save,imgInit,minTimeTraj,maxTimeTraj,maxLengthLarvaeTrajectory,booleanSave)
%     end
% end

%Correcting some trajectories. Removing isolated trajectories appearing at
%Y borders, and short trajectories.
borderIds = tableSummaryFeatures.yCoordInit < 5 | tableSummaryFeatures.yCoordInit > 165;
tableSummaryFeaturesFiltered =tableSummaryFeatures;
idsBoder2remove = tableSummaryFeaturesFiltered.id(borderIds);
tableSummaryFeaturesFiltered(borderIds,:) = [];
xFileUpdated(ismember(xFileUpdated(:,2),idsBoder2remove),:)=[];
yFileUpdated(ismember(yFileUpdated(:,2),idsBoder2remove),:)=[];

if ~isempty(outlineFile)
    dataSpineUpdated(ismember(dataSpineUpdated(:,2),idsBoder2remove),:)=[];
    cellOutlinesLarvaeUpdated(ismember(vertcat(cellOutlinesLarvaeUpdated{:,1}),idsBoder2remove),:)=[];
    castFileUpdated(ismember(castFileUpdated(:,2),idsBoder2remove),:)=[];
end


%%%% PLOT LARVAE TRAJECTORIES %%%%
minTimeTraj = 600; %sec
maxTimeTraj = 600; %sec
maxLengthLarvaeTrajectory = 600; %sec
booleanSave = 0;

ids2check = (tableSummaryFeaturesFiltered.maxTime - tableSummaryFeaturesFiltered.minTime)<maxTimeTraj*(0.8);

if ~isempty(outlineFile)
    plotTrajectoryLarvae(cellOutlinesLarvaeUpdated,dataSpineUpdated,xFileUpdated,yFileUpdated,tableSummaryFeaturesFiltered.id(ids2check),'',imgInit,minTimeTraj,maxTimeTraj,booleanSave)
else
    plotTrajectoryLarvae([],[],xFileUpdated,yFileUpdated,tableSummaryFeaturesFiltered.id(ids2check),'',imgInit,minTimeTraj,maxTimeTraj,booleanSave)
end


%%%% MANUALLY CORRECT LARVAE TRAJECTORIES & SAVE %%%%

if ~isempty(outlineFile)
    [tableSummaryFeaturesFiltered,xFileUpdated,yFileUpdated,cellOutlinesLarvaeUpdated,dataSpineUpdated]=correctManuallyTrajectories(tableSummaryFeaturesFiltered,xFileUpdated,yFileUpdated,cellOutlinesLarvaeUpdated,dataSpineUpdated,imgInit,minTimeTraj,maxTimeTraj,maxLengthLarvaeTrajectory,booleanSave);
    save(fullfile(dirPath,'choreographyData_Postprocessed.mat'),'xFileUpdated','yFileUpdated','castFileUpdated','tableSummaryFeaturesFiltered','dataSpineUpdated','cellOutlinesLarvaeUpdated')
else
    [tableSummaryFeaturesFiltered,xFileUpdated,yFileUpdated,~,~]=correctManuallyTrajectories(tableSummaryFeaturesFiltered,xFileUpdated,yFileUpdated,[],[],imgInit,minTimeTraj,maxTimeTraj,maxLengthLarvaeTrajectory,booleanSave);
    save(fullfile(dirPath,'choreographyData_Postprocessed.mat'),'xFileUpdated','yFileUpdated','tableSummaryFeaturesFiltered')
end



