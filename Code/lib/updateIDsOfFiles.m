function [xFileUpdated,yFileUpdated,speedFileUpdated,dataSpineUpdated,cellOutlinesLarvaeUpdated,castFileUpdated]=updateIDsOfFiles(unifiedLabels,xFile,yFile,speedFile,dataSpine,cellOutlinesLarvae,castFile)

    [xFileUpdated]=updateLabelsFile(unifiedLabels,xFile);
    [yFileUpdated]=updateLabelsFile(unifiedLabels,yFile);
    [speedFileUpdated]=updateLabelsFile(unifiedLabels,speedFile);
    
    if ~isempty(outlineFile)
        [dataSpineUpdated]=updateLabelsFile(unifiedLabels,dataSpine);
        [cellOutlinesLarvaeUpdated]=updateOutlinesFile(unifiedLabels,cellOutlinesLarvae);
        castFile(ismember(castFile(:,2),idsBoder2remove),:)=[];
    
        dataSpineUpdated(ismember(dataSpineUpdated(:,2),idsBoder2remove),:)=[];
        cellOutlinesLarvaeUpdated(ismember(vertcat(cellOutlinesLarvaeUpdated{:,1}),idsBoder2remove),:)=[];
        castFileUpdated =updateLabelsFile(unifiedLabels,castFile);
    end


end