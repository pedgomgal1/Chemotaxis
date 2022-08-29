function [newTableSummaryFeatures,cellUniqLabels] = automaticLarvaeIDUnification(tableSummaryLarvaeFeatures,rangeTime, xyCoordRange)


    listIDConcat = zeros(size(tableSummaryLarvaeFeatures,1),2);
    listIDConcat(:,1) = tableSummaryLarvaeFeatures.id(:);

    %% Apply threshold by distance
    for nID = 1:size(tableSummaryLarvaeFeatures,1)
        lastT = tableSummaryLarvaeFeatures.maxTime(nID);
        xyCoord1 = [tableSummaryLarvaeFeatures.xCoordEnd(nID),tableSummaryLarvaeFeatures.yCoordEnd(nID)];

        %Select possible candidates
        idCandidatesTime = tableSummaryLarvaeFeatures.id((tableSummaryLarvaeFeatures.minTime -lastT) < rangeTime & (tableSummaryLarvaeFeatures.minTime -lastT) > 0);
        xyCoordCandidates= [tableSummaryLarvaeFeatures.xCoordInit(ismember(tableSummaryLarvaeFeatures.id,idCandidatesTime)),tableSummaryLarvaeFeatures.yCoordInit(ismember(tableSummaryLarvaeFeatures.id,idCandidatesTime))];
        
        distanceTimeCandidates = pdist2(xyCoord1,xyCoordCandidates)<xyCoordRange;

        if sum(distanceTimeCandidates)==1
            listIDConcat(nID,2)=idCandidatesTime(distanceTimeCandidates);
        end
        if sum(distanceTimeCandidates)>1
            [~,idMin]=min(pdist2(xyCoord1,xyCoordCandidates));
            listIDConcat(nID,2)=idCandidatesTime(idMin);
        end
    end

    %% Apply threshold by area and morphology in repeated assignations
    repeatedIDs = listIDConcat(arrayfun(@(x) sum(x==listIDConcat(:,2))>1, listIDConcat(:,1)),1);
    
    for nIDrep = 1:length(repeatedIDs)
        
        conflictLabels = listIDConcat(listIDConcat(:,2)==repeatedIDs(nIDrep),1);
        conflictIDs = ismember(listIDConcat(:,1),conflictLabels);
        assignedID = ismember(listIDConcat(:,1),repeatedIDs(nIDrep));

        [normDistArea,minDifAreas] = min(pdist2(tableSummaryLarvaeFeatures.area(assignedID)/tableSummaryLarvaeFeatures.area(assignedID),tableSummaryLarvaeFeatures.area(conflictIDs)/tableSummaryLarvaeFeatures.area(assignedID)));
        [normDistMorp,minDifMorp] = min(pdist2(tableSummaryLarvaeFeatures.morpWidth(assignedID)/tableSummaryLarvaeFeatures.morpWidth(assignedID),tableSummaryLarvaeFeatures.morpWidth(conflictIDs)/tableSummaryLarvaeFeatures.morpWidth(assignedID)));

%%% ******** INCLUDE DIRECTION CONDITION IN CASE DIFFERENCE BETWEEN AREAS / MORPHO IS NOT
%%% EVIDENTE *********

        if minDifMorp==minDifAreas
            finalID = conflictLabels(minDifAreas);
        else
            proposedLabels = conflictLabels([minDifAreas,minDifMorp]);
            [~,minFeature]=min([normDistArea,normDistMorp]);
            finalID = proposedLabels(minFeature);
        end
        
        labels2Del = conflictLabels(conflictLabels~=finalID);
        listIDConcat(ismember(listIDConcat(:,1),labels2Del),2)=0;

    end

    %% Unify same label
    cellUniqLabels = {};
    nLab=1;
    nCount=1;
    listIDConcatCopy = listIDConcat;
    while nLab < size(listIDConcatCopy,1)+1
        if listIDConcatCopy(nLab,2)>0
            allLabels = listIDConcatCopy(nLab,:);
            nextAnalyzedRow = listIDConcatCopy(:,1)==allLabels(end);
            while listIDConcatCopy(nextAnalyzedRow,2)>0 
                allLabels=[allLabels, listIDConcatCopy(nextAnalyzedRow,2)];
                listIDConcatCopy(nextAnalyzedRow,:)=0;
                nextAnalyzedRow = listIDConcatCopy(:,1)==allLabels(end);
            end
            cellUniqLabels{nCount}=allLabels;
            nCount=nCount+1;
           
        else
            if listIDConcatCopy(nLab,1)>0
                cellUniqLabels{nCount}= listIDConcatCopy(nLab,1);
                nCount=nCount+1;
            end
        end  
        nLab=nLab+1;
    end


    %% Get summary table to return   
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