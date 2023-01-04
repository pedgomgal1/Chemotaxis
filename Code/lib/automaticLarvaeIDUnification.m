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

        %if there are more than 1 candidate, then compare distances and
        %angles
        if sum(distanceCandidatesFilter)>1
            distBetwLarvae=pdist2(xyCoord1,xyCoordCandidates(distanceCandidatesFilter,:));
            [~,idMinDist]=min(distBetwLarvae);

            idFilteredCandidates = idCandidatesTime(distanceCandidatesFilter);
            difAngles = abs(rad2deg(arrayfun(@(x) angdiff(deg2rad(tableSummaryLarvaeFeatures.directionLarvaLast(nID)),x),deg2rad(tableSummaryLarvaeFeatures.directionLarvaInit(ismember(tableSummaryLarvaeFeatures.id,idFilteredCandidates))))));
            [~,idMinAngle]=min(difAngles);

            if idMinDist~=idMinAngle 
                disp(['ID_' num2str(tableSummaryLarvaeFeatures.id(nID)) ' at t' num2str(lastT) ' could be merge either with ' num2str(idFilteredCandidates(idMinAngle)) ' by angle or ' num2str(idFilteredCandidates(idMinDist)) ' by distance'])

                minCombinedIndexes=[idMinDist,idMinAngle];
                distCand = distBetwLarvae(minCombinedIndexes);
                angCandNorm = difAngles(minCombinedIndexes)/180;
                %combine (multiply) distance and normalized angles to select the closest index
                %by similarity
                [~,selectedId]=min(distCand(:).*angCandNorm(:));

                listIDConcat(nID,2)=idFilteredCandidates(minCombinedIndexes(selectedId));
            else
                listIDConcat(nID,2)=idFilteredCandidates(idMinAngle);
            end
            
            
        end
    end

    %% Apply threshold by area and morphology in repeated assignations
    repeatedIDs = listIDConcat(arrayfun(@(x) sum(x==listIDConcat(:,2))>1, listIDConcat(:,1)),1);
    
    for nIDrep = 1:length(repeatedIDs)
        
        conflictLabels = listIDConcat(listIDConcat(:,2)==repeatedIDs(nIDrep),1);
        conflictIDs = ismember(listIDConcat(:,1),conflictLabels);
        assignedID = ismember(listIDConcat(:,1),repeatedIDs(nIDrep));

        [normDistArea,minIdAreas] = min(pdist2(tableSummaryLarvaeFeatures.area(assignedID)/tableSummaryLarvaeFeatures.area(assignedID),tableSummaryLarvaeFeatures.area(conflictIDs)/tableSummaryLarvaeFeatures.area(assignedID)));
        [normDistMorp,minIdMorp] = min(pdist2(tableSummaryLarvaeFeatures.morpWidth(assignedID)/tableSummaryLarvaeFeatures.morpWidth(assignedID),tableSummaryLarvaeFeatures.morpWidth(conflictIDs)/tableSummaryLarvaeFeatures.morpWidth(assignedID)));


        if (minIdMorp==minIdAreas)
            finalID = conflictLabels(minIdAreas);
        else
            proposedLabels = conflictLabels([minIdAreas,minIdMorp]);
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
    newTableSummaryFeatures=updateTableProperties(tableSummaryLarvaeFeatures,cellUniqLabels);

   

end