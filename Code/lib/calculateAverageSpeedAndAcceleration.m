function [avgSpeedRoundT, stdSpeedRoundT, semSpeedRoundT,avgMeanSpeed,avgStdSpeed,avgSemSpeed,avgAccelerationRoundT, stdAccelerationRoundT, semAccelerationRoundT,avgMeanAcceleration,avgStdAcceleration,avgSemAcceleration,speedFileRoundTSimplified,accelerationFileRoundTSimplified] = calculateAverageSpeedAndAcceleration(speedFile)

    %Only measure the time intervals when the larva is not stacked. 
    speedFileRoundT = speedFile;
    speedFileRoundT(:,2) = round(speedFile(:,2));
    uniqRoundTime = unique(round(speedFile(:,2)));
     
    uniqueLabels = unique(speedFileRoundT(:,1));

    speedFileRoundTSimplified = [];
    accelerationFileRoundTSimplified = [];
    dt = 1; % sec
    for nLab = 1:length(uniqueLabels)

        idsLab = ismember(speedFileRoundT(:,1),uniqueLabels(nLab));
        auxSpeedFileRoundT= speedFileRoundT(idsLab,:);
        auxUniqRoundTime = unique(round(auxSpeedFileRoundT(:,2)));
        auxAvgSpeedRoundT=arrayfun(@(x) mean(auxSpeedFileRoundT(ismember(auxSpeedFileRoundT(:,2),x),3)),auxUniqRoundTime);

        speedFileRoundTSimplified = [speedFileRoundTSimplified;[ones(size(auxAvgSpeedRoundT))*uniqueLabels(nLab),auxUniqRoundTime,auxAvgSpeedRoundT]];

        dV = gradient(auxAvgSpeedRoundT);

        accelerationFileRoundTSimplified = [accelerationFileRoundTSimplified; [ones(size(auxAvgSpeedRoundT))*uniqueLabels(nLab),auxUniqRoundTime, dV]];

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