function listIDConcat = automaticLarvaeIDUnification(tableLarvaeIDMinMax)

    rangeTime = 5; %seconds
    xyCoordRange = 50;
    listIDConcat = zeros(size(tableLarvaeIDMinMax,1),2);
    listIDConcat(:,1) = tableLarvaeIDMinMax.id(:);
    for nID = 1:size(tableLarvaeIDMinMax,1)
        lastT = tableLarvaeIDMinMax.maxTime(nID);
        xyCoord1 = [tableLarvaeIDMinMax.xCoordEnd(nID),tableLarvaeIDMinMax.yCoordEnd(nID)];

        %Select possible candidates
        idCandidatesTime = tableLarvaeIDMinMax.id((tableLarvaeIDMinMax.minTime -lastT) < rangeTime & (tableLarvaeIDMinMax.minTime -lastT) > 0);
        xyCoordCandidates= [tableLarvaeIDMinMax.xCoordInit(ismember(tableLarvaeIDMinMax.id,idCandidatesTime)),tableLarvaeIDMinMax.yCoordInit(ismember(tableLarvaeIDMinMax.id,idCandidatesTime))];
        
        distanceTimeCandidates = pdist2(xyCoord1,xyCoordCandidates)<xyCoordRange;

        if sum(distanceTimeCandidates)==1
            listIDConcat(nID,2)=idCandidatesTime(distanceTimeCandidates);
        end
        if sum(distanceTimeCandidates)>1

            [~,idMin]=min(pdist2(xyCoord1,xyCoordCandidates));
            listIDConcat(nID,2)=idCandidatesTime(idMin);
        end
        

    end

end