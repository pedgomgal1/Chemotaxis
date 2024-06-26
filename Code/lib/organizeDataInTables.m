function [tabNavIndex,tabSpeedNormLength,tabSpeed,tabLarvaeLength,tabAngSpeed,tabPercAngStates,tabMeanTransitionMatrixOrient,tabPercMovStates,tabMeanTransitionMatrixMov,...
    tabOrientationPriorAfterTurning]...
    = organizeDataInTables(allVars,idsEA,idsFreeNav,idsTH,idsG2019S,idsA53T,varsEA_Control,varsEA_A53T,varsEA_G2019S,varsFreeNav_Control,varsFreeNav_A53T,varsFreeNav_G2019S)

% %%% TABLE WITH TRANSITION MATRIX (8 x 12)
transitionMatrixOrientation=arrayfun(@(x) table2array(allVars{x}.transitionMatrixOrientation), 1:size(allVars,1), 'UniformOutput', false);
matrixProbOrientation=arrayfun(@(x) table2array(allVars{x}.matrixProbOrientation), 1:size(allVars,1), 'UniformOutput', false);

groupedMeanTransitionMatrixOrient =[mean(cat(3,transitionMatrixOrientation{intersect(idsEA,idsTH)}),3),mean(cat(3,transitionMatrixOrientation{intersect(idsEA,idsG2019S)}),3),mean(cat(3,transitionMatrixOrientation{intersect(idsEA,idsA53T)}),3);
    mean(cat(3,transitionMatrixOrientation{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,transitionMatrixOrientation{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,transitionMatrixOrientation{intersect(idsFreeNav,idsA53T)}),3)];

tabMeanTransitionMatrixOrient=array2table(groupedMeanTransitionMatrixOrient,'VariableNames',{'control_left','control_right','control_top','control_bottom','G2019S_left','G2019S_right','G2019S_top','G2019S_bottom','A53T_left','A53T_right','A53T_top','A53T_bottom'},'RowNames',...
    {'left_EA','right_EA','top_EA','bottom_EA','left_FreeNav','right_FreeNav','top_FreeNav','bottom_FreeNav'});

% groupedStdTransitionMatrixOrient =[std(cat(3,transitionMatrixOrientation{intersect(idsEA,idsTH)}),[],3),std(cat(3,transitionMatrixOrientation{intersect(idsEA,idsG2019S)}),[],3),std(cat(3,transitionMatrixOrientation{intersect(idsEA,idsA53T)}),[],3);
%     std(cat(3,transitionMatrixOrientation{intersect(idsFreeNav,idsTH)}),[],3),std(cat(3,transitionMatrixOrientation{intersect(idsFreeNav,idsG2019S)}),[],3),std(cat(3,transitionMatrixOrientation{intersect(idsFreeNav,idsA53T)}),[],3)];
% 
% tabStdTransitionMatrixOrient=array2table(groupedStdTransitionMatrixOrient,'VariableNames',{'control_left','control_right','control_top','control_bottom','G2019S_left','G2019S_right','G2019S_top','G2019S_bottom','A53T_left','A53T_right','A53T_top','A53T_bottom'},'RowNames',...
%     {'left_EA','right_EA','top_EA','bottom_EA','left_FreeNav','right_FreeNav','top_FreeNav','bottom_FreeNav'});


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

%% Transition matrix motion. run, stop, turn

%%%%%%%%%%transition matrix 
all_matrixProbMotionStates=arrayfun(@(x) table2array(allVars{x}.matrixProbMotionStates), 1:size(allVars,1), 'UniformOutput', false);

percMovState = cellfun(@(x) sum(x)/sum(x(:)), all_matrixProbMotionStates, 'UniformOutput', false);

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
    "RowNames",{'average_EA','std_EA','average_FreeNav','std_FreeNav'},'VariableNames',{'run_Control','stop_Control','turn_Control','run_G2019S','stop_G2019S','turn_G2019S','run_A53T','stop_A53T','turn_A53T'});


%%% TABLE WITH TRANSITION MATRIX (8 x 12)
transitionMatrixMotionStates=arrayfun(@(x) table2array(allVars{x}.transitionMatrixMotionStates), 1:size(allVars,1), 'UniformOutput', false);
transitionMatrixMotionStatesNoNaN= cellfun(@(x) replaceNaN_0(x),transitionMatrixMotionStates,'UniformOutput',false);
groupedMeanTransitionMatrixMov =[mean(cat(3,transitionMatrixMotionStatesNoNaN{intersect(idsEA,idsTH)}),3),mean(cat(3,transitionMatrixMotionStatesNoNaN{intersect(idsEA,idsG2019S)}),3),mean(cat(3,transitionMatrixMotionStatesNoNaN{intersect(idsEA,idsA53T)}),3);
    mean(cat(3,transitionMatrixMotionStatesNoNaN{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,transitionMatrixMotionStatesNoNaN{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,transitionMatrixMotionStatesNoNaN{intersect(idsFreeNav,idsA53T)}),3)];

tabMeanTransitionMatrixMov=array2table(groupedMeanTransitionMatrixMov,'VariableNames',{'control_run','control_stop','control_turn','G2019S_run','G2019S_stop','G2019S_turn','A53T_run','A53T_stop','A53T_turn'},'RowNames',...
    {'run_EA','stop_EA','turn_EA','run_FreeNav','stop_FreeNav','turn_FreeNav'});

%%% Tables with speeds (speed and angular speed)

angularSpeedGrouped =[mean([varsEA_Control(:).avgMeanAngularSpeed]),mean([varsEA_G2019S(:).avgMeanAngularSpeed]),mean([varsEA_A53T(:).avgMeanAngularSpeed]);...
    std([varsEA_Control(:).avgMeanAngularSpeed]),std([varsEA_G2019S(:).avgMeanAngularSpeed]),std([varsEA_A53T(:).avgMeanAngularSpeed]);...
    mean([varsEA_Control(:).avgStdAngularSpeed]),mean([varsEA_G2019S(:).avgStdAngularSpeed]),mean([varsEA_A53T(:).avgStdAngularSpeed]);...
    std([varsEA_Control(:).avgStdAngularSpeed]),std([varsEA_G2019S(:).avgStdAngularSpeed]),std([varsEA_A53T(:).avgStdAngularSpeed]);...
    mean([varsFreeNav_Control(:).avgMeanAngularSpeed]),mean([varsFreeNav_G2019S(:).avgMeanAngularSpeed]),mean([varsFreeNav_A53T(:).avgMeanAngularSpeed]);...
    std([varsFreeNav_Control(:).avgMeanAngularSpeed]),std([varsFreeNav_G2019S(:).avgMeanAngularSpeed]),std([varsFreeNav_A53T(:).avgMeanAngularSpeed]);...
    mean([varsFreeNav_Control(:).avgStdAngularSpeed]),mean([varsFreeNav_G2019S(:).avgStdAngularSpeed]),mean([varsFreeNav_A53T(:).avgStdAngularSpeed]);...
    std([varsFreeNav_Control(:).avgStdAngularSpeed]),std([varsFreeNav_G2019S(:).avgStdAngularSpeed]),std([varsFreeNav_A53T(:).avgStdAngularSpeed])];

tabAngSpeed = array2table(angularSpeedGrouped,'VariableNames',{'control','G2019S','A53T'},'RowNames',{'meanAvgMean_EA','stdAvgMean_EA','meanAvgStd_EA','stdAvgStd_EA','meanAvgMean_freeNav','stdAvgMean_freeNav','meanAvgStd_FreeNav','stdAvgStd_FreeNav'});


speedGrouped =[mean([varsEA_Control(:).avgMeanSpeedGolay]),mean([varsEA_G2019S(:).avgMeanSpeedGolay]),mean([varsEA_A53T(:).avgMeanSpeedGolay]);...
    std([varsEA_Control(:).avgMeanSpeedGolay]),std([varsEA_G2019S(:).avgMeanSpeedGolay]),std([varsEA_A53T(:).avgMeanSpeedGolay]);...
    mean([varsEA_Control(:).avgStdSpeedGolay]),mean([varsEA_G2019S(:).avgStdSpeedGolay]),mean([varsEA_A53T(:).avgStdSpeedGolay]);...
    std([varsEA_Control(:).avgStdSpeedGolay]),std([varsEA_G2019S(:).avgStdSpeedGolay]),std([varsEA_A53T(:).avgStdSpeedGolay]);...
    mean([varsFreeNav_Control(:).avgMeanSpeedGolay]),mean([varsFreeNav_G2019S(:).avgMeanSpeedGolay]),mean([varsFreeNav_A53T(:).avgMeanSpeedGolay]);...
    std([varsFreeNav_Control(:).avgMeanSpeedGolay]),std([varsFreeNav_G2019S(:).avgMeanSpeedGolay]),std([varsFreeNav_A53T(:).avgMeanSpeedGolay]);...
    mean([varsFreeNav_Control(:).avgStdSpeedGolay]),mean([varsFreeNav_G2019S(:).avgStdSpeedGolay]),mean([varsFreeNav_A53T(:).avgStdSpeedGolay]);...
    std([varsFreeNav_Control(:).avgStdSpeedGolay]),std([varsFreeNav_G2019S(:).avgStdSpeedGolay]),std([varsFreeNav_A53T(:).avgStdSpeedGolay])];

tabSpeed = array2table(speedGrouped,'VariableNames',{'control','G2019S','A53T'},'RowNames',{'meanAvgMean_EA','stdAvgMean_EA','meanAvgStd_EA','stdAvgStd_EA','meanAvgMean_freeNav','stdAvgMean_freeNav','meanAvgStd_FreeNav','stdAvgStd_FreeNav'});


speedGroupedNormLength =[mean([varsEA_Control(:).avgMeanSpeedGolayNormalized]),mean([varsEA_G2019S(:).avgMeanSpeedGolayNormalized]),mean([varsEA_A53T(:).avgMeanSpeedGolayNormalized]);...
    std([varsEA_Control(:).avgMeanSpeedGolayNormalized]),std([varsEA_G2019S(:).avgMeanSpeedGolayNormalized]),std([varsEA_A53T(:).avgMeanSpeedGolayNormalized]);...
    mean([varsEA_Control(:).avgStdSpeedGolayNormalized]),mean([varsEA_G2019S(:).avgStdSpeedGolayNormalized]),mean([varsEA_A53T(:).avgStdSpeedGolayNormalized]);...
    std([varsEA_Control(:).avgStdSpeedGolayNormalized]),std([varsEA_G2019S(:).avgStdSpeedGolayNormalized]),std([varsEA_A53T(:).avgStdSpeedGolayNormalized]);...
    mean([varsFreeNav_Control(:).avgMeanSpeedGolayNormalized]),mean([varsFreeNav_G2019S(:).avgMeanSpeedGolayNormalized]),mean([varsFreeNav_A53T(:).avgMeanSpeedGolayNormalized]);...
    std([varsFreeNav_Control(:).avgMeanSpeedGolayNormalized]),std([varsFreeNav_G2019S(:).avgMeanSpeedGolayNormalized]),std([varsFreeNav_A53T(:).avgMeanSpeedGolayNormalized]);...
    mean([varsFreeNav_Control(:).avgStdSpeedGolayNormalized]),mean([varsFreeNav_G2019S(:).avgStdSpeedGolayNormalized]),mean([varsFreeNav_A53T(:).avgStdSpeedGolayNormalized]);...
    std([varsFreeNav_Control(:).avgStdSpeedGolayNormalized]),std([varsFreeNav_G2019S(:).avgStdSpeedGolayNormalized]),std([varsFreeNav_A53T(:).avgStdSpeedGolayNormalized])];

tabSpeedNormLength = array2table(speedGroupedNormLength,'VariableNames',{'control','G2019S','A53T'},'RowNames',{'meanAvgMean_EA','stdAvgMean_EA','meanAvgStd_EA','stdAvgStd_EA','meanAvgMean_freeNav','stdAvgMean_freeNav','meanAvgStd_FreeNav','stdAvgStd_FreeNav'});


larvaeLength =[mean([varsEA_Control(:).averageLarvaeLength]),mean([varsEA_G2019S(:).averageLarvaeLength]),mean([varsEA_A53T(:).averageLarvaeLength]);...
    std([varsEA_Control(:).averageLarvaeLength]),std([varsEA_G2019S(:).averageLarvaeLength]),std([varsEA_A53T(:).averageLarvaeLength]);...
    mean([varsFreeNav_Control(:).averageLarvaeLength]),mean([varsFreeNav_G2019S(:).averageLarvaeLength]),mean([varsFreeNav_A53T(:).averageLarvaeLength]);...
    std([varsFreeNav_Control(:).averageLarvaeLength]),std([varsFreeNav_G2019S(:).averageLarvaeLength]),std([varsFreeNav_A53T(:).averageLarvaeLength])];

tabLarvaeLength = array2table(larvaeLength,'VariableNames',{'control','G2019S','A53T'},'RowNames',{'meanAvgMean_EA','stdAvgMean_EA','meanAvgMean_freeNav','stdAvgMean_freeNav'});


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


% %%% TABLES SPEEDS / ORIENTATION
% speedPerOrientationGrouped = [[mean(cat(3,varsEA_Control(:).avgSpeedPerOrientation),3),mean(cat(3,varsEA_G2019S(:).avgSpeedPerOrientation),3),mean(cat(3,varsEA_A53T(:).avgSpeedPerOrientation),3)];...
%     [mean(cat(3,varsFreeNav_Control(:).avgSpeedPerOrientation),3),mean(cat(3,varsFreeNav_G2019S(:).avgSpeedPerOrientation),3),mean(cat(3,varsFreeNav_A53T(:).avgSpeedPerOrientation),3)];...
%     [std(cat(3,varsEA_Control(:).avgSpeedPerOrientation),[],3),std(cat(3,varsEA_G2019S(:).avgSpeedPerOrientation),[],3),std(cat(3,varsEA_A53T(:).avgSpeedPerOrientation),[],3)];...
%     [std(cat(3,varsFreeNav_Control(:).avgSpeedPerOrientation),[],3),std(cat(3,varsFreeNav_G2019S(:).avgSpeedPerOrientation),[],3),std(cat(3,varsFreeNav_A53T(:).avgSpeedPerOrientation),[],3)];...
%     [mean(cat(3,varsEA_Control(:).stdSpeedPerOrientation),3),mean(cat(3,varsEA_G2019S(:).stdSpeedPerOrientation),3),mean(cat(3,varsEA_A53T(:).stdSpeedPerOrientation),3)];...
%     [mean(cat(3,varsFreeNav_Control(:).stdSpeedPerOrientation),3),mean(cat(3,varsFreeNav_G2019S(:).stdSpeedPerOrientation),3),mean(cat(3,varsFreeNav_A53T(:).stdSpeedPerOrientation),3)];...
%     [std(cat(3,varsEA_Control(:).stdSpeedPerOrientation),[],3),std(cat(3,varsEA_G2019S(:).stdSpeedPerOrientation),[],3),std(cat(3,varsEA_A53T(:).stdSpeedPerOrientation),[],3)];...
%     [std(cat(3,varsFreeNav_Control(:).stdSpeedPerOrientation),[],3),std(cat(3,varsFreeNav_G2019S(:).stdSpeedPerOrientation),[],3),std(cat(3,varsFreeNav_A53T(:).stdSpeedPerOrientation),[],3)]];
% 
% tabSpeedOrientation =array2table(speedPerOrientationGrouped,'VariableNames',{'control_left','control_right','control_top','control_bottom','G2019S_left','G2019S_right','G2019S_top','G2019S_bottom','A53T_left','A53T_right','A53T_top','A53T_bottom'},'RowNames',{'meanAvg_EA','meanAvg_FreeNav','stdAvg_EA','stdAvg_FreeNav','meanStd_EA','meanStd_FreeNav','stdStd_EA','stdStd_FreeNav'});
% 
% 
% angularSpeedPerOrientationGrouped = [[mean(cat(3,varsEA_Control(:).avgAngularSpeedPerOrientation),3),mean(cat(3,varsEA_G2019S(:).avgAngularSpeedPerOrientation),3),mean(cat(3,varsEA_A53T(:).avgAngularSpeedPerOrientation),3)];...
%     [mean(cat(3,varsFreeNav_Control(:).avgAngularSpeedPerOrientation),3),mean(cat(3,varsFreeNav_G2019S(:).avgAngularSpeedPerOrientation),3),mean(cat(3,varsFreeNav_A53T(:).avgAngularSpeedPerOrientation),3)];...
%     [std(cat(3,varsEA_Control(:).avgAngularSpeedPerOrientation),[],3),std(cat(3,varsEA_G2019S(:).avgAngularSpeedPerOrientation),[],3),std(cat(3,varsEA_A53T(:).avgAngularSpeedPerOrientation),[],3)];...
%     [std(cat(3,varsFreeNav_Control(:).avgAngularSpeedPerOrientation),[],3),std(cat(3,varsFreeNav_G2019S(:).avgAngularSpeedPerOrientation),[],3),std(cat(3,varsFreeNav_A53T(:).avgAngularSpeedPerOrientation),[],3)];...
%     [mean(cat(3,varsEA_Control(:).stdAngularSpeedPerOrientation),3),mean(cat(3,varsEA_G2019S(:).stdAngularSpeedPerOrientation),3),mean(cat(3,varsEA_A53T(:).stdAngularSpeedPerOrientation),3)];...
%     [mean(cat(3,varsFreeNav_Control(:).stdAngularSpeedPerOrientation),3),mean(cat(3,varsFreeNav_G2019S(:).stdAngularSpeedPerOrientation),3),mean(cat(3,varsFreeNav_A53T(:).stdAngularSpeedPerOrientation),3)];...
%     [std(cat(3,varsEA_Control(:).stdAngularSpeedPerOrientation),[],3),std(cat(3,varsEA_G2019S(:).stdAngularSpeedPerOrientation),[],3),std(cat(3,varsEA_A53T(:).stdAngularSpeedPerOrientation),[],3)];...
%     [std(cat(3,varsFreeNav_Control(:).stdAngularSpeedPerOrientation),[],3),std(cat(3,varsFreeNav_G2019S(:).stdAngularSpeedPerOrientation),[],3),std(cat(3,varsFreeNav_A53T(:).stdAngularSpeedPerOrientation),[],3)]];
% 
% tabAngularSpeedOrientation =array2table(angularSpeedPerOrientationGrouped,'VariableNames',{'control_left','control_right','control_top','control_bottom','G2019S_left','G2019S_right','G2019S_top','G2019S_bottom','A53T_left','A53T_right','A53T_top','A53T_bottom'},'RowNames',{'meanAvg_EA','meanAvg_FreeNav','stdAvg_EA','stdAvg_FreeNav','meanStd_EA','meanStd_FreeNav','stdStd_EA','stdStd_FreeNav'});
 

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
orientationPriorAfterTurningGrouped = [[mean(cat(3,varsEA_Control(:).propOrientationPriorTurning),3),mean(cat(3,varsEA_G2019S(:).propOrientationPriorTurning),3),mean(cat(3,varsEA_A53T(:).propOrientationPriorTurning),3)];...
[mean(cat(3,varsFreeNav_Control(:).propOrientationPriorTurning),3),mean(cat(3,varsFreeNav_G2019S(:).propOrientationPriorTurning),3),mean(cat(3,varsFreeNav_A53T(:).propOrientationPriorTurning),3)];...
[std(cat(3,varsEA_Control(:).propOrientationPriorTurning),[],3),std(cat(3,varsEA_G2019S(:).propOrientationPriorTurning),[],3),std(cat(3,varsEA_A53T(:).propOrientationPriorTurning),[],3)];...
[std(cat(3,varsFreeNav_Control(:).propOrientationPriorTurning),[],3),std(cat(3,varsFreeNav_G2019S(:).propOrientationPriorTurning),[],3),std(cat(3,varsFreeNav_A53T(:).propOrientationPriorTurning),[],3)];...
[mean(cat(3,varsEA_Control(:).propOrientationAfterTurning),3),mean(cat(3,varsEA_G2019S(:).propOrientationAfterTurning),3),mean(cat(3,varsEA_A53T(:).propOrientationAfterTurning),3)];...
[mean(cat(3,varsFreeNav_Control(:).propOrientationAfterTurning),3),mean(cat(3,varsFreeNav_G2019S(:).propOrientationAfterTurning),3),mean(cat(3,varsFreeNav_A53T(:).propOrientationAfterTurning),3)];...
[std(cat(3,varsEA_Control(:).propOrientationAfterTurning),[],3),std(cat(3,varsEA_G2019S(:).propOrientationAfterTurning),[],3),std(cat(3,varsEA_A53T(:).propOrientationAfterTurning),[],3)];...
[std(cat(3,varsFreeNav_Control(:).propOrientationAfterTurning),[],3),std(cat(3,varsFreeNav_G2019S(:).propOrientationAfterTurning),[],3),std(cat(3,varsFreeNav_A53T(:).propOrientationAfterTurning),[],3)]];

tabOrientationPriorAfterTurning=array2table(orientationPriorAfterTurningGrouped,'VariableNames',{'control_left','control_right','control_top','control_bottom','G2019S_left','G2019S_right','G2019S_top','G2019S_bottom','A53T_left','A53T_right','A53T_top','A53T_bottom'},'RowNames',{'priorCastingMean_EA','priorCastingMean_FreeNav','priorCastingStd_EA','priorCastingStd_FreeNav','afterCastingMean_EA','afterCastingMean_FreeNav','afterCastingStd_EA','afterCastingStd_FreeNav'});

end