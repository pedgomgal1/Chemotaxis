function [xFile]=updateLabelsFile(orderedLarvae,xFile)

    xFileIDUpdated = xFile;
    for nC = 1:length(orderedLarvae)
        xFileIDUpdated(ismember(xFileIDUpdated(:,1),[orderedLarvae{nC}]),1) = min([orderedLarvae{nC}]);
    end
    xFile(:,1)=xFileIDUpdated(:,1);
end