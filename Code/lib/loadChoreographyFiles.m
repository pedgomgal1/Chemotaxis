function [xFile, yFile, areaFile, speedFile, castFile, morpwidFile, dataSpine, cellOutlinesLarvae]=loadChoreographyFiles(dirPath)
    
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
        dataSpine= dataSpine(:,2:end);
    
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


end