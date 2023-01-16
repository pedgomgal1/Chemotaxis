function larvaeAngle = calculateAngleMovLarvae(xFile, yFile)
    
    uniqueLabels=unique(xFile(:,1));

    larvaeAngle=xFile;
    larvaeAngle(:,3)=0;
    
    %check the angles between -3 and +3 timepoints

    for nLab = 1:length(uniqueLabels)

        idLab = ismember(xFile(:,1),uniqueLabels(nLab));

        angleAux=zeros(sum(idLab),1);
        
        xFileAux=xFile(idLab,:);
        xFileAux=[xFileAux(1,:);xFileAux(1,:);xFileAux(1,:);xFileAux;xFileAux(end,:);xFileAux(end,:);xFileAux(end,:)];

        yFileAux=yFile(idLab,:);
        yFileAux=[yFileAux(1,:);yFileAux(1,:);yFileAux(1,:);yFileAux;yFileAux(end,:);yFileAux(end,:);yFileAux(end,:)];
        
        for nXY=4:length(xFileAux)-3
            x1 = xFileAux(nXY-1,3);
            x2 = xFileAux(nXY+1,3);
            y1 = yFileAux(nXY-1,3);
            y2 = yFileAux(nXY+1,3);
            angleAux(nXY-3) = atan2d(y2-y1,x2-x1);
        end
        larvaeAngle(idLab,3)=angleAux;
    end

    idNegAng=larvaeAngle(:,3)<0;
    larvaeAngle(idNegAng,3)=larvaeAngle(idNegAng,3)+360;

    
end