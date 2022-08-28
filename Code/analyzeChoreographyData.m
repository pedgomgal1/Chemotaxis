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

%load larvae area
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


%% Reorganized unique IDs
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

orderedLarvae={}; stopIterations=1;
%thresolds to look for unique IDs    
rangeTime = 30; %seconds
xyCoordRange = 10; %pixel distance
while stopIterations>0
    nLab1 = size(tableSummaryFeatures,1);
    [tableSummaryFeatures,orderedLarvae{stopIterations}] = automaticLarvaeIDUnification(tableSummaryFeatures,rangeTime,xyCoordRange);
    nLab2 = size(tableSummaryFeatures,1);
    if nLab1==nLab2
        stopIterations=0;
    else
        stopIterations=stopIterations+1;
    end
end
rangeTime = 100; %seconds
xyCoordRange = 20; %pixel distance
[tableSummaryFeatures,orderedLarvae{end+1}] = automaticLarvaeIDUnification(tableSummaryFeatures,rangeTime,xyCoordRange);

%updateLabels
dataSpineUpdated=dataSpine;
labelsOutlineUpdated = vertcat(cellOutlinesLarvae{:,1});
xFileIDUpdated = xFile;
for nIterations = 1:length(orderedLarvae)
    ordLarvae = orderedLarvae{nIterations};

    for nC = 1:length(ordLarvae)
        dataSpineUpdated(ismember(dataSpineUpdated(:,2),[ordLarvae{nC}]),2) = min([ordLarvae{nC}]);
        labelsOutlineUpdated(ismember(labelsOutlineUpdated,[ordLarvae{nC}])) = min([ordLarvae{nC}]);
        xFileIDUpdated(ismember(xFileIDUpdated(:,2),[ordLarvae{nC}]),2) = min([ordLarvae{nC}]);
    end
end
cellOutlinesLarvae(:,1)= num2cell(labelsOutlineUpdated(:));
xFile(:,2)=xFileIDUpdated(:,2);
yFile(:,2)=xFileIDUpdated(:,2);

imgName = dir(fullfile(dirPath,'*.png'));
imgInit = imread(fullfile(imgName.folder, imgName.name));


%% Save larvae temporal image sequence
% if ~exist(fullfile(outlineFile(1).folder,'temporalImageSequenceLarvae'),'file')  
    folder2save = fullfile(outlineFile(1).folder,'temporalImageSequenceLarvae');
    mkdir(folder2save)
    saveTemporalImageSequence(cellOutlinesLarvae,dataSpineUpdated,xFile,yFile,unique(xFile(:,2)),folder2save,imgInit)
% end


% plotTrajectoryLarvae(dataSpine,unique(newCellIDsSpine),imgInit)

% joinUniqueIDLarve()
% removeFakeLarvae()

%findLarvaeFollowingGradient
%calculateAgilityIndex
%calculateLarvaeSpeed

