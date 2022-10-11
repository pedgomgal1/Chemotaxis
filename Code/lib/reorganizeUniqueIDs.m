function [tableSummaryFeatures,orderedLarvae]=reorganizeUniqueIDs(tableSummaryFeatures)

    orderedLarvae={}; stopIterations=1;
    %thresolds to look for unique IDs    
    rangeTime = 30; %seconds
    averageSpeed = 1; %1px/sec
    xyCoordRange = 10; %pixel distance. Equivalent to 100 pixels over the image 
    while stopIterations>0
        nLab1 = size(tableSummaryFeatures,1);
        [tableSummaryFeatures,orderedLarvae{stopIterations}] = automaticLarvaeIDUnification(tableSummaryFeatures,rangeTime,xyCoordRange,averageSpeed);
        nLab2 = size(tableSummaryFeatures,1);
        if nLab1==nLab2
            stopIterations=0;
        else
            stopIterations=stopIterations+1;
        end
    end
    rangeTime = 100; %seconds
    xyCoordRange = 20; %pixel distance
    [tableSummaryFeatures,orderedLarvae{end+1}] = automaticLarvaeIDUnification(tableSummaryFeatures,rangeTime,xyCoordRange,averageSpeed);


end