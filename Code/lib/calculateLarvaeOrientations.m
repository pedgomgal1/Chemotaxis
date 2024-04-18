function [avgXFilePerRoundTFile, avgYFilePerRoundTFile,propLarvInAnglGroup,orderedAllLarvOrientPerSec,larvaeAngleXY,anglesTail2Head_RoundT,curveTail2Mid2Head_RoundT,posTailLarvae_RoundT] = calculateLarvaeOrientations(xFile,yFile,spineFile,angThreshold,golayTimeWindow)

    xFileRoundT = xFile;
    yFileRoundT = yFile;

    xFileRoundT(:,2)=round(xFile(:,2));
    yFileRoundT(:,2)=round(yFile(:,2));
    uniqLabels=unique(xFileRoundT(:,1));
    
    avgXFilePerRoundTFile = [];
    avgYFilePerRoundTFile = [];
    totalAccumAnglePerTurning = [];
    totalDurationTurningEvents = [];
    totalAngleBeforeAndAfterTurn = [];
    %transform speed to roundTspeed
    for nLab=1:length(uniqLabels)
        idsLab = ismember(xFileRoundT(:,1),uniqLabels(nLab));

        auxXFileRoundT= xFileRoundT(idsLab,:);
        auxUniqRoundTime = unique(round(auxXFileRoundT(:,2)));
        auxAvgXRoundT=arrayfun(@(x) mean(auxXFileRoundT(ismember(auxXFileRoundT(:,2),x),3)),auxUniqRoundTime);
        avgXPerRoundTFileAux = [ones(length(auxUniqRoundTime),1).*uniqLabels(nLab),auxUniqRoundTime,auxAvgXRoundT];
        % avgXFilePerRoundTFile = [avgXFilePerRoundTFile;avgXPerRoundTFileAux];

        auxYFileRoundT= yFileRoundT(idsLab,:);
        auxAvgYRoundT=arrayfun(@(x) mean(auxYFileRoundT(ismember(auxYFileRoundT(:,2),x),3)),auxUniqRoundTime);
        avgYPerRoundTFileAux = [ones(length(auxUniqRoundTime),1).*uniqLabels(nLab),auxUniqRoundTime,auxAvgYRoundT];
        % avgYFilePerRoundTFile = [avgYFilePerRoundTFile;avgYPerRoundTFileAux];
        

        %apply golay filter to smooth (shaky) larvae trajectories
        avgYPerRoundTFileAuxGolay = [avgYPerRoundTFileAux(:,1:2),sgolayfilt(avgYPerRoundTFileAux(:,3), 1, golayTimeWindow)];
        avgXPerRoundTFileAuxGolay = [avgXPerRoundTFileAux(:,1:2),sgolayfilt(avgXPerRoundTFileAux(:,3), 1, golayTimeWindow)];

        avgYFilePerRoundTFile = [avgYFilePerRoundTFile;avgYPerRoundTFileAuxGolay];
        avgXFilePerRoundTFile = [avgXFilePerRoundTFile;avgXPerRoundTFileAuxGolay];

        

    end

    larvaeAngleXY = calculateAngleMovLarvae(avgXFilePerRoundTFile, avgYFilePerRoundTFile);


