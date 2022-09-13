function [xFile]=updateLabelsFile(orderedLarvae,xFile)

    xFileIDUpdated = xFile;
    for nIterations = 1:length(orderedLarvae)
        ordLarvae = orderedLarvae{nIterations};
        for nC = 1:length(ordLarvae)
            xFileIDUpdated(ismember(xFileIDUpdated(:,2),[ordLarvae{nC}]),2) = min([ordLarvae{nC}]);
        end
    end
    xFile(:,2)=xFileIDUpdated(:,2);
end