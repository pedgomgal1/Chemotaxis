close all
clear all

addpath(genpath('lib'))
%Select folder to cast the outliesFiles data from Choreography
dirPath = uigetdir('../Choreography_results','select folder after Choreography processing');
outlineFiles = dir(fullfile(dirPath,'**/*.outline'));

for nFile = 1:size(outlineFiles)
    disp(outlineFiles(nFile).folder)
    if ~exist(fullfile(outlineFiles(nFile).folder,'rawlarvaeOutlines.mat'),'file')    
        [tempCellOutline]=parseOutlinesFile(outlineFiles(nFile).folder,outlineFiles(nFile).name);
    end

end