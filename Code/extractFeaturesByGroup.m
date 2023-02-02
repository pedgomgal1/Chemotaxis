
%% Extract the information from all experiments
clear all
close all

addpath(genpath('lib'))

experiments = {'n_1ul1000EA_600s@n','n_freeNavigation_600s@n'};
genotypes = {'thG@Uempty','thG@UG2019S','thG@UaSynA53T'};

path2search1=dir(fullfile('..','Choreography_results','**',genotypes{1},'**',experiments{1},'2022*'));
path2search2=dir(fullfile('..','Choreography_results','**',genotypes{2},'**',experiments{1},'2022*'));
path2search3=dir(fullfile('..','Choreography_results','**',genotypes{3},'**',experiments{1},'2022*'));

path2search4=dir(fullfile('..','Choreography_results','**',genotypes{1},'**',experiments{2},'2022*'));
path2search5=dir(fullfile('..','Choreography_results','**',genotypes{2},'**',experiments{2},'2022*'));
path2search6=dir(fullfile('..','Choreography_results','**',genotypes{3},'**',experiments{2},'2022*'));

totalDirectories=[path2search1;path2search2;path2search3;path2search4;path2search5;path2search6];
idsEA = 1:size([path2search1;path2search2;path2search3]);
idsFreeNav = length(idsEA)+1:size(totalDirectories,1);
idsTH=[1:size(path2search1,1),size([path2search1;path2search2;path2search3],1)+1:size([path2search1;path2search2;path2search3;path2search4],1)];
idsG2019S=[size(path2search1,1)+1:size([path2search1;path2search2],1),size([path2search1;path2search2;path2search3;path2search4],1)+1:size([path2search1;path2search2;path2search3;path2search4;path2search5],1)];
idsA53T=[size([path2search1;path2search2],1)+1:size([path2search1;path2search2;path2search3],1),size([path2search1;path2search2;path2search3;path2search4;path2search5],1)+1:size(totalDirectories,1)];



navigationIndex_Xaxis = zeros(size(totalDirectories,1),1);
navigationIndex_Yaxis = zeros(size(totalDirectories,1),1);
propLarvInAnglGroup = cell(size(totalDirectories,1),1);
matrixProbOrientation = cell(size(totalDirectories,1),1);
transitionMatrixOrientation = cell(size(totalDirectories,1),1);
binsXdistributionInitEnd= cell(size(totalDirectories,1),1);
avgSpeedRoundT= cell(size(totalDirectories,1),1);
stdSpeedRoundT= cell(size(totalDirectories,1),1);
semSpeedRoundT= cell(size(totalDirectories,1),1);
avgMeanSpeed= zeros(size(totalDirectories,1),1);
avgStdSpeed= zeros(size(totalDirectories,1),1);
avgSemSpeed= zeros(size(totalDirectories,1),1);
avgSpeed085RoundT= cell(size(totalDirectories,1),1);
stdSpeed085RoundT= cell(size(totalDirectories,1),1);
semSpeed085RoundT= cell(size(totalDirectories,1),1);
avgMeanSpeed085= zeros(size(totalDirectories,1),1);
avgStdSpeed085= zeros(size(totalDirectories,1),1);
avgSemSpeed085= zeros(size(totalDirectories,1),1);

avgCrabSpeedRoundT= cell(size(totalDirectories,1),1);
stdCrabSpeedRoundT= cell(size(totalDirectories,1),1); 
semCrabSpeedRoundT= cell(size(totalDirectories,1),1);
avgMeanCrabSpeed= zeros(size(totalDirectories,1),1);
avgStdCrabSpeed= zeros(size(totalDirectories,1),1);
avgSemCrabSpeed= zeros(size(totalDirectories,1),1);

