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
idSpeed = cellfun(@(x) strcmp(x,'speed'),featureName);
idX = cellfun(@(x) strcmp(x,'x'),featureName);
idY = cellfun(@(x) strcmp(x,'y'),featureName);
idDir = cellfun(@(x) strcmp(x,'dir'),featureName);

areaFile = load(fullfile(filesChoreography(idArea).folder,filesChoreography(idArea).name));
speedFile = load(fullfile(filesChoreography(idSpeed).folder,filesChoreography(idSpeed).name));
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

else
    dataSpine=[];
    cellOutlinesLarvae=[];
    morpwidFile = areaFile;
end

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

[tableSummaryFeatures,orderedLarvae] = reorganizeUniqueIDs(tableSummaryFeatures);
[xFileUpdated]=updateLabelsFile(orderedLarvae,xFile);
[yFileUpdated]=updateLabelsFile(orderedLarvae,yFile);
[speedFileUpdated]=updateLabelsFile(orderedLarvae,speedFile);

if ~isempty(outlineFile)
    [dataSpineUpdated]=updateLabelsFile(orderedLarvae,dataSpine);
    [cellOutlinesLarvaeUpdated]=updateOutlinesFile(orderedLarvae,cellOutlinesLarvae);
end

imgName = dir(fullfile(dirPath,'*.png'));
imgInit = imread(fullfile(imgName.folder, imgName.name));

% %% Save larvae temporal image sequence
% if ~exist(fullfile(xFile(1).folder,'temporalImageSequenceLarvae'),'file') 
%     minTimeTraj = 0; %sec
%     maxTimeTraj = 600; %sec
%     booleanSave = 1; %save==1, not save == 0 
%     folder2save = fullfile(xFile(1).folder,'temporalImageSequenceLarvae');
%     mkdir(folder2save)
%     if ~isempty(outlineFile)
%         plotTrajectoryLarvae(cellOutlinesLarvaeUpdated,dataSpineUpdated,xFileUpdated,yFileUpdated,unique(xFile(:,2)),folder2save,imgInit,minTimeTraj,maxTimeTraj,booleanSave)
%     else
%         plotTrajectoryLarvae([],[],xFileUpdated,yFileUpdated,unique(xFile(:,2)),folder2save,imgInit,minTimeTraj,maxTimeTraj,booleanSave)
%     end
% end

%Correcting some trajectories. Removing short trajectories or appearing at
%the plate border
borderIds = tableSummaryFeatures.xCoordInit < 20 | tableSummaryFeatures.xCoordInit > 210 | tableSummaryFeatures.yCoordInit < 5 | tableSummaryFeatures.yCoordInit > 165;
tableSummaryFeaturesFiltered =tableSummaryFeatures;
idsBoder2remove = tableSummaryFeaturesFiltered.id(borderIds);
tableSummaryFeaturesFiltered(borderIds,:) = [];
xFileUpdated(ismember(xFileUpdated(:,2),idsBoder2remove),:)=[];
yFileUpdated(ismember(yFileUpdated(:,2),idsBoder2remove),:)=[];
speedFileUpdated(ismember(speedFileUpdated(:,2),idsBoder2remove),:)=[];

if ~isempty(outlineFile)
    dataSpineUpdated(ismember(dataSpineUpdated(:,2),idsBoder2remove),:)=[];
    cellOutlinesLarvaeUpdated(ismember(vertcat(cellOutlinesLarvaeUpdated{:,1}),idsBoder2remove),:)=[];
end


%Discard remaining trajectory if larva touch border???

minTimeTraj = 600; %sec
maxTimeTraj = 600; %sec
booleanSave = 0;

ids2check = (tableSummaryFeaturesFiltered.maxTime - tableSummaryFeaturesFiltered.minTime)<maxTimeTraj*(0.8);

if ~isempty(outlineFile)
    plotTrajectoryLarvae(cellOutlinesLarvaeUpdated,dataSpineUpdated,xFileUpdated,yFileUpdated,tableSummaryFeaturesFiltered.id(ids2check),'',imgInit,minTimeTraj,maxTimeTraj,booleanSave)
else
    plotTrajectoryLarvae([],[],xFileUpdated,yFileUpdated,tableSummaryFeaturesFiltered.id(ids2check),'',imgInit,minTimeTraj,maxTimeTraj,booleanSave)
end

