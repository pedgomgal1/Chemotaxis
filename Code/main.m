
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

%% Extract features per experiment (or loading of precaptured features) 
allVars=cell(size(totalDirectories,1),1);
tableSummaryFeatures=cell(size(totalDirectories,1),1);

parfor nDir=1:size(totalDirectories,1)

    try
        allVars{nDir}=extractFeaturesPerExperiment(fullfile(totalDirectories(nDir).folder,totalDirectories(nDir).name));

    catch
        disp(['error in ' fullfile(totalDirectories(nDir).folder,totalDirectories(nDir).name) ]);
    end
end

varsEA_Control = vertcat(allVars{intersect(idsEA,idsTH)});
varsEA_A53T = vertcat(allVars{intersect(idsEA,idsA53T)});
varsEA_G2019S = vertcat(allVars{intersect(idsEA,idsG2019S)});
varsFreeNav_Control = vertcat(allVars{intersect(idsFreeNav,idsTH)});
varsFreeNav_A53T = vertcat(allVars{intersect(idsFreeNav,idsA53T)});
varsFreeNav_G2019S = vertcat(allVars{intersect(idsFreeNav,idsG2019S)});

%% PLOTS

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
        LineStyleEA='-'; T=0:600;

%%%% PLOT NAVIGATION INDEX %%%%

        minMax_Y_val = [-0.2, 0.5]; tickInterval=0.1;      
        h1 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
        %nav index
        subplot(3,2,1:2)
        chemotaxisData = {vertcat(varsEA_Control(:).navigationIndex_roundT),vertcat(varsEA_G2019S(:).navigationIndex_roundT),vertcat(varsEA_A53T(:).navigationIndex_roundT)};
        freeNavData = {vertcat(varsFreeNav_Control(:).navigationIndex_roundT),vertcat(varsFreeNav_G2019S(:).navigationIndex_roundT),vertcat(varsFreeNav_A53T(:).navigationIndex_roundT)};
        plotBoxChart(chemotaxisData,freeNavData,coloursEA,'',fontSizeFigure,fontNameFigure,'Navigation index');
        ylim(minMax_Y_val),yticks(minMax_Y_val(1):tickInterval:minMax_Y_val(2))
        legend('','','','','','','',phenotypes_name{1},'',phenotypes_name{2},'',phenotypes_name{3}),legend('Location','northwestoutside'),legend('boxoff')
        %abs. distance X axis
        subplot(3,2,3); minMax_Y_val = [-0.3, 0.7]; 
        chemotaxisDataX = {vertcat(varsEA_Control(:).distanceIndex_Xaxis_roundT),vertcat(varsEA_G2019S(:).distanceIndex_Xaxis_roundT),vertcat(varsEA_A53T(:).distanceIndex_Xaxis_roundT)};
        freeNavDataX = {vertcat(varsFreeNav_Control(:).distanceIndex_Xaxis_roundT),vertcat(varsFreeNav_G2019S(:).distanceIndex_Xaxis_roundT),vertcat(varsFreeNav_A53T(:).distanceIndex_Xaxis_roundT)};
        plotBoxChart(chemotaxisDataX,freeNavDataX,coloursEA,'',fontSizeFigure,fontNameFigure,'Distance index X axis');
        ylim(minMax_Y_val),yticks(minMax_Y_val(1):tickInterval:minMax_Y_val(2))
        %abs. distance Y axis
        subplot(3,2,4); 
        chemotaxisDataY = {vertcat(varsEA_Control(:).distanceIndex_Yaxis_roundT),vertcat(varsEA_G2019S(:).distanceIndex_Yaxis_roundT),vertcat(varsEA_A53T(:).distanceIndex_Yaxis_roundT)};
        freeNavDataY = {vertcat(varsFreeNav_Control(:).distanceIndex_Yaxis_roundT),vertcat(varsFreeNav_G2019S(:).distanceIndex_Yaxis_roundT),vertcat(varsFreeNav_A53T(:).distanceIndex_Yaxis_roundT)};
        plotBoxChart(chemotaxisDataY,freeNavDataY,coloursEA,'',fontSizeFigure,fontNameFigure,'Distance index Y axis');
        ylim(minMax_Y_val),yticks(minMax_Y_val(1):tickInterval:minMax_Y_val(2))


    %%%% PLOT bins distribution init & end
        num_indices = [1:3,5:7,9:11,13:15];
        bins_MeanDist_control_EA = mean(cat(3,varsEA_Control(:).binsXdistributionInitEnd),3);
        bins_MeanDist_G2019S_EA = mean(cat(3,varsEA_G2019S(:).binsXdistributionInitEnd),3);
        bins_MeanDist_A53T_EA = mean(cat(3,varsEA_A53T(:).binsXdistributionInitEnd),3);
        
        bins_stdDist_control_EA = std(cat(3,varsEA_Control(:).binsXdistributionInitEnd),[],3)/(sqrt(size(varsEA_Control,1)));
        bins_stdDist_G2019S_EA = std(cat(3,varsEA_G2019S(:).binsXdistributionInitEnd),[],3)/(sqrt(size(varsEA_G2019S,1)));
        bins_stdDist_A53T_EA = std(cat(3,varsEA_A53T(:).binsXdistributionInitEnd),[],3)/(sqrt(size(varsEA_A53T,1)));
        
        left_proportionsEA = [bins_MeanDist_control_EA(1,:);bins_MeanDist_G2019S_EA(1,:);bins_MeanDist_A53T_EA(1,:)];
        left_proportionsEA=left_proportionsEA(:);
        left_errorsEA = [bins_stdDist_control_EA(1,:);bins_stdDist_G2019S_EA(1,:);bins_stdDist_A53T_EA(1,:)];
        left_errorsEA=left_errorsEA(:);
        
        right_proportionsEA = [bins_MeanDist_control_EA(3,:);bins_MeanDist_G2019S_EA(3,:);bins_MeanDist_A53T_EA(3,:)];
        right_proportionsEA=right_proportionsEA(:);
        right_errorsEA = [bins_stdDist_control_EA(3,:);bins_stdDist_G2019S_EA(3,:);bins_stdDist_A53T_EA(3,:)];
        right_errorsEA=right_errorsEA(:);
        
        
        
        bins_MeanDist_control_FreeNav = mean(cat(3,varsFreeNav_Control(:).binsXdistributionInitEnd),3);
        bins_MeanDist_G2019S_FreeNav = mean(cat(3,varsFreeNav_G2019S(:).binsXdistributionInitEnd),3);
        bins_MeanDist_A53T_FreeNav = mean(cat(3,varsFreeNav_A53T(:).binsXdistributionInitEnd),3);
        
        bins_stdDist_control_FreeNav = std(cat(3,varsFreeNav_Control(:).binsXdistributionInitEnd),[],3)/(sqrt(size(varsFreeNav_Control,1)));
        bins_stdDist_G2019S_FreeNav = std(cat(3,varsFreeNav_G2019S(:).binsXdistributionInitEnd),[],3)/(sqrt(size(varsFreeNav_G2019S,1)));
        bins_stdDist_A53T_FreeNav = std(cat(3,varsFreeNav_A53T(:).binsXdistributionInitEnd),[],3)/(sqrt(size(varsFreeNav_A53T,1)));
        
        left_proportionsFreeNav = [bins_MeanDist_control_FreeNav(1,:);bins_MeanDist_G2019S_FreeNav(1,:);bins_MeanDist_A53T_FreeNav(1,:)];
        left_proportionsFreeNav=left_proportionsFreeNav(:);
        left_errorsFreeNav = [bins_stdDist_control_FreeNav(1,:);bins_stdDist_G2019S_FreeNav(1,:);bins_stdDist_A53T_FreeNav(1,:)];
        left_errorsFreeNav=left_errorsFreeNav(:);
        
        right_proportionsFreeNav = [bins_MeanDist_control_FreeNav(3,:);bins_MeanDist_G2019S_FreeNav(3,:);bins_MeanDist_A53T_FreeNav(3,:)];
        right_proportionsFreeNav=right_proportionsFreeNav(:);
        right_errorsFreeNav = [bins_stdDist_control_FreeNav(3,:);bins_stdDist_G2019S_FreeNav(3,:);bins_stdDist_A53T_FreeNav(3,:)];
        right_errorsFreeNav=right_errorsFreeNav(:);
        
        
        % add panels to the figure
        subplot(3,2,5)
        hold on;
        
        % Plot the positive bars (left side) for the current group
        b0=bar(num_indices, left_proportionsEA,'FaceAlpha', 0.5, 'EdgeColor', 'k');
        b0.FaceColor = 'flat';
        b0.CData = [coloursEA;coloursEA;coloursEA;coloursEA];
        
        % Plot the negative bars (right side) for the current group
        b1=bar(num_indices, -right_proportionsEA,'FaceAlpha', 0.25, 'EdgeColor', 'k','LineStyle','--');
        b1.FaceColor = 'flat';
        b1.CData = [coloursEA;coloursEA;coloursEA;coloursEA];
        
        
        % Add error bars for the positive bars (left side)
        errorbar(num_indices, left_proportionsEA, left_errorsEA, 'k', 'LineStyle', 'none');
        % Add error bars for the negative bars (right side)
        errorbar(num_indices, -right_proportionsEA, right_errorsEA, 'k', 'LineStyle', 'none');
        
        
        % Set labels and title
        xlabel({'time','Chemotaxis'});
        ylabel({'Proportion of larvae','(- odour) right side','(+ odour) left side'});
        
        minMax_Y_val = [-0.4, 0.7];
        titleFig =''; tickInterval = 0.2; hold on
        ylim(minMax_Y_val),yticks(minMax_Y_val(1):tickInterval:minMax_Y_val(2))
        set(gca, 'XTick', [2,6,10,14], 'XTickLabel', {'10 s','200 s','400 s','590 s'});


        grid on;
        set(gca,'XGrid','off')
        set(gcf, 'Units', 'inches');
        set(gcf, 'Position', [2, 2, 10, 6]); % Adjust width and height as needed
        set(gca, 'FontName', fontNameFigure, 'FontSize', fontSizeFigure);
        set(findall(gcf,'-property','FontName'),'FontName',fontNameFigure);
        set(findall(gcf,'-property','FontSize'),'FontSize',fontSizeFigure);

        
        subplot(3,2,6)
        hold on
        % Plot the positive bars (left side) for the current group
        b3=bar(num_indices, left_proportionsFreeNav,'FaceAlpha', 0.5, 'EdgeColor', 'k');
        b3.FaceColor = 'flat';
        b3.CData = [coloursEA;coloursEA;coloursEA;coloursEA];
        
        % Plot the negative bars (right side) for the current group
        b4=bar(num_indices, -right_proportionsFreeNav,'FaceAlpha', 0.25, 'EdgeColor', 'k','LineStyle','--');
        b4.FaceColor = 'flat';
        b4.CData = [coloursEA;coloursEA;coloursEA;coloursEA];
        
        
        % Add error bars for the positive bars (left side)
        errorbar(num_indices, left_proportionsFreeNav, left_errorsFreeNav, 'k', 'LineStyle', 'none');
        % Add error bars for the negative bars (right side)
        errorbar(num_indices, -right_proportionsFreeNav, right_errorsFreeNav, 'k', 'LineStyle', 'none');
        
        % Set labels and title
        xlabel({'time','Free Navigation'});
        set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);
        
        minMax_Y_val = [-0.4, 0.7];
        titleFig =''; tickInterval = 0.2; hold on
        ylim(minMax_Y_val),yticks(minMax_Y_val(1):tickInterval:minMax_Y_val(2))
        set(gca, 'XTick', [2,6,10,14], 'XTickLabel', {'10 s','200 s','400 s','590 s'});
        grid on;
        set(gca,'XGrid','off')
        hold off
      
        set(gcf, 'Units', 'inches');
        set(gcf, 'Position', [2, 2, 10, 6]); % Adjust width and height as needed
        set(gca, 'FontName', fontNameFigure, 'FontSize', fontSizeFigure);
        set(findall(h1,'-property','FontName'),'FontName',fontNameFigure);
        set(findall(h1,'-property','FontSize'),'FontSize',fontSizeFigure);