avgAreaRoundT= cell(size(totalDirectories,1),1);
stdAreaRoundT= cell(size(totalDirectories,1),1);
semAreaRoundT= cell(size(totalDirectories,1),1);
avgMeanArea=zeros(size(totalDirectories,1),1);
avgStdArea=zeros(size(totalDirectories,1),1);
avgSemArea=zeros(size(totalDirectories,1),1);

avgCurveRoundT= cell(size(totalDirectories,1),1);
stdCurveRoundT= cell(size(totalDirectories,1),1);
semCurveRoundT= cell(size(totalDirectories,1),1);
avgMeanCurve=zeros(size(totalDirectories,1),1);
avgStdCurve=zeros(size(totalDirectories,1),1);
avgSemCurve=zeros(size(totalDirectories,1),1);

avgSpeedPerOrientation= cell(size(totalDirectories,1),1);
stdSpeedPerOrientation= cell(size(totalDirectories,1),1);
avgSpeed085PerOrientation= cell(size(totalDirectories,1),1);
stdSpeed085PerOrientation= cell(size(totalDirectories,1),1);

avgCrabSpeedPerOrientation= cell(size(totalDirectories,1),1);
stdCrabSpeedPerOrientation= cell(size(totalDirectories,1),1);
avgCurvePerOrientation= cell(size(totalDirectories,1),1);
stdCurvePerOrientation= cell(size(totalDirectories,1),1);

meanAngularSpeedPerT= cell(size(totalDirectories,1),1);
stdAngularSpeedPerT= cell(size(totalDirectories,1),1);
semAngularSpeedPerT= cell(size(totalDirectories,1),1);
avgMeanAngularSpeed= zeros(size(totalDirectories,1),1);
avgStdAngularSpeed= zeros(size(totalDirectories,1),1);
avgSemAngularSpeed= zeros(size(totalDirectories,1),1);
angularSpeed= cell(size(totalDirectories,1),1);
avgAngularSpeedPerOrientation= cell(size(totalDirectories,1),1);
stdAngularSpeedPerOrientation= cell(size(totalDirectories,1),1);

matrixProbMotionStates= cell(size(totalDirectories,1),1);
transitionMatrixMotionStates= cell(size(totalDirectories,1),1);

runRatePerOrient= cell(size(totalDirectories,1),1);
stopRatePerOrient= cell(size(totalDirectories,1),1);
turningRatePerOrient= cell(size(totalDirectories,1),1);

tableSummaryFeatures = cell(size(totalDirectories,1),1);

for nDir=1:size(totalDirectories,1)

    try
        [navigationIndex_Xaxis(nDir),navigationIndex_Yaxis(nDir),propLarvInAnglGroup{nDir},matrixProbOrientation{nDir},transitionMatrixOrientation{nDir},matrixProbMotionStates{nDir},transitionMatrixMotionStates{nDir},binsXdistributionInitEnd{nDir},...
        avgSpeedRoundT{nDir}, stdSpeedRoundT{nDir}, semSpeedRoundT{nDir},avgMeanSpeed(nDir),avgStdSpeed(nDir),avgSemSpeed(nDir),...
        avgSpeed085RoundT{nDir}, stdSpeed085RoundT{nDir}, semSpeed085RoundT{nDir},avgMeanSpeed085(nDir),avgStdSpeed085(nDir),avgSemSpeed085(nDir),...
        avgCrabSpeedRoundT{nDir}, stdCrabSpeedRoundT{nDir}, semCrabSpeedRoundT{nDir},avgMeanCrabSpeed(nDir),avgStdCrabSpeed(nDir),avgSemCrabSpeed(nDir),...
        avgAreaRoundT{nDir}, stdAreaRoundT{nDir}, semAreaRoundT{nDir},avgMeanArea(nDir),avgStdArea(nDir),avgSemArea(nDir),...
        avgCurveRoundT{nDir}, stdCurveRoundT{nDir}, semCurveRoundT{nDir},avgMeanCurve(nDir),avgStdCurve(nDir),avgSemCurve(nDir),...
        avgSpeedPerOrientation{nDir},stdSpeedPerOrientation{nDir},avgSpeed085PerOrientation{nDir},stdSpeed085PerOrientation{nDir},...       
        avgCrabSpeedPerOrientation{nDir},stdCrabSpeedPerOrientation{nDir},avgCurvePerOrientation{nDir},stdCurvePerOrientation{nDir},...
        meanAngularSpeedPerT{nDir},stdAngularSpeedPerT{nDir},semAngularSpeedPerT{nDir},avgMeanAngularSpeed(nDir),avgSemAngularSpeed(nDir),avgStdAngularSpeed(nDir),angularSpeed{nDir},...
        avgAngularSpeedPerOrientation{nDir},stdAngularSpeedPerOrientation{nDir},runRatePerOrient{nDir},stopRatePerOrient{nDir},turningRatePerOrient{nDir},tableSummaryFeatures{nDir}]=extractFeaturesPerExperiment(fullfile(totalDirectories(nDir).folder,totalDirectories(nDir).name));
        
    catch
         disp(['error in ' fullfile(totalDirectories(nDir).folder,totalDirectories(nDir).name) ]);
    end
