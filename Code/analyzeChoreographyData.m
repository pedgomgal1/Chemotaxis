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
areaFile = load(fullfile(filesChoreography(idArea).folder,filesChoreography(idArea).name));
morpwidFile = load(fullfile(filesChoreography(idMorpwidth).folder,filesChoreography(idMorpwidth).name));
speedFile = load(fullfile(filesChoreography(idSpeed).folder,filesChoreography(idSpeed).name));


%% Reorganized unique IDs
uniqueIdSpine = unique(dataSpine(:,2));

minTimesPerID = arrayfun(@(x) min(dataSpine(dataSpine(:,2)==x,3)), uniqueIdSpine);
initCoordXLarvae = arrayfun(@(x,y) mean(dataSpine(dataSpine(:,3)==x & dataSpine(:,2)==y,4:2:end)),minTimesPerID,uniqueIdSpine);
initCoordYLarvae = arrayfun(@(x,y) mean(dataSpine(dataSpine(:,3)==x & dataSpine(:,2)==y,5:2:end)),minTimesPerID,uniqueIdSpine);
maxTimesPerID = arrayfun(@(x) max(dataSpine(dataSpine(:,2)==x,3)), uniqueIdSpine);
lastCoordXLarvae = arrayfun(@(x,y) mean(dataSpine(dataSpine(:,3)==x & dataSpine(:,2)==y,4:2:end)),maxTimesPerID,uniqueIdSpine);
lastCoordYLarvae = arrayfun(@(x,y) mean(dataSpine(dataSpine(:,3)==x & dataSpine(:,2)==y,5:2:end)),maxTimesPerID,uniqueIdSpine);
medianAreaLarvae = arrayfun(@(x) median(areaFile(areaFile(:,2)==x,4)), uniqueIdSpine);
morpwidLarvae = arrayfun(@(x) median(morpwidFile(morpwidFile(:,2)==x,4)), uniqueIdSpine);


tableSummaryFeatures = array2table([uniqueIdSpine,minTimesPerID,initCoordXLarvae,initCoordYLarvae,maxTimesPerID,lastCoordXLarvae,lastCoordYLarvae,medianAreaLarvae,morpwidLarvae],'VariableNames',{'id','minTime','xCoordInit','yCoordInit','maxTime','xCoordEnd','yCoordEnd','area','morpWidth'});

orderedLarvae={}; stopIterations=1;
while stopIterations>0
    nLab1 = size(tableSummaryFeatures,1);
    [tableSummaryFeatures,orderedLarvae{stopIterations}] = automaticLarvaeIDUnification(tableSummaryFeatures);
    nLab2 = size(tableSummaryFeatures,1);
    if nLab1==nLab2
        stopIterations=0;
    else
        stopIterations=stopIterations+1;
    end
end

%updateLabels
dataSpineUpdated=dataSpine;
labelsOutlineUpdated = vertcat(cellOutlinesLarvae{:,1});
for nIterations = 1:length(orderedLarvae)
    cellIDsSpine = cellfun(@(x) ismember(dataSpineUpdated(:,2),x).*min(x), orderedLarvae{nIterations},'UniformOutput',false);
    newCellIDsSpine=sum(cat(3,cellIDsSpine{:}),3);
    dataSpineUpdated(:,2)=newCellIDsSpine;
    
    cellIDsOutline = cellfun(@(x) ismember(labelsOutlineUpdated,x).*min(x), orderedLarvae{nIterations},'UniformOutput',false);
    newCellIDsOutline=sum(cat(3,cellIDsOutline{:}),3);
    labelsOutlineUpdated=newCellIDsOutline;
end
cellOutlinesLarvae(:,1)= num2cell(labelsOutlineUpdated(:));


plotTrajectoryLarvae(dataSpine,cellOutlinesLarvae,unique(newCellIDsSpine))

% joinUniqueIDLarve()
% removeFakeLarvae()

%findLarvaeFollowingGradient
%calculateAgilityIndex
%calculateLarvaeSpeed



for nFiles = 1:size(filesChoreography,1)

    selectedFeature = featureName{nFiles};
    switch selectedFeature
        case {'x'}

        case {'y'}

        case {'morpwidth'}

        case {'midline'}

        case {'dir'}

        case {'cast'}

        case {'crabspeed'}

        otherwise

    end

end
    