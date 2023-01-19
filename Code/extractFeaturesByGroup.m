
%% Extract the information from all experiments
clear all
close all

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
avgSpeedPerOrientation= cell(size(totalDirectories,1),1);
stdSpeedPerOrientation= cell(size(totalDirectories,1),1);
avgSpeed085PerOrientation= cell(size(totalDirectories,1),1);
stdSpeed085PerOrientation= cell(size(totalDirectories,1),1);
meanAngularSpeedPerT= cell(size(totalDirectories,1),1);
stdAngularSpeedPerT= cell(size(totalDirectories,1),1);
avgMeanAngularSpeed= zeros(size(totalDirectories,1),1);
avgStdAngularSpeed= zeros(size(totalDirectories,1),1);
angularSpeed= cell(size(totalDirectories,1),1);
avgAngularSpeedPerOrientation= cell(size(totalDirectories,1),1);
stdAngularSpeedPerOrientation= cell(size(totalDirectories,1),1);




for nDir=1:size(totalDirectories,1)

    try

        [navigationIndex_Xaxis(nDir),navigationIndex_Yaxis(nDir),propLarvInAnglGroup{nDir},matrixProbOrientation{nDir},transitionMatrixOrientation{nDir},binsXdistributionInitEnd{nDir},...
        avgSpeedRoundT{nDir}, stdSpeedRoundT{nDir}, semSpeedRoundT{nDir},avgMeanSpeed(nDir),avgStdSpeed(nDir),avgSemSpeed(nDir),...
        avgSpeed085RoundT{nDir}, stdSpeed085RoundT{nDir}, semSpeed085RoundT{nDir},avgMeanSpeed085(nDir),avgStdSpeed085(nDir),avgSemSpeed085(nDir),...
        avgSpeedPerOrientation{nDir},stdSpeedPerOrientation{nDir},avgSpeed085PerOrientation{nDir},stdSpeed085PerOrientation{nDir},...
        meanAngularSpeedPerT{nDir},stdAngularSpeedPerT{nDir},avgMeanAngularSpeed(nDir),avgStdAngularSpeed(nDir),angularSpeed{nDir},...
        avgAngularSpeedPerOrientation{nDir},stdAngularSpeedPerOrientation{nDir}]=extractFeaturesPerExperiment(fullfile(totalDirectories(nDir).folder,totalDirectories(nDir).name));
    catch
         disp(['error in ' fullfile(totalDirectories(nDir).folder,totalDirectories(nDir).name) ]);
    end
end


%% GROUP DATA

%%% TABLE WITH TRANSITION MATRIX (4 x 12)
groupedMeanTransitionMatrix =[mean(cat(3,transitionMatrixOrientation{intersect(idsEA,idsTH)}),3),mean(cat(3,transitionMatrixOrientation{intersect(idsEA,idsG2019S)}),3),mean(cat(3,transitionMatrixOrientation{intersect(idsEA,idsA53T)}),3);
    mean(cat(3,transitionMatrixOrientation{intersect(idsFreeNav,idsTH)}),3),mean(cat(3,transitionMatrixOrientation{intersect(idsFreeNav,idsG2019S)}),3),mean(cat(3,transitionMatrixOrientation{intersect(idsFreeNav,idsA53T)}),3)];

tabMeanTransitionMatrix=array2table(groupedMeanTransitionMatrix,'VariableNames',{'control_left','control_right','control_top','control_bottom','G2019S_left','G2019S_right','G2019S_top','G2019S_bottom','A53T_left','A53T_right','A53T_top','A53T_bottom'},'RowNames',...
    {'left_Odor','right_Odor','top_Odor','bottom_Odor','left_FreeNav','right_FreeNav','top_FreeNav','bottom_FreeNav'});

groupedStdTransitionMatrix =[std(cat(3,transitionMatrixOrientation{intersect(idsEA,idsTH)}),[],3),std(cat(3,transitionMatrixOrientation{intersect(idsEA,idsG2019S)}),[],3),std(cat(3,transitionMatrixOrientation{intersect(idsEA,idsA53T)}),[],3);
    std(cat(3,transitionMatrixOrientation{intersect(idsFreeNav,idsTH)}),[],3),std(cat(3,transitionMatrixOrientation{intersect(idsFreeNav,idsG2019S)}),[],3),std(cat(3,transitionMatrixOrientation{intersect(idsFreeNav,idsA53T)}),[],3)];

