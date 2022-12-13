function [newTableSummaryFeatures,cellUniqLabels] = automaticLarvaeIDUnification(tableSummaryLarvaeFeatures,rangeTime, xyCoordRange, averageSpeed)


    listIDConcat = zeros(size(tableSummaryLarvaeFeatures,1),2);
    listIDConcat(:,1) = tableSummaryLarvaeFeatures.id(:);

    %% Apply threshold by distance
    for nID = 1:size(tableSummaryLarvaeFeatures,1)
        lastT = tableSummaryLarvaeFeatures.maxTime(nID);
        xyCoord1 = [tableSummaryLarvaeFeatures.xCoordEnd(nID),tableSummaryLarvaeFeatures.yCoordEnd(nID)];

        %Select possible candidates
        idCandidatesTime = tableSummaryLarvaeFeatures.id((tableSummaryLarvaeFeatures.minTime -lastT) < rangeTime & (tableSummaryLarvaeFeatures.minTime -lastT) > 0);
        xyCoordCandidates= [tableSummaryLarvaeFeatures.xCoordInit(ismember(tableSummaryLarvaeFeatures.id,idCandidatesTime)),tableSummaryLarvaeFeatures.yCoordInit(ismember(tableSummaryLarvaeFeatures.id,idCandidatesTime))];
        
        distanceCandidates = pdist2(xyCoord1,xyCoordCandidates);
        timeDifCandidates = tableSummaryLarvaeFeatures.minTime(ismember(tableSummaryLarvaeFeatures.id,idCandidatesTime)) - lastT;

        

        %discard the larvae with larger trajectories than possible using
        %time difference of apparition and average speed of larvae.
        distanceTimeCandidates = distanceCandidates < xyCoordRange;
        maximumCoveredDistance = timeDifCandidates*averageSpeed;
        distanceCandidatesFilter = distanceTimeCandidates & (maximumCoveredDistance'-distanceCandidates)>0;


        if sum(distanceCandidatesFilter)==1
            listIDConcat(nID,2)=idCandidatesTime(distanceCandidatesFilter);
        end
        if sum(distanceCandidatesFilter)>1
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

        [minDistAngle,minDifAngle]=min(abs((deg2rad(tableSummaryLarvaeFeatures.directionLarvaLast(assignedID))-deg2rad(tableSummaryLarvaeFeatures.directionLarvaInit(conflictIDs)))/2*pi));

        if (minDifMorp==minDifAreas) && (minDifAreas==minDifAngle)
            finalID = conflictLabels(minDifAreas);
        else
            proposedLabels = conflictLabels([minDifAreas,minDifMorp,minDifAngle]);
            [modeId,nRep,difReps]=mode([minDifAreas,minDifMorp,minDifAngle]);
            if nRep>1
                finalID = proposedLabels(modeId);
            else
                [~,minFeature]=min([normDistArea,normDistMorp,minDistAngle]);
                finalID = proposedLabels(minFeature);
            end
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
    newTableSummaryFeatures=updateTableProperties(tableSummaryLarvaeFeatures,cellUniqLabels);

    


end