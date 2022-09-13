function [cellOutlinesLarvae]=updateOutlinesFile(orderedLarvae,cellOutlinesLarvae)

    labelsOutlineUpdated = vertcat(cellOutlinesLarvae{:,1});
    for nIterations = 1:length(orderedLarvae)
        ordLarvae = orderedLarvae{nIterations};
    
        for nC = 1:length(ordLarvae)
            labelsOutlineUpdated(ismember(labelsOutlineUpdated,[ordLarvae{nC}])) = min([ordLarvae{nC}]);
        end
    end
    cellOutlinesLarvae(:,1)= num2cell(labelsOutlineUpdated(:));

end