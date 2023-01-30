function [totalAnglesTail2HeadLarvae,curveLarvaeHeadMidTail,tailLarvae] = calculateHeadTailCenterAngles(larvaeAngleXY,spineFile)
    
    uniqLabels= unique(spineFile(:,1));
    centerLarvae=spineFile(:,[1:2,13:14]);
    tailLarvae=zeros(size(centerLarvae)); 
    headLarvae=zeros(size(centerLarvae)); 

    %%I'll place tail at left, head at right
    for nLab=1:length(uniqLabels)
    
        idsLab=ismember(spineFile(:,1),uniqLabels(nLab));
        auxSpine= spineFile(idsLab,:);

        %atan2d(y2 (head) -y1 (tail),x2 (head) - x1 (tail))
        larvaAng1=atan2d(auxSpine(1,4)-auxSpine(1,end),auxSpine(1,3)-auxSpine(1,end-1));
        larvaAng1(larvaAng1<0)=larvaAng1(larvaAng1<0)+360;

        tAng=round(auxSpine(2,2));

        angleXY = larvaeAngleXY(ismember(larvaeAngleXY(:,1),uniqLabels(nLab)) & ismember(larvaeAngleXY(:,2),tAng),3);

        difAngles = abs(rad2deg(angdiff(deg2rad(larvaAng1),deg2rad(angleXY))));

        if difAngles>120
            headLarvInit = auxSpine(1,end-1:end);
            tailLarvInit = auxSpine(1,3:4);
        else
            headLarvInit = auxSpine(1,3:4);
            tailLarvInit = auxSpine(1,end-1:end);
        end

        tailAux=tailLarvInit;
        headAux=headLarvInit;
        listTails = zeros(size(auxSpine,1),4);
        listHeads = zeros(size(auxSpine,1),4);
        for nT = 1:size(auxSpine,1)

            tipsLarva= [auxSpine(nT,3:4);auxSpine(nT,end-1:end)];
            [~,idMin]=min(pdist2(tailAux,tipsLarva));

            tailAux= tipsLarva(idMin,:);
            headAux= tipsLarva(3-idMin,:);

            listTails(nT,:)=[auxSpine(nT,1:2),tailAux];
            listHeads(nT,:)=[auxSpine(nT,1:2),headAux];
        end

        tailLarvae(idsLab,:)=listTails;
        headLarvae(idsLab,:)=listHeads;

    end

    %calculate of the angles considereing that we have classified properly
    %what is head and what is tail
    totalAnglesTail2HeadLarvae=[tailLarvae(:,1:2) , arrayfun(@(x1,y1,x2,y2) atan2d(y2-y1,x2-x1),tailLarvae(:,3),tailLarvae(:,4),headLarvae(:,3),headLarvae(:,4))];
    totalAnglesTail2HeadLarvae(totalAnglesTail2HeadLarvae(:,3)<0,3)=totalAnglesTail2HeadLarvae(totalAnglesTail2HeadLarvae(:,3)<0,3)+360;


    %Calculate curve of larvae splitting the larvae in two segmentes (tail-mid & mid-head)
    angleTailMid = arrayfun(@(x1,y1,x2,y2) atan2d(y2-y1,x2-x1),tailLarvae(:,3),tailLarvae(:,4),centerLarvae(:,3),centerLarvae(:,4));
    angleMidHead = arrayfun(@(x1,y1,x2,y2) atan2d(y2-y1,x2-x1),centerLarvae(:,3),centerLarvae(:,4),headLarvae(:,3),headLarvae(:,4));
    
    curveLarvaeHeadMidTail =[tailLarvae(:,1:2), abs(arrayfun(@(x,y) rad2deg(angdiff(deg2rad(x),deg2rad(y))),angleTailMid,angleMidHead))];

end
