function [tableSummaryFeaturesRaw,xFile,yFile,speedFile,speedFile085,crabSpeedFile,areaFile,dataSpine,cellOutlinesLarvae,curveFile,castFile]=removeBorderIds(borderIds,tableSummaryFeaturesRaw,xFile,yFile,speedFile,speedFile085,crabSpeedFile,areaFile,dataSpine,cellOutlinesLarvae,curveFile,castFile)

    idsBoder2remove = tableSummaryFeaturesRaw.id(borderIds);
    tableSummaryFeaturesRaw(borderIds,:) = [];

    xFile(ismember(xFile(:,1),idsBoder2remove),:)=[];
    yFile(ismember(yFile(:,1),idsBoder2remove),:)=[];
    speedFile(ismember(speedFile(:,1),idsBoder2remove),:)=[];
    speedFile085(ismember(speedFile085(:,1),idsBoder2remove),:)=[];
    crabSpeedFile(ismember(crabSpeedFile(:,1),idsBoder2remove),:)=[];
    areaFile(ismember(areaFile(:,1),idsBoder2remove),:)=[];


    uniqValidId = xFile(:,1);

    if ~isempty(cellOutlinesLarvae)
        idSpine = ismember(dataSpine(:,1),uniqValidId);
        
        castFile(ismember(castFile(:,1),idsBoder2remove),:)=[];
        curveFile(ismember(curveFile(:,1),idsBoder2remove),:)=[];
        dataSpine(~idSpine,:)=[];
        
        cellOutlinesLarvae(ismember(vertcat(cellOutlinesLarvae{:,1}),idsBoder2remove),:)=[];
    end

end