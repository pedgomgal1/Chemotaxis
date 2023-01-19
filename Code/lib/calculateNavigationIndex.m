function navigationIndex_Xaxis=calculateNavigationIndex(yFile)

    %(yFile corresponds with xAxis being larger values left [patches], lower right)
    uniqueId = unique(yFile(:,1));
    difY=zeros(length(uniqueId),1);
    absY=zeros(length(uniqueId),1);
    for nId = 1:length(uniqueId)
        yFileId = yFile(ismember(yFile(:,1),uniqueId(nId)),:);
        difYMov=arrayfun(@(x,y) x-y, yFileId(1:end-1,3),yFileId(2:end,3));
        difY(nId)= sum(difYMov);
        absY(nId)= sum(abs(difYMov));
    end

    totalY = sum(absY);

    navigationIndex_Xaxis=sum(difY)/totalY;

end