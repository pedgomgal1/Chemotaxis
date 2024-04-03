
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
allVars=cell(size(totalDirectories,1),1);
tableSummaryFeatures=cell(size(totalDirectories,1),1);


for nDir=1:size(totalDirectories,1)

    try
        allVars{nDir}=extractFeaturesPerExperiment(fullfile(totalDirectories(nDir).folder,totalDirectories(nDir).name));

    catch
        disp(['error in ' fullfile(totalDirectories(nDir).folder,totalDirectories(nDir).name) ]);
    end
end

%% Group and plot data
varsEA_Control = vertcat(allVars{intersect(idsEA,idsTH)});
varsEA_A53T = vertcat(allVars{intersect(idsEA,idsA53T)});
varsEA_G2019S = vertcat(allVars{intersect(idsEA,idsG2019S)});
varsFreeNav_Control = vertcat(allVars{intersect(idsFreeNav,idsTH)});
varsFreeNav_A53T = vertcat(allVars{intersect(idsFreeNav,idsA53T)});
varsFreeNav_G2019S = vertcat(allVars{intersect(idsFreeNav,idsG2019S)});

% %%% TABLE WITH TRANSITION MATRIX (8 x 12)
transitionMatrixOrientation=arrayfun(@(x) table2array(allVars{x}.transitionMatrixOrientation), 1:size(allVars,1), 'UniformOutput', false);
matrixProbOrientation=arrayfun(@(x) table2array(allVars{x}.matrixProbOrientation), 1:size(allVars,1), 'UniformOutput', false);

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

