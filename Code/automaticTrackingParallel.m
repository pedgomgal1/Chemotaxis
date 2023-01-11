close all
clear all

addpath(genpath('lib'))

path2search1=fullfile('..','Choreography_results','**','n_freeNavigation*','2022*');
path2search2=fullfile('..','Choreography_results','**','n_1ul1000EA_600s@n','2022*');


totalDirectories=[dir(path2search1);dir(path2search2)];

parpool(8);
parfor nFile = 1:size(totalDirectories,1)
    try
        %disp(['starting - ' num2str(nFile) ' - ' totalDirectories(nFile).name])
        targetDir = fullfile(totalDirectories(nFile).folder,totalDirectories(nFile).name);
        processRawChoreographyData(targetDir)
        disp(['DONE - ' num2str(nFile) ' - ' totalDirectories(nFile).name])
    catch e %e is an MException struct
        disp([totalDirectories(nFile).name ' - ' e.message]);
        % more error handling...
    end
end