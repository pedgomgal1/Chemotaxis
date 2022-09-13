function [tableSummaryFeatures,orderedLarvae]=reorganizeUniqueIDs(tableSummaryFeatures)

    orderedLarvae={}; stopIterations=1;
    %thresolds to look for unique IDs    
    rangeTime = 30; %seconds
    xyCoordRange = 10; %pixel distance
    while stopIterations>0
        nLab1 = size(tableSummaryFeatures,1);
        [tableSummaryFeatures,orderedLarvae{stopIterations}] = automaticLarvaeIDUnification(tableSummaryFeatures,rangeTime,xyCoordRange);
        nLab2 = size(tableSummaryFeatures,1);
        if nLab1==nLab2
            stopIterations=0;
        else
            stopIterations=stopIterations+1;
        end
    end
    rangeTime = 100; %seconds
    xyCoordRange = 20; %pixel distance
    [tableSummaryFeatures,orderedLarvae{end+1}] = automaticLarvaeIDUnification(tableSummaryFeatures,rangeTime,xyCoordRange);


end