%%THE ANGLE CALCULATION BASED ON THE SPINE IS TEMPORARY IN QUARANTINE DUE TO UNCERTAINTY IN LARVAE CONTOUR AND SKELETON PRECISION 
    anglesTail2Head_RoundT=[];
    curveTail2Mid2Head_RoundT=[];
    posTailLarvae_RoundT=[];
    % %% Code to calcultate larvae orientation from Spine
    % [totalAnglesTail2HeadLarvae,curveLarvaeHeadMidTail,tailLarvae] = calculateHeadTailCenterAngles(larvaeAngleXY,spineFile);
    % 
    % anglesTail2Head_RoundT = [];
    % curveTail2Mid2Head_RoundT =[];
    % posTailLarvae_RoundT = [];
    % %%choose the angle closer to the round second
    % uniqLabelsSpine = unique(totalAnglesTail2HeadLarvae(:,1));
    % for nLabSp=1:length(uniqLabelsSpine)
    %     idL = ismember(totalAnglesTail2HeadLarvae(:,1),uniqLabelsSpine(nLabSp));
    %     uniqueRoundTAux = unique(round(totalAnglesTail2HeadLarvae(idL,2)));
    %     anglesAuxLarv = totalAnglesTail2HeadLarvae(idL,:);
    %     curvAuxLarv = curveLarvaeHeadMidTail(idL,:);
    %     tailPosAux = tailLarvae(idL,:);
    % 
    % 
    %     tempAnglesLarva = zeros(size(uniqueRoundTAux,1),3);
    %     tempCurveLarva = zeros(size(uniqueRoundTAux,1),3);
    %     tempTailPosLarva = zeros(size(uniqueRoundTAux,1),4);
    % 
    %     for nAuxT=1:length(uniqueRoundTAux)
    %         [~,idMin]=min(pdist2(anglesAuxLarv(:,2),uniqueRoundTAux(nAuxT)));
    %         tempAnglesLarva(nAuxT,:) = [anglesAuxLarv(idMin,1),uniqueRoundTAux(nAuxT),anglesAuxLarv(idMin,3)];
    % 
    %         [~,idMin]=min(pdist2(curvAuxLarv(:,2),uniqueRoundTAux(nAuxT)));
    %         tempCurveLarva(nAuxT,:) = [curvAuxLarv(idMin,1),uniqueRoundTAux(nAuxT),curvAuxLarv(idMin,3)];
    % 
    %         [~,idMin]=min(pdist2(tailPosAux(:,2),uniqueRoundTAux(nAuxT)));
    %         tempTailPosLarva(nAuxT,:) = [tailPosAux(idMin,1),uniqueRoundTAux(nAuxT),tailPosAux(idMin,3:4)];
    %     end
    %     anglesTail2Head_RoundT=[anglesTail2Head_RoundT;tempAnglesLarva];
    %     curveTail2Mid2Head_RoundT=[curveTail2Mid2Head_RoundT;tempCurveLarva];
    %     posTailLarvae_RoundT=[posTailLarvae_RoundT;tempTailPosLarva];
    % 
    % end

    uniqRoundTime = unique(round(larvaeAngleXY(:,2)));
    
    propLarvInAnglGroup=zeros(length(uniqRoundTime),4);
    allLarvaeOrientationXYPerSec = [];
    for nSec=1:length(uniqRoundTime)
        idT=ismember(round(larvaeAngleXY(:,2)),uniqRoundTime(nSec));
        uniqLabelsSec = unique(larvaeAngleXY(idT,1));
        
        %classify the angles in 4 groups as explained in the header (<- ; -> ; ^ ; v )
        auxLarvInGroups=zeros(length(uniqLabelsSec),4);
    
        for nLar = 1:length(uniqLabelsSec)
            idLar = ismember(larvaeAngleXY(:,1),uniqLabelsSec(nLar));
            group2 = larvaeAngleXY(idLar & idT,3)>=angThreshold(1) & larvaeAngleXY(idLar & idT,3) < angThreshold(2);  %right
            group3 = larvaeAngleXY(idLar & idT,3)>=angThreshold(2) & larvaeAngleXY(idLar & idT,3) < angThreshold(3);  %top
            group1 = larvaeAngleXY(idLar & idT,3)>=angThreshold(3) & larvaeAngleXY(idLar & idT,3) < angThreshold(4);  %left
            group4 = larvaeAngleXY(idLar & idT,3)>=angThreshold(4) | larvaeAngleXY(idLar & idT,3) < angThreshold(1);  %bottom
            [~,idGroup]=max([group1,group2,group3,group4]);
            auxLarvInGroups(nLar,idGroup)=1;
        end
    
        larvaeOrientationPerSec = [uniqLabelsSec,ones(size(uniqLabelsSec)).*uniqRoundTime(nSec),auxLarvInGroups];
    
        allLarvaeOrientationXYPerSec=[allLarvaeOrientationXYPerSec;larvaeOrientationPerSec];
        propLarvInAnglGroup(nSec,:)=sum(auxLarvInGroups,1)/sum(auxLarvInGroups(:));
    end
    % 
    % figure;hold on
    % 
    % plot(uniqRoundTime,propLarvInAnglGroup(:,1),'-r', 'LineWidth', 2);
    % plot(uniqRoundTime,propLarvInAnglGroup(:,2),'-b', 'LineWidth', 2);
    % plot(uniqRoundTime,propLarvInAnglGroup(:,3),'-p', 'LineWidth', 2);
    % plot(uniqRoundTime,propLarvInAnglGroup(:,4),'-k', 'LineWidth', 2);
    % legend({'left','right','top','bottom'})
    
    
    [~,idOrd]=sort(allLarvaeOrientationXYPerSec(:,1));
    orderedAllLarvOrientPerSec=allLarvaeOrientationXYPerSec(idOrd,:);


end