%%%% PLOT AVERAGE SPEED (NORMALIZED BY LENGTH) %%%%
        h2 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
        %subplot speed (normalized)/t       
        paintError='pooledStandardError';

        subplot(3,5,11:12);
        hold on
        plotPropertyVersusT(T,cat(2,varsEA_Control(:).avgSpeedRoundTGolay),cat(2,varsEA_G2019S(:).avgSpeedRoundTGolay),cat(2,varsEA_A53T(:).avgSpeedRoundTGolay),...,
            cat(2,varsEA_Control(:).semSpeedRoundTGolay),cat(2,varsEA_G2019S(:).semSpeedRoundTGolay),cat(2,varsEA_A53T(:).semSpeedRoundTGolay),LineStyleEA,coloursEA,paintError)
        xlabel({'Time (s)','Chemotaxis'});ylabel('Speed (mm/s)');ylim([0 0.4]);

        subplot(3,5,13:14);
        plotPropertyVersusT(T,cat(2,varsFreeNav_Control(:).avgSpeedRoundTGolay),cat(2,varsFreeNav_G2019S(:).avgSpeedRoundTGolay),cat(2,varsFreeNav_A53T(:).avgSpeedRoundTGolay),...,
            cat(2,varsFreeNav_Control(:).semSpeedRoundTGolay),cat(2,varsFreeNav_G2019S(:).semSpeedRoundTGolay),cat(2,varsFreeNav_A53T(:).semSpeedRoundTGolay),LineStyleEA,coloursEA,paintError)
        xlabel({'Time (s)','Free navigation'});ylim([0 0.4]);


        subplot(3,5,6:7);
        hold on
        plotPropertyVersusT(T,cat(2,varsEA_Control(:).avgSpeedRoundTGolayNormalized),cat(2,varsEA_G2019S(:).avgSpeedRoundTGolayNormalized),cat(2,varsEA_A53T(:).avgSpeedRoundTGolayNormalized),...,
            cat(2,varsEA_Control(:).semSpeedRoundTGolayNormalized),cat(2,varsEA_G2019S(:).semSpeedRoundTGolayNormalized),cat(2,varsEA_A53T(:).semSpeedRoundTGolayNormalized),LineStyleEA,coloursEA,paintError)
        xlabel({'Time (s)','Chemotaxis'});ylabel('Speed / length (1/s)');ylim([0 0.3]);

        subplot(3,5,8:9);
        plotPropertyVersusT(T,cat(2,varsFreeNav_Control(:).avgSpeedRoundTGolayNormalized),cat(2,varsFreeNav_G2019S(:).avgSpeedRoundTGolayNormalized),cat(2,varsFreeNav_A53T(:).avgSpeedRoundTGolayNormalized),...,
            cat(2,varsFreeNav_Control(:).semSpeedRoundTGolayNormalized),cat(2,varsFreeNav_G2019S(:).semSpeedRoundTGolayNormalized),cat(2,varsFreeNav_A53T(:).semSpeedRoundTGolayNormalized),LineStyleEA,coloursEA,paintError)
        xlabel({'Time (s)','Free navigation'});ylim([0 0.3]);


        % subplot box chart average values
        subplot(3,5,3:5);
        avgSpeedPerExpChemotaxis = {vertcat(varsEA_Control(:).avgMeanSpeedGolayNormalized),vertcat(varsEA_G2019S(:).avgMeanSpeedGolayNormalized),vertcat(varsEA_A53T(:).avgMeanSpeedGolayNormalized)};
        avgSpeedPerExpFreeNav = {vertcat(varsFreeNav_Control(:).avgMeanSpeedGolayNormalized),vertcat(varsFreeNav_G2019S(:).avgMeanSpeedGolayNormalized),vertcat(varsFreeNav_A53T(:).avgMeanSpeedGolayNormalized)};
        minMax_Y_val = [0, 0.4];
        titleFig ='';
        hold on
        plotBoxChart(avgSpeedPerExpChemotaxis,avgSpeedPerExpFreeNav,coloursEA,titleFig,fontSizeFigure,fontNameFigure,'Speed / length (1/s)');
        ylim(minMax_Y_val),yticks(minMax_Y_val(1):tickInterval:minMax_Y_val(2))
        legend('','','','','','','',phenotypes_name{1},'',phenotypes_name{2},'',phenotypes_name{3}),legend('Location','northeastoutside'),legend('boxoff')
        subplot(3,5,1:2);
        % Plot scatter plot with inverted axes
        experiment1_length= [vertcat(varsEA_Control(:).averageLarvaeLength);vertcat(varsFreeNav_Control(:).averageLarvaeLength)];
        experiment2_length= [vertcat(varsEA_G2019S(:).averageLarvaeLength);vertcat(varsFreeNav_G2019S(:).averageLarvaeLength)];
        experiment3_length= [vertcat(varsEA_A53T(:).averageLarvaeLength);vertcat(varsFreeNav_A53T(:).averageLarvaeLength)];
        experiment1_speed= [vertcat(varsEA_Control(:).avgMeanSpeedGolay);vertcat(varsFreeNav_Control(:).avgMeanSpeedGolay)];
        experiment2_speed= [vertcat(varsEA_G2019S(:).avgMeanSpeedGolay);vertcat(varsFreeNav_G2019S(:).avgMeanSpeedGolay)];
        experiment3_speed= [vertcat(varsEA_A53T(:).avgMeanSpeedGolay);vertcat(varsFreeNav_A53T(:).avgMeanSpeedGolay)];
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

