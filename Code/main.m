
%% Extract the information from all experiments
clear all
close all

addpath(genpath('lib'))

%% Select driver lines
[pathFolder] = uigetdir(fullfile('..','..','cephfs','choreography-results'),'select folder containing a line experiment (e.g. thG@UPD)');

%% Prepare directories
foldersGenotypes = dir(fullfile(pathFolder,'*@*'));

experiments = {'n_1ul1000EA_600s@n','n_freeNavigation_600s@n'};

path2search1=dir(fullfile(pathFolder,foldersGenotypes(1).name,'**',experiments{1},'202*'));
path2search2=dir(fullfile(pathFolder,foldersGenotypes(2).name,'**',experiments{1},'202*'));
path2search3=dir(fullfile(pathFolder,foldersGenotypes(3).name,'**',experiments{1},'202*'));%[dir(fullfile(pathFolder,foldersGenotypes(3).name,'**',experiments{1},'202305*'));dir(fullfile(pathFolder,foldersGenotypes(3).name,'**',experiments{1},'202306*'))];

path2search4=dir(fullfile(pathFolder,foldersGenotypes(1).name,'**',experiments{2},'202*'));
path2search5=dir(fullfile(pathFolder,foldersGenotypes(2).name,'**',experiments{2},'202*'));
path2search6=dir(fullfile(pathFolder,foldersGenotypes(3).name,'**',experiments{2},'202*'));


totalDirectories=[path2search1;path2search2;path2search3;path2search4;path2search5;path2search6];
celDirectories ={totalDirectories.folder};

idsEA = find(cellfun(@(x) contains(x,'n_1ul1000EA_600s@n'), celDirectories));
idsFreeNav = find(cellfun(@(x) contains(x,'n_freeNavigation_600s@n'), celDirectories));
idsTH = find(cellfun(@(x) contains(x,'Uempty'), celDirectories));
idsG2019S = find(cellfun(@(x) contains(x,'UG2019S'), celDirectories));
idsA53T = find(cellfun(@(x) contains(x,'UaSynA53T'), celDirectories));

%%% INITIALIZING ALL VARIABLES %%%
allVars1=initializeVars(size(totalDirectories,1));
allVars2=initializeVars(size(totalDirectories,1));


parfor nDir=1:size(totalDirectories,1)

    try
        allVars=extractFeaturesPerExperiment(fullfile(totalDirectories(nDir).folder,totalDirectories(nDir).name));

    catch
        disp(['error in ' fullfile(totalDirectories(nDir).folder,totalDirectories(nDir).name) ]);
    end
end

%% Group and plot data



