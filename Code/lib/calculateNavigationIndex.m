function [navIndex_roundT,distIndex_Xaxis_roundT,distIndex_Yaxis_roundT,navIndex,distIndex_Xaxis,distIndex_Yaxis]=calculateNavigationIndex(xCoords, yCoords)
    
    %Assuming odour source reference in X(+), across all Y. 
    
    %
    %
    %    _________________________________
    %   | [EA]                            |
    %   |                                 |
    %   | [EA]                            |
    %   |             (init               |
    %   | [EA]        larvae)             |
    %   |                                 |
    %   | [EA]                            |
    %   |_________________________________|
    %
    %    [EA] = Ethyl acetate odour patches 
    %
    %

    %% Measuring (by averaging) X and Y coordinates closer to every single int timepoint (e.g 0.54 0.75, 0.99, 1.23, 1.45 -> belong to t=1 s)

    %considering id in col 1, time in col 2 and property in col 3
    xCoordsRoundT = roundToDiscreteTimePoints (xCoords);
    yCoordsRoundT = roundToDiscreteTimePoints (yCoords);

    % distIndexX = (Dist X(+) - Dist X(-)) / (Dist X(+) + Dist X(-))
    % distIndexY = (Dist Y(+) - Dist Y(-)) / (Dist Y(+) + Dist Y(-))

    uniqueId = unique(yCoords(:,1));
    difX=zeros(length(uniqueId),1);
    absX=zeros(length(uniqueId),1);
    difY=zeros(length(uniqueId),1);
    absY=zeros(length(uniqueId),1);
    difXY=zeros(length(uniqueId),1);
    timePerID = zeros(length(uniqueId),1);
    difX_roundT=zeros(length(uniqueId),1);
    absX_roundT=zeros(length(uniqueId),1);
    difY_roundT=zeros(length(uniqueId),1);
    absY_roundT=zeros(length(uniqueId),1);
    difXY_roundT=zeros(length(uniqueId),1);
    timePerID_roundT = zeros(length(uniqueId),1);

    for nId = 1:length(uniqueId)
        xFileId = xCoords(ismember(xCoords(:,1),uniqueId(nId)),:);
        difXMov=arrayfun(@(x,y) x-y, xFileId(1:end-1,3),xFileId(2:end,3));
        difX(nId)= sum(difXMov);
        absX(nId)= sum(abs(difXMov));
        timePerID(nId)= (xFileId(end,2)-xFileId(1,2));

        yFileId = yCoords(ismember(yCoords(:,1),uniqueId(nId)),:);
        difYMov=arrayfun(@(x,y) x-y, yFileId(1:end-1,3),yFileId(2:end,3));
        difY(nId)= sum(difYMov);
        absY(nId)= sum(abs(difYMov));

        difXYMov =arrayfun(@(x1,x2,y1,y2) sqrt((x1-x2)^2 + (y1-y2)^2), xFileId(1:end-1,3),xFileId(2:end,3),yFileId(1:end-1,3),yFileId(2:end,3));
        difXY(nId) = sum(difXYMov);

        %repeting code with roundT
        xFileId_roundT = xCoordsRoundT(ismember(xCoordsRoundT(:,1),uniqueId(nId)),:);
        difXMov_roundT=arrayfun(@(x,y) x-y, xFileId_roundT(1:end-1,3),xFileId_roundT(2:end,3));
        difX_roundT(nId)= sum(difXMov_roundT);
        absX_roundT(nId)= sum(abs(difXMov_roundT));
        timePerID_roundT(nId)= (xFileId_roundT(end,2)-xFileId_roundT(1,2));

        yFileId_roundT = yCoordsRoundT(ismember(yCoordsRoundT(:,1),uniqueId(nId)),:);
        difYMov_roundT=arrayfun(@(x,y) x-y, yFileId_roundT(1:end-1,3),yFileId_roundT(2:end,3));
        difY_roundT(nId)= sum(difYMov_roundT);
        absY_roundT(nId)= sum(abs(difYMov_roundT));

        difXYMov_roundT =arrayfun(@(x1,x2,y1,y2) sqrt((x1-x2)^2 + (y1-y2)^2), xFileId_roundT(1:end-1,3),xFileId_roundT(2:end,3),yFileId_roundT(1:end-1,3),yFileId_roundT(2:end,3));
        difXY_roundT(nId) = sum(difXYMov_roundT);

    end

    totalX = sum(absX);
    distIndex_Xaxis=sum(difX)/totalX;

    totalY = sum(absY);
    distIndex_Yaxis=sum(difY)/totalY;

    totalX_roundT = sum(absX_roundT);
    distanceIndex_Xaxis_roundT = sum(difX_roundT)/totalX_roundT;

    totalY_roundT = sum(absY_roundT);
    distanceIndex_Yaxis_roundT = sum(difY_roundT)/totalY_roundT;

    %% Nav. index (Gershow, et al. 2012).  <mean_speed_x> / <mean_speed>
    % Near +1. Navigation toward odour.
    % Near -1. Navigation opposite odour.
    % Near 0. Navigation unbiased.

    speed_x = sum(difX)/sum(timePerID);
    %speed_y = sum(difY)/sum(timePerID);
    speed_avg = sum(difXY)/sum(timePerID);
    navIndex = speed_x/speed_avg;
    
    speed_x_roundT = sum(difX_roundT)/sum(timePerID_roundT);
    %speed_y_roundT = sum(difY_roundT)/sum(timePerID_roundT);
    speed_avg_roundT = sum(difXY_roundT)/sum(timePerID);
    navIndex_roundT = speed_x_roundT/speed_avg_roundT;

end