%% PLOT ANGULAR SPEED  and TORTUOSITY %%%%
        h3 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
        paintError = 'pooledStandardError';
        % subplot box chart average values
        subplot(3,2,1:2);
        avgAngSpeedPerExpChemotaxis = {vertcat(varsEA_Control(:).avgMeanAngularSpeed),vertcat(varsEA_G2019S(:).avgMeanAngularSpeed),vertcat(varsEA_A53T(:).avgMeanAngularSpeed)};
        avgAngSpeedPerExpFreeNav = {vertcat(varsFreeNav_Control(:).avgMeanAngularSpeed),vertcat(varsFreeNav_G2019S(:).avgMeanAngularSpeed),vertcat(varsFreeNav_A53T(:).avgMeanAngularSpeed)};
        minMax_Y_val = [0, 5];
        titleFig =''; tickInterval = 1; hold on
        plotBoxChart(avgAngSpeedPerExpChemotaxis,avgAngSpeedPerExpFreeNav,coloursEA,titleFig,fontSizeFigure,fontNameFigure,'Angular speed (degrees/s)');
        ylim(minMax_Y_val),yticks(minMax_Y_val(1):tickInterval:minMax_Y_val(2))
        legend('','','','','','','',phenotypes_name{1},'',phenotypes_name{2},'',phenotypes_name{3}),legend('Location','northwestoutside'),legend('boxoff')


        subplot(3,2,3);hold on
        plotPropertyVersusT(T,cat(2,varsEA_Control(:).meanAngularSpeedPerT),cat(2,varsEA_G2019S(:).meanAngularSpeedPerT),cat(2,varsEA_A53T(:).meanAngularSpeedPerT),...,
            cat(2,varsEA_Control(:).semAngularSpeedPerT),cat(2,varsEA_G2019S(:).semAngularSpeedPerT),cat(2,varsEA_A53T(:).semAngularSpeedPerT),LineStyleEA,coloursEA,paintError)
        xlabel({'Time (s)','Chemotaxis'});ylabel('Angular speed (degress/s)');ylim(minMax_Y_val);yticks(minMax_Y_val(1):tickInterval:minMax_Y_val(2))       

        subplot(3,2,4)
        plotPropertyVersusT(T,cat(2,varsFreeNav_Control(:).meanAngularSpeedPerT),cat(2,varsFreeNav_G2019S(:).meanAngularSpeedPerT),cat(2,varsFreeNav_A53T(:).meanAngularSpeedPerT),...,
            cat(2,varsFreeNav_Control(:).semAngularSpeedPerT),cat(2,varsFreeNav_G2019S(:).semAngularSpeedPerT),cat(2,varsFreeNav_A53T(:).semAngularSpeedPerT),LineStyleEA,coloursEA,paintError)
        xlabel({'Time (s)','Free navigation'});ylabel('Angular speed (degress/s)');ylim(minMax_Y_val);yticks(minMax_Y_val(1):tickInterval:minMax_Y_val(2))
        %%%% Tortuosity (Loveless 2018, Integrative & Comparative Biology)
        subplot(3,2,5)

        avgTortuosityChemotaxis = {vertcat(varsEA_Control(:).meanTortuosity),vertcat(varsEA_G2019S(:).meanTortuosity),vertcat(varsEA_A53T(:).meanTortuosity)};
        avgTortuosityFreeNav = {vertcat(varsFreeNav_Control(:).meanTortuosity),vertcat(varsFreeNav_G2019S(:).meanTortuosity),vertcat(varsFreeNav_A53T(:).meanTortuosity)};
        minMax_Y_val = [0, 1];
        titleFig =''; tickInterval = 0.2; hold on
        plotBoxChart(avgTortuosityChemotaxis,avgTortuosityFreeNav,coloursEA,titleFig,fontSizeFigure,fontNameFigure,'Tortuosity');
        ylim(minMax_Y_val),yticks(minMax_Y_val(1):tickInterval:minMax_Y_val(2))

        
