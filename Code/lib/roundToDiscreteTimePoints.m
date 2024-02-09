function [xCoordsFileRoundTSimplified] = roundToDiscreteTimePoints(xCoords)
    
    xCoordsRoundT = xCoords;
    xCoordsRoundT(:,2) = round(xCoords(:,2));
    uniqueLabels = unique(xCoordsRoundT(:,1));

    xCoordsFileRoundTSimplified = [];
    for nLab = 1:length(uniqueLabels)
        idsLab = ismember(xCoordsRoundT(:,1),uniqueLabels(nLab));
        auxXCoordsFileRoundT= xCoordsRoundT(idsLab,:);
        auxUniqRoundTime = unique(round(auxXCoordsFileRoundT(:,2)));
        auxAvgXCoordsRoundT=arrayfun(@(x) mean(auxXCoordsFileRoundT(ismember(auxXCoordsFileRoundT(:,2),x),3)),auxUniqRoundTime);
        xCoordsFileRoundTSimplified = [xCoordsFileRoundTSimplified;[ones(size(auxAvgXCoordsRoundT))*uniqueLabels(nLab),auxUniqRoundTime,auxAvgXCoordsRoundT]];
    end

end