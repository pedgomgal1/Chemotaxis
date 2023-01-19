function binsXdistributionInitEnd=calculatePositionDistributionXaxis(initTime, endTime,xAxisLimits,yFile)
    idInitT=ismember(round(yFile(:,2)),initTime);
    idEndT=ismember(round(yFile(:,2)),endTime);
    labelsInitT = unique(yFile(idInitT,1));
    labelsEndT = unique(yFile(idEndT,1));
    
    coordInitT = arrayfun(@(x)  mean(yFile(idInitT & ismember(yFile(:,1),x),3),'omitnan'),labelsInitT);
    coordEndT = arrayfun(@(x)  mean(yFile(idEndT & ismember(yFile(:,1),x),3),'omitnan'),labelsEndT);
    
    numberOfBins = 5;
    limitLeft = xAxisLimits(end);
    limitRight = xAxisLimits(1);
    bins = limitLeft:-(limitLeft-limitRight)/numberOfBins:limitRight;
    
    bin1_10s = sum(arrayfun(@(x) x<=bins(1) & x>bins(2),coordInitT))/length(coordInitT);
    bin2_10s = sum(arrayfun(@(x) x<=bins(2) & x>bins(3),coordInitT))/length(coordInitT);
    bin3_10s = sum(arrayfun(@(x) x<=bins(3) & x>bins(4),coordInitT))/length(coordInitT);
    bin4_10s = sum(arrayfun(@(x) x<=bins(4) & x>bins(5),coordInitT))/length(coordInitT);
    bin5_10s = sum(arrayfun(@(x) x<=bins(5) & x>=bins(6),coordInitT))/length(coordInitT);
    
    bin1_590s = sum(arrayfun(@(x) x<=bins(1) & x>bins(2),coordEndT))/length(coordEndT);
    bin2_590s = sum(arrayfun(@(x) x<=bins(2) & x>bins(3),coordEndT))/length(coordEndT);
    bin3_590s = sum(arrayfun(@(x) x<=bins(3) & x>bins(4),coordEndT))/length(coordEndT);
    bin4_590s = sum(arrayfun(@(x) x<=bins(4) & x>bins(5),coordEndT))/length(coordEndT);
    bin5_590s = sum(arrayfun(@(x) x<=bins(5) & x>=bins(6),coordEndT))/length(coordEndT);
    
    binsXdistributionInitEnd = [bin1_10s,bin1_590s;bin2_10s,bin2_590s;bin3_10s,bin3_590s;bin4_10s,bin4_590s;bin5_10s,bin5_590s];

end