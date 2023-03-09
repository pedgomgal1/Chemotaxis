function binsXdistributionInitEnd=calculatePositionDistributionXaxis(initTime, intermediateTimes, endTime,xAxisLimits,yFile,tableSummaryFeatures,xBorders,yBorders)
    
    idInitT=ismember(round(yFile(:,2)),initTime);
    idIntermT1=ismember(round(yFile(:,2)),intermediateTimes(1));
    idIntermT2=ismember(round(yFile(:,2)),intermediateTimes(2));
    idEndT=ismember(round(yFile(:,2)),endTime);
    labelsInitT = unique(yFile(idInitT,1));
    labelsIntermT1 = unique(yFile(idIntermT1,1));
    labelsIntermT2 = unique(yFile(idIntermT2,1));
    labelsEndT = unique(yFile(idEndT,1));
    
    coordInitT = arrayfun(@(x)  mean(yFile(idInitT & ismember(yFile(:,1),x),3),'omitnan'),labelsInitT);
    coordIntermT1 = arrayfun(@(x)  mean(yFile(idIntermT1 & ismember(yFile(:,1),x),3),'omitnan'),labelsIntermT1);
    coordIntermT2 = arrayfun(@(x)  mean(yFile(idIntermT2 & ismember(yFile(:,1),x),3),'omitnan'),labelsIntermT2);
    coordEndT = arrayfun(@(x)  mean(yFile(idEndT & ismember(yFile(:,1),x),3),'omitnan'),labelsEndT);

    %add the larvae that found the borders between time 0 and intermediate
    %timepoint
    larvaeFindingBordersIntermT1 = (tableSummaryFeatures.maxTime < intermediateTimes(1)) & (tableSummaryFeatures.yCoordEnd < xBorders(1) | tableSummaryFeatures.yCoordEnd > xBorders(2) |  tableSummaryFeatures.xCoordEnd < yBorders(1) | tableSummaryFeatures.xCoordEnd > yBorders(2));     
    coordIntermT1 = [coordIntermT1; tableSummaryFeatures.yCoordEnd(larvaeFindingBordersIntermT1)];

    larvaeFindingBordersIntermT2 = (tableSummaryFeatures.maxTime < intermediateTimes(2)) & (tableSummaryFeatures.yCoordEnd < xBorders(1) | tableSummaryFeatures.yCoordEnd > xBorders(2) |  tableSummaryFeatures.xCoordEnd < yBorders(1) | tableSummaryFeatures.xCoordEnd > yBorders(2));     
    coordIntermT2 = [coordIntermT2; tableSummaryFeatures.yCoordEnd(larvaeFindingBordersIntermT2)];

    larvaeFindingBordersEndT = (tableSummaryFeatures.maxTime < endTime) & (tableSummaryFeatures.yCoordEnd < xBorders(1) | tableSummaryFeatures.yCoordEnd > xBorders(2) |  tableSummaryFeatures.xCoordEnd < yBorders(1) | tableSummaryFeatures.xCoordEnd > yBorders(2)); 
    coordEndT = [coordEndT; tableSummaryFeatures.yCoordEnd(larvaeFindingBordersEndT)];

    
    
%     numberOfBins = 5;
    numberOfBins = 3;
    limitLeft = xAxisLimits(1);
    limitRight = xAxisLimits(end);
    bins = limitLeft:-(limitLeft-limitRight)/numberOfBins:limitRight;
    
    bin1_10s = sum(arrayfun(@(x) x<bins(2),coordInitT))/length(coordInitT);
    bin2_10s = sum(arrayfun(@(x) x>=bins(2) & x<bins(3),coordInitT))/length(coordInitT);
    bin3_10s = sum(arrayfun(@(x) x>=bins(3),coordInitT))/length(coordInitT);
%     bin4_10s = sum(arrayfun(@(x) x>=bins(4) & x<bins(5),coordInitT))/length(coordInitT);
%     bin5_10s = sum(arrayfun(@(x) x>=bins(5) & x<=bins(6),coordInitT))/length(coordInitT);

    bin1_200s = sum(arrayfun(@(x) x<bins(2),coordIntermT1))/length(coordIntermT1);
    bin2_200s = sum(arrayfun(@(x) x>=bins(2) & x<bins(3),coordIntermT1))/length(coordIntermT1);
    bin3_200s = sum(arrayfun(@(x) x>=bins(3),coordIntermT1))/length(coordIntermT1);
%     bin4_200s = sum(arrayfun(@(x) x>=bins(4) & x<bins(5),coordIntermT1))/length(coordIntermT1);
%     bin5_200s = sum(arrayfun(@(x) x>=bins(5) & x<=bins(6),coordIntermT1))/length(coordIntermT1);

    bin1_400s = sum(arrayfun(@(x) x<bins(2),coordIntermT2))/length(coordIntermT2);
    bin2_400s = sum(arrayfun(@(x) x>=bins(2) & x<bins(3),coordIntermT2))/length(coordIntermT2);
    bin3_400s = sum(arrayfun(@(x) x>=bins(3),coordIntermT2))/length(coordIntermT2);    


    bin1_590s = sum(arrayfun(@(x) x<bins(2),coordEndT))/length(coordEndT);
    bin2_590s = sum(arrayfun(@(x) x>=bins(2) & x<bins(3),coordEndT))/length(coordEndT);
    bin3_590s = sum(arrayfun(@(x) x>=bins(3),coordEndT))/length(coordEndT);
%     bin4_590s = sum(arrayfun(@(x) x>=bins(4) & x<bins(5),coordEndT))/length(coordEndT);
%     bin5_590s = sum(arrayfun(@(x) x>=bins(5) & x<=bins(6),coordEndT))/length(coordEndT);
%     
%     binsXdistributionInitEnd = [bin1_10s,bin1_300s,bin1_590s;bin2_10s,bin2_300s,bin2_590s;bin3_10s,bin3_300s,bin3_590s;bin4_10s,bin4_300s,bin4_590s;bin5_10s,bin5_300s,bin5_590s];

    binsXdistributionInitEnd = [bin1_10s,bin1_200s,bin1_400s,bin1_590s;bin2_10s,bin2_200s,bin2_400s,bin2_590s;bin3_10s,bin3_200s,bin3_400s,bin3_590s];

end