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
if ~exist(fullfile(outlineFile(1).folder,'rawlarvaeOutlines.mat'),'file')    
    cellOutlinesLarvae=parseOutlinesFile(outlineFile(1).folder,outlineFile(1).name);
else
    load(fullfile(outlineFile(1).folder,'rawlarvaeOutlines.mat'),'cellOutlinesLarvae');
end
uniqueIdOutline=unique(vertcat(cellOutlinesLarvae{:,1}));

dataSpine = load(fullfile(spineFile(1).folder,spineFile(1).name));

%load larvae properties
idArea = cellfun(@(x) strcmp(x,'area'),featureName);
idMorpwidth = cellfun(@(x) strcmp(x,'morpwidth'),featureName);
idSpeed = cellfun(@(x) strcmp(x,'speed'),featureName);
idX = cellfun(@(x) strcmp(x,'x'),featureName);
idY = cellfun(@(x) strcmp(x,'y'),featureName);
idDir = cellfun(@(x) strcmp(x,'dir'),featureName);

areaFile = load(fullfile(filesChoreography(idArea).folder,filesChoreography(idArea).name));
morpwidFile = load(fullfile(filesChoreography(idMorpwidth).folder,filesChoreography(idMorpwidth).name));
speedFile = load(fullfile(filesChoreography(idSpeed).folder,filesChoreography(idSpeed).name));
xFile = load(fullfile(filesChoreography(idX).folder,filesChoreography(idX).name));
yFile = load(fullfile(filesChoreography(idY).folder,filesChoreography(idY).name));
dirFile = load(fullfile(filesChoreography(idDir).folder,filesChoreography(idDir).name));


%% Reorganize unique IDs

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


tableSummaryFeatures = array2table([uniqueId,minTimesPerID,initCoordXLarvae,initCoordYLarvae,maxTimesPerID,lastCoordXLarvae,lastCoordYLarvae,medianAreaLarvae,morpwidLarvae],'VariableNames',{'id','minTime','xCoordInit','yCoordInit','maxTime','xCoordEnd','yCoordEnd','area','morpWidth'});
[tableSummaryFeatures,cellOutlinesLarvaeUpdated,dataSpineUpdated,xFileUpdated,yFileUpdated] = reorganizeUniqueIDs(tableSummaryFeatures,cellOutlinesLarvae,dataSpine,xFile,yFile);


imgName = dir(fullfile(dirPath,'*.png'));
imgInit = imread(fullfile(imgName.folder, imgName.name));


%% Save larvae temporal image sequence
if ~exist(fullfile(outlineFile(1).folder,'temporalImageSequenceLarvae'),'file') 
    minTimeTraj = 0; %sec
    maxTimeTraj = 600; %sec
    booleanSave = 1; %save==1, not save == 0 
    folder2save = fullfile(outlineFile(1).folder,'temporalImageSequenceLarvae');
    mkdir(folder2save)
    plotTrajectoryLarvae(cellOutlinesLarvaeUpdated,dataSpineUpdated,xFileUpdated,yFileUpdated,unique(xFile(:,2)),folder2save,imgInit,minTimeTraj,maxTimeTraj,booleanSave)
end

%Correcting some trajectories. Removing short trajectories or appearing at
%the plate border
borderIds = tableSummaryFeatures.xCoordInit < 20 | tableSummaryFeatures.xCoordInit > 210 | tableSummaryFeatures.yCoordInit < 5 | tableSummaryFeatures.yCoordInit > 165;
tableSummaryFeaturesFiltered =tableSummaryFeatures;
tableSummaryFeaturesFiltered(borderIds,:) = [];

minTimeTraj = 600; %sec
maxTimeTraj = 600; %sec
booleanSave = 0;

% ids2check = (tableSummaryFeaturesFiltered.maxTime - tableSummaryFeaturesFiltered.minTime)<maxTimeTraj*(0.8);
% plotTrajectoryLarvae(cellOutlinesLarvaeUpdated,dataSpineUpdated,xFileUpdated,yFileUpdated,tableSummaryFeaturesFiltered.id(ids2check),'',imgInit,minTimeTraj,maxTimeTraj,booleanSave)

splitOrSelectDir = 'Yes';
while strcmp(splitOrSelectDir,'Yes')
    splitOrSelectDir = questdlg('Do you want to combine IDs?', '','Yes','No, all right','Yes');
    
    if ~strcmp(splitOrSelectDir,'Yes')
        break
    end
    answer = inputdlg('Enter ALL space-separated IDs to be combined: (e.g.: 1 3 4; 2 3 4; 6 7 8):','Combine IDs', [1 50]);
    if ~isempty(answer)
        ids2Combine = str2num(answer{1});
    end
end

%Calculate average speed

%Polar histogram with trajectories
angleInitFinalPoint = atan2(tableSummaryFeaturesFiltered.yCoordEnd - tableSummaryFeaturesFiltered.yCoordInit, tableSummaryFeaturesFiltered.xCoordEnd - tableSummaryFeaturesFiltered.xCoordInit);
figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
polarhistogram(angleInitFinalPoint,12);
figure;plotTrajectoryLarvae(cellOutlinesLarvaeUpdated,dataSpineUpdated,xFileUpdated,yFileUpdated,tableSummaryFeaturesFiltered.id,'',imgInit,minTimeTraj,maxTimeTraj,booleanSave)




%polar plot

% joinUniqueIDLarve()
% removeFakeLarvae()

%findLarvaeFollowingGradient
%calculateAgilityIndex
%calculateLarvaeSpeed

