function [propLarvInAnglGroup,orderedAllLarvOrientPerSec,larvaeAngle] = calculateLarvaeOrientations(xFile,yFile)

    xFileRoundT = xFile;
    yFileRoundT = yFile;

    xFileRoundT(:,2)=round(xFile(:,2));
    yFileRoundT(:,2)=round(yFile(:,2));
    uniqLabels=unique(xFileRoundT(:,1));
    
    avgXFilePerRoundTFile = [];
    avgYFilePerRoundTFile = [];
    %transform speed to roundTspeed
    for nLab=1:length(uniqLabels)
        idsLab = ismember(xFileRoundT(:,1),uniqLabels(nLab));

        auxXFileRoundT= xFileRoundT(idsLab,:);
        auxUniqRoundTime = unique(round(auxXFileRoundT(:,2)));
        auxAvgXRoundT=arrayfun(@(x) mean(auxXFileRoundT(ismember(auxXFileRoundT(:,2),x),3)),auxUniqRoundTime);
        avgXPerRoundTFileAux = [ones(length(auxUniqRoundTime),1).*uniqLabels(nLab),auxUniqRoundTime,auxAvgXRoundT];
        avgXFilePerRoundTFile = [avgXFilePerRoundTFile;avgXPerRoundTFileAux];

        auxYFileRoundT= yFileRoundT(idsLab,:);
        auxAvgYRoundT=arrayfun(@(x) mean(auxYFileRoundT(ismember(auxYFileRoundT(:,2),x),3)),auxUniqRoundTime);
        avgYPerRoundTFileAux = [ones(length(auxUniqRoundTime),1).*uniqLabels(nLab),auxUniqRoundTime,auxAvgYRoundT];
        avgYFilePerRoundTFile = [avgYFilePerRoundTFile;avgYPerRoundTFileAux];
    end

    larvaeAngle = calculateAngleMovLarvae(avgXFilePerRoundTFile, avgYFilePerRoundTFile);
   
    uniqRoundTime = unique(round(larvaeAngle(:,2)));
    
    propLarvInAnglGroup=zeros(length(uniqRoundTime),4);
    allLarvaeOrientationPerSec = [];
    for nSec=1:length(uniqRoundTime)
        idT=ismember(larvaeAngle(:,2),uniqRoundTime(nSec));
        uniqLabelsSec = unique(larvaeAngle(idT,1));
        
        %classify the angles in 4 groups as explained in the header (<- ; -> ; ^ ; v )
        auxLarvInGroups=zeros(length(uniqLabelsSec),4);
    
        for nLar = 1:length(uniqLabelsSec)
            idLar = ismember(larvaeAngle(:,1),uniqLabelsSec(nLar));
            group1 = larvaeAngle(idLar & idT,3)>=225 & larvaeAngle(idLar & idT,3) < 315;
            group2 = larvaeAngle(idLar & idT,3)>=45 & larvaeAngle(idLar & idT,3) < 135;
            group3 = larvaeAngle(idLar & idT,3)>=135 & larvaeAngle(idLar & idT,3) < 225;
            group4 = larvaeAngle(idLar & idT,3)>=315 | larvaeAngle(idLar & idT,3) < 45;
            [~,idGroup]=max([group1,group2,group3,group4]);
            auxLarvInGroups(nLar,idGroup)=1;
        end
    
        larvaeOrientationPerSec = [uniqLabelsSec,ones(size(uniqLabelsSec)).*uniqRoundTime(nSec),auxLarvInGroups];
    
        allLarvaeOrientationPerSec=[allLarvaeOrientationPerSec;larvaeOrientationPerSec];
        propLarvInAnglGroup(nSec,:)=sum(auxLarvInGroups,1)/sum(auxLarvInGroups(:));
    end
    
%     figure;hold on
%     
%     plot(uniqRoundTime,propLarvInAnglGroup(:,1),'-r', 'LineWidth', 2);
%     plot(uniqRoundTime,propLarvInAnglGroup(:,2),'-b', 'LineWidth', 2);
%     plot(uniqRoundTime,propLarvInAnglGroup(:,3),'-p', 'LineWidth', 2);
%     plot(uniqRoundTime,propLarvInAnglGroup(:,4),'-k', 'LineWidth', 2);
%     legend({'left','right','top','bottom'})
    
    
    [~,idOrd]=sort(allLarvaeOrientationPerSec(:,1));
    orderedAllLarvOrientPerSec=allLarvaeOrientationPerSec(idOrd,:);


end
