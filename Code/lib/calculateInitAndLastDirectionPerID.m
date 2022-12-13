function [angleInitVector,angleLastVector] = calculateInitAndLastDirectionPerID(xFile,yFile,minTimesPerID,maxTimesPerID,uniqueId)

    %time window to calculate direction vector
    timeW = repmat(3,length(uniqueId),1); %3 seconds
    updTimeW = arrayfun(@(x,y,z) ((x-y)>z)*z + ((x-y)<=z)*(x-y), maxTimesPerID,minTimesPerID,timeW);
    
    x1Init = cell2mat(arrayfun(@(x,y) xFile(xFile(:,3)==x & xFile(:,2)==y,4),minTimesPerID,uniqueId,'UniformOutput',false));
    x2Init = cellfun(@(x) x(end),arrayfun(@(x,y,z) xFile(xFile(:,3)<=(x+z) & xFile(:,2)==y,4),minTimesPerID,uniqueId,updTimeW,'UniformOutput',false));
    
    x1Last = cellfun(@(x) x(1),arrayfun(@(x,y,z) xFile(xFile(:,3)>=(x-z) & xFile(:,2)==y,4),maxTimesPerID,uniqueId,updTimeW,'UniformOutput',false));
    x2Last = cell2mat(arrayfun(@(x,y) xFile(xFile(:,3)==x & xFile(:,2)==y,4),maxTimesPerID,uniqueId,'UniformOutput',false));
    
    y1Init = cell2mat(arrayfun(@(x,y) yFile(yFile(:,3)==x & yFile(:,2)==y,4),minTimesPerID,uniqueId,'UniformOutput',false));
    y2Init = cellfun(@(x) x(end),arrayfun(@(x,y,z) yFile(yFile(:,3)<=(x+z) & yFile(:,2)==y,4),minTimesPerID,uniqueId,updTimeW,'UniformOutput',false));
    
    y1Last = cellfun(@(x) x(1),arrayfun(@(x,y,z) yFile(yFile(:,3)>=(x-z) & yFile(:,2)==y,4),maxTimesPerID,uniqueId,updTimeW,'UniformOutput',false));
    y2Last = cell2mat(arrayfun(@(x,y) yFile(yFile(:,3)==x & yFile(:,2)==y,4),maxTimesPerID,uniqueId,'UniformOutput',false));
    
    
    
    angleInitVector = atan2d(y2Init-y1Init,x2Init-x1Init);
    angleLastVector = atan2d(y2Last-y1Last,x2Last-x1Last);

end