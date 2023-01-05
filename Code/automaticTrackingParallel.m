close all
clear all

addpath(genpath('lib'))

path2search1=fullfile('..','Choreography_results','**','n_freeNavigation*','2022*');
path2search2=fullfile('..','Choreography_results','**','n_1ul1000EA_600s@n','2022*');


totalDirectories=[dir(path2search1);dir(path2search2)];

parpool(64);
parfor nFile = 1:size(totalDirectories,1)
    targetDir = fullfile(totalDirectories(nFile).folder,totalDirectories(nFile).name);
    processRawChoreographyData(targetDir)
end