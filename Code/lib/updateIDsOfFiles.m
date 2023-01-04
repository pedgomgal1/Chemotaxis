function [xFileUpdated,yFileUpdated,speedFileUpdated,dataSpineUpdated,cellOutlinesLarvaeUpdated,castFileUpdated]=updateIDsOfFiles(unifiedLabels,xFile,yFile,speedFile,dataSpine,cellOutlinesLarvae,castFile)

    [xFileUpdated]=updateLabelsFile(unifiedLabels,xFile);
    [yFileUpdated]=updateLabelsFile(unifiedLabels,yFile);
    [speedFileUpdated]=updateLabelsFile(unifiedLabels,speedFile);
    
    if ~isempty(cellOutlinesLarvae)
        [dataSpineUpdated]=updateLabelsFile(unifiedLabels,dataSpine);
        [cellOutlinesLarvaeUpdated]=updateOutlinesFile(unifiedLabels,cellOutlinesLarvae);
        castFileUpdated =updateLabelsFile(unifiedLabels,castFile);
    end


end