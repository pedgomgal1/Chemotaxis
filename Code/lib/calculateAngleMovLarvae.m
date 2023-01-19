function larvaeAngle = calculateAngleMovLarvae(xFile, yFile)
    
    uniqueLabels=unique(xFile(:,1));

    larvaeAngle=xFile;
    larvaeAngle(:,3)=0;
    
    %check the angles between -1 and +1 timepoints

    for nLab = 1:length(uniqueLabels)

        idLab = ismember(xFile(:,1),uniqueLabels(nLab));

        angleAux=zeros(sum(idLab),1);
        
        xFileAux=xFile(idLab,:);
        xFileAux=[xFileAux(1,:);xFileAux;xFileAux(end,:)];

        yFileAux=yFile(idLab,:);
        yFileAux=[yFileAux(1,:);yFileAux;yFileAux(end,:)];
        
        for nXY=2:length(xFileAux)-1
            x1 = xFileAux(nXY-1,3);
            x2 = xFileAux(nXY+1,3);
            y1 = yFileAux(nXY-1,3);
            y2 = yFileAux(nXY+1,3);
            angleAux(nXY-1) = atan2d(y2-y1,x2-x1);
        end
        larvaeAngle(idLab,3)=angleAux;
    end

    idNegAng=larvaeAngle(:,3)<0;
    larvaeAngle(idNegAng,3)=larvaeAngle(idNegAng,3)+360;

    
end