tabStdTransitionMatrix=array2table(groupedStdTransitionMatrix,'VariableNames',{'control_left','control_right','control_top','control_bottom','G2019S_left','G2019S_right','G2019S_top','G2019S_bottom','A53T_left','A53T_right','A53T_top','A53T_bottom'},'RowNames',...
    {'left_Odor','right_Odor','top_Odor','bottom_Odor','left_FreeNav','right_FreeNav','top_FreeNav','bottom_FreeNav'});


%%% TABLES WITH SPEEDS (angular, speed and speed085)
angularSpeedGrouped =[mean(avgMeanAngularSpeed(intersect(idsEA,idsTH))),mean(avgMeanAngularSpeed(intersect(idsEA,idsG2019S))),mean(avgMeanAngularSpeed(intersect(idsEA,idsA53T)));...
    std(avgMeanAngularSpeed(intersect(idsEA,idsTH))),std(avgMeanAngularSpeed(intersect(idsEA,idsG2019S))),std(avgMeanAngularSpeed(intersect(idsEA,idsA53T)));...
    mean(avgStdAngularSpeed(intersect(idsEA,idsTH))),mean(avgStdAngularSpeed(intersect(idsEA,idsG2019S))),mean(avgStdAngularSpeed(intersect(idsEA,idsA53T)));...
    std(avgStdAngularSpeed(intersect(idsEA,idsTH))),std(avgStdAngularSpeed(intersect(idsEA,idsG2019S))),std(avgStdAngularSpeed(intersect(idsEA,idsA53T)));...
    mean(avgMeanAngularSpeed(intersect(idsFreeNav,idsTH))),mean(avgMeanAngularSpeed(intersect(idsFreeNav,idsG2019S))),mean(avgMeanAngularSpeed(intersect(idsFreeNav,idsA53T)));...
    std(avgMeanAngularSpeed(intersect(idsFreeNav,idsTH))),std(avgMeanAngularSpeed(intersect(idsFreeNav,idsG2019S))),std(avgMeanAngularSpeed(intersect(idsFreeNav,idsA53T)));...
    mean(avgStdAngularSpeed(intersect(idsFreeNav,idsTH))),mean(avgStdAngularSpeed(intersect(idsFreeNav,idsG2019S))),mean(avgStdAngularSpeed(intersect(idsFreeNav,idsA53T)));...
    std(avgStdAngularSpeed(intersect(idsFreeNav,idsTH))),std(avgStdAngularSpeed(intersect(idsFreeNav,idsG2019S))),std(avgStdAngularSpeed(intersect(idsFreeNav,idsA53T)))];

tabAngSpeed = array2table(angularSpeedGrouped,'VariableNames',{'control','G2019S','A53T'},'RowNames',{'meanAvgMean_Odor','stdAvgMean_Odor','meanAvgStd_Odor','stdAvgStd_Odor','meanAvgMean_freeNav','stdAvgMean_freeNav','meanAvgStd_FreeNav','stdAvgStd_FreeNav'});


