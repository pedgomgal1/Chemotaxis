function [cellOutlinesLarvae]=updateOutlinesFile(orderedLarvae,cellOutlinesLarvae)

    labelsOutlineUpdated = vertcat(cellOutlinesLarvae{:,1});
    
    for nC = 1:length(orderedLarvae)
        labelsOutlineUpdated(ismember(labelsOutlineUpdated,[orderedLarvae{nC}])) = min([orderedLarvae{nC}]);
    end

    cellOutlinesLarvae(:,1)= num2cell(labelsOutlineUpdated(:));

end