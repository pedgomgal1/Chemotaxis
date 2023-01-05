function newTableSummaryFeatures=updateTableProperties(tableSummaryLarvaeFeatures,cellUniqLabels)

    auxIDs = tableSummaryLarvaeFeatures.id;
    for nC = 1:length(cellUniqLabels)
        auxIDs(ismember(auxIDs,[cellUniqLabels{nC}])) = min([cellUniqLabels{nC}]);
    end
    
    [newOrdIds,ordNew]=sort(auxIDs);
    newOrderTable = tableSummaryLarvaeFeatures(ordNew,:);
    newOrderTable.id=newOrdIds;

    uniqNewIds = unique(newOrderTable.id);

    newTableSummaryFeatures=table;
    for newId = 1:length(uniqNewIds)
        interestIDtable = newOrderTable(newOrderTable.id==uniqNewIds(newId),:);
        newRowTable = [interestIDtable.id(1),interestIDtable.minTime(1),interestIDtable.maxTime(end),interestIDtable.xCoordInit(1),interestIDtable.xCoordEnd(end),interestIDtable.yCoordInit(1),interestIDtable.yCoordEnd(end),interestIDtable.directionLarvaInit(1),interestIDtable.directionLarvaLast(end),mean(interestIDtable.area(:)),mean(interestIDtable.morpWidth(:))];
        newRowTable = array2table(newRowTable,'VariableNames',interestIDtable.Properties.VariableNames);
        newTableSummaryFeatures=[newTableSummaryFeatures;newRowTable];
        
    end

    %remove discarded IDs (if any)
    allIDs=[cellUniqLabels{:}];
    tabIDs=newTableSummaryFeatures.id;
    rows2remove=~ismember(tabIDs,allIDs);
    newTableSummaryFeatures(rows2remove,:)=[];
end