end

%% GROUP DATA

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


%% Transition matrix motion - stop - run states

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
    "RowNames",{'average_EA','std_EA','average_FreeNav','std_FreeNav'},'VariableNames',{'run_Control','stop_Control','turn_Control','run_G2019S','stop_G2019S','turn_G2019S','run_A53T','stop_A53T','turn_A53T'});


%%% TABLE WITH TRANSITION MATRIX (8 x 12)
groupedMeanTransitionMatrixMov =[mean(cat(3,transitionMatrixMotionStates{intersect(idsEA,idsTH)}),3),mean(cat(3,transitionMatrixMotionStates{intersect(idsEA,idsG2019S)}),3),mean(cat(3,transitionMatrixMotionStates{intersect(idsEA,idsA53T)}),3);
    mean(cat(3,transitionMatrixMotionStates{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,transitionMatrixMotionStates{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,transitionMatrixMotionStates{intersect(idsFreeNav,idsA53T)}),3)];

tabMeanTransitionMatrixMov=array2table(groupedMeanTransitionMatrixMov,'VariableNames',{'control_run','control_stop','control_turn','G2019S_run','G2019S_stop','G2019S_turn','A53T_run','A53T_stop','A53T_turn'},'RowNames',...
    {'run_EA','stop_EA','turn_EA','run_FreeNav','stop_FreeNav','turn_FreeNav'});


%table running states per orientation
groupedMovStatePerOrientation = [mean(cat(3,runRatePerOrient{intersect(idsEA,idsTH)}),3),mean(cat(3,runRatePerOrient{intersect(idsEA,idsG2019S)}),3),mean(cat(3,runRatePerOrient{intersect(idsEA,idsA53T)}),3);...
    mean(cat(3,stopRatePerOrient{intersect(idsEA,idsTH)}),3),mean(cat(3,stopRatePerOrient{intersect(idsEA,idsG2019S)}),3),mean(cat(3,stopRatePerOrient{intersect(idsEA,idsA53T)}),3);...
    mean(cat(3,turningRatePerOrient{intersect(idsEA,idsTH)}),3),mean(cat(3,turningRatePerOrient{intersect(idsEA,idsG2019S)}),3),mean(cat(3,turningRatePerOrient{intersect(idsEA,idsA53T)}),3);...
    mean(cat(3,runRatePerOrient{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,runRatePerOrient{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,runRatePerOrient{intersect(idsFreeNav,idsA53T)}),3);...
    mean(cat(3,stopRatePerOrient{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,stopRatePerOrient{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,stopRatePerOrient{intersect(idsFreeNav,idsA53T)}),3);
    mean(cat(3,turningRatePerOrient{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,turningRatePerOrient{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,turningRatePerOrient{intersect(idsFreeNav,idsA53T)}),3)];

tabMovRatePerOrient=array2table(groupedMovStatePerOrientation,'VariableNames',{'control_left','control_right','control_top','control_bottom','G2019S_left','G2019S_right','G2019S_top','G2019S_bottom','A53T_left','A53T_right','A53T_top','A53T_bottom'},'RowNames',...
    {'run_EA','stop_EA','turn_EA','run_FreeNav','stop_FreeNav','turn_FreeNav'});


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


speed085Grouped =[mean(avgMeanSpeed085(intersect(idsEA,idsTH))),mean(avgMeanSpeed085(intersect(idsEA,idsG2019S))),mean(avgMeanSpeed085(intersect(idsEA,idsA53T)));...
    std(avgMeanSpeed085(intersect(idsEA,idsTH))),std(avgMeanSpeed085(intersect(idsEA,idsG2019S))),std(avgMeanSpeed085(intersect(idsEA,idsA53T)));...
    mean(avgStdSpeed085(intersect(idsEA,idsTH))),mean(avgStdSpeed085(intersect(idsEA,idsG2019S))),mean(avgStdSpeed085(intersect(idsEA,idsA53T)));...
    std(avgStdSpeed085(intersect(idsEA,idsTH))),std(avgStdSpeed085(intersect(idsEA,idsG2019S))),std(avgStdSpeed085(intersect(idsEA,idsA53T)));...
    mean(avgMeanSpeed085(intersect(idsFreeNav,idsTH))),mean(avgMeanSpeed085(intersect(idsFreeNav,idsG2019S))),mean(avgMeanSpeed085(intersect(idsFreeNav,idsA53T)));...
    std(avgMeanSpeed085(intersect(idsFreeNav,idsTH))),std(avgMeanSpeed085(intersect(idsFreeNav,idsG2019S))),std(avgMeanSpeed085(intersect(idsFreeNav,idsA53T)));...
    mean(avgStdSpeed085(intersect(idsFreeNav,idsTH))),mean(avgStdSpeed085(intersect(idsFreeNav,idsG2019S))),mean(avgStdSpeed085(intersect(idsFreeNav,idsA53T)));...
    std(avgStdSpeed085(intersect(idsFreeNav,idsTH))),std(avgStdSpeed085(intersect(idsFreeNav,idsG2019S))),std(avgStdSpeed085(intersect(idsFreeNav,idsA53T)))];

tabSpeed085 = array2table(speed085Grouped,'VariableNames',{'control','G2019S','A53T'},'RowNames',{'meanAvgMean_EA','stdAvgMean_EA','meanAvgStd_EA','stdAvgStd_EA','meanAvgMean_freeNav','stdAvgMean_freeNav','meanAvgStd_FreeNav','stdAvgStd_FreeNav'});

crabSpeedGrouped =[mean(avgMeanCrabSpeed(intersect(idsEA,idsTH))),mean(avgMeanCrabSpeed(intersect(idsEA,idsG2019S))),mean(avgMeanCrabSpeed(intersect(idsEA,idsA53T)));...
    std(avgMeanCrabSpeed(intersect(idsEA,idsTH))),std(avgMeanCrabSpeed(intersect(idsEA,idsG2019S))),std(avgMeanCrabSpeed(intersect(idsEA,idsA53T)));...
    mean(avgStdCrabSpeed(intersect(idsEA,idsTH))),mean(avgStdCrabSpeed(intersect(idsEA,idsG2019S))),mean(avgStdCrabSpeed(intersect(idsEA,idsA53T)));...
    std(avgStdCrabSpeed(intersect(idsEA,idsTH))),std(avgStdCrabSpeed(intersect(idsEA,idsG2019S))),std(avgStdCrabSpeed(intersect(idsEA,idsA53T)));...
    mean(avgMeanCrabSpeed(intersect(idsFreeNav,idsTH))),mean(avgMeanCrabSpeed(intersect(idsFreeNav,idsG2019S))),mean(avgMeanCrabSpeed(intersect(idsFreeNav,idsA53T)));...
    std(avgMeanCrabSpeed(intersect(idsFreeNav,idsTH))),std(avgMeanCrabSpeed(intersect(idsFreeNav,idsG2019S))),std(avgMeanCrabSpeed(intersect(idsFreeNav,idsA53T)));...
    mean(avgStdCrabSpeed(intersect(idsFreeNav,idsTH))),mean(avgStdCrabSpeed(intersect(idsFreeNav,idsG2019S))),mean(avgStdCrabSpeed(intersect(idsFreeNav,idsA53T)));...
    std(avgStdCrabSpeed(intersect(idsFreeNav,idsTH))),std(avgStdCrabSpeed(intersect(idsFreeNav,idsG2019S))),std(avgStdCrabSpeed(intersect(idsFreeNav,idsA53T)))];

tabCrabSpeed = array2table(crabSpeedGrouped,'VariableNames',{'control','G2019S','A53T'},'RowNames',{'meanAvgMean_EA','stdAvgMean_EA','meanAvgStd_EA','stdAvgStd_EA','meanAvgMean_freeNav','stdAvgMean_freeNav','meanAvgStd_FreeNav','stdAvgStd_FreeNav'});

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


%   NAVIGATION INDEX


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

%% PLOT speed 085 (normalized by area) / time
h6 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
paintError=1;
avgSpeed085RoundTNormByArea = cellfun(@(x,y) x./y,avgSpeed085RoundT,avgAreaRoundT,'UniformOutput',false);
semSpeed085RoundTNormByArea = cellfun(@(x,y) x./y,semSpeed085RoundT,avgAreaRoundT,'UniformOutput',false);
subplot(1,2,1);hold on
plotSpeedVersusT(T,avgSpeed085RoundTNormByArea,semSpeed085RoundTNormByArea,idsEA,idsTH,idsG2019S,idsA53T,LineStyleEA,coloursEA,paintError)
legend({'','','','Control EA','G2019S EA','A53T EA'})
xlabel('Time (s)')
ylabel('Speed085 / area (mm/s)');
ylim([0.1 0.35])
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);

subplot(1,2,2);
plotSpeedVersusT(T,avgSpeed085RoundTNormByArea,semSpeed085RoundTNormByArea,idsFreeNav,idsTH,idsG2019S,idsA53T,LineStyleFreeN,coloursFreeN,paintError)
legend({'','','','Control FreeNav','G2019S FreeNav','A53T FreeNav'})
xlabel('Time (s)')
ylabel('Speed085 / area (mm/s)');
ylim([0.1 0.35])
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


%% PLOT bins distribution init & end
bins_MeanDist_control_EA = mean(cat(3,binsXdistributionInitEnd{intersect(idsEA,idsTH)}),3);
bins_MeanDist_G2019S_EA = mean(cat(3,binsXdistributionInitEnd{intersect(idsEA,idsG2019S)}),3);
bins_MeanDist_A53T_EA = mean(cat(3,binsXdistributionInitEnd{intersect(idsEA,idsA53T)}),3);
h8 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');

subplot(2,3,1);
bar (bins_MeanDist_control_EA)
ylabel('larvae proportion')
xlabel('left     center     right')
title('Control EA')
legend({'10 s','300  s', '590  s'})
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);

subplot(2,3,2);
bar (bins_MeanDist_G2019S_EA)
legend({'10 s','300  s', '590  s'})
ylabel('larvae proportion')
xlabel('left     center     right')
title('G2019 EA')
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);

subplot(2,3,3);
bar (bins_MeanDist_A53T_EA)
ylabel('larvae proportion')
xlabel('left     center     right')
legend({'10 s','300  s', '590  s'})
title('A53T EA')
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);


bins_MeanDist_control_FreeNav = mean(cat(3,binsXdistributionInitEnd{intersect(idsFreeNav,idsTH)}),3);
bins_MeanDist_G2019S_FreeNav = mean(cat(3,binsXdistributionInitEnd{intersect(idsFreeNav,idsG2019S)}),3);
bins_MeanDist_A53T_FreeNav = mean(cat(3,binsXdistributionInitEnd{intersect(idsFreeNav,idsA53T)}),3);

subplot(2,3,4);
bar (bins_MeanDist_control_FreeNav)
title('Control Free Navig')
legend({'10 s','300  s', '590  s'})
ylabel('larvae proportion')
xlabel('left     center     right')
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);

subplot(2,3,5);
bar (bins_MeanDist_G2019S_FreeNav)
legend({'10 s','300  s', '590  s'})
ylabel('larvae proportion')
xlabel('left     center     right')
set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);

title('G2019 Free Navig')
subplot(2,3,6);
bar (bins_MeanDist_A53T_FreeNav)
ylabel('larvae proportion')
legend({'10 s','300  s', '590  s'})
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
folder2save = fullfile('..','Results');

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
    print(h6,fullfile(folder2save,'Figures','speed085_normArea_vs_T.png'),'-dpng','-r300')
    savefig(h6,fullfile(folder2save,'Figures','speed085_normArea_vs_T.fig'))
    print(h7,fullfile(folder2save,'Figures','curve_vs_T.png'),'-dpng','-r300')
    savefig(h7,fullfile(folder2save,'Figures','curve_vs_T.fig'))
    print(h8,fullfile(folder2save,'Figures','distributionXaxis.png'),'-dpng','-r300')
    savefig(h8,fullfile(folder2save,'Figures','distributionXaxis.fig'))

end

clearvars -except folder2save tabCurveOrientation tabCrabSpeedOrientation tabSpeedOrientation tabAngularSpeedOrientation tabSpeed085Orientation tabNavigation tabMeanTransitionMatrixOrient tabMeanTransitionMatrixMov tabArea tabCurve tabSpeed tabCrabSpeed tabSpeed085 tabAngSpeed tabPercAngStates tabPercMovStates tabMovRatePerOrient

writetable(tabNavigation,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','NavIndex','Range','B2','WriteRowNames',true)

writetable(tabArea,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','Area','Range','B2','WriteRowNames',true)

writetable(tabSpeed,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','Speed','Range','B2','WriteRowNames',true)
writetable(tabSpeed085,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','Speed085','Range','B2','WriteRowNames',true)
writetable(tabCrabSpeed,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','CrabSpeed','Range','B2','WriteRowNames',true)
writetable(tabAngSpeed,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','AngSpeed','Range','B2','WriteRowNames',true)
writetable(tabCurve,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','Curve','Range','B2','WriteRowNames',true)

writetable(tabMeanTransitionMatrixOrient,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','TransitionMatrixOrientation','Range','B2','WriteRowNames',true)
writetable(tabMeanTransitionMatrixMov,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','TransitionMatrixMovStates','Range','B2','WriteRowNames',true)
writetable(tabPercAngStates,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','PercAngStates','Range','B2','WriteRowNames',true)
writetable(tabPercMovStates,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','PercMovStates','Range','B2','WriteRowNames',true)

writetable(tabMovRatePerOrient,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','RateMovStates','Range','B2','WriteRowNames',true)

writetable(tabSpeedOrientation,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','SpeedPerOrientation','Range','B2','WriteRowNames',true)
writetable(tabSpeed085Orientation,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','Speed085PerOrientation','Range','B2','WriteRowNames',true)
writetable(tabCrabSpeedOrientation,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','CrabSpeedPerOrientation','Range','B2','WriteRowNames',true)
writetable(tabAngularSpeedOrientation,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','AngSpeedPerOrientation','Range','B2','WriteRowNames',true)
writetable(tabCurveOrientation,fullfile(folder2save,'dataNavigation.xlsx'),'Sheet','CurvePerOrientation','Range','B2','WriteRowNames',true)



