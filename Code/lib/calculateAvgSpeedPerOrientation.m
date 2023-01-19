function [avgSpeedPerOrientation,stdSpeedPerOrientation]=calculateAvgSpeedPerOrientation(speedFile,orderedAllLarvOrientPerSec)

    speedFileRoundT = speedFile;
    speedFileRoundT(:,2) = round(speedFile(:,2));

    uniqLabels=unique(speedFile(:,1));

    avgSpeedPerRoundTFile = [];

    %transform speed to roundTspeed
    for nLab=1:length(uniqLabels)
        idsLab = ismember(speedFileRoundT(:,1),uniqLabels(nLab));
        auxSpeedFileRoundT= speedFileRoundT(idsLab,:);
        auxUniqRoundTime = unique(round(auxSpeedFileRoundT(:,2)));
        auxAvgSpeedRoundT=arrayfun(@(x) mean(auxSpeedFileRoundT(ismember(auxSpeedFileRoundT(:,2),x),3)),auxUniqRoundTime);

        avgSpeedPerRoundTFileAux = [ones(length(auxUniqRoundTime),1).*uniqLabels(nLab),auxUniqRoundTime,auxAvgSpeedRoundT];
        avgSpeedPerRoundTFile = [avgSpeedPerRoundTFile;avgSpeedPerRoundTFileAux];
    end


    avgSpeedLeft = mean(avgSpeedPerRoundTFile(orderedAllLarvOrientPerSec(:,3)>0,3));
    stdSpeedLeft = std(avgSpeedPerRoundTFile(orderedAllLarvOrientPerSec(:,3)>0,3));

    avgSpeedRight = mean(avgSpeedPerRoundTFile(orderedAllLarvOrientPerSec(:,4)>0,3));
    stdSpeedRight = std(avgSpeedPerRoundTFile(orderedAllLarvOrientPerSec(:,4)>0,3));

    avgSpeedTop = mean(avgSpeedPerRoundTFile(orderedAllLarvOrientPerSec(:,5)>0,3));
    stdSpeedTop = std(avgSpeedPerRoundTFile(orderedAllLarvOrientPerSec(:,5)>0,3));

    avgSpeedDown = mean(avgSpeedPerRoundTFile(orderedAllLarvOrientPerSec(:,6)>0,3));
    stdSpeedDown = std(avgSpeedPerRoundTFile(orderedAllLarvOrientPerSec(:,6)>0,3));


    avgSpeedPerOrientation = [avgSpeedLeft,avgSpeedRight,avgSpeedTop,avgSpeedDown];
    stdSpeedPerOrientation = [stdSpeedLeft,stdSpeedRight,stdSpeedTop,stdSpeedDown];

end
