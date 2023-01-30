function [avgSpeedRoundT, stdSpeedRoundT, semSpeedRoundT,avgMeanSpeed,avgStdSpeed,avgSemSpeed,avgAccelerationRoundT, stdAccelerationRoundT, semAccelerationRoundT,avgMeanAcceleration,avgStdAcceleration,avgSemAcceleration,speedFileRoundTSimplified,accelerationFileRoundTSimplified] = calculateAverageSpeedAndAcceleration(speedFile)

    %Only measure the time intervals when the larva is not stacked. 
    speedFileRoundT = speedFile;
    speedFileRoundT(:,2) = round(speedFile(:,2));
    uniqRoundTime = unique(round(speedFile(:,2)));

%     %Plot individual speeds

%     uniqLabels = unique(speedFileRoundT(:,1));
%     figure;
%     hold on
%     for nLab=1:length(uniqLabels)
%         idsLab = ismember(speedFileRoundT(:,1),uniqLabels(nLab));
%         auxSpeedFileRoundT= speedFileRoundT(idsLab,:);
%         auxUniqRoundTime = unique(round(auxSpeedFileRoundT(:,2)));
%         auxAvgSpeedRoundT=arrayfun(@(x) mean(auxSpeedFileRoundT(ismember(auxSpeedFileRoundT(:,2),x),3)),auxUniqRoundTime);
%         plot(auxUniqRoundTime,auxAvgSpeedRoundT, 'LineWidth', 2);
%     end
     
    uniqueLabels = unique(speedFileRoundT(:,1));

    speedFileRoundTSimplified = [];
    accelerationFileRoundTSimplified = [];
    dt = 1; % sec
    for nLab = 1:length(uniqueLabels)
        for nTimP = 1:length(uniqRoundTime)
            
            idsT = ismember(speedFileRoundT(:,2),uniqRoundTime(nTimP));
            idsLabel = ismember(speedFileRoundT(:,1),uniqueLabels(nLab));

            speedFileRoundTSimplified = [speedFileRoundTSimplified;[uniqueLabels(nLab) uniqRoundTime(nTimP) mean([speedFileRoundT(idsT & idsLabel,3)])]];

        end

        [rows,~]=find(isnan(speedFileRoundTSimplified));
        speedFileRoundTSimplified(rows,:)=[];

        idsLabel2 = ismember(speedFileRoundTSimplified(:,1),uniqueLabels(nLab));
        dV = gradient(speedFileRoundTSimplified(idsLabel2,3));

        plot(speedFileRoundTSimplified(idsLabel2,2),dV,'-') 
        hold on
        accelerationFileRoundTSimplified = [accelerationFileRoundTSimplified; [speedFileRoundTSimplified(idsLabel2,1:2) dV]];


    end


    
    avgSpeedRoundT=arrayfun(@(x) mean(speedFileRoundTSimplified(ismember(speedFileRoundTSimplified(:,2),x),3)),uniqRoundTime);
    semSpeedRoundT=arrayfun(@(x) std(speedFileRoundTSimplified(ismember(speedFileRoundTSimplified(:,2),x),3))/sqrt(sum(ismember(speedFileRoundTSimplified(:,2),x))),uniqRoundTime);
    stdSpeedRoundT=arrayfun(@(x) std(speedFileRoundTSimplified(ismember(speedFileRoundTSimplified(:,2),x),3)),uniqRoundTime);


    avgAccelerationRoundT=arrayfun(@(x) mean(accelerationFileRoundTSimplified(ismember(accelerationFileRoundTSimplified(:,2),x),3)),uniqRoundTime);
    semAccelerationRoundT=arrayfun(@(x) std(accelerationFileRoundTSimplified(ismember(accelerationFileRoundTSimplified(:,2),x),3))/sqrt(sum(ismember(accelerationFileRoundTSimplified(:,2),x))),uniqRoundTime);
    stdAccelerationRoundT=arrayfun(@(x) std(accelerationFileRoundTSimplified(ismember(accelerationFileRoundTSimplified(:,2),x),3)),uniqRoundTime);
    
    

    avgMeanSpeed = mean(avgSpeedRoundT);
    avgStdSpeed = mean(stdSpeedRoundT);
    avgSemSpeed = mean(semSpeedRoundT);

    avgMeanAcceleration = mean(avgAccelerationRoundT);
    avgStdAcceleration  = mean(semAccelerationRoundT);
    avgSemAcceleration= mean(stdAccelerationRoundT);


end