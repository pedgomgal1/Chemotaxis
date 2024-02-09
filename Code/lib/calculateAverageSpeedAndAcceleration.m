function [avgSpeedRoundT, stdSpeedRoundT, semSpeedRoundT,avgMeanSpeed,avgStdSpeed,avgSemSpeed,avgAccelerationRoundT, stdAccelerationRoundT, semAccelerationRoundT,avgMeanAcceleration,avgStdAcceleration,avgSemAcceleration,speedFileRoundTSimplified,accelerationFileRoundTSimplified] = calculateAverageSpeedAndAcceleration(speedFile)

    %Only measure the time intervals when the larva is not stacked. 
    %Round to discrete timepoints
    %considering id in col 1, time in col 2 and property in col 3
    speedFileRoundT = roundToDiscreteTimePoints (speedFile);

    uniqRoundTime = unique(speedFileRoundT(:,2));
    uniqueLabels = unique(speedFileRoundT(:,1));

    accelerationFileRoundTSimplified = [];
    for nLab = 1:length(uniqueLabels)

        idsLab = ismember(speedFileRoundT(:,1),uniqueLabels(nLab));
        auxSpeedFileRoundT= speedFileRoundT(idsLab,:);
        auxUniqRoundTime = unique(round(auxSpeedFileRoundT(:,2)));

        dV = gradient(auxSpeedFileRoundT(:,3));

        accelerationFileRoundTSimplified = [accelerationFileRoundTSimplified; [ones(sum(idsLab),1)*uniqueLabels(nLab),auxUniqRoundTime, dV]];

    end


    avgSpeedRoundT=arrayfun(@(x) mean(speedFileRoundT(ismember(speedFileRoundT(:,2),x),3)),uniqRoundTime);
    semSpeedRoundT=arrayfun(@(x) std(speedFileRoundT(ismember(speedFileRoundT(:,2),x),3))/sqrt(sum(ismember(speedFileRoundT(:,2),x))),uniqRoundTime);
    stdSpeedRoundT=arrayfun(@(x) std(speedFileRoundT(ismember(speedFileRoundT(:,2),x),3)),uniqRoundTime);


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