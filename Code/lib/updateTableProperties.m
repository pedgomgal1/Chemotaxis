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
        newRowTable = [interestIDtable(1,1:4),interestIDtable(end,5:end)];
        newTableSummaryFeatures=[newTableSummaryFeatures;newRowTable];
    end

end