% %hidden MK
% 
% %% Transition matrix motion. run, stop, turn and cast states
% 
% %%%%%%%%%%transition matrix 
% 
% percMovState = cellfun(@(x) sum(x)/sum(x(:)), matrixProbMotionStates, 'UniformOutput', false);
% 
% meanPercMov_control_EA = mean(cat(3,percMovState{intersect(idsEA,idsTH)}),3);
% stdPercMov_control_EA = std(cat(3,percMovState{intersect(idsEA,idsTH)}),[],3);
% meanPercMov_G2019S_EA = mean(cat(3,percMovState{intersect(idsEA,idsG2019S)}),3);
% stdPercMov_G2019S_EA = std(cat(3,percMovState{intersect(idsEA,idsG2019S)}),[],3);
% meanPercMov_A53T_EA = mean(cat(3,percMovState{intersect(idsEA,idsA53T)}),3);
% stdPercMov_A53T_EA = std(cat(3,percMovState{intersect(idsEA,idsA53T)}),[],3);
% meanPercMov_control_Free = mean(cat(3,percMovState{intersect(idsFreeNav,idsTH)}),3);
% stdPercMov_control_Free = std(cat(3,percMovState{intersect(idsFreeNav,idsTH)}),[],3);
% meanPercMov_G2019S_Free = mean(cat(3,percMovState{intersect(idsFreeNav,idsG2019S)}),3);
% stdPercMov_G2019S_Free = std(cat(3,percMovState{intersect(idsFreeNav,idsG2019S)}),[],3);
% meanPercMov_A53T_Free = mean(cat(3,percMovState{intersect(idsFreeNav,idsA53T)}),3);
% stdPercMov_A53T_Free = std(cat(3,percMovState{intersect(idsFreeNav,idsA53T)}),[],3);
% 
% tabPercMovStates = array2table([[meanPercMov_control_EA; stdPercMov_control_EA; meanPercMov_control_Free; stdPercMov_control_Free],[meanPercMov_G2019S_EA; stdPercMov_G2019S_EA;meanPercMov_G2019S_Free; stdPercMov_G2019S_Free],[meanPercMov_A53T_EA;stdPercMov_A53T_EA;meanPercMov_A53T_Free;stdPercMov_A53T_Free]],...
%     "RowNames",{'average_EA','std_EA','average_FreeNav','std_FreeNav'},'VariableNames',{'run_Control','stop_Control','turn_Control','cast_Control','run_G2019S','stop_G2019S','turn_G2019S','cast_G2019S','run_A53T','stop_A53T','turn_A53T','cast_A53T'});
% 
% 
% %%% TABLE WITH TRANSITION MATRIX (8 x 12)
% groupedMeanTransitionMatrixMov =[mean(cat(3,transitionMatrixMotionStates{intersect(idsEA,idsTH)}),3),mean(cat(3,transitionMatrixMotionStates{intersect(idsEA,idsG2019S)}),3),mean(cat(3,transitionMatrixMotionStates{intersect(idsEA,idsA53T)}),3);
%     mean(cat(3,transitionMatrixMotionStates{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,transitionMatrixMotionStates{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,transitionMatrixMotionStates{intersect(idsFreeNav,idsA53T)}),3)];
% 
% tabMeanTransitionMatrixMov=array2table(groupedMeanTransitionMatrixMov,'VariableNames',{'control_run','control_stop','control_turn','control_cast','G2019S_run','G2019S_stop','G2019S_turn','G2019S_cast','A53T_run','A53T_stop','A53T_turn','A53T_cast'},'RowNames',...
%     {'run_EA','stop_EA','turn_EA','cast_EA','run_FreeNav','stop_FreeNav','turn_FreeNav','cast_FreeNav'});
% 
% 
% % %table running states per orientation
% % groupedMovStatePerOrientation = [mean(cat(3,runRatePerOrient{intersect(idsEA,idsTH)}),3),mean(cat(3,runRatePerOrient{intersect(idsEA,idsG2019S)}),3),mean(cat(3,runRatePerOrient{intersect(idsEA,idsA53T)}),3);...
% %     mean(cat(3,stopRatePerOrient{intersect(idsEA,idsTH)}),3),mean(cat(3,stopRatePerOrient{intersect(idsEA,idsG2019S)}),3),mean(cat(3,stopRatePerOrient{intersect(idsEA,idsA53T)}),3);...
% %     mean(cat(3,turningRatePerOrient{intersect(idsEA,idsTH)}),3),mean(cat(3,turningRatePerOrient{intersect(idsEA,idsG2019S)}),3),mean(cat(3,turningRatePerOrient{intersect(idsEA,idsA53T)}),3);...
% %     mean(cat(3,runRatePerOrient{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,runRatePerOrient{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,runRatePerOrient{intersect(idsFreeNav,idsA53T)}),3);...
% %     mean(cat(3,stopRatePerOrient{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,stopRatePerOrient{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,stopRatePerOrient{intersect(idsFreeNav,idsA53T)}),3);
% %     mean(cat(3,turningRatePerOrient{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,turningRatePerOrient{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,turningRatePerOrient{intersect(idsFreeNav,idsA53T)}),3)];
% % 
% % tabMovRatePerOrient=array2table(groupedMovStatePerOrientation,'VariableNames',{'control_left','control_right','control_top','control_bottom','G2019S_left','G2019S_right','G2019S_top','G2019S_bottom','A53T_left','A53T_right','A53T_top','A53T_bottom'},'RowNames',...
% %     {'run_EA','stop_EA','turn_EA','run_FreeNav','stop_FreeNav','turn_FreeNav'});
% 
% 
%%% TABLES WITH SPEEDS (angular, speed, crabSpeed and speed085)

angularSpeedGrouped =[mean([varsEA_Control(:).avgMeanAngularSpeed]),mean([varsEA_G2019S(:).avgMeanAngularSpeed]),mean([varsEA_A53T(:).avgMeanAngularSpeed]);...
    std([varsEA_Control(:).avgMeanAngularSpeed]),std([varsEA_G2019S(:).avgMeanAngularSpeed]),std([varsEA_A53T(:).avgMeanAngularSpeed]);...
    mean([varsEA_Control(:).avgStdAngularSpeed]),mean([varsEA_G2019S(:).avgStdAngularSpeed]),mean([varsEA_A53T(:).avgStdAngularSpeed]);...
    std([varsEA_Control(:).avgStdAngularSpeed]),std([varsEA_G2019S(:).avgStdAngularSpeed]),std([varsEA_A53T(:).avgStdAngularSpeed]);...
    mean([varsFreeNav_Control(:).avgMeanAngularSpeed]),mean([varsFreeNav_G2019S(:).avgMeanAngularSpeed]),mean([varsFreeNav_A53T(:).avgMeanAngularSpeed]);...
    std([varsFreeNav_Control(:).avgMeanAngularSpeed]),std([varsFreeNav_G2019S(:).avgMeanAngularSpeed]),std([varsFreeNav_A53T(:).avgMeanAngularSpeed]);...
    mean([varsFreeNav_Control(:).avgStdAngularSpeed]),mean([varsFreeNav_G2019S(:).avgStdAngularSpeed]),mean([varsFreeNav_A53T(:).avgStdAngularSpeed]);...
    std([varsFreeNav_Control(:).avgStdAngularSpeed]),std([varsFreeNav_G2019S(:).avgStdAngularSpeed]),std([varsFreeNav_A53T(:).avgStdAngularSpeed])];

tabAngSpeed = array2table(angularSpeedGrouped,'VariableNames',{'control','G2019S','A53T'},'RowNames',{'meanAvgMean_EA','stdAvgMean_EA','meanAvgStd_EA','stdAvgStd_EA','meanAvgMean_freeNav','stdAvgMean_freeNav','meanAvgStd_FreeNav','stdAvgStd_FreeNav'});


speedGrouped =[mean([varsEA_Control(:).avgMeanSpeed]),mean([varsEA_G2019S(:).avgMeanSpeed]),mean([varsEA_A53T(:).avgMeanSpeed]);...
    std([varsEA_Control(:).avgMeanSpeed]),std([varsEA_G2019S(:).avgMeanSpeed]),std([varsEA_A53T(:).avgMeanSpeed]);...
    mean([varsEA_Control(:).avgStdSpeed]),mean([varsEA_G2019S(:).avgStdSpeed]),mean([varsEA_A53T(:).avgStdSpeed]);...
    std([varsEA_Control(:).avgStdSpeed]),std([varsEA_G2019S(:).avgStdSpeed]),std([varsEA_A53T(:).avgStdSpeed]);...
    mean([varsFreeNav_Control(:).avgMeanSpeed]),mean([varsFreeNav_G2019S(:).avgMeanSpeed]),mean([varsFreeNav_A53T(:).avgMeanSpeed]);...
    std([varsFreeNav_Control(:).avgMeanSpeed]),std([varsFreeNav_G2019S(:).avgMeanSpeed]),std([varsFreeNav_A53T(:).avgMeanSpeed]);...
    mean([varsFreeNav_Control(:).avgStdSpeed]),mean([varsFreeNav_G2019S(:).avgStdSpeed]),mean([varsFreeNav_A53T(:).avgStdSpeed]);...
    std([varsFreeNav_Control(:).avgStdSpeed]),std([varsFreeNav_G2019S(:).avgStdSpeed]),std([varsFreeNav_A53T(:).avgStdSpeed])];

tabSpeed = array2table(speedGrouped,'VariableNames',{'control','G2019S','A53T'},'RowNames',{'meanAvgMean_EA','stdAvgMean_EA','meanAvgStd_EA','stdAvgStd_EA','meanAvgMean_freeNav','stdAvgMean_freeNav','meanAvgStd_FreeNav','stdAvgStd_FreeNav'});


speedGroupedNormLength =[mean([varsEA_Control(:).avgMeanSpeed]./[varsEA_Control(:).averageLarvaeLength]),mean([varsEA_G2019S(:).avgMeanSpeed]./[varsEA_G2019S(:).averageLarvaeLength]),mean([varsEA_A53T(:).avgMeanSpeed]./[varsEA_A53T(:).averageLarvaeLength]);...
    std([varsEA_Control(:).avgMeanSpeed]./[varsEA_Control(:).averageLarvaeLength]),std([varsEA_G2019S(:).avgMeanSpeed]./[varsEA_G2019S(:).averageLarvaeLength]),std([varsEA_A53T(:).avgMeanSpeed]./[varsEA_A53T(:).averageLarvaeLength]);...
    mean([varsEA_Control(:).avgStdSpeed]./[varsEA_Control(:).averageLarvaeLength]),mean([varsEA_G2019S(:).avgStdSpeed]./[varsEA_G2019S(:).averageLarvaeLength]),mean([varsEA_A53T(:).avgStdSpeed]./[varsEA_A53T(:).averageLarvaeLength]);...
    std([varsEA_Control(:).avgStdSpeed]./[varsEA_Control(:).averageLarvaeLength]),std([varsEA_G2019S(:).avgStdSpeed]./[varsEA_G2019S(:).averageLarvaeLength]),std([varsEA_A53T(:).avgStdSpeed]./[varsEA_A53T(:).averageLarvaeLength]);...
    mean([varsFreeNav_Control(:).avgMeanSpeed]./[varsFreeNav_Control(:).averageLarvaeLength]),mean([varsFreeNav_G2019S(:).avgMeanSpeed]./[varsFreeNav_G2019S(:).averageLarvaeLength]),mean([varsFreeNav_A53T(:).avgMeanSpeed]./[varsFreeNav_A53T(:).averageLarvaeLength]);...
    std([varsFreeNav_Control(:).avgMeanSpeed]./[varsFreeNav_Control(:).averageLarvaeLength]),std([varsFreeNav_G2019S(:).avgMeanSpeed]./[varsFreeNav_G2019S(:).averageLarvaeLength]),std([varsFreeNav_A53T(:).avgMeanSpeed]./[varsFreeNav_A53T(:).averageLarvaeLength]);...
    mean([varsFreeNav_Control(:).avgStdSpeed]./[varsFreeNav_Control(:).averageLarvaeLength]),mean([varsFreeNav_G2019S(:).avgStdSpeed]./[varsFreeNav_G2019S(:).averageLarvaeLength]),mean([varsFreeNav_A53T(:).avgStdSpeed]./[varsFreeNav_A53T(:).averageLarvaeLength]);...
    std([varsFreeNav_Control(:).avgStdSpeed]./[varsFreeNav_Control(:).averageLarvaeLength]),std([varsFreeNav_G2019S(:).avgStdSpeed]./[varsFreeNav_G2019S(:).averageLarvaeLength]),std([varsFreeNav_A53T(:).avgStdSpeed]./[varsFreeNav_A53T(:).averageLarvaeLength])];

tabSpeedNormLength = array2table(speedGroupedNormLength,'VariableNames',{'control','G2019S','A53T'},'RowNames',{'meanAvgMean_EA','stdAvgMean_EA','meanAvgStd_EA','stdAvgStd_EA','meanAvgMean_freeNav','stdAvgMean_freeNav','meanAvgStd_FreeNav','stdAvgStd_FreeNav'});


% %%% TABLE WITH AREA

areaGrouped =[mean([varsEA_Control(:).avgMeanArea]),mean([varsEA_G2019S(:).avgMeanArea]),mean([varsEA_A53T(:).avgMeanArea]);...
    std([varsEA_Control(:).avgMeanArea]),std([varsEA_G2019S(:).avgMeanArea]),std([varsEA_A53T(:).avgMeanArea]);...
    mean([varsEA_Control(:).avgStdArea]),mean([varsEA_G2019S(:).avgStdArea]),mean([varsEA_A53T(:).avgStdArea]);...
    std([varsEA_Control(:).avgStdArea]),std([varsEA_G2019S(:).avgStdArea]),std([varsEA_A53T(:).avgStdArea]);...
    mean([varsFreeNav_Control(:).avgMeanArea]),mean([varsFreeNav_G2019S(:).avgMeanArea]),mean([varsFreeNav_A53T(:).avgMeanArea]);...
    std([varsFreeNav_Control(:).avgMeanArea]),std([varsFreeNav_G2019S(:).avgMeanArea]),std([varsFreeNav_A53T(:).avgMeanArea]);...
    mean([varsFreeNav_Control(:).avgStdArea]),mean([varsFreeNav_G2019S(:).avgStdArea]),mean([varsFreeNav_A53T(:).avgStdArea]);...
    std([varsFreeNav_Control(:).avgStdArea]),std([varsFreeNav_G2019S(:).avgStdArea]),std([varsFreeNav_A53T(:).avgStdArea])];

tabArea = array2table(areaGrouped,'VariableNames',{'control','G2019S','A53T'},'RowNames',{'meanAvgMean_EA','stdAvgMean_EA','meanAvgStd_EA','stdAvgStd_EA','meanAvgMean_freeNav','stdAvgMean_freeNav','meanAvgStd_FreeNav','stdAvgStd_FreeNav'});

% %%% TABLE WITH CURVE
curveGrouped =[mean([varsEA_Control(:).avgMeanCurve]),mean([varsEA_G2019S(:).avgMeanCurve]),mean([varsEA_A53T(:).avgMeanCurve]);...
    std([varsEA_Control(:).avgMeanCurve]),std([varsEA_G2019S(:).avgMeanCurve]),std([varsEA_A53T(:).avgMeanCurve]);...
    mean([varsEA_Control(:).avgStdCurve]),mean([varsEA_G2019S(:).avgStdCurve]),mean([varsEA_A53T(:).avgStdCurve]);...
    std([varsEA_Control(:).avgStdCurve]),std([varsEA_G2019S(:).avgStdCurve]),std([varsEA_A53T(:).avgStdCurve]);...
    mean([varsFreeNav_Control(:).avgMeanCurve]),mean([varsFreeNav_G2019S(:).avgMeanCurve]),mean([varsFreeNav_A53T(:).avgMeanCurve]);...
    std([varsFreeNav_Control(:).avgMeanCurve]),std([varsFreeNav_G2019S(:).avgMeanCurve]),std([varsFreeNav_A53T(:).avgMeanCurve]);...
    mean([varsFreeNav_Control(:).avgStdCurve]),mean([varsFreeNav_G2019S(:).avgStdCurve]),mean([varsFreeNav_A53T(:).avgStdCurve]);...
    std([varsFreeNav_Control(:).avgStdCurve]),std([varsFreeNav_G2019S(:).avgStdCurve]),std([varsFreeNav_A53T(:).avgStdCurve])];

tabCurve = array2table(curveGrouped,'VariableNames',{'control','G2019S','A53T'},'RowNames',{'meanAvgMean_EA','stdAvgMean_EA','meanAvgStd_EA','stdAvgStd_EA','meanAvgMean_freeNav','stdAvgMean_freeNav','meanAvgStd_FreeNav','stdAvgStd_FreeNav'});


% NAVIGATION INDEX
NavIndexGrouped =[[mean([varsEA_Control(:).navigationIndex_roundT]),mean([varsEA_G2019S(:).navigationIndex_roundT]),mean([varsEA_A53T(:).navigationIndex_roundT])];...
    [std([varsEA_Control(:).navigationIndex_roundT]),std([varsEA_G2019S(:).navigationIndex_roundT]),std([varsEA_A53T(:).navigationIndex_roundT])];...
    [mean([varsEA_Control(:).distanceIndex_Xaxis_roundT]),mean([varsEA_G2019S(:).distanceIndex_Xaxis_roundT]),mean([varsEA_A53T(:).distanceIndex_Xaxis_roundT])];...
    [std([varsEA_Control(:).distanceIndex_Xaxis_roundT]),std([varsEA_G2019S(:).distanceIndex_Xaxis_roundT]),std([varsEA_A53T(:).distanceIndex_Xaxis_roundT])];...
    [mean([varsEA_Control(:).distanceIndex_Yaxis_roundT]),mean([varsEA_G2019S(:).distanceIndex_Yaxis_roundT]),mean([varsEA_A53T(:).distanceIndex_Yaxis_roundT])];...
    [std([varsEA_Control(:).distanceIndex_Yaxis_roundT]),std([varsEA_G2019S(:).distanceIndex_Yaxis_roundT]),std([varsEA_A53T(:).distanceIndex_Yaxis_roundT])];...
    [mean([varsFreeNav_Control(:).navigationIndex_roundT]),mean([varsFreeNav_G2019S(:).navigationIndex_roundT]),mean([varsFreeNav_A53T(:).navigationIndex_roundT])];...
    [std([varsFreeNav_Control(:).navigationIndex_roundT]),std([varsFreeNav_G2019S(:).navigationIndex_roundT]),std([varsFreeNav_A53T(:).navigationIndex_roundT])];...
    [mean([varsFreeNav_Control(:).distanceIndex_Xaxis_roundT]),mean([varsFreeNav_G2019S(:).distanceIndex_Xaxis_roundT]),mean([varsFreeNav_A53T(:).distanceIndex_Xaxis_roundT])];...
    [std([varsFreeNav_Control(:).distanceIndex_Xaxis_roundT]),std([varsFreeNav_G2019S(:).distanceIndex_Xaxis_roundT]),std([varsFreeNav_A53T(:).distanceIndex_Xaxis_roundT])];...
    [mean([varsFreeNav_Control(:).distanceIndex_Yaxis_roundT]),mean([varsFreeNav_G2019S(:).distanceIndex_Yaxis_roundT]),mean([varsFreeNav_A53T(:).distanceIndex_Yaxis_roundT])];...
    [std([varsFreeNav_Control(:).distanceIndex_Yaxis_roundT]),std([varsFreeNav_G2019S(:).distanceIndex_Yaxis_roundT]),std([varsFreeNav_A53T(:).distanceIndex_Yaxis_roundT])]];

tabNavIndex = array2table(NavIndexGrouped,'VariableNames',{'control','G2019S','A53T'},'RowNames',{'mean_NavIndexOdor','std_NavIndexOdor','mean_Xdist_axisOdor','std_Xdist_axisOdor','mean_Ydist_axisOdor','std_Ydist_axisOdor','mean_NavIndexFreeNav','std_NavIndexFreeNav','mean_Xdist_axisFreeNav','std_Xdist_axisFreeNav','mean_Ydist_axisFreeNav','std_Ydist_axisFreeNav'});



%%%% GENERAL PARAMS FOR PLOTS %%%%
        coloursEA = [0 0 1; 1 0.5 0;0 1 0];% Blue for control, orange for G2019S, green for A53T
        fontSizeFigure = 12;
        fontNameFigure = 'Arial';
        [ ~ , nameExp , ~ ] = fileparts( pathFolder );
        switch nameExp
            case 'Control'
              phenotypes_name = {'TH-Gal4 ; +', '+ ; UAS-hLRRK2-G2019S', '+ ; UAS-aSyn-A53T'};
            case 'R58E02G@UPD'
              phenotypes_name = {'R58E02-Gal4 ; +', 'R58E02-Gal4 ; UAS-hLRRK2-G2019S', 'R58E02-Gal4 ; UAS-aSyn-A53T'};
            case 'thG@UPD'
              phenotypes_name = {'TH-Gal4 ; +', 'TH-Gal4 ; UAS-hLRRK2-G2019S', 'TH-Gal4 ; UAS-aSyn-A53T'};
            case 'tshG80thG@UPD'
              phenotypes_name = {'TH-Gal4, tsh-Gal80 ; +', 'TH-Gal4, tsh-Gal80 ; UAS-hLRRK2-G2019S', 'TH-Gal4, tsh-Gal80 ; UAS-aSyn-A53T'};
        end
        LineStyleEA='-';
        T=0:600;

%%%% PLOT NAVIGATION INDEX %%%%
        
        minMax_Y_val = [-0.2, 0.5]; tickInterval=0.1;      
        h1 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
        %nav index
        subplot(2,2,1:2)
        chemotaxisData = {vertcat(varsEA_Control(:).navigationIndex_roundT),vertcat(varsEA_G2019S(:).navigationIndex_roundT),vertcat(varsEA_A53T(:).navigationIndex_roundT)};
        freeNavData = {vertcat(varsFreeNav_Control(:).navigationIndex_roundT),vertcat(varsFreeNav_G2019S(:).navigationIndex_roundT),vertcat(varsFreeNav_A53T(:).navigationIndex_roundT)};
        plotBoxChart(chemotaxisData,freeNavData,coloursEA,'',fontSizeFigure,fontNameFigure,'Navigation index');
        ylim(minMax_Y_val),yticks(minMax_Y_val(1):tickInterval:minMax_Y_val(2))
        legend('','','','','','','',phenotypes_name{1},'',phenotypes_name{2},'',phenotypes_name{3}),legend('Location','northwestoutside'),legend('boxoff')
        %abs. distance X axis
        subplot(2,2,3); minMax_Y_val = [-0.3, 0.7]; 
        chemotaxisDataX = {vertcat(varsEA_Control(:).distanceIndex_Xaxis_roundT),vertcat(varsEA_G2019S(:).distanceIndex_Xaxis_roundT),vertcat(varsEA_A53T(:).distanceIndex_Xaxis_roundT)};
        freeNavDataX = {vertcat(varsFreeNav_Control(:).distanceIndex_Xaxis_roundT),vertcat(varsFreeNav_G2019S(:).distanceIndex_Xaxis_roundT),vertcat(varsFreeNav_A53T(:).distanceIndex_Xaxis_roundT)};
        plotBoxChart(chemotaxisDataX,freeNavDataX,coloursEA,'',fontSizeFigure,fontNameFigure,'Distance index X axis');
        ylim(minMax_Y_val),yticks(minMax_Y_val(1):tickInterval:minMax_Y_val(2))
        %abs. distance Y axis
        subplot(2,2,4); 
        chemotaxisDataY = {vertcat(varsEA_Control(:).distanceIndex_Yaxis_roundT),vertcat(varsEA_G2019S(:).distanceIndex_Yaxis_roundT),vertcat(varsEA_A53T(:).distanceIndex_Yaxis_roundT)};
        freeNavDataY = {vertcat(varsFreeNav_Control(:).distanceIndex_Yaxis_roundT),vertcat(varsFreeNav_G2019S(:).distanceIndex_Yaxis_roundT),vertcat(varsFreeNav_A53T(:).distanceIndex_Yaxis_roundT)};
        plotBoxChart(chemotaxisDataY,freeNavDataY,coloursEA,'',fontSizeFigure,fontNameFigure,'Distance index Y axis');
        ylim(minMax_Y_val),yticks(minMax_Y_val(1):tickInterval:minMax_Y_val(2))

%%%% PLOT AVERAGE SPEED (NORMALIZED BY LENGTH) %%%%
        h2 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
        %subplot speed (normalized)/t       
        paintError='pooledStandardError';
        
        subplot(2,5,6:7);
        hold on
        plotPropertyVersusT(T,cat(2,varsEA_Control(:).avgSpeedRoundT)./cat(2,varsEA_Control(:).averageLarvaeLength),cat(2,varsEA_G2019S(:).avgSpeedRoundT)./cat(2,varsEA_G2019S(:).averageLarvaeLength),cat(2,varsEA_A53T(:).avgSpeedRoundT)./cat(2,varsEA_A53T(:).averageLarvaeLength),...,
            cat(2,varsEA_Control(:).semSpeedRoundT)./cat(2,varsEA_Control(:).averageLarvaeLength),cat(2,varsEA_G2019S(:).semSpeedRoundT)./cat(2,varsEA_G2019S(:).averageLarvaeLength),cat(2,varsEA_A53T(:).semSpeedRoundT)./cat(2,varsEA_A53T(:).averageLarvaeLength),LineStyleEA,coloursEA,paintError)
        xlabel('Time (s)');ylabel('Speed / length (1/s)');ylim([0 0.3]);title ('Chemotaxis')
        
        subplot(2,5,8:9);
        plotPropertyVersusT(T,cat(2,varsFreeNav_Control(:).avgSpeedRoundT)./cat(2,varsFreeNav_Control(:).averageLarvaeLength),cat(2,varsFreeNav_G2019S(:).avgSpeedRoundT)./cat(2,varsFreeNav_G2019S(:).averageLarvaeLength),cat(2,varsFreeNav_A53T(:).avgSpeedRoundT)./cat(2,varsFreeNav_A53T(:).averageLarvaeLength),...,
            cat(2,varsFreeNav_Control(:).semSpeedRoundT)./cat(2,varsFreeNav_Control(:).averageLarvaeLength),cat(2,varsFreeNav_G2019S(:).semSpeedRoundT)./cat(2,varsFreeNav_G2019S(:).averageLarvaeLength),cat(2,varsFreeNav_A53T(:).semSpeedRoundT)./cat(2,varsFreeNav_A53T(:).averageLarvaeLength),LineStyleEA,coloursEA,paintError)        
        xlabel('Time (s)');ylim([0 0.3]);title ('Free navigation')
        
        
        % subplot box chart average values
        subplot(2,5,3:5);
        avgSpeedPerExpChemotaxis = {vertcat(varsEA_Control(:).avgMeanSpeed)./vertcat(varsEA_Control(:).averageLarvaeLength),vertcat(varsEA_G2019S(:).avgMeanSpeed)./vertcat(varsEA_G2019S(:).averageLarvaeLength),vertcat(varsEA_A53T(:).avgMeanSpeed)./vertcat(varsEA_A53T(:).averageLarvaeLength)};
        avgSpeedPerExpFreeNav = {vertcat(varsFreeNav_Control(:).avgMeanSpeed)./vertcat(varsFreeNav_Control(:).averageLarvaeLength),vertcat(varsFreeNav_G2019S(:).avgMeanSpeed)./vertcat(varsFreeNav_G2019S(:).averageLarvaeLength),vertcat(varsFreeNav_A53T(:).avgMeanSpeed)./vertcat(varsFreeNav_A53T(:).averageLarvaeLength)};
        minMax_Y_val = [0, 0.4];
        titleFig ='';
        hold on
        plotBoxChart(avgSpeedPerExpChemotaxis,avgSpeedPerExpFreeNav,coloursEA,titleFig,fontSizeFigure,fontNameFigure,'Speed / length (1/s)');
        ylim(minMax_Y_val),yticks(minMax_Y_val(1):tickInterval:minMax_Y_val(2))
        legend('','','','','','','',phenotypes_name{1},'',phenotypes_name{2},'',phenotypes_name{3}),legend('Location','northeastoutside'),legend('boxoff')
        subplot(2,5,1:2);
        % Plot scatter plot with inverted axes
        experiment1_length= [vertcat(varsEA_Control(:).averageLarvaeLength);vertcat(varsFreeNav_Control(:).averageLarvaeLength)];
        experiment2_length= [vertcat(varsEA_G2019S(:).averageLarvaeLength);vertcat(varsFreeNav_G2019S(:).averageLarvaeLength)];
        experiment3_length= [vertcat(varsEA_A53T(:).averageLarvaeLength);vertcat(varsFreeNav_A53T(:).averageLarvaeLength)];
        experiment1_speed= [vertcat(varsEA_Control(:).avgMeanSpeed);vertcat(varsFreeNav_Control(:).avgMeanSpeed)];
        experiment2_speed= [vertcat(varsEA_G2019S(:).avgMeanSpeed);vertcat(varsFreeNav_G2019S(:).avgMeanSpeed)];
        experiment3_speed= [vertcat(varsEA_A53T(:).avgMeanSpeed);vertcat(varsFreeNav_A53T(:).avgMeanSpeed)];
        hold on;
        scatter(experiment1_length, experiment1_speed, 10, coloursEA(1,:), 'filled', 'MarkerEdgeColor', 'k');
        scatter(experiment2_length, experiment2_speed, 10, coloursEA(2,:), 'filled', 'MarkerEdgeColor', 'k');
        scatter(experiment3_length, experiment3_speed, 10, coloursEA(3,:), 'filled', 'MarkerEdgeColor', 'k');
        
        r2_exp1 = plotTrendLine(experiment1_speed,experiment1_length, coloursEA(1,:));
        r2_exp2 = plotTrendLine(experiment2_speed,experiment2_length, coloursEA(2,:));
        r2_exp3 = plotTrendLine(experiment3_speed,experiment3_length, coloursEA(3,:));
        xlabel('Larva length (mm)'); ylabel('Speed (mm/s)'); grid on;
        set(gca, 'FontName', fontNameFigure, 'FontSize', fontSizeFigure,'Box', 'on', 'XColor', 'k', 'YColor', 'k');

        hold off;

        set(findall(gcf,'-property','FontName'),'FontName',fontNameFigure);
        set(findall(gcf,'-property','FontSize'),'FontSize',fontSizeFigure);

%%%% PLOT ANGULAR SPEED %%%% [avgCurveRoundT could be used instead of meanAngularSpeedPerT]
        h3 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
        paintError = 'pooledStandardError';
        % subplot box chart average values
        subplot(2,2,1:2);
        avgAngSpeedPerExpChemotaxis = {vertcat(varsEA_Control(:).avgMeanAngularSpeed),vertcat(varsEA_G2019S(:).avgMeanAngularSpeed),vertcat(varsEA_A53T(:).avgMeanAngularSpeed)};
        avgAngSpeedPerExpFreeNav = {vertcat(varsFreeNav_Control(:).avgMeanAngularSpeed),vertcat(varsFreeNav_G2019S(:).avgMeanAngularSpeed),vertcat(varsFreeNav_A53T(:).avgMeanAngularSpeed)};
        minMax_Y_val = [0, 45];
        titleFig =''; tickInterval = 5; hold on
        plotBoxChart(avgAngSpeedPerExpChemotaxis,avgAngSpeedPerExpFreeNav,coloursEA,titleFig,fontSizeFigure,fontNameFigure,'Angular speed (degrees/s)');
        ylim(minMax_Y_val),yticks(minMax_Y_val(1):tickInterval:minMax_Y_val(2))
        legend('','','','','','','',phenotypes_name{1},'',phenotypes_name{2},'',phenotypes_name{3}),legend('Location','northwestoutside'),legend('boxoff')


        subplot(2,2,3);hold on
        plotPropertyVersusT(T,cat(2,varsEA_Control(:).meanAngularSpeedPerT),cat(2,varsEA_G2019S(:).meanAngularSpeedPerT),cat(2,varsEA_A53T(:).meanAngularSpeedPerT),...,
            cat(2,varsEA_Control(:).semAngularSpeedPerT),cat(2,varsEA_G2019S(:).semAngularSpeedPerT),cat(2,varsEA_A53T(:).semAngularSpeedPerT),LineStyleEA,coloursEA,paintError)
        xlabel('Time (s)');ylabel('Angular speed (degress/s)');ylim([0 45]);yticks(minMax_Y_val(1):tickInterval:minMax_Y_val(2)),title ('Chemotaxis')       
        
        subplot(2,2,4)
        plotPropertyVersusT(T,cat(2,varsFreeNav_Control(:).meanAngularSpeedPerT),cat(2,varsFreeNav_G2019S(:).meanAngularSpeedPerT),cat(2,varsFreeNav_A53T(:).meanAngularSpeedPerT),...,
            cat(2,varsFreeNav_Control(:).semAngularSpeedPerT),cat(2,varsFreeNav_G2019S(:).semAngularSpeedPerT),cat(2,varsFreeNav_A53T(:).semAngularSpeedPerT),LineStyleEA,coloursEA,paintError)
        xlabel('Time (s)');ylabel('Angular speed (degress/s)');ylim([0 45]);yticks(minMax_Y_val(1):tickInterval:minMax_Y_val(2)),title ('Free Navigation')



%%% TABLES SPEEDS / ORIENTATION
speedPerOrientationGrouped = [[mean(cat(3,varsEA_Control(:).avgSpeedPerOrientation),3),mean(cat(3,varsEA_G2019S(:).avgSpeedPerOrientation),3),mean(cat(3,varsEA_A53T(:).avgSpeedPerOrientation),3)];...
    [mean(cat(3,varsFreeNav_Control(:).avgSpeedPerOrientation),3),mean(cat(3,varsFreeNav_G2019S(:).avgSpeedPerOrientation),3),mean(cat(3,varsFreeNav_A53T(:).avgSpeedPerOrientation),3)];...
    [std(cat(3,varsEA_Control(:).avgSpeedPerOrientation),[],3),std(cat(3,varsEA_G2019S(:).avgSpeedPerOrientation),[],3),std(cat(3,varsEA_A53T(:).avgSpeedPerOrientation),[],3)];...
    [std(cat(3,varsFreeNav_Control(:).avgSpeedPerOrientation),[],3),std(cat(3,varsFreeNav_G2019S(:).avgSpeedPerOrientation),[],3),std(cat(3,varsFreeNav_A53T(:).avgSpeedPerOrientation),[],3)];...
    [mean(cat(3,varsEA_Control(:).stdSpeedPerOrientation),3),mean(cat(3,varsEA_G2019S(:).stdSpeedPerOrientation),3),mean(cat(3,varsEA_A53T(:).stdSpeedPerOrientation),3)];...
    [mean(cat(3,varsFreeNav_Control(:).stdSpeedPerOrientation),3),mean(cat(3,varsFreeNav_G2019S(:).stdSpeedPerOrientation),3),mean(cat(3,varsFreeNav_A53T(:).stdSpeedPerOrientation),3)];...
    [std(cat(3,varsEA_Control(:).stdSpeedPerOrientation),[],3),std(cat(3,varsEA_G2019S(:).stdSpeedPerOrientation),[],3),std(cat(3,varsEA_A53T(:).stdSpeedPerOrientation),[],3)];...
    [std(cat(3,varsFreeNav_Control(:).stdSpeedPerOrientation),[],3),std(cat(3,varsFreeNav_G2019S(:).stdSpeedPerOrientation),[],3),std(cat(3,varsFreeNav_A53T(:).stdSpeedPerOrientation),[],3)]];

tabSpeedOrientation =array2table(speedPerOrientationGrouped,'VariableNames',{'control_left','control_right','control_top','control_bottom','G2019S_left','G2019S_right','G2019S_top','G2019S_bottom','A53T_left','A53T_right','A53T_top','A53T_bottom'},'RowNames',{'meanAvg_EA','meanAvg_FreeNav','stdAvg_EA','stdAvg_FreeNav','meanStd_EA','meanStd_FreeNav','stdStd_EA','stdStd_FreeNav'});


angularSpeedPerOrientationGrouped = [[mean(cat(3,varsEA_Control(:).avgAngularSpeedPerOrientation),3),mean(cat(3,varsEA_G2019S(:).avgAngularSpeedPerOrientation),3),mean(cat(3,varsEA_A53T(:).avgAngularSpeedPerOrientation),3)];...
    [mean(cat(3,varsFreeNav_Control(:).avgAngularSpeedPerOrientation),3),mean(cat(3,varsFreeNav_G2019S(:).avgAngularSpeedPerOrientation),3),mean(cat(3,varsFreeNav_A53T(:).avgAngularSpeedPerOrientation),3)];...
    [std(cat(3,varsEA_Control(:).avgAngularSpeedPerOrientation),[],3),std(cat(3,varsEA_G2019S(:).avgAngularSpeedPerOrientation),[],3),std(cat(3,varsEA_A53T(:).avgAngularSpeedPerOrientation),[],3)];...
    [std(cat(3,varsFreeNav_Control(:).avgAngularSpeedPerOrientation),[],3),std(cat(3,varsFreeNav_G2019S(:).avgAngularSpeedPerOrientation),[],3),std(cat(3,varsFreeNav_A53T(:).avgAngularSpeedPerOrientation),[],3)];...
    [mean(cat(3,varsEA_Control(:).stdAngularSpeedPerOrientation),3),mean(cat(3,varsEA_G2019S(:).stdAngularSpeedPerOrientation),3),mean(cat(3,varsEA_A53T(:).stdAngularSpeedPerOrientation),3)];...
    [mean(cat(3,varsFreeNav_Control(:).stdAngularSpeedPerOrientation),3),mean(cat(3,varsFreeNav_G2019S(:).stdAngularSpeedPerOrientation),3),mean(cat(3,varsFreeNav_A53T(:).stdAngularSpeedPerOrientation),3)];...
    [std(cat(3,varsEA_Control(:).stdAngularSpeedPerOrientation),[],3),std(cat(3,varsEA_G2019S(:).stdAngularSpeedPerOrientation),[],3),std(cat(3,varsEA_A53T(:).stdAngularSpeedPerOrientation),[],3)];...
    [std(cat(3,varsFreeNav_Control(:).stdAngularSpeedPerOrientation),[],3),std(cat(3,varsFreeNav_G2019S(:).stdAngularSpeedPerOrientation),[],3),std(cat(3,varsFreeNav_A53T(:).stdAngularSpeedPerOrientation),[],3)]];

tabAngularSpeedOrientation =array2table(angularSpeedPerOrientationGrouped,'VariableNames',{'control_left','control_right','control_top','control_bottom','G2019S_left','G2019S_right','G2019S_top','G2019S_bottom','A53T_left','A53T_right','A53T_top','A53T_bottom'},'RowNames',{'meanAvg_EA','meanAvg_FreeNav','stdAvg_EA','stdAvg_FreeNav','meanStd_EA','meanStd_FreeNav','stdStd_EA','stdStd_FreeNav'});
 

curvePerOrientationGrouped = [[mean(cat(3,varsEA_Control(:).avgCurvePerOrientation),3),mean(cat(3,varsEA_G2019S(:).avgCurvePerOrientation),3),mean(cat(3,varsEA_A53T(:).avgCurvePerOrientation),3)];...
    [mean(cat(3,varsFreeNav_Control(:).avgCurvePerOrientation),3),mean(cat(3,varsFreeNav_G2019S(:).avgCurvePerOrientation),3),mean(cat(3,varsFreeNav_A53T(:).avgCurvePerOrientation),3)];...
    [std(cat(3,varsEA_Control(:).avgCurvePerOrientation),[],3),std(cat(3,varsEA_G2019S(:).avgCurvePerOrientation),[],3),std(cat(3,varsEA_A53T(:).avgCurvePerOrientation),[],3)];...
    [std(cat(3,varsFreeNav_Control(:).avgCurvePerOrientation),[],3),std(cat(3,varsFreeNav_G2019S(:).avgCurvePerOrientation),[],3),std(cat(3,varsFreeNav_A53T(:).avgCurvePerOrientation),[],3)];...
    [mean(cat(3,varsEA_Control(:).stdCurvePerOrientation),3),mean(cat(3,varsEA_G2019S(:).stdCurvePerOrientation),3),mean(cat(3,varsEA_A53T(:).stdCurvePerOrientation),3)];...
    [mean(cat(3,varsFreeNav_Control(:).stdCurvePerOrientation),3),mean(cat(3,varsFreeNav_G2019S(:).stdCurvePerOrientation),3),mean(cat(3,varsFreeNav_A53T(:).stdCurvePerOrientation),3)];...
    [std(cat(3,varsEA_Control(:).stdCurvePerOrientation),[],3),std(cat(3,varsEA_G2019S(:).stdCurvePerOrientation),[],3),std(cat(3,varsEA_A53T(:).stdCurvePerOrientation),[],3)];...
    [std(cat(3,varsFreeNav_Control(:).stdCurvePerOrientation),[],3),std(cat(3,varsFreeNav_G2019S(:).stdCurvePerOrientation),[],3),std(cat(3,varsFreeNav_A53T(:).stdCurvePerOrientation),[],3)]];

tabCurveOrientation =array2table(curvePerOrientationGrouped,'VariableNames',{'control_left','control_right','control_top','control_bottom','G2019S_left','G2019S_right','G2019S_top','G2019S_bottom','A53T_left','A53T_right','A53T_top','A53T_bottom'},'RowNames',{'meanAvg_EA','meanAvg_FreeNav','stdAvg_EA','stdAvg_FreeNav','meanStd_EA','meanStd_FreeNav','stdStd_EA','stdStd_FreeNav'});
% 
% %% Orientation prior and after casting (or casting+turning)
% orientationPriorAfterCastingGrouped = [[mean(cat(3,propOrientationPriorCasting{intersect(idsEA,idsTH)}),3),mean(cat(3,propOrientationPriorCasting{intersect(idsEA,idsG2019S)}),3),mean(cat(3,propOrientationPriorCasting{intersect(idsEA,idsA53T)}),3)];...
% [mean(cat(3,propOrientationPriorCasting{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,propOrientationPriorCasting{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,propOrientationPriorCasting{intersect(idsFreeNav,idsA53T)}),3)];...
% [std(cat(3,propOrientationPriorCasting{intersect(idsEA,idsTH)}),[],3),std(cat(3,propOrientationPriorCasting{intersect(idsEA,idsG2019S)}),[],3),std(cat(3,propOrientationPriorCasting{intersect(idsEA,idsA53T)}),[],3)];...
% [std(cat(3,propOrientationPriorCasting{intersect(idsFreeNav,idsTH)}),[],3),std(cat(3,propOrientationPriorCasting{intersect(idsFreeNav,idsG2019S)}),[],3),std(cat(3,propOrientationPriorCasting{intersect(idsFreeNav,idsA53T)}),[],3)];...
% [mean(cat(3,propOrientationAfterCasting{intersect(idsEA,idsTH)}),3),mean(cat(3,propOrientationAfterCasting{intersect(idsEA,idsG2019S)}),3),mean(cat(3,propOrientationAfterCasting{intersect(idsEA,idsA53T)}),3)];...
% [mean(cat(3,propOrientationAfterCasting{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,propOrientationAfterCasting{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,propOrientationAfterCasting{intersect(idsFreeNav,idsA53T)}),3)];...
% [std(cat(3,propOrientationAfterCasting{intersect(idsEA,idsTH)}),[],3),std(cat(3,propOrientationAfterCasting{intersect(idsEA,idsG2019S)}),[],3),std(cat(3,propOrientationAfterCasting{intersect(idsEA,idsA53T)}),[],3)];...
% [std(cat(3,propOrientationAfterCasting{intersect(idsFreeNav,idsTH)}),[],3),std(cat(3,propOrientationAfterCasting{intersect(idsFreeNav,idsG2019S)}),[],3),std(cat(3,propOrientationAfterCasting{intersect(idsFreeNav,idsA53T)}),[],3)]];
% 
% tabOrientationLarvPriorAfterCasting =array2table(orientationPriorAfterCastingGrouped,'VariableNames',{'control_left','control_right','control_top','control_bottom','G2019S_left','G2019S_right','G2019S_top','G2019S_bottom','A53T_left','A53T_right','A53T_top','A53T_bottom'},'RowNames',{'priorCastingMean_EA','priorCastingMean_FreeNav','priorCastingStd_EA','priorCastingStd_FreeNav','afterCastingMean_EA','afterCastingMean_FreeNav','afterCastingStd_EA','afterCastingStd_FreeNav'});
% 
% 
% orientationPriorAfterCastingTurningGrouped = [[mean(cat(3,propOrientationPriorCastingOrTurning{intersect(idsEA,idsTH)}),3),mean(cat(3,propOrientationPriorCastingOrTurning{intersect(idsEA,idsG2019S)}),3),mean(cat(3,propOrientationPriorCastingOrTurning{intersect(idsEA,idsA53T)}),3)];...
% [mean(cat(3,propOrientationPriorCastingOrTurning{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,propOrientationPriorCastingOrTurning{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,propOrientationPriorCastingOrTurning{intersect(idsFreeNav,idsA53T)}),3)];...
% [std(cat(3,propOrientationPriorCastingOrTurning{intersect(idsEA,idsTH)}),[],3),std(cat(3,propOrientationPriorCastingOrTurning{intersect(idsEA,idsG2019S)}),[],3),std(cat(3,propOrientationPriorCastingOrTurning{intersect(idsEA,idsA53T)}),[],3)];...
% [std(cat(3,propOrientationPriorCastingOrTurning{intersect(idsFreeNav,idsTH)}),[],3),std(cat(3,propOrientationPriorCastingOrTurning{intersect(idsFreeNav,idsG2019S)}),[],3),std(cat(3,propOrientationPriorCastingOrTurning{intersect(idsFreeNav,idsA53T)}),[],3)];...
% [mean(cat(3,propOrientationAfterCastingOrTurning{intersect(idsEA,idsTH)}),3),mean(cat(3,propOrientationAfterCastingOrTurning{intersect(idsEA,idsG2019S)}),3),mean(cat(3,propOrientationAfterCastingOrTurning{intersect(idsEA,idsA53T)}),3)];...
% [mean(cat(3,propOrientationAfterCastingOrTurning{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,propOrientationAfterCastingOrTurning{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,propOrientationAfterCastingOrTurning{intersect(idsFreeNav,idsA53T)}),3)];...
% [std(cat(3,propOrientationAfterCastingOrTurning{intersect(idsEA,idsTH)}),[],3),std(cat(3,propOrientationAfterCastingOrTurning{intersect(idsEA,idsG2019S)}),[],3),std(cat(3,propOrientationAfterCastingOrTurning{intersect(idsEA,idsA53T)}),[],3)];...
% [std(cat(3,propOrientationAfterCastingOrTurning{intersect(idsFreeNav,idsTH)}),[],3),std(cat(3,propOrientationAfterCastingOrTurning{intersect(idsFreeNav,idsG2019S)}),[],3),std(cat(3,propOrientationAfterCastingOrTurning{intersect(idsFreeNav,idsA53T)}),[],3)]];
% 
% tabOrientationPriorAfterCastingOrTurning=array2table(orientationPriorAfterCastingTurningGrouped,'VariableNames',{'control_left','control_right','control_top','control_bottom','G2019S_left','G2019S_right','G2019S_top','G2019S_bottom','A53T_left','A53T_right','A53T_top','A53T_bottom'},'RowNames',{'priorCastingMean_EA','priorCastingMean_FreeNav','priorCastingStd_EA','priorCastingStd_FreeNav','afterCastingMean_EA','afterCastingMean_FreeNav','afterCastingStd_EA','afterCastingStd_FreeNav'});
% 

% %% Plot run, stop, turn & casting / time
% %larvae running
% h8 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
% subplot(1,2,1);hold on
% plotSpeedVersusT(T,proportionLarvaeRunPerT,[],idsEA,idsTH,idsG2019S,idsA53T,LineStyleEA,coloursEA,'calculateError')
% legend({'','','','Control EA','G2019S EA','A53T EA'})
% xlabel('Time (s)')
% ylabel('Proportion of larvae running');
% set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);
% ylim([0 1])
% 
% subplot(1,2,2)
% plotSpeedVersusT(T,proportionLarvaeRunPerT,[],idsFreeNav,idsTH,idsG2019S,idsA53T,LineStyleFreeN,coloursFreeN,'calculateError')
% legend({'','','','Control FreeNav','G2019S FreeNav','A53T FreeNav'})
% xlabel('Time (s)')
% ylabel('Proportion of larvae running');
% set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);
% ylim([0 1])
% 
% 
% %%larvae stopping
% paintError=0;
% h9 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
% subplot(1,2,1);hold on
% plotSpeedVersusT(T,proportionLarvaeStopPerT,[],idsEA,idsTH,idsG2019S,idsA53T,LineStyleEA,coloursEA,'calculateError')
% legend({'','','','Control EA','G2019S EA','A53T EA'})
% xlabel('Time (s)')
% ylabel('Proportion of larvae stopping');
% set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);
% ylim([0 1])
% 
% subplot(1,2,2)
% plotSpeedVersusT(T,proportionLarvaeStopPerT,[],idsFreeNav,idsTH,idsG2019S,idsA53T,LineStyleFreeN,coloursFreeN,'calculateError')
% legend({'','','','Control FreeNav','G2019S FreeNav','A53T FreeNav'})
% xlabel('Time (s)')
% ylabel('Proportion of larvae stopping');
% set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);
% ylim([0 1])
% 
% %%larvae turning
% paintError=0;
% h10 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
% subplot(1,2,1);hold on
% plotSpeedVersusT(T,proportionLarvaeTurnPerT,[],idsEA,idsTH,idsG2019S,idsA53T,LineStyleEA,coloursEA,'calculateError')
% legend({'','','','Control EA','G2019S EA','A53T EA'})
% xlabel('Time (s)')
% ylabel('Proportion of larvae turning');
% set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);
% ylim([0 1])
% 
% subplot(1,2,2)
% plotSpeedVersusT(T,proportionLarvaeTurnPerT,[],idsFreeNav,idsTH,idsG2019S,idsA53T,LineStyleFreeN,coloursFreeN,'calculateError')
% legend({'','','','Control FreeNav','G2019S FreeNav','A53T FreeNav'})
% xlabel('Time (s)')
% ylabel('Proportion of larvae turning');
% set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);
% ylim([0 1])
% 
% %%larvae casting
% paintError=0;
% h11 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
% subplot(1,2,1);hold on
% plotSpeedVersusT(T,proportionLarvaeCastingPerT,[],idsEA,idsTH,idsG2019S,idsA53T,LineStyleEA,coloursEA,'calculateError')
% legend({'','','','Control EA','G2019S EA','A53T EA'})
% xlabel('Time (s)')
% ylabel('Proportion of larvae casting');
% set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);
% ylim([0 1])
% 
% subplot(1,2,2)
% plotSpeedVersusT(T,proportionLarvaeCastingPerT,[],idsFreeNav,idsTH,idsG2019S,idsA53T,LineStyleFreeN,coloursFreeN,'calculateError')
% legend({'','','','Control FreeNav','G2019S FreeNav','A53T FreeNav'})
% xlabel('Time (s)')
% ylabel('Proportion of larvae casting');
% set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);
% ylim([0 1])
% 
% %%larvae turning or casting
% paintError=0;
% h12 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
% subplot(1,2,1);hold on
% plotSpeedVersusT(T,cellfun(@(x,y) x+y, proportionLarvaeTurnPerT,proportionLarvaeCastingPerT,'UniformOutput',false),[],idsEA,idsTH,idsG2019S,idsA53T,LineStyleEA,coloursEA,'calculateError')
% legend({'','','','Control EA','G2019S EA','A53T EA'})
% xlabel('Time (s)')
% ylabel('Proportion of larvae turning or casting');
% set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);
% ylim([0 1])
% 
% subplot(1,2,2)
% plotSpeedVersusT(T,cellfun(@(x,y) x+y, proportionLarvaeTurnPerT,proportionLarvaeCastingPerT,'UniformOutput',false),[],idsFreeNav,idsTH,idsG2019S,idsA53T,LineStyleFreeN,coloursFreeN,'calculateError')
% legend({'','','','Control FreeNav','G2019S FreeNav','A53T FreeNav'})
% xlabel('Time (s)')
% ylabel('Proportion of larvae turning or casting');
% set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);
% ylim([0 1])
% 
%% PLOT bins distribution init & end
x=[0.73 0.91 1.095 1.275; 1.73 1.91 2.095 2.275; 2.73 2.91 3.095 3.275];

bins_MeanDist_control_EA = mean(cat(3,varsEA_Control(:).binsXdistributionInitEnd),3);
bins_MeanDist_G2019S_EA = mean(cat(3,varsEA_G2019S(:).binsXdistributionInitEnd),3);
bins_MeanDist_A53T_EA = mean(cat(3,varsEA_A53T(:).binsXdistributionInitEnd),3);

bins_stdDist_control_EA = std(cat(3,varsEA_Control(:).binsXdistributionInitEnd),[],3)/(sqrt(size(varsEA_Control,1)));
bins_stdDist_G2019S_EA = std(cat(3,varsEA_G2019S(:).binsXdistributionInitEnd),[],3)/(sqrt(size(varsEA_G2019S,1)));
bins_stdDist_A53T_EA = std(cat(3,varsEA_A53T(:).binsXdistributionInitEnd),[],3)/(sqrt(size(varsEA_A53T,1)));

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

bins_MeanDist_control_FreeNav = mean(cat(3,varsFreeNav_Control(:).binsXdistributionInitEnd),3);
bins_MeanDist_G2019S_FreeNav = mean(cat(3,varsFreeNav_G2019S(:).binsXdistributionInitEnd),3);
bins_MeanDist_A53T_FreeNav = mean(cat(3,varsFreeNav_A53T(:).binsXdistributionInitEnd),3);

bins_stdDist_control_FreeNav = std(cat(3,varsFreeNav_Control(:).binsXdistributionInitEnd),[],3)/(sqrt(size(varsFreeNav_Control,1)));
bins_stdDist_G2019S_FreeNav = std(cat(3,varsFreeNav_G2019S(:).binsXdistributionInitEnd),[],3)/(sqrt(size(varsFreeNav_G2019S,1)));
bins_stdDist_A53T_FreeNav = std(cat(3,varsFreeNav_A53T(:).binsXdistributionInitEnd),[],3)/(sqrt(size(varsFreeNav_A53T,1)));

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

title('G2019S Free Navig')
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


isPrintOn=1;
[filepath,nameF,ext] = fileparts(pathFolder);

folder2save = fullfile('..','Results',nameF);
if ~exist(folder2save,'dir'), mkdir(fullfile(folder2save,'Figures')); end

if isPrintOn == 1
    print(h1,fullfile(folder2save,'Figures','area_vs_T.png'),'-dpng','-r300')
    savefig(h1,fullfile(folder2save,'Figures','area_vs_T.fig'))
    print(h2,fullfile(folder2save,'Figures','speed_vs_T.png'),'-dpng','-r300')
    savefig(h2,fullfile(folder2save,'Figures','speed_vs_T.fig'))
    print(h5,fullfile(folder2save,'Figures','angularSpeed_vs_T.png'),'-dpng','-r300')
    savefig(h5,fullfile(folder2save,'Figures','angularSpeed_vs_T.fig'))
    print(h6_1,fullfile(folder2save,'Figures','speed_normLength_vs_T.png'),'-dpng','-r300')
    savefig(h6_1,fullfile(folder2save,'Figures','speed_normLength_vs_T.fig'))
    print(h7,fullfile(folder2save,'Figures','curve_vs_T.png'),'-dpng','-r300')
    savefig(h7,fullfile(folder2save,'Figures','curve_vs_T.fig'))

%     print(h8,fullfile(folder2save,'Figures','proportionOfLarvaeRunning.png'),'-dpng','-r300')
%     savefig(h8,fullfile(folder2save,'Figures','proportionOfLarvaeRunning.fig'))
%     print(h9,fullfile(folder2save,'Figures','proportionOfLarvaeStopping.png'),'-dpng','-r300')
%     savefig(h9,fullfile(folder2save,'Figures','proportionOfLarvaeStopping.fig')) 
%     print(h10,fullfile(folder2save,'Figures','proportionOfLarvaeTurning.png'),'-dpng','-r300')
%     savefig(h10,fullfile(folder2save,'Figures','proportionOfLarvaeTurning.fig')) 
%     print(h11,fullfile(folder2save,'Figures','proportionOfLarvaeCasting.png'),'-dpng','-r300')
%     savefig(h11,fullfile(folder2save,'Figures','proportionOfLarvaeCasting.fig')) 
%     print(h12,fullfile(folder2save,'Figures','proportionOfLarvaeTurningOrCasting.png'),'-dpng','-r300')
%     savefig(h12,fullfile(folder2save,'Figures','proportionOfLarvaeTurningOrCasting.fig'))

    print(h13,fullfile(folder2save,'Figures','distributionXaxis.png'),'-dpng','-r300')
    savefig(h13,fullfile(folder2save,'Figures','distributionXaxis.fig'))


    clearvars -except folder2save tabSpeedNormLength tabOrientationLarvPriorAfterCasting tabOrientationPriorAfterCastingOrTurning tabCurveOrientation tabSpeedOrientation tabAngularSpeedOrientation tabNavIndex tabMeanTransitionMatrixOrient tabMeanTransitionMatrixMov tabArea tabCurve tabSpeed tabAngSpeed tabPercAngStates tabPercMovStates tabMovRatePerOrient

    writetable(tabNavIndex,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','NavIndex','Range','B2','WriteRowNames',true)
    writetable(tabArea,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','AreaLarvae','Range','B2','WriteRowNames',true)    
    writetable(tabSpeed,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','Speed','Range','B2','WriteRowNames',true)
    writetable(tabSpeedNormLength,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','SpeedNormLength','Range','B2','WriteRowNames',true)
    writetable(tabAngSpeed,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','AngSpeed','Range','B2','WriteRowNames',true)
    writetable(tabCurve,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','Curve','Range','B2','WriteRowNames',true)
    writetable(tabMeanTransitionMatrixOrient,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','TransitionMatrixOrientation','Range','B2','WriteRowNames',true)
%     writetable(tabMeanTransitionMatrixMov,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','TransitionMatrixMovStates','Range','B2','WriteRowNames',true)
    writetable(tabPercAngStates,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','PercAngStates','Range','B2','WriteRowNames',true)
%     writetable(tabPercMovStates,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','PercMovStates','Range','B2','WriteRowNames',true)
%     writetable(tabMovRatePerOrient,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','RateMovStates','Range','B2','WriteRowNames',true)
    writetable(tabSpeedOrientation,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','SpeedPerOrientation','Range','B2','WriteRowNames',true)
    writetable(tabAngularSpeedOrientation,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','AngSpeedPerOrientation','Range','B2','WriteRowNames',true)
    writetable(tabCurveOrientation,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','CurvePerOrientation','Range','B2','WriteRowNames',true)
%     writetable(tabOrientationLarvPriorAfterCasting,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','OrientBefAftCast','Range','B2','WriteRowNames',true)
%     writetable(tabOrientationPriorAfterCastingOrTurning,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','OrientBefAftCastTurn','Range','B2','WriteRowNames',true)

end

close all
clear all


%Average speed/larvae length

%Angular speed

%Number of turns / average n larvae / minute 

%Number of castings / average n larvae / minute

%Number of stops / average n larvae / minute

%Tortuosity vs fractal dimension (Loveless 2018, Integrative & Comparative Biology)

%Mean squared error

%Turn probability regarding orientation to odor source (Gomez-Marin 2011,
%Nat. Commns). Considering % time spent for the larvae per orientation.






