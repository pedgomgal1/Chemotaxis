function [dataSpineUpdated,cellOutlinesLarvae,xFile,yFile]=updateLabelsFile(orderedLarvae,dataSpine,cellOutlinesLarvae,xFile,yFile)

    dataSpineUpdated=dataSpine;
    labelsOutlineUpdated = vertcat(cellOutlinesLarvae{:,1});
    xFileIDUpdated = xFile;
    for nIterations = 1:length(orderedLarvae)
        ordLarvae = orderedLarvae{nIterations};
    
        for nC = 1:length(ordLarvae)
            dataSpineUpdated(ismember(dataSpineUpdated(:,2),[ordLarvae{nC}]),2) = min([ordLarvae{nC}]);
            labelsOutlineUpdated(ismember(labelsOutlineUpdated,[ordLarvae{nC}])) = min([ordLarvae{nC}]);
            xFileIDUpdated(ismember(xFileIDUpdated(:,2),[ordLarvae{nC}]),2) = min([ordLarvae{nC}]);
        end
    end
    cellOutlinesLarvae(:,1)= num2cell(labelsOutlineUpdated(:));
    xFile(:,2)=xFileIDUpdated(:,2);
    yFile(:,2)=xFileIDUpdated(:,2);

end