%% TURNING/DECISION MAKING ANALYSIS ANALYSIS PLOTS
        h4 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');
        
        %Number of turns[change of direction > 45 dg] per larva per minute 
        subplot(3,2,1:2);
        
        avgTurningRateChemotaxis = {vertcat(varsEA_Control(:).turningRatePerMinute),vertcat(varsEA_G2019S(:).turningRatePerMinute),vertcat(varsEA_A53T(:).turningRatePerMinute)};
        avgTurningRateFreeNav = {vertcat(varsFreeNav_Control(:).turningRatePerMinute),vertcat(varsFreeNav_G2019S(:).turningRatePerMinute),vertcat(varsFreeNav_A53T(:).turningRatePerMinute)};
        minMax_Y_val = [0, 3];
        titleFig =''; tickInterval = 0.25; hold on
        plotBoxChart(avgTurningRateChemotaxis,avgTurningRateFreeNav,coloursEA,titleFig,fontSizeFigure,fontNameFigure,{'Turning rate','(# turns > 45 dg) / min'});
        ylim(minMax_Y_val),yticks(minMax_Y_val(1):tickInterval:minMax_Y_val(2))
        legend('','','','','','','',phenotypes_name{1},'',phenotypes_name{2},'',phenotypes_name{3}),legend('Location','northwestoutside'),legend('boxoff')
        
        %Agility index (mean speed running / mean speed turning
        subplot(3,2,3);
        avgAgilityIndexChemotaxis = {arrayfun(@(x) varsEA_Control(x).larvaeAgilityNormalized.meanSpeed_Turning / varsEA_Control(x).larvaeAgilityNormalized.meanSpeed_Run,1:size(varsEA_Control,1)),arrayfun(@(x) varsEA_G2019S(x).larvaeAgilityNormalized.meanSpeed_Turning / varsEA_G2019S(x).larvaeAgilityNormalized.meanSpeed_Run,1:size(varsEA_G2019S,1)),arrayfun(@(x) varsEA_A53T(x).larvaeAgilityNormalized.meanSpeed_Turning / varsEA_A53T(x).larvaeAgilityNormalized.meanSpeed_Run,1:size(varsEA_A53T,1))};
        avgAgilityIndexFreeNav = {arrayfun(@(x) varsFreeNav_Control(x).larvaeAgilityNormalized.meanSpeed_Turning / varsFreeNav_Control(x).larvaeAgilityNormalized.meanSpeed_Run,1:size(varsFreeNav_Control,1)),arrayfun(@(x) varsFreeNav_G2019S(x).larvaeAgilityNormalized.meanSpeed_Turning / varsFreeNav_G2019S(x).larvaeAgilityNormalized.meanSpeed_Run,1:size(varsFreeNav_G2019S,1)),arrayfun(@(x) varsFreeNav_A53T(x).larvaeAgilityNormalized.meanSpeed_Turning / varsFreeNav_A53T(x).larvaeAgilityNormalized.meanSpeed_Run,1:size(varsFreeNav_A53T,1))};
        minMax_Y_val = [0, 0.8];
        titleFig =''; tickInterval = 0.2; hold on
        plotBoxChart(avgAgilityIndexChemotaxis,avgAgilityIndexFreeNav,coloursEA,titleFig,fontSizeFigure,fontNameFigure,{'Agility index','<speed turning>/<speed running>'});
        ylim(minMax_Y_val),yticks(minMax_Y_val(1):tickInterval:minMax_Y_val(2))

        %Accumulated angle change during turning events
        subplot(3,2,4);
        avgAccumAngleDuringTurningChemotaxis = {arrayfun(@(x) varsEA_Control(x).averageAccumAnglePerTurn.mean_accumAngle,1:size(varsEA_Control,1)),arrayfun(@(x) varsEA_G2019S(x).averageAccumAnglePerTurn.mean_accumAngle,1:size(varsEA_G2019S,1)),arrayfun(@(x) varsEA_A53T(x).averageAccumAnglePerTurn.mean_accumAngle,1:size(varsEA_A53T,1))};
        avgAccumAngleDuringTurningFreeNav = {arrayfun(@(x) varsFreeNav_Control(x).averageAccumAnglePerTurn.mean_accumAngle,1:size(varsFreeNav_Control,1)),arrayfun(@(x) varsFreeNav_G2019S(x).averageAccumAnglePerTurn.mean_accumAngle,1:size(varsFreeNav_G2019S,1)),arrayfun(@(x) varsFreeNav_A53T(x).averageAccumAnglePerTurn.mean_accumAngle,1:size(varsFreeNav_A53T,1))};

        minMax_Y_val = [0, 300];
        titleFig =''; tickInterval = 30; hold on
        plotBoxChart(avgAccumAngleDuringTurningChemotaxis,avgAccumAngleDuringTurningFreeNav,coloursEA,titleFig,fontSizeFigure,fontNameFigure,{'Angular exploration', 'in turning event (degrees)'});
        ylim(minMax_Y_val),yticks(minMax_Y_val(1):tickInterval:minMax_Y_val(2))

        %Duration of turning event angle during turning
        subplot(3,2,5);
        avgDurationTurningChemotaxis = {arrayfun(@(x) varsEA_Control(x).averageAccumAnglePerTurn.mean_durationTurn,1:size(varsEA_Control,1)),arrayfun(@(x) varsEA_G2019S(x).averageAccumAnglePerTurn.mean_durationTurn,1:size(varsEA_G2019S,1)),arrayfun(@(x) varsEA_A53T(x).averageAccumAnglePerTurn.mean_durationTurn,1:size(varsEA_A53T,1))};
        avgDurationTurningFreeNav = {arrayfun(@(x) varsFreeNav_Control(x).averageAccumAnglePerTurn.mean_durationTurn,1:size(varsFreeNav_Control,1)),arrayfun(@(x) varsFreeNav_G2019S(x).averageAccumAnglePerTurn.mean_durationTurn,1:size(varsFreeNav_G2019S,1)),arrayfun(@(x) varsFreeNav_A53T(x).averageAccumAnglePerTurn.mean_durationTurn,1:size(varsFreeNav_A53T,1))};

        minMax_Y_val = [0, 10];
        titleFig =''; tickInterval = 2; hold on
        plotBoxChart(avgDurationTurningChemotaxis,avgDurationTurningFreeNav,coloursEA,titleFig,fontSizeFigure,fontNameFigure,{'Duration turning events (s)'});
        ylim(minMax_Y_val),yticks(minMax_Y_val(1):tickInterval:minMax_Y_val(2))

        %Number of stops per larva per minute 
        subplot(3,2,6);
        
        avgStopRateChemotaxis = {vertcat(varsEA_Control(:).stoppingRatePerMinute),vertcat(varsEA_G2019S(:).stoppingRatePerMinute),vertcat(varsEA_A53T(:).stoppingRatePerMinute)};
        avgStopRateFreeNav = {vertcat(varsFreeNav_Control(:).stoppingRatePerMinute),vertcat(varsFreeNav_G2019S(:).stoppingRatePerMinute),vertcat(varsFreeNav_A53T(:).stoppingRatePerMinute)};
        minMax_Y_val = [-0.1, 0.5];
        titleFig =''; tickInterval = 0.1; hold on
        plotBoxChart(avgStopRateChemotaxis,avgStopRateFreeNav,coloursEA,titleFig,fontSizeFigure,fontNameFigure,{'Stopping rate','(# stops / min'});
        ylim(minMax_Y_val),yticks(minMax_Y_val(1):tickInterval:minMax_Y_val(2))
        

%% Polar histogram orientations;

        h5=figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');

        %%Overall larvae orientation probability
        % Orientation when turning. Row 3 comes to say that although larvae turn
        % more when they are heading the odor, they do it less often (spend more
        % time running toward the odor). Larvae start the turning more ofter when
        % they are pointing opossite to the odour source.

        subplot(4,3,1)
        ticksAngles=0:45:360;
        angleTicksLabels={'Right','45°','Top','135°','Left','225°','Bottom','270°'};
        angle_ranges = [3*pi/4, 5*pi/4;-pi/4, pi/4;pi/4, 3*pi/4;5*pi/4, 7*pi/4];
        num_bins=4;
        radiusLimits=[0,0.5];arrayRTicks=[0,0.25,0.5,0.75,1];rTicksLabels={'','','','',''};
        
        avgOrientationPropControlEA= mean(vertcat(varsEA_Control(:).runRatePerOrient)+vertcat(varsEA_Control(:).turningRatePerOrient)+vertcat(varsEA_Control(:).stopRatePerOrient));
        stdOrientationPropControlEA= std(vertcat(varsEA_Control(:).runRatePerOrient)+vertcat(varsEA_Control(:).turningRatePerOrient)+vertcat(varsEA_Control(:).stopRatePerOrient));
        colourBins = repmat(coloursEA(1,:),4,1);
        legendName=[];titleName=phenotypes_name{1};
        plotPolarhistogram(avgOrientationPropControlEA,num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
                
        subplot(4,3,2)
        avgOrientationPropG2019SEA= mean(vertcat(varsEA_G2019S(:).runRatePerOrient)+vertcat(varsEA_G2019S(:).turningRatePerOrient)+vertcat(varsEA_G2019S(:).stopRatePerOrient));
        stdOrientationPropG2019SEA= std(vertcat(varsEA_G2019S(:).runRatePerOrient)+vertcat(varsEA_G2019S(:).turningRatePerOrient)+vertcat(varsEA_G2019S(:).stopRatePerOrient));
        colourBins = repmat(coloursEA(2,:),4,1);
        legendName=[];titleName={'Probability of larvae orientation [Chemotaxis]','',phenotypes_name{2}};
        plotPolarhistogram(avgOrientationPropG2019SEA,num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
                
        subplot(4,3,3)
        avgOrientationPropA53TEA= mean(vertcat(varsEA_A53T(:).runRatePerOrient)+vertcat(varsEA_A53T(:).turningRatePerOrient)+vertcat(varsEA_A53T(:).stopRatePerOrient));
        stdOrientationPropA53TEA= std(vertcat(varsEA_A53T(:).runRatePerOrient)+vertcat(varsEA_A53T(:).turningRatePerOrient)+vertcat(varsEA_A53T(:).stopRatePerOrient));
        colourBins = repmat(coloursEA(3,:),4,1);
        legendName=[];titleName=phenotypes_name{3};
        plotPolarhistogram(avgOrientationPropA53TEA,num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)

        
        ticksAngles=0:45:360;
        angleTicksLabels={'Right','45°','Top','135°','Left','225°','Bottom','270°'};
        angle_ranges = [3*pi/4, 5*pi/4;-pi/4, pi/4;pi/4, 3*pi/4;5*pi/4, 7*pi/4];
        arrayRTicks=0:0.2:1;rTicksLabels={'','','','','',''};

        
        colourBins = repmat(coloursEA(1,:),4,1);
        radiusLimits=[0,0.5];
        legendName=[];titleName=[];
        avgPropOrientPreTurningControl_EA = mean(vertcat(varsEA_Control(:).propOrientationPriorTurning));
        avgPropOrientPostTurningControl_EA = mean(vertcat(varsEA_Control(:).propOrientationAfterTurning));
        subplot(4,3,4)
        plotPolarhistogram(avgPropOrientPreTurningControl_EA,num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
        subplot(4,3,7)
        plotPolarhistogram( (avgPropOrientPreTurningControl_EA./avgOrientationPropControlEA)/sum(avgPropOrientPreTurningControl_EA./avgOrientationPropControlEA),num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
        subplot(4,3,10)
        plotPolarhistogram(avgPropOrientPostTurningControl_EA,num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
        % subplot(4,6,19)
        % plotPolarhistogram( (avgPropOrientPostTurningControl_EA./avgOrientationPropControlEA)/sum(avgPropOrientPostTurningControl_EA./avgOrientationPropControlEA),num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
        % 
        avgPropOrientPreTurningG2019S_EA = mean(vertcat(varsEA_G2019S(:).propOrientationPriorTurning));
        avgPropOrientPostTurningG2019S_EA = mean(vertcat(varsEA_G2019S(:).propOrientationAfterTurning));
        subplot(4,3,5)
        colourBins = repmat(coloursEA(2,:),4,1);
        legendName=[];titleName={'Probability of larvae orientation pre-turning [Chemotaxis]'};
        plotPolarhistogram(avgPropOrientPreTurningG2019S_EA,num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
        subplot(4,3,8)
        titleName={'Probability of larvae orientation pre-turning [Chemotaxis]','(normalized by time spent per orientation)'};
        plotPolarhistogram((avgPropOrientPreTurningG2019S_EA./avgOrientationPropG2019SEA)/sum(avgPropOrientPreTurningG2019S_EA./avgOrientationPropG2019SEA),num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
        subplot(4,3,11)
        titleName={'Probability of larvae orientation after turning [Chemotaxis]'};
        plotPolarhistogram(avgPropOrientPostTurningG2019S_EA,num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
        % subplot(4,6,20)
        % titleName={'Probability of larvae orientation after turning','(normalized by time spent per orientation)'};
        % plotPolarhistogram((avgPropOrientPostTurningG2019S_EA./avgOrientationPropG2019SEA)/sum(avgPropOrientPostTurningG2019S_EA./avgOrientationPropG2019SEA),num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
        % 
        avgPropOrientPreTurningA53T_EA = mean(vertcat(varsEA_A53T(:).propOrientationPriorTurning));
        avgPropOrientPostTurningA53T_EA = mean(vertcat(varsEA_A53T(:).propOrientationAfterTurning));
        colourBins = repmat(coloursEA(3,:),4,1);
        legendName=[];titleName=[];
        subplot(4,3,6)
        plotPolarhistogram(avgPropOrientPreTurningA53T_EA,num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
        titleName=[];
        subplot(4,3,9)
        plotPolarhistogram((avgPropOrientPreTurningA53T_EA./avgOrientationPropA53TEA)/sum(avgPropOrientPreTurningA53T_EA./avgOrientationPropA53TEA),num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
        subplot(4,3,12)
        plotPolarhistogram(avgPropOrientPostTurningA53T_EA,num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
        % subplot(4,6,21)
        % plotPolarhistogram((avgPropOrientPostTurningA53T_EA./avgOrientationPropA53TEA)/sum(avgPropOrientPostTurningA53T_EA./avgOrientationPropA53TEA),num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
        % 

        %%FREE NAVIGATION
        h6=figure;
        subplot(4,3,1)
        avgOrientationPropControlFreeNav= mean(vertcat(varsFreeNav_Control(:).runRatePerOrient)+vertcat(varsFreeNav_Control(:).turningRatePerOrient)+vertcat(varsFreeNav_Control(:).stopRatePerOrient));
        stdOrientationPropControlFreeNav= std(vertcat(varsFreeNav_Control(:).runRatePerOrient)+vertcat(varsFreeNav_Control(:).turningRatePerOrient)+vertcat(varsFreeNav_Control(:).stopRatePerOrient));
        colourBins = repmat(coloursEA(1,:),4,1);
        legendName=[];titleName=phenotypes_name{1};
        plotPolarhistogram(avgOrientationPropControlFreeNav,num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
                
        subplot(4,3,2)
        avgOrientationPropG2019SFreeNav= mean(vertcat(varsFreeNav_G2019S(:).runRatePerOrient)+vertcat(varsFreeNav_G2019S(:).turningRatePerOrient)+vertcat(varsFreeNav_G2019S(:).stopRatePerOrient));
        stdOrientationPropG2019SFreeNav= std(vertcat(varsFreeNav_G2019S(:).runRatePerOrient)+vertcat(varsFreeNav_G2019S(:).turningRatePerOrient)+vertcat(varsFreeNav_G2019S(:).stopRatePerOrient));
        colourBins = repmat(coloursEA(2,:),4,1);
        legendName=[];titleName={'Probability of larvae orientation [Free Nav]','',phenotypes_name{2}};
        plotPolarhistogram(avgOrientationPropG2019SFreeNav,num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
                
        subplot(4,3,3)
        avgOrientationPropA53TFreeNav= mean(vertcat(varsFreeNav_A53T(:).runRatePerOrient)+vertcat(varsFreeNav_A53T(:).turningRatePerOrient)+vertcat(varsFreeNav_A53T(:).stopRatePerOrient));
        stdOrientationPropA53TFreeNav= std(vertcat(varsFreeNav_A53T(:).runRatePerOrient)+vertcat(varsFreeNav_A53T(:).turningRatePerOrient)+vertcat(varsFreeNav_A53T(:).stopRatePerOrient));
        colourBins = repmat(coloursEA(3,:),4,1);
        legendName=[];titleName=phenotypes_name{3};
        plotPolarhistogram(avgOrientationPropA53TFreeNav,num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)

        colourBins = repmat(coloursEA(1,:),4,1);
        radiusLimits=[0,0.5];
        legendName=[];titleName=[];
        avgPropOrientPreTurningControl_FreeNav = mean(vertcat(varsFreeNav_Control(:).propOrientationPriorTurning));
        avgPropOrientPostTurningControl_FreeNav = mean(vertcat(varsFreeNav_Control(:).propOrientationAfterTurning));
        subplot(4,3,4)
        plotPolarhistogram(avgPropOrientPreTurningControl_FreeNav,num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
        titleName=[];
        subplot(4,3,7)
        plotPolarhistogram( (avgPropOrientPreTurningControl_FreeNav./avgOrientationPropControlFreeNav)/sum(avgPropOrientPreTurningControl_FreeNav./avgOrientationPropControlFreeNav),num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
        subplot(4,3,10)
        plotPolarhistogram(avgPropOrientPostTurningControl_FreeNav,num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
        % subplot(4,6,22)
        % plotPolarhistogram( (avgPropOrientPostTurningControl_FreeNav./avgOrientationPropControlFreeNav)/sum(avgPropOrientPostTurningControl_FreeNav./avgOrientationPropControlFreeNav),num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
        % 
        avgPropOrientPreTurningG2019S_FreeNav = mean(vertcat(varsFreeNav_G2019S(:).propOrientationPriorTurning));
        avgPropOrientPostTurningG2019S_FreeNav = mean(vertcat(varsFreeNav_G2019S(:).propOrientationAfterTurning));
        subplot(4,3,5)
        colourBins = repmat(coloursEA(2,:),4,1);
        legendName=[];titleName={'Probability of larvae orientation pre-turning [Free Nav]'};
        plotPolarhistogram(avgPropOrientPreTurningG2019S_FreeNav,num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
        subplot(4,3,8)
        titleName={'Probability of larvae orientation pre-turning [Free Nav]','(normalized by time spent per orientation)'};
        plotPolarhistogram((avgPropOrientPreTurningG2019S_FreeNav./avgOrientationPropG2019SFreeNav)/sum(avgPropOrientPreTurningG2019S_FreeNav./avgOrientationPropG2019SFreeNav),num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
        subplot(4,3,11)
        titleName={'Probability of larvae orientation after turning [Free Nav]'};
        plotPolarhistogram(avgPropOrientPostTurningG2019S_FreeNav,num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
        % subplot(4,6,23)
        % titleName={'Probability of larvae orientation after turning','(normalized by time spent per orientation)'};
        % plotPolarhistogram((avgPropOrientPostTurningG2019S_FreeNav./avgOrientationPropG2019SFreeNav)/sum(avgPropOrientPostTurningG2019S_FreeNav./avgOrientationPropG2019SFreeNav),num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
        % 

        avgPropOrientPreTurningA53T_FreeNav = mean(vertcat(varsFreeNav_A53T(:).propOrientationPriorTurning));
        avgPropOrientPostTurningA53T_FreeNav = mean(vertcat(varsFreeNav_A53T(:).propOrientationAfterTurning));
        colourBins = repmat(coloursEA(3,:),4,1);
        legendName=[];titleName=[];
        subplot(4,3,6)
        plotPolarhistogram(avgPropOrientPreTurningA53T_FreeNav,num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
        titleName=[];
        subplot(4,3,9)
        plotPolarhistogram((avgPropOrientPreTurningA53T_FreeNav./avgOrientationPropA53TFreeNav)/sum(avgPropOrientPreTurningA53T_FreeNav./avgOrientationPropA53TFreeNav),num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
        subplot(4,3,12)
        plotPolarhistogram(avgPropOrientPostTurningA53T_FreeNav,num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
        % subplot(4,6,24)
        % plotPolarhistogram((avgPropOrientPostTurningA53T_FreeNav./avgOrientationPropA53TFreeNav)/sum(avgPropOrientPostTurningA53T_FreeNav./avgOrientationPropA53TFreeNav),num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)
        % 





isPrintOn=1;
[filepath,nameF,ext] = fileparts(pathFolder);

folder2save = fullfile('..','Results',nameF);
if ~exist(folder2save,'dir'), mkdir(fullfile(folder2save,'Figures')); end


%% ORGANIZE DATA IN TABLES

[tabNavIndex,tabSpeedNormLength,tabSpeed,tabAngSpeed,tabPercAngStates,tabMeanTransitionMatrixOrient,tabStdTransitionMatrixOrient,...
    tabOrientationLarvPriorAfterCasting,tabOrientationPriorAfterCastingOrTurning,tabSpeedOrientation,tabAngularSpeedOrientation] ...
    = organizeDataInTables(allVars,varsEA_Control,varsEA_A53T,varsEA_G2019S,varsFreeNav_Control,varsFreeNav_A53T,varsFreeNav_G2019S);


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



%Number of turns / average n larvae / minute 

%Number of castings / average n larvae / minute

%Number of stops / average n larvae / minute

%Tortuosity (Loveless 2018, Integrative & Comparative Biology)

%Turn probability regarding orientation to odor source (Gomez-Marin 2011,
%Nat. Commns). Considering % time spent for the larvae per orientation.