combineIDSelection = 'Yes';
while strcmp(combineIDSelection,'Yes')
    combineIDSelection = questdlg('Do you want to combine IDs?', '','Yes','No, all right','Yes');
    
    if ~strcmp(combineIDSelection,'Yes')
        break
    end
    answer = inputdlg('Enter ALL space-separated IDs to be combined: (e.g.: 1 3 4; 2 3 4; 6 7 8):','Combine IDs', [1 50]);
    if ~isempty(answer)
        try
            ids2Combine = str2num(answer{1});
            allIds = tableSummaryFeaturesFiltered.id;
            allIdsOrdered = mat2cell(allIds);
            for nComb = 1:size(ids2Combine,2)
                idMin = min(ids2Combine(nComb,:));
                allIdsOrdered{allIds==idMin}=ids2Combine(nComb,:);
            end
            [xFileUpdated]=updateLabelsFile(allIdsOrdered,xFileUpdated);
            [yFileUpdated]=updateLabelsFile(allIdsOrdered,yFileUpdated);
            [speedFileUpdated]=updateLabelsFile(allIdsOrdered,speedFileUpdated);

            tableSummaryFeaturesFiltered=updateTableProperties(tableSummaryFeaturesFiltered,allIdsOrdered);
            if ~isempty(outlineFile)
                [dataSpineUpdated]=updateLabelsFile(orderedLarvae,dataSpineUpdated);
                [cellOutlinesLarvaeUpdated]=updateOutlinesFile(orderedLarvae,cellOutlinesLarvaeUpdated);
            end
        catch
            disp('Something is wrong, try again.')
        end
    end
end

%Final plot
plotTrajectoryLarvae([],[],xFileUpdated,yFileUpdated,tableSummaryFeaturesFiltered.id,'',imgInit,minTimeTraj,maxTimeTraj,booleanSave)
removeIDSelection = 'Yes';
while strcmp(removeIDSelection,'Yes')
    removeIDSelection = questdlg('Do you want to remove any ID?', '','Yes','No, all right','Yes');
    if ~strcmp(removeIDSelection,'Yes')
        break
    end
    answer = inputdlg('Enter ALL space-separated IDs to be combined: (e.g.: 1 3 4):','remove IDs', [1 50]);
     
    if ~isempty(answer)
        try
            ids2Remove = str2num(answer{1});
            xFileUpdated(ismember(xFileUpdated(:,2),ids2Remove),:)=[];
            yFileUpdated(ismember(yFileUpdated(:,2),ids2Remove),:)=[];
            speedFileUpdated(ismember(speedFileUpdated(:,2),ids2Remove),:)=[];
            tableSummaryFeaturesFiltered(ismember(tableSummaryFeaturesFiltered.id,ids2Remove),:) = [];
            
            plotTrajectoryLarvae([],[],xFileUpdated,yFileUpdated,tableSummaryFeaturesFiltered.id,'',imgInit,minTimeTraj,maxTimeTraj,booleanSave)

            if ~isempty(outlineFile)
                dataSpineUpdated(ismember(dataSpineUpdated(:,2),ids2Remove),:)=[];
                cellOutlinesLarvaeUpdated(ismember(vertcat(cellOutlinesLarvaeUpdated{:,1}),ids2Remove),:)=[];
            end
        catch
            disp('Something is wrong, try again.')
        end
    end
end

if ~isempty(outlineFile)
    save(fullfile(dirPath,'cleanedChoreographyData.mat'),'xFileUpdated','yFileUpdated','speedFileUpdated','tableSummaryFeaturesFiltered','dataSpineUpdated','cellOutlinesLarvaeUpdated','xFile','yFile','speedFile','tableSummaryFeatures','spineFile','cellOutlinesLarvae')
else
    save(fullfile(dirPath,'cleanedChoreographyData.mat'),'xFileUpdated','yFileUpdated','speedFileUpdated','tableSummaryFeaturesFiltered','xFile','yFile','speedFile','tableSummaryFeatures')
end


%Calculate average speed

averageSpeedLarvae = arrayfun(@(x) mean(speedFileUpdated(speedFileUpdated(:,2)==x,4)), uniqueId);
mean(averageSpeedLarvae,'omitnan')

%Polar histogram with trajectories
angleInitFinalPoint = atan2(tableSummaryFeaturesFiltered.xCoordEnd - tableSummaryFeaturesFiltered.xCoordInit, tableSummaryFeaturesFiltered.yCoordEnd - tableSummaryFeaturesFiltered.yCoordInit);
distInitFinalPoint = pdist2([tableSummaryFeaturesFiltered.xCoordInit, tableSummaryFeaturesFiltered.yCoordInit],[tableSummaryFeaturesFiltered.xCoordEnd, tableSummaryFeaturesFiltered.yCoordEnd]);
distBetwPairs = diag(distInitFinalPoint);

h1=figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
p=polarhistogram(angleInitFinalPoint,12);
labels = findall(gca,'type','text');
set(labels,'visible','off');
set(gca,'FontSize', 24,'FontName','Helvetica','GridAlpha',1);
rticks([])

% lines = findall(gca,'type','line');
% set(lines,'visible','off');

h2=figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
[x,y] = pol2cart(angleInitFinalPoint,distBetwPairs./max(distBetwPairs));
compass(x,y)
labels = findall(gca,'type','text');
set(labels,'visible','off');
rticks([])


%polar plot

% joinUniqueIDLarve()
% removeFakeLarvae()

%findLarvaeFollowingGradient
%calculateAgilityIndex
%calculateLarvaeSpeed

