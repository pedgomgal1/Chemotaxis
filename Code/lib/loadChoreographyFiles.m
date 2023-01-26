function [xFile, yFile, areaFile, speedFile, speedFile085,crabSpeedFile, curveFile,castFile, morpwidFile, dataSpine, cellOutlinesLarvae]=loadChoreographyFiles(dirPath)
    
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
    idCurve = cellfun(@(x) strcmp(x,'curve'),featureName);
    idCrabSpeed = cellfun(@(x) strcmp(x,'crabspeed'),featureName);
%     idKink = cellfun(@(x) strcmp(x,'kink'),featureName);


    idSpeed = cellfun(@(x) strcmp(x,'speed'),featureName);
    idSpeed085 = cellfun(@(x) strcmp(x,'speed085'),featureName);

    idX = cellfun(@(x) strcmp(x,'x'),featureName);
    idY = cellfun(@(x) strcmp(x,'y'),featureName);
    
    areaFile = readtable(fullfile(filesChoreography(idArea).folder,filesChoreography(idArea).name));
    areaFile=table2array(areaFile(:,2:5));
    [rows,~]=find(isnan(areaFile));
    areaFile(rows,:)= [];
    areaFile=unique(areaFile,'rows');

    speedFile = readtable(fullfile(filesChoreography(idSpeed).folder,filesChoreography(idSpeed).name));
    speedFile=table2array(speedFile(:,2:5));
    [rows,~]=find(isnan(speedFile));
    speedFile(rows,:)= [];
    speedFile=unique(speedFile,'rows');

    speedFile085 = readtable(fullfile(filesChoreography(idSpeed085).folder,filesChoreography(idSpeed085).name));
    speedFile085=table2array(speedFile085(:,2:5));
    [rows,~]=find(isnan(speedFile085));
    speedFile085(rows,:)= [];
    speedFile085=unique(speedFile085,'rows');
    
    crabSpeedFile = readtable(fullfile(filesChoreography(idCrabSpeed).folder,filesChoreography(idCrabSpeed).name));
    crabSpeedFile=table2array(crabSpeedFile(:,2:5));
    [rows,~]=find(isnan(crabSpeedFile));
    crabSpeedFile(rows,:)= [];

%     kinkFile = readtable(fullfile(filesChoreography(idKink).folder,filesChoreography(idKink).name));
%     kinkFile=table2array(kinkFile(:,2:5));
%     [rows,~]=find(isnan(kinkFile));
%     kinkFile(rows,:)= [];


    xFile = readtable(fullfile(filesChoreography(idX).folder,filesChoreography(idX).name));
    xFile=table2array(xFile(:,2:5));
    [rows,~]=find(isnan(xFile));
    xFile(rows,:)= [];
    xFile=unique(xFile,'rows');
    
    yFile = readtable(fullfile(filesChoreography(idY).folder,filesChoreography(idY).name));
    yFile=table2array(yFile(:,2:5));
    [rows,~]=find(isnan(yFile));
    yFile(rows,:)= [];    
    yFile=unique(yFile,'rows');
    
    if ~isempty(outlineFile)
        if ~exist(fullfile(outlineFile(1).folder,'rawlarvaeOutlines.mat'),'file')    
            cellOutlinesLarvae=parseOutlinesFile(outlineFile(1).folder,outlineFile(1).name);
        else
            load(fullfile(outlineFile(1).folder,'rawlarvaeOutlines.mat'),'cellOutlinesLarvae');
        end
        
        dataSpine = load(fullfile(spineFile(1).folder,spineFile(1).name));
        dataSpine= dataSpine(:,2:end);
        dataSpine(isnan(dataSpine(:,1)),:)= [];
        dataSpine=unique(dataSpine,'rows');
        
        idMorpwidth = cellfun(@(x) strcmp(x,'morpwidth'),featureName);
        morpwidFile = readtable(fullfile(filesChoreography(idMorpwidth).folder,filesChoreography(idMorpwidth).name));
        morpwidFile=table2array(morpwidFile(:,2:end));
        morpwidFile(isnan(morpwidFile(:,1)),:)= [];
        morpwidFile=unique(morpwidFile,'rows');
        castFile = readtable(fullfile(filesChoreography(idCast).folder,filesChoreography(idCast).name));
        castFile=table2array(castFile(:,2:end));
        [rows,~]=find(isnan(castFile));
        castFile(rows,:)= [];    
        castFile=unique(castFile,'rows');

        curveFile = readtable(fullfile(filesChoreography(idCurve).folder,filesChoreography(idCurve).name));
        curveFile=table2array(curveFile(:,2:5));
        [rows,~]=find(isnan(curveFile));
        curveFile(rows,:)= [];   
        curveFile=unique(curveFile,'rows');
    else
        dataSpine=[];
        castFile = [];
        cellOutlinesLarvae=[];
        curveFile=[];
        morpwidFile = areaFile;
    end


end