function [xFile]=updateLabelsFile(orderedLarvae,xFile)

    xFileIDUpdated = xFile;
    for nC = 1:length(orderedLarvae)
        xFileIDUpdated(ismember(xFileIDUpdated(:,2),[orderedLarvae{nC}]),2) = min([orderedLarvae{nC}]);
    end
    xFile(:,2)=xFileIDUpdated(:,2);
end