%%% TABLE WITH TRANSITION MATRIX (8 x 12)
groupedMeanTransitionMatrixOrient =[mean(cat(3,transitionMatrixOrientation{intersect(idsEA,idsTH)}),3),mean(cat(3,transitionMatrixOrientation{intersect(idsEA,idsG2019S)}),3),mean(cat(3,transitionMatrixOrientation{intersect(idsEA,idsA53T)}),3);
    mean(cat(3,transitionMatrixOrientation{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,transitionMatrixOrientation{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,transitionMatrixOrientation{intersect(idsFreeNav,idsA53T)}),3)];

tabMeanTransitionMatrixOrient=array2table(groupedMeanTransitionMatrixOrient,'VariableNames',{'control_left','control_right','control_top','control_bottom','G2019S_left','G2019S_right','G2019S_top','G2019S_bottom','A53T_left','A53T_right','A53T_top','A53T_bottom'},'RowNames',...
    {'left_EA','right_EA','top_EA','bottom_EA','left_FreeNav','right_FreeNav','top_FreeNav','bottom_FreeNav'});

groupedStdTransitionMatrixOrient =[std(cat(3,transitionMatrixOrientation{intersect(idsEA,idsTH)}),[],3),std(cat(3,transitionMatrixOrientation{intersect(idsEA,idsG2019S)}),[],3),std(cat(3,transitionMatrixOrientation{intersect(idsEA,idsA53T)}),[],3);
    std(cat(3,transitionMatrixOrientation{intersect(idsFreeNav,idsTH)}),[],3),std(cat(3,transitionMatrixOrientation{intersect(idsFreeNav,idsG2019S)}),[],3),std(cat(3,transitionMatrixOrientation{intersect(idsFreeNav,idsA53T)}),[],3)];

tabStdTransitionMatrixOrient=array2table(groupedStdTransitionMatrixOrient,'VariableNames',{'control_left','control_right','control_top','control_bottom','G2019S_left','G2019S_right','G2019S_top','G2019S_bottom','A53T_left','A53T_right','A53T_top','A53T_bottom'},'RowNames',...
    {'left_EA','right_EA','top_EA','bottom_EA','left_FreeNav','right_FreeNav','top_FreeNav','bottom_FreeNav'});


percAngularState = cellfun(@(x) sum(x)/sum(x(:)), matrixProbOrientation, 'UniformOutput', false);
meanPercAng_control_EA = mean(cat(3,percAngularState{intersect(idsEA,idsTH)}),3);
stdPercAng_control_EA = std(cat(3,percAngularState{intersect(idsEA,idsTH)}),[],3);
meanPercAng_G2019S_EA = mean(cat(3,percAngularState{intersect(idsEA,idsG2019S)}),3);
stdPercAng_G2019S_EA = std(cat(3,percAngularState{intersect(idsEA,idsG2019S)}),[],3);
meanPercAng_A53T_EA = mean(cat(3,percAngularState{intersect(idsEA,idsA53T)}),3);
stdPercAng_A53T_EA = std(cat(3,percAngularState{intersect(idsEA,idsA53T)}),[],3);
meanPercAng_control_Free = mean(cat(3,percAngularState{intersect(idsFreeNav,idsTH)}),3);
stdPercAng_control_Free = std(cat(3,percAngularState{intersect(idsFreeNav,idsTH)}),[],3);
meanPercAng_G2019S_Free = mean(cat(3,percAngularState{intersect(idsFreeNav,idsG2019S)}),3);
stdPercAng_G2019S_Free = std(cat(3,percAngularState{intersect(idsFreeNav,idsG2019S)}),[],3);
meanPercAng_A53T_Free = mean(cat(3,percAngularState{intersect(idsFreeNav,idsA53T)}),3);
stdPercAng_A53T_Free = std(cat(3,percAngularState{intersect(idsFreeNav,idsA53T)}),[],3);

tabPercAngStates = array2table([[meanPercAng_control_EA; stdPercAng_control_EA; meanPercAng_control_Free; stdPercAng_control_Free],[meanPercAng_G2019S_EA; stdPercAng_G2019S_EA;meanPercAng_G2019S_Free; stdPercAng_G2019S_Free],[meanPercAng_A53T_EA;stdPercAng_A53T_EA;meanPercAng_A53T_Free;stdPercAng_A53T_Free]],...
    "RowNames",{'average_EA','std_EA','average_FreeNav','std_FreeNav'},'VariableNames',{'left_control','right_control','top_control','down_control','left_G2019S','right_G2019S','top_G2019S','down_G2019S','left_A53T','right_A53T','top_A53T','down_A53T'});

%hidden MK

%% Transition matrix motion. run, stop, turn and cast states

%%%%%%%%%%transition matrix 

percMovState = cellfun(@(x) sum(x)/sum(x(:)), matrixProbMotionStates, 'UniformOutput', false);

meanPercMov_control_EA = mean(cat(3,percMovState{intersect(idsEA,idsTH)}),3);
stdPercMov_control_EA = std(cat(3,percMovState{intersect(idsEA,idsTH)}),[],3);
meanPercMov_G2019S_EA = mean(cat(3,percMovState{intersect(idsEA,idsG2019S)}),3);
stdPercMov_G2019S_EA = std(cat(3,percMovState{intersect(idsEA,idsG2019S)}),[],3);
meanPercMov_A53T_EA = mean(cat(3,percMovState{intersect(idsEA,idsA53T)}),3);
stdPercMov_A53T_EA = std(cat(3,percMovState{intersect(idsEA,idsA53T)}),[],3);
meanPercMov_control_Free = mean(cat(3,percMovState{intersect(idsFreeNav,idsTH)}),3);
stdPercMov_control_Free = std(cat(3,percMovState{intersect(idsFreeNav,idsTH)}),[],3);
meanPercMov_G2019S_Free = mean(cat(3,percMovState{intersect(idsFreeNav,idsG2019S)}),3);
stdPercMov_G2019S_Free = std(cat(3,percMovState{intersect(idsFreeNav,idsG2019S)}),[],3);
meanPercMov_A53T_Free = mean(cat(3,percMovState{intersect(idsFreeNav,idsA53T)}),3);
stdPercMov_A53T_Free = std(cat(3,percMovState{intersect(idsFreeNav,idsA53T)}),[],3);

tabPercMovStates = array2table([[meanPercMov_control_EA; stdPercMov_control_EA; meanPercMov_control_Free; stdPercMov_control_Free],[meanPercMov_G2019S_EA; stdPercMov_G2019S_EA;meanPercMov_G2019S_Free; stdPercMov_G2019S_Free],[meanPercMov_A53T_EA;stdPercMov_A53T_EA;meanPercMov_A53T_Free;stdPercMov_A53T_Free]],...
    "RowNames",{'average_EA','std_EA','average_FreeNav','std_FreeNav'},'VariableNames',{'run_Control','stop_Control','turn_Control','cast_Control','run_G2019S','stop_G2019S','turn_G2019S','cast_G2019S','run_A53T','stop_A53T','turn_A53T','cast_A53T'});


%%% TABLE WITH TRANSITION MATRIX (8 x 12)
groupedMeanTransitionMatrixMov =[mean(cat(3,transitionMatrixMotionStates{intersect(idsEA,idsTH)}),3),mean(cat(3,transitionMatrixMotionStates{intersect(idsEA,idsG2019S)}),3),mean(cat(3,transitionMatrixMotionStates{intersect(idsEA,idsA53T)}),3);
    mean(cat(3,transitionMatrixMotionStates{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,transitionMatrixMotionStates{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,transitionMatrixMotionStates{intersect(idsFreeNav,idsA53T)}),3)];

tabMeanTransitionMatrixMov=array2table(groupedMeanTransitionMatrixMov,'VariableNames',{'control_run','control_stop','control_turn','control_cast','G2019S_run','G2019S_stop','G2019S_turn','G2019S_cast','A53T_run','A53T_stop','A53T_turn','A53T_cast'},'RowNames',...
    {'run_EA','stop_EA','turn_EA','cast_EA','run_FreeNav','stop_FreeNav','turn_FreeNav','cast_FreeNav'});


% %table running states per orientation
% groupedMovStatePerOrientation = [mean(cat(3,runRatePerOrient{intersect(idsEA,idsTH)}),3),mean(cat(3,runRatePerOrient{intersect(idsEA,idsG2019S)}),3),mean(cat(3,runRatePerOrient{intersect(idsEA,idsA53T)}),3);...
%     mean(cat(3,stopRatePerOrient{intersect(idsEA,idsTH)}),3),mean(cat(3,stopRatePerOrient{intersect(idsEA,idsG2019S)}),3),mean(cat(3,stopRatePerOrient{intersect(idsEA,idsA53T)}),3);...
%     mean(cat(3,turningRatePerOrient{intersect(idsEA,idsTH)}),3),mean(cat(3,turningRatePerOrient{intersect(idsEA,idsG2019S)}),3),mean(cat(3,turningRatePerOrient{intersect(idsEA,idsA53T)}),3);...
%     mean(cat(3,runRatePerOrient{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,runRatePerOrient{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,runRatePerOrient{intersect(idsFreeNav,idsA53T)}),3);...
%     mean(cat(3,stopRatePerOrient{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,stopRatePerOrient{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,stopRatePerOrient{intersect(idsFreeNav,idsA53T)}),3);
%     mean(cat(3,turningRatePerOrient{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,turningRatePerOrient{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,turningRatePerOrient{intersect(idsFreeNav,idsA53T)}),3)];
% 
% tabMovRatePerOrient=array2table(groupedMovStatePerOrientation,'VariableNames',{'control_left','control_right','control_top','control_bottom','G2019S_left','G2019S_right','G2019S_top','G2019S_bottom','A53T_left','A53T_right','A53T_top','A53T_bottom'},'RowNames',...
%     {'run_EA','stop_EA','turn_EA','run_FreeNav','stop_FreeNav','turn_FreeNav'});


%%% TABLES WITH SPEEDS (angular, speed, crabSpeed and speed085)
angularSpeedGrouped =[mean(avgMeanAngularSpeed(intersect(idsEA,idsTH))),mean(avgMeanAngularSpeed(intersect(idsEA,idsG2019S))),mean(avgMeanAngularSpeed(intersect(idsEA,idsA53T)));...
    std(avgMeanAngularSpeed(intersect(idsEA,idsTH))),std(avgMeanAngularSpeed(intersect(idsEA,idsG2019S))),std(avgMeanAngularSpeed(intersect(idsEA,idsA53T)));...
    mean(avgStdAngularSpeed(intersect(idsEA,idsTH))),mean(avgStdAngularSpeed(intersect(idsEA,idsG2019S))),mean(avgStdAngularSpeed(intersect(idsEA,idsA53T)));...
    std(avgStdAngularSpeed(intersect(idsEA,idsTH))),std(avgStdAngularSpeed(intersect(idsEA,idsG2019S))),std(avgStdAngularSpeed(intersect(idsEA,idsA53T)));...
    mean(avgMeanAngularSpeed(intersect(idsFreeNav,idsTH))),mean(avgMeanAngularSpeed(intersect(idsFreeNav,idsG2019S))),mean(avgMeanAngularSpeed(intersect(idsFreeNav,idsA53T)));...
    std(avgMeanAngularSpeed(intersect(idsFreeNav,idsTH))),std(avgMeanAngularSpeed(intersect(idsFreeNav,idsG2019S))),std(avgMeanAngularSpeed(intersect(idsFreeNav,idsA53T)));...
    mean(avgStdAngularSpeed(intersect(idsFreeNav,idsTH))),mean(avgStdAngularSpeed(intersect(idsFreeNav,idsG2019S))),mean(avgStdAngularSpeed(intersect(idsFreeNav,idsA53T)));...
    std(avgStdAngularSpeed(intersect(idsFreeNav,idsTH))),std(avgStdAngularSpeed(intersect(idsFreeNav,idsG2019S))),std(avgStdAngularSpeed(intersect(idsFreeNav,idsA53T)))];

tabAngSpeed = array2table(angularSpeedGrouped,'VariableNames',{'control','G2019S','A53T'},'RowNames',{'meanAvgMean_EA','stdAvgMean_EA','meanAvgStd_EA','stdAvgStd_EA','meanAvgMean_freeNav','stdAvgMean_freeNav','meanAvgStd_FreeNav','stdAvgStd_FreeNav'});


speedGrouped =[mean(avgMeanSpeed(intersect(idsEA,idsTH))),mean(avgMeanSpeed(intersect(idsEA,idsG2019S))),mean(avgMeanSpeed(intersect(idsEA,idsA53T)));...
    std(avgMeanSpeed(intersect(idsEA,idsTH))),std(avgMeanSpeed(intersect(idsEA,idsG2019S))),std(avgMeanSpeed(intersect(idsEA,idsA53T)));...
    mean(avgStdSpeed(intersect(idsEA,idsTH))),mean(avgStdSpeed(intersect(idsEA,idsG2019S))),mean(avgStdSpeed(intersect(idsEA,idsA53T)));...
    std(avgStdSpeed(intersect(idsEA,idsTH))),std(avgStdSpeed(intersect(idsEA,idsG2019S))),std(avgStdSpeed(intersect(idsEA,idsA53T)));...
    mean(avgMeanSpeed(intersect(idsFreeNav,idsTH))),mean(avgMeanSpeed(intersect(idsFreeNav,idsG2019S))),mean(avgMeanSpeed(intersect(idsFreeNav,idsA53T)));...
    std(avgMeanSpeed(intersect(idsFreeNav,idsTH))),std(avgMeanSpeed(intersect(idsFreeNav,idsG2019S))),std(avgMeanSpeed(intersect(idsFreeNav,idsA53T)));...
    mean(avgStdSpeed(intersect(idsFreeNav,idsTH))),mean(avgStdSpeed(intersect(idsFreeNav,idsG2019S))),mean(avgStdSpeed(intersect(idsFreeNav,idsA53T)));...
    std(avgStdSpeed(intersect(idsFreeNav,idsTH))),std(avgStdSpeed(intersect(idsFreeNav,idsG2019S))),std(avgStdSpeed(intersect(idsFreeNav,idsA53T)))];

tabSpeed = array2table(speedGrouped,'VariableNames',{'control','G2019S','A53T'},'RowNames',{'meanAvgMean_EA','stdAvgMean_EA','meanAvgStd_EA','stdAvgStd_EA','meanAvgMean_freeNav','stdAvgMean_freeNav','meanAvgStd_FreeNav','stdAvgStd_FreeNav'});

avgMeanSpeedNormLength = avgMeanSpeed./averageLarvaeLength;
avgStdSpeedNormLength = avgStdSpeed./averageLarvaeLength;
speedGroupedNormLength =[mean(avgMeanSpeedNormLength(intersect(idsEA,idsTH))),mean(avgMeanSpeedNormLength(intersect(idsEA,idsG2019S))),mean(avgMeanSpeedNormLength(intersect(idsEA,idsA53T)));...
    std(avgMeanSpeedNormLength(intersect(idsEA,idsTH))),std(avgMeanSpeedNormLength(intersect(idsEA,idsG2019S))),std(avgMeanSpeedNormLength(intersect(idsEA,idsA53T)));...
    mean(avgStdSpeedNormLength(intersect(idsEA,idsTH))),mean(avgStdSpeedNormLength(intersect(idsEA,idsG2019S))),mean(avgStdSpeedNormLength(intersect(idsEA,idsA53T)));...
    std(avgStdSpeedNormLength(intersect(idsEA,idsTH))),std(avgStdSpeedNormLength(intersect(idsEA,idsG2019S))),std(avgStdSpeedNormLength(intersect(idsEA,idsA53T)));...
    mean(avgMeanSpeedNormLength(intersect(idsFreeNav,idsTH))),mean(avgMeanSpeedNormLength(intersect(idsFreeNav,idsG2019S))),mean(avgMeanSpeedNormLength(intersect(idsFreeNav,idsA53T)));...
    std(avgMeanSpeedNormLength(intersect(idsFreeNav,idsTH))),std(avgMeanSpeedNormLength(intersect(idsFreeNav,idsG2019S))),std(avgMeanSpeedNormLength(intersect(idsFreeNav,idsA53T)));...
    mean(avgStdSpeedNormLength(intersect(idsFreeNav,idsTH))),mean(avgStdSpeedNormLength(intersect(idsFreeNav,idsG2019S))),mean(avgStdSpeedNormLength(intersect(idsFreeNav,idsA53T)));...
    std(avgStdSpeedNormLength(intersect(idsFreeNav,idsTH))),std(avgStdSpeedNormLength(intersect(idsFreeNav,idsG2019S))),std(avgStdSpeedNormLength(intersect(idsFreeNav,idsA53T)))];

tabSpeedNormLength = array2table(speedGroupedNormLength,'VariableNames',{'control','G2019S','A53T'},'RowNames',{'meanAvgMean_EA','stdAvgMean_EA','meanAvgStd_EA','stdAvgStd_EA','meanAvgMean_freeNav','stdAvgMean_freeNav','meanAvgStd_FreeNav','stdAvgStd_FreeNav'});


speed085Grouped =[mean(avgMeanSpeed085(intersect(idsEA,idsTH))),mean(avgMeanSpeed085(intersect(idsEA,idsG2019S))),mean(avgMeanSpeed085(intersect(idsEA,idsA53T)));...
    std(avgMeanSpeed085(intersect(idsEA,idsTH))),std(avgMeanSpeed085(intersect(idsEA,idsG2019S))),std(avgMeanSpeed085(intersect(idsEA,idsA53T)));...
    mean(avgStdSpeed085(intersect(idsEA,idsTH))),mean(avgStdSpeed085(intersect(idsEA,idsG2019S))),mean(avgStdSpeed085(intersect(idsEA,idsA53T)));...
    std(avgStdSpeed085(intersect(idsEA,idsTH))),std(avgStdSpeed085(intersect(idsEA,idsG2019S))),std(avgStdSpeed085(intersect(idsEA,idsA53T)));...
    mean(avgMeanSpeed085(intersect(idsFreeNav,idsTH))),mean(avgMeanSpeed085(intersect(idsFreeNav,idsG2019S))),mean(avgMeanSpeed085(intersect(idsFreeNav,idsA53T)));...
    std(avgMeanSpeed085(intersect(idsFreeNav,idsTH))),std(avgMeanSpeed085(intersect(idsFreeNav,idsG2019S))),std(avgMeanSpeed085(intersect(idsFreeNav,idsA53T)));...
    mean(avgStdSpeed085(intersect(idsFreeNav,idsTH))),mean(avgStdSpeed085(intersect(idsFreeNav,idsG2019S))),mean(avgStdSpeed085(intersect(idsFreeNav,idsA53T)));...
    std(avgStdSpeed085(intersect(idsFreeNav,idsTH))),std(avgStdSpeed085(intersect(idsFreeNav,idsG2019S))),std(avgStdSpeed085(intersect(idsFreeNav,idsA53T)))];

tabSpeed085 = array2table(speed085Grouped,'VariableNames',{'control','G2019S','A53T'},'RowNames',{'meanAvgMean_EA','stdAvgMean_EA','meanAvgStd_EA','stdAvgStd_EA','meanAvgMean_freeNav','stdAvgMean_freeNav','meanAvgStd_FreeNav','stdAvgStd_FreeNav'});

avgMeanSpeed085NormLength = avgMeanSpeed085./averageLarvaeLength;
avgStdSpeed085NormLength = avgStdSpeed085./averageLarvaeLength;
speed085GroupedNormLength =[mean(avgMeanSpeed085NormLength(intersect(idsEA,idsTH))),mean(avgMeanSpeed085NormLength(intersect(idsEA,idsG2019S))),mean(avgMeanSpeed085NormLength(intersect(idsEA,idsA53T)));...
    std(avgMeanSpeed085NormLength(intersect(idsEA,idsTH))),std(avgMeanSpeed085NormLength(intersect(idsEA,idsG2019S))),std(avgMeanSpeed085NormLength(intersect(idsEA,idsA53T)));...
    mean(avgStdSpeed085NormLength(intersect(idsEA,idsTH))),mean(avgStdSpeed085NormLength(intersect(idsEA,idsG2019S))),mean(avgStdSpeed085NormLength(intersect(idsEA,idsA53T)));...
    std(avgStdSpeed085NormLength(intersect(idsEA,idsTH))),std(avgStdSpeed085NormLength(intersect(idsEA,idsG2019S))),std(avgStdSpeed085NormLength(intersect(idsEA,idsA53T)));...
    mean(avgMeanSpeed085NormLength(intersect(idsFreeNav,idsTH))),mean(avgMeanSpeed085NormLength(intersect(idsFreeNav,idsG2019S))),mean(avgMeanSpeed085NormLength(intersect(idsFreeNav,idsA53T)));...
    std(avgMeanSpeed085NormLength(intersect(idsFreeNav,idsTH))),std(avgMeanSpeed085NormLength(intersect(idsFreeNav,idsG2019S))),std(avgMeanSpeed085NormLength(intersect(idsFreeNav,idsA53T)));...
    mean(avgStdSpeed085NormLength(intersect(idsFreeNav,idsTH))),mean(avgStdSpeed085NormLength(intersect(idsFreeNav,idsG2019S))),mean(avgStdSpeed085NormLength(intersect(idsFreeNav,idsA53T)));...
    std(avgStdSpeed085NormLength(intersect(idsFreeNav,idsTH))),std(avgStdSpeed085NormLength(intersect(idsFreeNav,idsG2019S))),std(avgStdSpeed085NormLength(intersect(idsFreeNav,idsA53T)))];

tabSpeed085NormLength = array2table(speed085GroupedNormLength,'VariableNames',{'control','G2019S','A53T'},'RowNames',{'meanAvgMean_EA','stdAvgMean_EA','meanAvgStd_EA','stdAvgStd_EA','meanAvgMean_freeNav','stdAvgMean_freeNav','meanAvgStd_FreeNav','stdAvgStd_FreeNav'});


crabSpeedGrouped =[mean(avgMeanCrabSpeed(intersect(idsEA,idsTH))),mean(avgMeanCrabSpeed(intersect(idsEA,idsG2019S))),mean(avgMeanCrabSpeed(intersect(idsEA,idsA53T)));...
    std(avgMeanCrabSpeed(intersect(idsEA,idsTH))),std(avgMeanCrabSpeed(intersect(idsEA,idsG2019S))),std(avgMeanCrabSpeed(intersect(idsEA,idsA53T)));...
    mean(avgStdCrabSpeed(intersect(idsEA,idsTH))),mean(avgStdCrabSpeed(intersect(idsEA,idsG2019S))),mean(avgStdCrabSpeed(intersect(idsEA,idsA53T)));...
    std(avgStdCrabSpeed(intersect(idsEA,idsTH))),std(avgStdCrabSpeed(intersect(idsEA,idsG2019S))),std(avgStdCrabSpeed(intersect(idsEA,idsA53T)));...
    mean(avgMeanCrabSpeed(intersect(idsFreeNav,idsTH))),mean(avgMeanCrabSpeed(intersect(idsFreeNav,idsG2019S))),mean(avgMeanCrabSpeed(intersect(idsFreeNav,idsA53T)));...
    std(avgMeanCrabSpeed(intersect(idsFreeNav,idsTH))),std(avgMeanCrabSpeed(intersect(idsFreeNav,idsG2019S))),std(avgMeanCrabSpeed(intersect(idsFreeNav,idsA53T)));...
    mean(avgStdCrabSpeed(intersect(idsFreeNav,idsTH))),mean(avgStdCrabSpeed(intersect(idsFreeNav,idsG2019S))),mean(avgStdCrabSpeed(intersect(idsFreeNav,idsA53T)));...
    std(avgStdCrabSpeed(intersect(idsFreeNav,idsTH))),std(avgStdCrabSpeed(intersect(idsFreeNav,idsG2019S))),std(avgStdCrabSpeed(intersect(idsFreeNav,idsA53T)))];

tabCrabSpeed = array2table(crabSpeedGrouped,'VariableNames',{'control','G2019S','A53T'},'RowNames',{'meanAvgMean_EA','stdAvgMean_EA','meanAvgStd_EA','stdAvgStd_EA','meanAvgMean_freeNav','stdAvgMean_freeNav','meanAvgStd_FreeNav','stdAvgStd_FreeNav'});

avgMeanCrabSpeedNormLength = avgMeanCrabSpeed./averageLarvaeLength;
avgStdCrabSpeedNormLength = avgStdCrabSpeed./averageLarvaeLength;
crabSpeedGroupedNormLength =[mean(avgMeanCrabSpeedNormLength(intersect(idsEA,idsTH))),mean(avgMeanCrabSpeedNormLength(intersect(idsEA,idsG2019S))),mean(avgMeanCrabSpeedNormLength(intersect(idsEA,idsA53T)));...
    std(avgMeanCrabSpeedNormLength(intersect(idsEA,idsTH))),std(avgMeanCrabSpeedNormLength(intersect(idsEA,idsG2019S))),std(avgMeanCrabSpeedNormLength(intersect(idsEA,idsA53T)));...
    mean(avgStdCrabSpeedNormLength(intersect(idsEA,idsTH))),mean(avgStdCrabSpeedNormLength(intersect(idsEA,idsG2019S))),mean(avgStdCrabSpeedNormLength(intersect(idsEA,idsA53T)));...
    std(avgStdCrabSpeedNormLength(intersect(idsEA,idsTH))),std(avgStdCrabSpeedNormLength(intersect(idsEA,idsG2019S))),std(avgStdCrabSpeedNormLength(intersect(idsEA,idsA53T)));...
    mean(avgMeanCrabSpeedNormLength(intersect(idsFreeNav,idsTH))),mean(avgMeanCrabSpeedNormLength(intersect(idsFreeNav,idsG2019S))),mean(avgMeanCrabSpeedNormLength(intersect(idsFreeNav,idsA53T)));...
    std(avgMeanCrabSpeedNormLength(intersect(idsFreeNav,idsTH))),std(avgMeanCrabSpeedNormLength(intersect(idsFreeNav,idsG2019S))),std(avgMeanCrabSpeedNormLength(intersect(idsFreeNav,idsA53T)));...
    mean(avgStdCrabSpeedNormLength(intersect(idsFreeNav,idsTH))),mean(avgStdCrabSpeedNormLength(intersect(idsFreeNav,idsG2019S))),mean(avgStdCrabSpeedNormLength(intersect(idsFreeNav,idsA53T)));...
    std(avgStdCrabSpeedNormLength(intersect(idsFreeNav,idsTH))),std(avgStdCrabSpeedNormLength(intersect(idsFreeNav,idsG2019S))),std(avgStdCrabSpeedNormLength(intersect(idsFreeNav,idsA53T)))];

tabCrabSpeedNormLength = array2table(crabSpeedGroupedNormLength,'VariableNames',{'control','G2019S','A53T'},'RowNames',{'meanAvgMean_EA','stdAvgMean_EA','meanAvgStd_EA','stdAvgStd_EA','meanAvgMean_freeNav','stdAvgMean_freeNav','meanAvgStd_FreeNav','stdAvgStd_FreeNav'});



%%% TABLE WITH AREA

areaGrouped =[mean(avgMeanArea(intersect(idsEA,idsTH))),mean(avgMeanArea(intersect(idsEA,idsG2019S))),mean(avgMeanArea(intersect(idsEA,idsA53T)));...
    std(avgMeanArea(intersect(idsEA,idsTH))),std(avgMeanArea(intersect(idsEA,idsG2019S))),std(avgMeanArea(intersect(idsEA,idsA53T)));...
    mean(avgStdArea(intersect(idsEA,idsTH))),mean(avgStdArea(intersect(idsEA,idsG2019S))),mean(avgStdArea(intersect(idsEA,idsA53T)));...
    std(avgStdArea(intersect(idsEA,idsTH))),std(avgStdArea(intersect(idsEA,idsG2019S))),std(avgStdArea(intersect(idsEA,idsA53T)));...
    mean(avgMeanArea(intersect(idsFreeNav,idsTH))),mean(avgMeanArea(intersect(idsFreeNav,idsG2019S))),mean(avgMeanArea(intersect(idsFreeNav,idsA53T)));...
    std(avgMeanArea(intersect(idsFreeNav,idsTH))),std(avgMeanArea(intersect(idsFreeNav,idsG2019S))),std(avgMeanArea(intersect(idsFreeNav,idsA53T)));...
    mean(avgStdArea(intersect(idsFreeNav,idsTH))),mean(avgStdArea(intersect(idsFreeNav,idsG2019S))),mean(avgStdArea(intersect(idsFreeNav,idsA53T)));...
    std(avgStdArea(intersect(idsFreeNav,idsTH))),std(avgStdArea(intersect(idsFreeNav,idsG2019S))),std(avgStdArea(intersect(idsFreeNav,idsA53T)))];

tabArea = array2table(areaGrouped,'VariableNames',{'control','G2019S','A53T'},'RowNames',{'meanAvgMean_EA','stdAvgMean_EA','meanAvgStd_EA','stdAvgStd_EA','meanAvgMean_freeNav','stdAvgMean_freeNav','meanAvgStd_FreeNav','stdAvgStd_FreeNav'});

%%% TABLE WITH CURVE
curveGrouped =[mean(avgMeanCurve(intersect(idsEA,idsTH))),mean(avgMeanCurve(intersect(idsEA,idsG2019S))),mean(avgMeanCurve(intersect(idsEA,idsA53T)));...
    std(avgMeanCurve(intersect(idsEA,idsTH))),std(avgMeanCurve(intersect(idsEA,idsG2019S))),std(avgMeanCurve(intersect(idsEA,idsA53T)));...
    mean(avgStdCurve(intersect(idsEA,idsTH))),mean(avgStdCurve(intersect(idsEA,idsG2019S))),mean(avgStdCurve(intersect(idsEA,idsA53T)));...
    std(avgStdCurve(intersect(idsEA,idsTH))),std(avgStdCurve(intersect(idsEA,idsG2019S))),std(avgStdCurve(intersect(idsEA,idsA53T)));...
    mean(avgMeanCurve(intersect(idsFreeNav,idsTH))),mean(avgMeanCurve(intersect(idsFreeNav,idsG2019S))),mean(avgMeanCurve(intersect(idsFreeNav,idsA53T)));...
    std(avgMeanCurve(intersect(idsFreeNav,idsTH))),std(avgMeanCurve(intersect(idsFreeNav,idsG2019S))),std(avgMeanCurve(intersect(idsFreeNav,idsA53T)));...
    mean(avgStdCurve(intersect(idsFreeNav,idsTH))),mean(avgStdCurve(intersect(idsFreeNav,idsG2019S))),mean(avgStdCurve(intersect(idsFreeNav,idsA53T)));...
    std(avgStdCurve(intersect(idsFreeNav,idsTH))),std(avgStdCurve(intersect(idsFreeNav,idsG2019S))),std(avgStdCurve(intersect(idsFreeNav,idsA53T)))];

tabCurve = array2table(curveGrouped,'VariableNames',{'control','G2019S','A53T'},'RowNames',{'meanAvgMean_EA','stdAvgMean_EA','meanAvgStd_EA','stdAvgStd_EA','meanAvgMean_freeNav','stdAvgMean_freeNav','meanAvgStd_FreeNav','stdAvgStd_FreeNav'});


% NAVIGATION INDEX
navIndexGrouped =[[mean(navigationIndex_Xaxis(intersect(idsEA,idsTH))),mean(navigationIndex_Xaxis(intersect(idsEA,idsG2019S))),mean(navigationIndex_Xaxis(intersect(idsEA,idsA53T)))];...
    [std(navigationIndex_Xaxis(intersect(idsEA,idsTH))),std(navigationIndex_Xaxis(intersect(idsEA,idsG2019S))),std(navigationIndex_Xaxis(intersect(idsEA,idsA53T)))];...
    [mean(navigationIndex_Yaxis(intersect(idsEA,idsTH))),mean(navigationIndex_Yaxis(intersect(idsEA,idsG2019S))),mean(navigationIndex_Yaxis(intersect(idsEA,idsA53T)))];...
    [std(navigationIndex_Yaxis(intersect(idsEA,idsTH))),std(navigationIndex_Yaxis(intersect(idsEA,idsG2019S))),std(navigationIndex_Yaxis(intersect(idsEA,idsA53T)))];...
    [mean(navigationIndex_Xaxis(intersect(idsFreeNav,idsTH))),mean(navigationIndex_Xaxis(intersect(idsFreeNav,idsG2019S))),mean(navigationIndex_Xaxis(intersect(idsFreeNav,idsA53T)))];...
    [std(navigationIndex_Xaxis(intersect(idsFreeNav,idsTH))),std(navigationIndex_Xaxis(intersect(idsFreeNav,idsG2019S))),std(navigationIndex_Xaxis(intersect(idsFreeNav,idsA53T)))];...
    [mean(navigationIndex_Yaxis(intersect(idsFreeNav,idsTH))),mean(navigationIndex_Yaxis(intersect(idsFreeNav,idsG2019S))),mean(navigationIndex_Yaxis(intersect(idsFreeNav,idsA53T)))];...
    [std(navigationIndex_Yaxis(intersect(idsFreeNav,idsTH))),std(navigationIndex_Yaxis(intersect(idsFreeNav,idsG2019S))),std(navigationIndex_Yaxis(intersect(idsFreeNav,idsA53T)))]];

tabNavigation = array2table(navIndexGrouped,'VariableNames',{'control','G2019S','A53T'},'RowNames',{'mean_X_axisOdor','std_X_axisOdor','mean_Y_axisOdor','std_Y_axisOdor','mean_X_axisFreeNav','std_X_axisFreeNav','mean_Y_axisFreeNav','std_Y_axisFreeNav'});

%%% TABLES SPEEDS / ORIENTATION
speedPerOrientationGrouped = [[mean(cat(3,avgSpeedPerOrientation{intersect(idsEA,idsTH)}),3),mean(cat(3,avgSpeedPerOrientation{intersect(idsEA,idsG2019S)}),3),mean(cat(3,avgSpeedPerOrientation{intersect(idsEA,idsA53T)}),3)];...
    [mean(cat(3,avgSpeedPerOrientation{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,avgSpeedPerOrientation{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,avgSpeedPerOrientation{intersect(idsFreeNav,idsA53T)}),3)];...
    [std(cat(3,avgSpeedPerOrientation{intersect(idsEA,idsTH)}),[],3),std(cat(3,avgSpeedPerOrientation{intersect(idsEA,idsG2019S)}),[],3),std(cat(3,avgSpeedPerOrientation{intersect(idsEA,idsA53T)}),[],3)];...
    [std(cat(3,avgSpeedPerOrientation{intersect(idsFreeNav,idsTH)}),[],3),std(cat(3,avgSpeedPerOrientation{intersect(idsFreeNav,idsG2019S)}),[],3),std(cat(3,avgSpeedPerOrientation{intersect(idsFreeNav,idsA53T)}),[],3)];...
    [mean(cat(3,stdSpeedPerOrientation{intersect(idsEA,idsTH)}),3),mean(cat(3,stdSpeedPerOrientation{intersect(idsEA,idsG2019S)}),3),mean(cat(3,stdSpeedPerOrientation{intersect(idsEA,idsA53T)}),3)];...
    [mean(cat(3,stdSpeedPerOrientation{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,stdSpeedPerOrientation{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,stdSpeedPerOrientation{intersect(idsFreeNav,idsA53T)}),3)];...
    [std(cat(3,stdSpeedPerOrientation{intersect(idsEA,idsTH)}),[],3),std(cat(3,stdSpeedPerOrientation{intersect(idsEA,idsG2019S)}),[],3),std(cat(3,stdSpeedPerOrientation{intersect(idsEA,idsA53T)}),[],3)];...
    [std(cat(3,stdSpeedPerOrientation{intersect(idsFreeNav,idsTH)}),[],3),std(cat(3,stdSpeedPerOrientation{intersect(idsFreeNav,idsG2019S)}),[],3),std(cat(3,stdSpeedPerOrientation{intersect(idsFreeNav,idsA53T)}),[],3)]];

tabSpeedOrientation =array2table(speedPerOrientationGrouped,'VariableNames',{'control_left','control_right','control_top','control_bottom','G2019S_left','G2019S_right','G2019S_top','G2019S_bottom','A53T_left','A53T_right','A53T_top','A53T_bottom'},'RowNames',{'meanAvg_EA','meanAvg_FreeNav','stdAvg_EA','stdAvg_FreeNav','meanStd_EA','meanStd_FreeNav','stdStd_EA','stdStd_FreeNav'});

speed085PerOrientationGrouped = [[mean(cat(3,avgSpeed085PerOrientation{intersect(idsEA,idsTH)}),3),mean(cat(3,avgSpeed085PerOrientation{intersect(idsEA,idsG2019S)}),3),mean(cat(3,avgSpeed085PerOrientation{intersect(idsEA,idsA53T)}),3)];...
    [mean(cat(3,avgSpeed085PerOrientation{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,avgSpeed085PerOrientation{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,avgSpeed085PerOrientation{intersect(idsFreeNav,idsA53T)}),3)];...
    [std(cat(3,avgSpeed085PerOrientation{intersect(idsEA,idsTH)}),[],3),std(cat(3,avgSpeed085PerOrientation{intersect(idsEA,idsG2019S)}),[],3),std(cat(3,avgSpeed085PerOrientation{intersect(idsEA,idsA53T)}),[],3)];...
    [std(cat(3,avgSpeed085PerOrientation{intersect(idsFreeNav,idsTH)}),[],3),std(cat(3,avgSpeed085PerOrientation{intersect(idsFreeNav,idsG2019S)}),[],3),std(cat(3,avgSpeed085PerOrientation{intersect(idsFreeNav,idsA53T)}),[],3)];...
    [mean(cat(3,stdSpeed085PerOrientation{intersect(idsEA,idsTH)}),3),mean(cat(3,stdSpeed085PerOrientation{intersect(idsEA,idsG2019S)}),3),mean(cat(3,stdSpeed085PerOrientation{intersect(idsEA,idsA53T)}),3)];...
    [mean(cat(3,stdSpeed085PerOrientation{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,stdSpeed085PerOrientation{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,stdSpeed085PerOrientation{intersect(idsFreeNav,idsA53T)}),3)];...
    [std(cat(3,stdSpeed085PerOrientation{intersect(idsEA,idsTH)}),[],3),std(cat(3,stdSpeed085PerOrientation{intersect(idsEA,idsG2019S)}),[],3),std(cat(3,stdSpeed085PerOrientation{intersect(idsEA,idsA53T)}),[],3)];...
    [std(cat(3,stdSpeed085PerOrientation{intersect(idsFreeNav,idsTH)}),[],3),std(cat(3,stdSpeed085PerOrientation{intersect(idsFreeNav,idsG2019S)}),[],3),std(cat(3,stdSpeed085PerOrientation{intersect(idsFreeNav,idsA53T)}),[],3)]];

tabSpeed085Orientation =array2table(speed085PerOrientationGrouped,'VariableNames',{'control_left','control_right','control_top','control_bottom','G2019S_left','G2019S_right','G2019S_top','G2019S_bottom','A53T_left','A53T_right','A53T_top','A53T_bottom'},'RowNames',{'meanAvg_EA','meanAvg_FreeNav','stdAvg_EA','stdAvg_FreeNav','meanStd_EA','meanStd_FreeNav','stdStd_EA','stdStd_FreeNav'});


angularSpeedPerOrientationGrouped = [[mean(cat(3,avgAngularSpeedPerOrientation{intersect(idsEA,idsTH)}),3),mean(cat(3,avgAngularSpeedPerOrientation{intersect(idsEA,idsG2019S)}),3),mean(cat(3,avgAngularSpeedPerOrientation{intersect(idsEA,idsA53T)}),3)];...
    [mean(cat(3,avgAngularSpeedPerOrientation{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,avgAngularSpeedPerOrientation{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,avgAngularSpeedPerOrientation{intersect(idsFreeNav,idsA53T)}),3)];...
    [std(cat(3,avgAngularSpeedPerOrientation{intersect(idsEA,idsTH)}),[],3),std(cat(3,avgAngularSpeedPerOrientation{intersect(idsEA,idsG2019S)}),[],3),std(cat(3,avgAngularSpeedPerOrientation{intersect(idsEA,idsA53T)}),[],3)];...
    [std(cat(3,avgAngularSpeedPerOrientation{intersect(idsFreeNav,idsTH)}),[],3),std(cat(3,avgAngularSpeedPerOrientation{intersect(idsFreeNav,idsG2019S)}),[],3),std(cat(3,avgAngularSpeedPerOrientation{intersect(idsFreeNav,idsA53T)}),[],3)];...
    [mean(cat(3,stdAngularSpeedPerOrientation{intersect(idsEA,idsTH)}),3),mean(cat(3,stdAngularSpeedPerOrientation{intersect(idsEA,idsG2019S)}),3),mean(cat(3,stdAngularSpeedPerOrientation{intersect(idsEA,idsA53T)}),3)];...
    [mean(cat(3,stdAngularSpeedPerOrientation{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,stdAngularSpeedPerOrientation{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,stdAngularSpeedPerOrientation{intersect(idsFreeNav,idsA53T)}),3)];...
    [std(cat(3,stdAngularSpeedPerOrientation{intersect(idsEA,idsTH)}),[],3),std(cat(3,stdAngularSpeedPerOrientation{intersect(idsEA,idsG2019S)}),[],3),std(cat(3,stdAngularSpeedPerOrientation{intersect(idsEA,idsA53T)}),[],3)];...
    [std(cat(3,stdAngularSpeedPerOrientation{intersect(idsFreeNav,idsTH)}),[],3),std(cat(3,stdAngularSpeedPerOrientation{intersect(idsFreeNav,idsG2019S)}),[],3),std(cat(3,stdAngularSpeedPerOrientation{intersect(idsFreeNav,idsA53T)}),[],3)]];

tabAngularSpeedOrientation =array2table(angularSpeedPerOrientationGrouped,'VariableNames',{'control_left','control_right','control_top','control_bottom','G2019S_left','G2019S_right','G2019S_top','G2019S_bottom','A53T_left','A53T_right','A53T_top','A53T_bottom'},'RowNames',{'meanAvg_EA','meanAvg_FreeNav','stdAvg_EA','stdAvg_FreeNav','meanStd_EA','meanStd_FreeNav','stdStd_EA','stdStd_FreeNav'});


crabSpeedPerOrientationGrouped = [[mean(cat(3,avgCrabSpeedPerOrientation{intersect(idsEA,idsTH)}),3),mean(cat(3,avgCrabSpeedPerOrientation{intersect(idsEA,idsG2019S)}),3),mean(cat(3,avgCrabSpeedPerOrientation{intersect(idsEA,idsA53T)}),3)];...
    [mean(cat(3,avgCrabSpeedPerOrientation{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,avgCrabSpeedPerOrientation{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,avgCrabSpeedPerOrientation{intersect(idsFreeNav,idsA53T)}),3)];...
    [std(cat(3,avgCrabSpeedPerOrientation{intersect(idsEA,idsTH)}),[],3),std(cat(3,avgCrabSpeedPerOrientation{intersect(idsEA,idsG2019S)}),[],3),std(cat(3,avgCrabSpeedPerOrientation{intersect(idsEA,idsA53T)}),[],3)];...
    [std(cat(3,avgCrabSpeedPerOrientation{intersect(idsFreeNav,idsTH)}),[],3),std(cat(3,avgCrabSpeedPerOrientation{intersect(idsFreeNav,idsG2019S)}),[],3),std(cat(3,avgCrabSpeedPerOrientation{intersect(idsFreeNav,idsA53T)}),[],3)];...
    [mean(cat(3,stdCrabSpeedPerOrientation{intersect(idsEA,idsTH)}),3),mean(cat(3,stdCrabSpeedPerOrientation{intersect(idsEA,idsG2019S)}),3),mean(cat(3,stdCrabSpeedPerOrientation{intersect(idsEA,idsA53T)}),3)];...
    [mean(cat(3,stdCrabSpeedPerOrientation{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,stdCrabSpeedPerOrientation{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,stdCrabSpeedPerOrientation{intersect(idsFreeNav,idsA53T)}),3)];...
    [std(cat(3,stdCrabSpeedPerOrientation{intersect(idsEA,idsTH)}),[],3),std(cat(3,stdCrabSpeedPerOrientation{intersect(idsEA,idsG2019S)}),[],3),std(cat(3,stdCrabSpeedPerOrientation{intersect(idsEA,idsA53T)}),[],3)];...
    [std(cat(3,stdCrabSpeedPerOrientation{intersect(idsFreeNav,idsTH)}),[],3),std(cat(3,stdCrabSpeedPerOrientation{intersect(idsFreeNav,idsG2019S)}),[],3),std(cat(3,stdCrabSpeedPerOrientation{intersect(idsFreeNav,idsA53T)}),[],3)]];

tabCrabSpeedOrientation =array2table(crabSpeedPerOrientationGrouped,'VariableNames',{'control_left','control_right','control_top','control_bottom','G2019S_left','G2019S_right','G2019S_top','G2019S_bottom','A53T_left','A53T_right','A53T_top','A53T_bottom'},'RowNames',{'meanAvg_EA','meanAvg_FreeNav','stdAvg_EA','stdAvg_FreeNav','meanStd_EA','meanStd_FreeNav','stdStd_EA','stdStd_FreeNav'});


curvePerOrientationGrouped = [[mean(cat(3,avgCurvePerOrientation{intersect(idsEA,idsTH)}),3),mean(cat(3,avgCurvePerOrientation{intersect(idsEA,idsG2019S)}),3),mean(cat(3,avgCurvePerOrientation{intersect(idsEA,idsA53T)}),3)];...
    [mean(cat(3,avgCurvePerOrientation{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,avgCurvePerOrientation{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,avgCurvePerOrientation{intersect(idsFreeNav,idsA53T)}),3)];...
    [std(cat(3,avgCurvePerOrientation{intersect(idsEA,idsTH)}),[],3),std(cat(3,avgCurvePerOrientation{intersect(idsEA,idsG2019S)}),[],3),std(cat(3,avgCurvePerOrientation{intersect(idsEA,idsA53T)}),[],3)];...
    [std(cat(3,avgCurvePerOrientation{intersect(idsFreeNav,idsTH)}),[],3),std(cat(3,avgCurvePerOrientation{intersect(idsFreeNav,idsG2019S)}),[],3),std(cat(3,avgCurvePerOrientation{intersect(idsFreeNav,idsA53T)}),[],3)];...
    [mean(cat(3,stdCurvePerOrientation{intersect(idsEA,idsTH)}),3),mean(cat(3,stdCurvePerOrientation{intersect(idsEA,idsG2019S)}),3),mean(cat(3,stdCurvePerOrientation{intersect(idsEA,idsA53T)}),3)];...
    [mean(cat(3,stdCurvePerOrientation{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,stdCurvePerOrientation{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,stdCurvePerOrientation{intersect(idsFreeNav,idsA53T)}),3)];...
    [std(cat(3,stdCurvePerOrientation{intersect(idsEA,idsTH)}),[],3),std(cat(3,stdCurvePerOrientation{intersect(idsEA,idsG2019S)}),[],3),std(cat(3,stdCurvePerOrientation{intersect(idsEA,idsA53T)}),[],3)];...
    [std(cat(3,stdCurvePerOrientation{intersect(idsFreeNav,idsTH)}),[],3),std(cat(3,stdCurvePerOrientation{intersect(idsFreeNav,idsG2019S)}),[],3),std(cat(3,stdCurvePerOrientation{intersect(idsFreeNav,idsA53T)}),[],3)]];

tabCurveOrientation =array2table(curvePerOrientationGrouped,'VariableNames',{'control_left','control_right','control_top','control_bottom','G2019S_left','G2019S_right','G2019S_top','G2019S_bottom','A53T_left','A53T_right','A53T_top','A53T_bottom'},'RowNames',{'meanAvg_EA','meanAvg_FreeNav','stdAvg_EA','stdAvg_FreeNav','meanStd_EA','meanStd_FreeNav','stdStd_EA','stdStd_FreeNav'});

%% Orientation prior and after casting (or casting+turning)
orientationPriorAfterCastingGrouped = [[mean(cat(3,propOrientationPriorCasting{intersect(idsEA,idsTH)}),3),mean(cat(3,propOrientationPriorCasting{intersect(idsEA,idsG2019S)}),3),mean(cat(3,propOrientationPriorCasting{intersect(idsEA,idsA53T)}),3)];...
[mean(cat(3,propOrientationPriorCasting{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,propOrientationPriorCasting{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,propOrientationPriorCasting{intersect(idsFreeNav,idsA53T)}),3)];...
[std(cat(3,propOrientationPriorCasting{intersect(idsEA,idsTH)}),[],3),std(cat(3,propOrientationPriorCasting{intersect(idsEA,idsG2019S)}),[],3),std(cat(3,propOrientationPriorCasting{intersect(idsEA,idsA53T)}),[],3)];...
[std(cat(3,propOrientationPriorCasting{intersect(idsFreeNav,idsTH)}),[],3),std(cat(3,propOrientationPriorCasting{intersect(idsFreeNav,idsG2019S)}),[],3),std(cat(3,propOrientationPriorCasting{intersect(idsFreeNav,idsA53T)}),[],3)];...
[mean(cat(3,propOrientationAfterCasting{intersect(idsEA,idsTH)}),3),mean(cat(3,propOrientationAfterCasting{intersect(idsEA,idsG2019S)}),3),mean(cat(3,propOrientationAfterCasting{intersect(idsEA,idsA53T)}),3)];...
[mean(cat(3,propOrientationAfterCasting{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,propOrientationAfterCasting{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,propOrientationAfterCasting{intersect(idsFreeNav,idsA53T)}),3)];...
[std(cat(3,propOrientationAfterCasting{intersect(idsEA,idsTH)}),[],3),std(cat(3,propOrientationAfterCasting{intersect(idsEA,idsG2019S)}),[],3),std(cat(3,propOrientationAfterCasting{intersect(idsEA,idsA53T)}),[],3)];...
[std(cat(3,propOrientationAfterCasting{intersect(idsFreeNav,idsTH)}),[],3),std(cat(3,propOrientationAfterCasting{intersect(idsFreeNav,idsG2019S)}),[],3),std(cat(3,propOrientationAfterCasting{intersect(idsFreeNav,idsA53T)}),[],3)]];

tabOrientationLarvPriorAfterCasting =array2table(orientationPriorAfterCastingGrouped,'VariableNames',{'control_left','control_right','control_top','control_bottom','G2019S_left','G2019S_right','G2019S_top','G2019S_bottom','A53T_left','A53T_right','A53T_top','A53T_bottom'},'RowNames',{'priorCastingMean_EA','priorCastingMean_FreeNav','priorCastingStd_EA','priorCastingStd_FreeNav','afterCastingMean_EA','afterCastingMean_FreeNav','afterCastingStd_EA','afterCastingStd_FreeNav'});


orientationPriorAfterCastingTurningGrouped = [[mean(cat(3,propOrientationPriorCastingOrTurning{intersect(idsEA,idsTH)}),3),mean(cat(3,propOrientationPriorCastingOrTurning{intersect(idsEA,idsG2019S)}),3),mean(cat(3,propOrientationPriorCastingOrTurning{intersect(idsEA,idsA53T)}),3)];...
[mean(cat(3,propOrientationPriorCastingOrTurning{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,propOrientationPriorCastingOrTurning{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,propOrientationPriorCastingOrTurning{intersect(idsFreeNav,idsA53T)}),3)];...
[std(cat(3,propOrientationPriorCastingOrTurning{intersect(idsEA,idsTH)}),[],3),std(cat(3,propOrientationPriorCastingOrTurning{intersect(idsEA,idsG2019S)}),[],3),std(cat(3,propOrientationPriorCastingOrTurning{intersect(idsEA,idsA53T)}),[],3)];...
[std(cat(3,propOrientationPriorCastingOrTurning{intersect(idsFreeNav,idsTH)}),[],3),std(cat(3,propOrientationPriorCastingOrTurning{intersect(idsFreeNav,idsG2019S)}),[],3),std(cat(3,propOrientationPriorCastingOrTurning{intersect(idsFreeNav,idsA53T)}),[],3)];...
[mean(cat(3,propOrientationAfterCastingOrTurning{intersect(idsEA,idsTH)}),3),mean(cat(3,propOrientationAfterCastingOrTurning{intersect(idsEA,idsG2019S)}),3),mean(cat(3,propOrientationAfterCastingOrTurning{intersect(idsEA,idsA53T)}),3)];...
[mean(cat(3,propOrientationAfterCastingOrTurning{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,propOrientationAfterCastingOrTurning{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,propOrientationAfterCastingOrTurning{intersect(idsFreeNav,idsA53T)}),3)];...
[std(cat(3,propOrientationAfterCastingOrTurning{intersect(idsEA,idsTH)}),[],3),std(cat(3,propOrientationAfterCastingOrTurning{intersect(idsEA,idsG2019S)}),[],3),std(cat(3,propOrientationAfterCastingOrTurning{intersect(idsEA,idsA53T)}),[],3)];...
[std(cat(3,propOrientationAfterCastingOrTurning{intersect(idsFreeNav,idsTH)}),[],3),std(cat(3,propOrientationAfterCastingOrTurning{intersect(idsFreeNav,idsG2019S)}),[],3),std(cat(3,propOrientationAfterCastingOrTurning{intersect(idsFreeNav,idsA53T)}),[],3)]];

tabOrientationPriorAfterCastingOrTurning=array2table(orientationPriorAfterCastingTurningGrouped,'VariableNames',{'control_left','control_right','control_top','control_bottom','G2019S_left','G2019S_right','G2019S_top','G2019S_bottom','A53T_left','A53T_right','A53T_top','A53T_bottom'},'RowNames',{'priorCastingMean_EA','priorCastingMean_FreeNav','priorCastingStd_EA','priorCastingStd_FreeNav','afterCastingMean_EA','afterCastingMean_FreeNav','afterCastingStd_EA','afterCastingStd_FreeNav'});

%% PLOT area / time

coloursEA = [0 0 1; 1 0.5 0;0 1 0];
coloursFreeN = [0.2 0 1; 1 0.8 0;0 1 0.2];
LineStyleEA='-';
LineStyleFreeN=':';
T=0:600;
fontSizeFigure = 18;
fontNameFigure = 'Arial';

h1 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
paintError=1;
subplot(1,2,1);hold on
plotSpeedVersusT(T,avgAreaRoundT,semAreaRoundT,idsEA,idsTH,idsG2019S,idsA53T,LineStyleEA,coloursEA,paintError)
legend({'','','','Control EA','G2019S EA','A53T EA'})
xlabel('Time (s)')
ylabel('Area');
ylim([0 2])
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);


subplot(1,2,2);
plotSpeedVersusT(T,avgAreaRoundT,semAreaRoundT,idsFreeNav,idsTH,idsG2019S,idsA53T,LineStyleFreeN,coloursFreeN,paintError)
legend({'','','','Control FreeNav','G2019S FreeNav','A53T FreeNav'})
xlabel('Time (s)')
ylabel('Area');
ylim([0 2])
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);



%% PLOT speed / time
h2 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
paintError=1;
subplot(1,2,1);hold on
plotSpeedVersusT(T,avgSpeedRoundT,semSpeedRoundT,idsEA,idsTH,idsG2019S,idsA53T,LineStyleEA,coloursEA,paintError)
legend({'','','','Control EA','G2019S EA','A53T EA'})
xlabel('Time (s)')
ylabel('Speed (mm/s)');
ylim([0.1 0.4])
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);

subplot(1,2,2);
plotSpeedVersusT(T,avgSpeedRoundT,semSpeedRoundT,idsFreeNav,idsTH,idsG2019S,idsA53T,LineStyleFreeN,coloursFreeN,paintError)
legend({'','','','Control FreeNav','G2019S FreeNav','A53T FreeNav'})
xlabel('Time (s)')
ylabel('Speed (mm/s)');
ylim([0.1 0.4])
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);

%% PLOT speed 085 / time
h3=figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
paintError=1;
subplot(1,2,1);hold on
plotSpeedVersusT(T,avgSpeed085RoundT,semSpeed085RoundT,idsEA,idsTH,idsG2019S,idsA53T,LineStyleEA,coloursEA,paintError)
legend({'','','','Control EA','G2019S EA','A53T EA'})
xlabel('Time (s)')
ylabel('Speed085 (mm/s)');
ylim([0.1 0.4])
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);

subplot(1,2,2);
plotSpeedVersusT(T,avgSpeed085RoundT,semSpeed085RoundT,idsFreeNav,idsTH,idsG2019S,idsA53T,LineStyleFreeN,coloursFreeN,paintError)
legend({'','','','Control FreeNav','G2019S FreeNav','A53T FreeNav'})
xlabel('Time (s)')
ylabel('Speed085 (mm/s)');
ylim([0.1 0.4])
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);

%% PLOT crabspeed / time
h4 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
paintError=1;
subplot(1,2,1);hold on
plotSpeedVersusT(T,avgCrabSpeedRoundT,semCrabSpeedRoundT,idsEA,idsTH,idsG2019S,idsA53T,LineStyleEA,coloursEA,paintError)
legend({'','','','Control EA','G2019S EA','A53T EA'})
xlabel('Time (s)')
ylabel('Crab speed (mm/s)');
ylim([0 0.2])
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);

subplot(1,2,2);
plotSpeedVersusT(T,avgCrabSpeedRoundT,semCrabSpeedRoundT,idsFreeNav,idsTH,idsG2019S,idsA53T,LineStyleFreeN,coloursFreeN,paintError)
legend({'','','','Control FreeNav','G2019S FreeNav','A53T FreeNav'})
xlabel('Time (s)')
ylabel('Crab speed (mm/s)');
ylim([0 0.2])
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);

%% PLOT angular speed / time
h5 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
paintError = 0;
subplot(1,2,1);hold on
plotSpeedVersusT(T,meanAngularSpeedPerT,semAngularSpeedPerT,idsEA,idsTH,idsG2019S,idsA53T,LineStyleEA,coloursEA,paintError)
ylim([0,20])
legend({'Control EA','G2019S EA','A53T EA'})
xlabel('Time (s)')
ylabel('Angular speed (degrees/s)');
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);

% legend({'','Control EA','','G2019S EA','','A53T EA'});
% xlabel('Time (s)')
% ylabel('Angular speed (degrees/s)');
% figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
subplot(1,2,2)
plotSpeedVersusT(T,meanAngularSpeedPerT,semAngularSpeedPerT,idsFreeNav,idsTH,idsG2019S,idsA53T,LineStyleFreeN,coloursFreeN,paintError)
% legend({'Control Free','','G2019S Free','','A53T Free'})

legend({'Control FreeNav','G2019S FreeNav','A53T FreeNav'})
xlabel('Time (s)')
ylabel('Angular speed (degrees/s)');
ylim([0,20])
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);

%% PLOT speed (normalized by larvae length) / time
h6_1 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
paintError=1;
% avgSpeedRoundTNormByArea = cellfun(@(x,y) x./y,avgSpeedRoundT,avgAreaRoundT,'UniformOutput',false);
% semSpeedRoundTNormByArea = cellfun(@(x,y) x./y,semSpeedRoundT,avgAreaRoundT,'UniformOutput',false);
avgSpeedRoundTNormByLength = cellfun(@(x,y) x./y,avgSpeedRoundT,num2cell(averageLarvaeLength),'UniformOutput',false);
semSpeedRoundTNormByLength = cellfun(@(x,y) x./y,semSpeedRoundT,num2cell(averageLarvaeLength),'UniformOutput',false);

subplot(1,2,1);hold on
plotSpeedVersusT(T,avgSpeedRoundTNormByLength,semSpeedRoundTNormByLength,idsEA,idsTH,idsG2019S,idsA53T,LineStyleEA,coloursEA,paintError)
legend({'','','','Control EA','G2019S EA','A53T EA'})
xlabel('Time (s)')
ylabel('Speed / larva length (1/s)');
ylim([0 0.3])
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);

subplot(1,2,2);
plotSpeedVersusT(T,avgSpeedRoundTNormByLength,semSpeedRoundTNormByLength,idsFreeNav,idsTH,idsG2019S,idsA53T,LineStyleFreeN,coloursFreeN,paintError)
legend({'','','','Control FreeNav','G2019S FreeNav','A53T FreeNav'})
xlabel('Time (s)')
ylabel('Speed / larva length (1/s)');
ylim([0 0.3])
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);

%% PLOT speed 085 (normalized by larvae length) / time
h6_2 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
paintError=1;
% avgSpeed085RoundTNormByArea = cellfun(@(x,y) x./y,avgSpeed085RoundT,avgAreaRoundT,'UniformOutput',false);
% semSpeed085RoundTNormByArea = cellfun(@(x,y) x./y,semSpeed085RoundT,avgAreaRoundT,'UniformOutput',false);
avgSpeed085RoundTNormByLength = cellfun(@(x,y) x./y,avgSpeed085RoundT,num2cell(averageLarvaeLength),'UniformOutput',false);
semSpeed085RoundTNormByLength = cellfun(@(x,y) x./y,semSpeed085RoundT,num2cell(averageLarvaeLength),'UniformOutput',false);

subplot(1,2,1);hold on
plotSpeedVersusT(T,avgSpeed085RoundTNormByLength,semSpeed085RoundTNormByLength,idsEA,idsTH,idsG2019S,idsA53T,LineStyleEA,coloursEA,paintError)
legend({'','','','Control EA','G2019S EA','A53T EA'})
xlabel('Time (s)')
ylabel('Speed085 / larva length (1/s)');
ylim([0 0.3])
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);

subplot(1,2,2);
plotSpeedVersusT(T,avgSpeed085RoundTNormByLength,semSpeed085RoundTNormByLength,idsFreeNav,idsTH,idsG2019S,idsA53T,LineStyleFreeN,coloursFreeN,paintError)
legend({'','','','Control FreeNav','G2019S FreeNav','A53T FreeNav'})
xlabel('Time (s)')
ylabel('Speed085 / larva length (1/s)');
ylim([0 0.3])
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);


%% PLOT curve / time
h7 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
paintError = 0;
subplot(1,2,1);hold on
plotSpeedVersusT(T,avgCurveRoundT,semCurveRoundT,idsEA,idsTH,idsG2019S,idsA53T,LineStyleEA,coloursEA,paintError)
ylim([0,20])
legend({'Control EA','G2019S EA','A53T EA'})
xlabel('Time (s)')
ylabel('Curve head-tail (degrees)');
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);

subplot(1,2,2)
plotSpeedVersusT(T,avgCurveRoundT,semCurveRoundT,idsFreeNav,idsTH,idsG2019S,idsA53T,LineStyleFreeN,coloursFreeN,paintError)

legend({'Control FreeNav','G2019S FreeNav','A53T FreeNav'})
xlabel('Time (s)')
ylabel('Curve head-tail (degress)');
ylim([0,20])
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);

%% Plot run, stop, turn & casting / time
%larvae running
h8 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
subplot(1,2,1);hold on
plotSpeedVersusT(T,proportionLarvaeRunPerT,[],idsEA,idsTH,idsG2019S,idsA53T,LineStyleEA,coloursEA,'calculateError')
legend({'','','','Control EA','G2019S EA','A53T EA'})
xlabel('Time (s)')
ylabel('Proportion of larvae running');
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);
ylim([0 1])

subplot(1,2,2)
plotSpeedVersusT(T,proportionLarvaeRunPerT,[],idsFreeNav,idsTH,idsG2019S,idsA53T,LineStyleFreeN,coloursFreeN,'calculateError')
legend({'','','','Control FreeNav','G2019S FreeNav','A53T FreeNav'})
xlabel('Time (s)')
ylabel('Proportion of larvae running');
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);
ylim([0 1])


%%larvae stopping
paintError=0;
h9 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
subplot(1,2,1);hold on
plotSpeedVersusT(T,proportionLarvaeStopPerT,[],idsEA,idsTH,idsG2019S,idsA53T,LineStyleEA,coloursEA,'calculateError')
legend({'','','','Control EA','G2019S EA','A53T EA'})
xlabel('Time (s)')
ylabel('Proportion of larvae stopping');
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);
ylim([0 1])

subplot(1,2,2)
plotSpeedVersusT(T,proportionLarvaeStopPerT,[],idsFreeNav,idsTH,idsG2019S,idsA53T,LineStyleFreeN,coloursFreeN,'calculateError')
legend({'','','','Control FreeNav','G2019S FreeNav','A53T FreeNav'})
xlabel('Time (s)')
ylabel('Proportion of larvae stopping');
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);
ylim([0 1])

%%larvae turning
paintError=0;
h10 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
subplot(1,2,1);hold on
plotSpeedVersusT(T,proportionLarvaeTurnPerT,[],idsEA,idsTH,idsG2019S,idsA53T,LineStyleEA,coloursEA,'calculateError')
legend({'','','','Control EA','G2019S EA','A53T EA'})
xlabel('Time (s)')
ylabel('Proportion of larvae turning');
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);
ylim([0 1])

subplot(1,2,2)
plotSpeedVersusT(T,proportionLarvaeTurnPerT,[],idsFreeNav,idsTH,idsG2019S,idsA53T,LineStyleFreeN,coloursFreeN,'calculateError')
legend({'','','','Control FreeNav','G2019S FreeNav','A53T FreeNav'})
xlabel('Time (s)')
ylabel('Proportion of larvae turning');
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);
ylim([0 1])

%%larvae casting
paintError=0;
h11 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
subplot(1,2,1);hold on
plotSpeedVersusT(T,proportionLarvaeCastingPerT,[],idsEA,idsTH,idsG2019S,idsA53T,LineStyleEA,coloursEA,'calculateError')
legend({'','','','Control EA','G2019S EA','A53T EA'})
xlabel('Time (s)')
ylabel('Proportion of larvae casting');
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);
ylim([0 1])

subplot(1,2,2)
plotSpeedVersusT(T,proportionLarvaeCastingPerT,[],idsFreeNav,idsTH,idsG2019S,idsA53T,LineStyleFreeN,coloursFreeN,'calculateError')
legend({'','','','Control FreeNav','G2019S FreeNav','A53T FreeNav'})
xlabel('Time (s)')
ylabel('Proportion of larvae casting');
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);
ylim([0 1])

%%larvae turning or casting
paintError=0;
h12 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
subplot(1,2,1);hold on
plotSpeedVersusT(T,cellfun(@(x,y) x+y, proportionLarvaeTurnPerT,proportionLarvaeCastingPerT,'UniformOutput',false),[],idsEA,idsTH,idsG2019S,idsA53T,LineStyleEA,coloursEA,'calculateError')
legend({'','','','Control EA','G2019S EA','A53T EA'})
xlabel('Time (s)')
ylabel('Proportion of larvae turning or casting');
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);
ylim([0 1])

subplot(1,2,2)
plotSpeedVersusT(T,cellfun(@(x,y) x+y, proportionLarvaeTurnPerT,proportionLarvaeCastingPerT,'UniformOutput',false),[],idsFreeNav,idsTH,idsG2019S,idsA53T,LineStyleFreeN,coloursFreeN,'calculateError')
legend({'','','','Control FreeNav','G2019S FreeNav','A53T FreeNav'})
xlabel('Time (s)')
ylabel('Proportion of larvae turning or casting');
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);
ylim([0 1])

%% PLOT bins distribution init & end
x=[0.73 0.91 1.095 1.275; 1.73 1.91 2.095 2.275; 2.73 2.91 3.095 3.275];

bins_MeanDist_control_EA = mean(cat(3,binsXdistributionInitEnd{intersect(idsEA,idsTH)}),3);
bins_MeanDist_G2019S_EA = mean(cat(3,binsXdistributionInitEnd{intersect(idsEA,idsG2019S)}),3);
bins_MeanDist_A53T_EA = mean(cat(3,binsXdistributionInitEnd{intersect(idsEA,idsA53T)}),3);

bins_stdDist_control_EA = std(cat(3,binsXdistributionInitEnd{intersect(idsEA,idsTH)}),[],3)/(sqrt(numel(intersect(idsEA,idsTH))));
bins_stdDist_G2019S_EA = std(cat(3,binsXdistributionInitEnd{intersect(idsEA,idsG2019S)}),[],3)/(sqrt(numel(intersect(idsEA,idsG2019S))));
bins_stdDist_A53T_EA = std(cat(3,binsXdistributionInitEnd{intersect(idsEA,idsA53T)}),[],3)/(sqrt(numel(intersect(idsEA,idsA53T))));

h13 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');

subplot(2,3,1);
bar (bins_MeanDist_control_EA)

hold on
er = errorbar(x(:),bins_MeanDist_control_EA(:),bins_stdDist_control_EA(:),bins_stdDist_control_EA(:));    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  

ylabel('larvae proportion')
xlabel('left     center     right')
title('Control EA')
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);


subplot(2,3,2);
bar (bins_MeanDist_G2019S_EA)
hold on
er = errorbar(x(:),bins_MeanDist_G2019S_EA(:),bins_stdDist_G2019S_EA(:),bins_stdDist_G2019S_EA(:));    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
lng = legend({'10 s','200 s', '400 s', '590 s'});
lgd.Layout.Tile = 'east';

ylabel('larvae proportion')
xlabel('left     center     right')
title('G2019 EA')
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);

subplot(2,3,3);
bar (bins_MeanDist_A53T_EA)
hold on
er = errorbar(x(:),bins_MeanDist_A53T_EA(:),bins_stdDist_A53T_EA(:),bins_stdDist_A53T_EA(:));    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  

ylabel('larvae proportion')
xlabel('left     center     right')
title('A53T EA')
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);


bins_MeanDist_control_FreeNav = mean(cat(3,binsXdistributionInitEnd{intersect(idsFreeNav,idsTH)}),3);
bins_MeanDist_G2019S_FreeNav = mean(cat(3,binsXdistributionInitEnd{intersect(idsFreeNav,idsG2019S)}),3);
bins_MeanDist_A53T_FreeNav = mean(cat(3,binsXdistributionInitEnd{intersect(idsFreeNav,idsA53T)}),3);

bins_stdDist_control_FreeNav = std(cat(3,binsXdistributionInitEnd{intersect(idsFreeNav,idsTH)}),[],3)/(sqrt(numel(intersect(idsFreeNav,idsTH))));
bins_stdDist_G2019S_FreeNav = std(cat(3,binsXdistributionInitEnd{intersect(idsFreeNav,idsG2019S)}),[],3)/(sqrt(numel(intersect(idsFreeNav,idsG2019S))));
bins_stdDist_A53T_FreeNav = std(cat(3,binsXdistributionInitEnd{intersect(idsFreeNav,idsA53T)}),[],3)/(sqrt(numel(intersect(idsFreeNav,idsA53T))));

subplot(2,3,4);
bar (bins_MeanDist_control_FreeNav) 
hold on
er = errorbar(x(:),bins_MeanDist_control_FreeNav(:),bins_stdDist_control_FreeNav(:),bins_stdDist_control_FreeNav(:));    
er.Color = [0 0 0];   
er.LineStyle = 'none';

title('Control Free Navig')
ylabel('larvae proportion')
xlabel('left     center     right')
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);

subplot(2,3,5);
bar (bins_MeanDist_G2019S_FreeNav)
hold on
er = errorbar(x(:),bins_MeanDist_G2019S_FreeNav(:),bins_stdDist_G2019S_FreeNav(:),bins_stdDist_G2019S_FreeNav(:));    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
ylabel('larvae proportion')
xlabel('left     center     right')
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);

title('G2019 Free Navig')
subplot(2,3,6);
bar (bins_MeanDist_A53T_FreeNav)
hold on
er = errorbar(x(:),bins_MeanDist_A53T_FreeNav(:),bins_stdDist_A53T_FreeNav(:),bins_stdDist_A53T_FreeNav(:));    
er.Color = [0 0 0];                            
er.LineStyle = 'none';

ylabel('larvae proportion')
xlabel('left     center     right')
title('A53T Free Navig')
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);

%% Histograms of speed 085 individual larvae in free locomotion
% h10 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
% tabContFreeNav = cat(1,tableSummaryFeatures{intersect(idsFreeNav,idsTH)});
% tabG2019SFreeNav = cat(1,tableSummaryFeatures{intersect(idsFreeNav,idsG2019S)});
% tabA53TFreeNav = cat(1,tableSummaryFeatures{intersect(idsFreeNav,idsA53T)});
% 
% rangeData = 0:0.05:1;
% [binsTabCont] = histc(tabContFreeNav.perc80Speed,rangeData);
% [binsTabG2019S] = histc(tabG2019SFreeNav.perc80Speed,rangeData);
% [binsTabA53T] = histc(tabA53TFreeNav.perc80Speed,rangeData);
% 
% subplot(3,1,1)
% title('Histogram percentile 80 - speed085 individual larvae')
% b=bar(rangeData,binsTabCont,'histc');
% b(1).FaceColor = [0 0 1];
% ylim([0 300])
% xlim([0.1 0.8])
% legend('Control')
% xlabel('speed (mm/s)')
% ylabel('count')
% 
% subplot(3,1,2)
% b=bar(rangeData,binsTabG2019S,'histc');
% b(1).FaceColor = [1 0.5 0];
% xlabel('speed (mm/s)')
% legend('G2019S')
% ylabel('count')
% ylim([0 300])
% xlim([0.1 0.8])
% 
% subplot(3,1,3)
% b=bar(rangeData,binsTabA53T,'histc');
% b(1).FaceColor = [0 1 0];
% xlabel('speed (mm/s)')
% legend('A53T')
% ylabel('count')
% ylim([0 300])
% xlim([0.1 0.8])

isPrintOn=1;
[filepath,nameF,ext] = fileparts(pathFolder);

folder2save = fullfile('..','Results',nameF);
if ~exist(folder2save,'dir'), mkdir(fullfile(folder2save,'Figures')); end


if isPrintOn == 1
    print(h1,fullfile(folder2save,'Figures','area_vs_T.png'),'-dpng','-r300')
    savefig(h1,fullfile(folder2save,'Figures','area_vs_T.fig'))
    print(h2,fullfile(folder2save,'Figures','speed_vs_T.png'),'-dpng','-r300')
    savefig(h2,fullfile(folder2save,'Figures','speed_vs_T.fig'))
    print(h3,fullfile(folder2save,'Figures','speed085_vs_T.png'),'-dpng','-r300')
    savefig(h3,fullfile(folder2save,'Figures','speed085_vs_T.fig'))
    print(h4,fullfile(folder2save,'Figures','crabSpeed_vs_T.png'),'-dpng','-r300')
    savefig(h4,fullfile(folder2save,'Figures','crabSpeed_vs_T.fig'))
    print(h5,fullfile(folder2save,'Figures','angularSpeed_vs_T.png'),'-dpng','-r300')
    savefig(h5,fullfile(folder2save,'Figures','angularSpeed_vs_T.fig'))
    print(h6_1,fullfile(folder2save,'Figures','speed_normLength_vs_T.png'),'-dpng','-r300')
    savefig(h6_1,fullfile(folder2save,'Figures','speed_normLength_vs_T.fig'))
    print(h6_2,fullfile(folder2save,'Figures','speed085_normLength_vs_T.png'),'-dpng','-r300')
    savefig(h6_2,fullfile(folder2save,'Figures','speed085_normLength_vs_T.fig'))
    print(h7,fullfile(folder2save,'Figures','curve_vs_T.png'),'-dpng','-r300')
    savefig(h7,fullfile(folder2save,'Figures','curve_vs_T.fig'))

    print(h8,fullfile(folder2save,'Figures','proprtionOfLarvaeRunning.png'),'-dpng','-r300')
    savefig(h8,fullfile(folder2save,'Figures','proprtionOfLarvaeRunning.fig'))
    print(h9,fullfile(folder2save,'Figures','proprtionOfLarvaeStopping.png'),'-dpng','-r300')
    savefig(h9,fullfile(folder2save,'Figures','proprtionOfLarvaeStopping.fig')) 
    print(h10,fullfile(folder2save,'Figures','proprtionOfLarvaeTurning.png'),'-dpng','-r300')
    savefig(h10,fullfile(folder2save,'Figures','proprtionOfLarvaeTurning.fig')) 
    print(h11,fullfile(folder2save,'Figures','proprtionOfLarvaeCasting.png'),'-dpng','-r300')
    savefig(h11,fullfile(folder2save,'Figures','proprtionOfLarvaeCasting.fig')) 
    print(h12,fullfile(folder2save,'Figures','proprtionOfLarvaeTurningOrCasting.png'),'-dpng','-r300')
    savefig(h12,fullfile(folder2save,'Figures','proprtionOfLarvaeTurningOrCasting.fig'))

    print(h13,fullfile(folder2save,'Figures','distributionXaxis.png'),'-dpng','-r300')
    savefig(h13,fullfile(folder2save,'Figures','distributionXaxis.fig'))


    clearvars -except folder2save tabSpeedNormLength tabSpeed085NormLength tabCrabSpeedNormLength tabOrientationLarvPriorAfterCasting tabOrientationPriorAfterCastingOrTurning tabCurveOrientation tabCrabSpeedOrientation tabSpeedOrientation tabAngularSpeedOrientation tabSpeed085Orientation tabNavigation tabMeanTransitionMatrixOrient tabMeanTransitionMatrixMov tabArea tabCurve tabSpeed tabCrabSpeed tabSpeed085 tabAngSpeed tabPercAngStates tabPercMovStates tabMovRatePerOrient

    writetable(tabNavigation,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','NavIndex','Range','B2','WriteRowNames',true)
    writetable(tabArea,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','AreaLarvae','Range','B2','WriteRowNames',true)    
    writetable(tabSpeed,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','Speed','Range','B2','WriteRowNames',true)
    writetable(tabSpeed085,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','Speed085','Range','B2','WriteRowNames',true)
    writetable(tabCrabSpeed,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','CrabSpeed','Range','B2','WriteRowNames',true)
    writetable(tabSpeedNormLength,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','SpeedNormLength','Range','B2','WriteRowNames',true)
    writetable(tabSpeed085NormLength,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','Speed085NormLength','Range','B2','WriteRowNames',true)
    writetable(tabCrabSpeedNormLength,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','CrabSpeedNormLength','Range','B2','WriteRowNames',true)
    writetable(tabAngSpeed,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','AngSpeed','Range','B2','WriteRowNames',true)
    writetable(tabCurve,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','Curve','Range','B2','WriteRowNames',true)
    writetable(tabMeanTransitionMatrixOrient,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','TransitionMatrixOrientation','Range','B2','WriteRowNames',true)
    writetable(tabMeanTransitionMatrixMov,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','TransitionMatrixMovStates','Range','B2','WriteRowNames',true)
    writetable(tabPercAngStates,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','PercAngStates','Range','B2','WriteRowNames',true)
    writetable(tabPercMovStates,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','PercMovStates','Range','B2','WriteRowNames',true)
%     writetable(tabMovRatePerOrient,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','RateMovStates','Range','B2','WriteRowNames',true)
    writetable(tabSpeedOrientation,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','SpeedPerOrientation','Range','B2','WriteRowNames',true)
    writetable(tabSpeed085Orientation,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','Speed085PerOrientation','Range','B2','WriteRowNames',true)
    writetable(tabCrabSpeedOrientation,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','CrabSpeedPerOrientation','Range','B2','WriteRowNames',true)
    writetable(tabAngularSpeedOrientation,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','AngSpeedPerOrientation','Range','B2','WriteRowNames',true)
    writetable(tabCurveOrientation,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','CurvePerOrientation','Range','B2','WriteRowNames',true)
    writetable(tabOrientationLarvPriorAfterCasting,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','OrientBefAftCast','Range','B2','WriteRowNames',true)
    writetable(tabOrientationPriorAfterCastingOrTurning,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','OrientBefAftCastTurn','Range','B2','WriteRowNames',true)

end



