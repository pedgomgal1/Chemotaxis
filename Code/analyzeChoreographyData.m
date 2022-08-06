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
% fileOutline = load(fullfile(outlineFile(1).folder,outlineFile(1).name));
dataSpine = load(fullfile(spineFile(1).folder,spineFile(1).name));

%% Reorganized unique IDs
uniqueLarvaeID = unique(dataSpine(:,2));

minTimesPerID = arrayfun(@(x) min(dataSpine(dataSpine(:,2)==x,3)), uniqueLarvaeID);
initCoordXLarvae = arrayfun(@(x,y) mean(dataSpine(dataSpine(:,3)==x & dataSpine(:,2)==y,4:2:end)),minTimesPerID,uniqueLarvaeID);
initCoordYLarvae = arrayfun(@(x,y) mean(dataSpine(dataSpine(:,3)==x & dataSpine(:,2)==y,5:2:end)),minTimesPerID,uniqueLarvaeID);
maxTimesPerID = arrayfun(@(x) max(dataSpine(dataSpine(:,2)==x,3)), uniqueLarvaeID);
lastCoordXLarvae = arrayfun(@(x,y) mean(dataSpine(dataSpine(:,3)==x & dataSpine(:,2)==y,4:2:end)),maxTimesPerID,uniqueLarvaeID);
lastCoordYLarvae = arrayfun(@(x,y) mean(dataSpine(dataSpine(:,3)==x & dataSpine(:,2)==y,5:2:end)),maxTimesPerID,uniqueLarvaeID);

tableLarvaeIDMinMax = array2table([uniqueLarvaeID,minTimesPerID,initCoordXLarvae,initCoordYLarvae,maxTimesPerID,lastCoordXLarvae,lastCoordYLarvae],'VariableNames',{'id','minTime','xCoordInit','yCoordInit','maxTime','xCoordEnd','yCoordEnd'});

orderedLarvae = automaticLarvaeIDUnification(tableLarvaeIDMinMax);

plotTrajectoryLarvae(dataSpine,uniqueLarvaeID)

% joinUniqueIDLarve()
% removeFakeLarve()

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
    