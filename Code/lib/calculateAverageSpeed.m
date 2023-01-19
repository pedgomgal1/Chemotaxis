function [avgSpeedRoundT, stdSpeedRoundT, semSpeedRoundT,avgMeanSpeed,avgStdSpeed,avgSemSpeed] = calculateAverageSpeed(speedFile)

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
       
    
    avgSpeedRoundT=arrayfun(@(x) mean(speedFileRoundT(ismember(speedFileRoundT(:,2),x),3)),uniqRoundTime);
    semSpeedRoundT=arrayfun(@(x) std(speedFileRoundT(ismember(speedFileRoundT(:,2),x),3))/sqrt(sum(ismember(speedFileRoundT(:,2),x))),uniqRoundTime);
    stdSpeedRoundT=arrayfun(@(x) std(speedFileRoundT(ismember(speedFileRoundT(:,2),x),3)),uniqRoundTime);

%     curve1 = avgSpeedRoundT + stdSpeedRoundT;
%     curve2 = avgSpeedRoundT - stdSpeedRoundT;
%     x2 = [uniqRoundTime', fliplr(uniqRoundTime')];
%     inBetween = [curve1', fliplr(curve2')];
%     fill(x2, inBetween, 'r','FaceAlpha',0.3);
%     hold on;
%     plot(uniqRoundTime,avgSpeedRoundT,'r', 'LineWidth', 2);

    avgMeanSpeed = mean(avgSpeedRoundT);
    avgStdSpeed = mean(stdSpeedRoundT);
    avgSemSpeed = mean(semSpeedRoundT);


end