speedGrouped =[mean(avgMeanSpeed(intersect(idsEA,idsTH))),mean(avgMeanSpeed(intersect(idsEA,idsG2019S))),mean(avgMeanSpeed(intersect(idsEA,idsA53T)));...
    std(avgMeanSpeed(intersect(idsEA,idsTH))),std(avgMeanSpeed(intersect(idsEA,idsG2019S))),std(avgMeanSpeed(intersect(idsEA,idsA53T)));...
    mean(avgStdSpeed(intersect(idsEA,idsTH))),mean(avgStdSpeed(intersect(idsEA,idsG2019S))),mean(avgStdSpeed(intersect(idsEA,idsA53T)));...
    std(avgStdSpeed(intersect(idsEA,idsTH))),std(avgStdSpeed(intersect(idsEA,idsG2019S))),std(avgStdSpeed(intersect(idsEA,idsA53T)));...
    mean(avgMeanSpeed(intersect(idsFreeNav,idsTH))),mean(avgMeanSpeed(intersect(idsFreeNav,idsG2019S))),mean(avgMeanSpeed(intersect(idsFreeNav,idsA53T)));...
    std(avgMeanSpeed(intersect(idsFreeNav,idsTH))),std(avgMeanSpeed(intersect(idsFreeNav,idsG2019S))),std(avgMeanSpeed(intersect(idsFreeNav,idsA53T)));...
    mean(avgStdSpeed(intersect(idsFreeNav,idsTH))),mean(avgStdSpeed(intersect(idsFreeNav,idsG2019S))),mean(avgStdSpeed(intersect(idsFreeNav,idsA53T)));...
    std(avgStdSpeed(intersect(idsFreeNav,idsTH))),std(avgStdSpeed(intersect(idsFreeNav,idsG2019S))),std(avgStdSpeed(intersect(idsFreeNav,idsA53T)))];

tabSpeed = array2table(speedGrouped,'VariableNames',{'control','G2019S','A53T'},'RowNames',{'meanAvgMean_Odor','stdAvgMean_Odor','meanAvgStd_Odor','stdAvgStd_Odor','meanAvgMean_freeNav','stdAvgMean_freeNav','meanAvgStd_FreeNav','stdAvgStd_FreeNav'});


speed085Grouped =[mean(avgMeanSpeed(intersect(idsEA,idsTH))),mean(avgMeanSpeed085(intersect(idsEA,idsG2019S))),mean(avgMeanSpeed085(intersect(idsEA,idsA53T)));...
    std(avgMeanSpeed085(intersect(idsEA,idsTH))),std(avgMeanSpeed085(intersect(idsEA,idsG2019S))),std(avgMeanSpeed085(intersect(idsEA,idsA53T)));...
    mean(avgStdSpeed085(intersect(idsEA,idsTH))),mean(avgStdSpeed085(intersect(idsEA,idsG2019S))),mean(avgStdSpeed085(intersect(idsEA,idsA53T)));...
    std(avgStdSpeed085(intersect(idsEA,idsTH))),std(avgStdSpeed085(intersect(idsEA,idsG2019S))),std(avgStdSpeed085(intersect(idsEA,idsA53T)));...
    mean(avgMeanSpeed085(intersect(idsFreeNav,idsTH))),mean(avgMeanSpeed085(intersect(idsFreeNav,idsG2019S))),mean(avgMeanSpeed085(intersect(idsFreeNav,idsA53T)));...
    std(avgMeanSpeed085(intersect(idsFreeNav,idsTH))),std(avgMeanSpeed085(intersect(idsFreeNav,idsG2019S))),std(avgMeanSpeed085(intersect(idsFreeNav,idsA53T)));...
    mean(avgStdSpeed085(intersect(idsFreeNav,idsTH))),mean(avgStdSpeed085(intersect(idsFreeNav,idsG2019S))),mean(avgStdSpeed085(intersect(idsFreeNav,idsA53T)));...
    std(avgStdSpeed085(intersect(idsFreeNav,idsTH))),std(avgStdSpeed085(intersect(idsFreeNav,idsG2019S))),std(avgStdSpeed085(intersect(idsFreeNav,idsA53T)))];

tabSpeed085 = array2table(speed085Grouped,'VariableNames',{'control','G2019S','A53T'},'RowNames',{'meanAvgMean_Odor','stdAvgMean_Odor','meanAvgStd_Odor','stdAvgStd_Odor','meanAvgMean_freeNav','stdAvgMean_freeNav','meanAvgStd_FreeNav','stdAvgStd_FreeNav'});


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
avgSpeedPerOrientation;
avgSpeed085PerOrientation;
avgAngularSpeedPerOrientation;


%% PLOT speed / time
avgSpeedRoundT;
semSpeed085RoundT;

avgSpeed085RoundT;
semSpeed085RoundT;

meanAngularSpeedPerT;
stdAngularSpeedPerT;

%% PLOT bins distribution init & end
binsXdistributionInitEnd;
