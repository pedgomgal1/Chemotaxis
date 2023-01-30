function [meanAngularSpeedPerT,stdAngularSpeedPerT,semAngularSpeedPerT,avgStdAngularSpeed,avgMeanAngularSpeed,avgSemAngularSpeed,angularSpeed,meanAngularAccelerationPerT,angularAcceleration] = calculateAngularSpeed (larvaeAngle)
    
    angularSpeed = larvaeAngle;
    angularSpeed(:,3)=0;
    angularAcceleration=larvaeAngle;
    angularAcceleration(:,3)=0;
    
    uniqLarv= unique(larvaeAngle(:,1));
    dT=1;%sec
    for nLarv=1:length(uniqLarv)
        idLarv = ismember(larvaeAngle(:,1),uniqLarv(nLarv));
        posIdLarv = find(idLarv);
        auxAngLarv = larvaeAngle(idLarv,:);
        for nSec = 1:sum(idLarv)
            if nSec==1
                angularSpeed(posIdLarv(nSec),3)=rad2deg(angdiff(deg2rad(auxAngLarv(nSec,3)), deg2rad(auxAngLarv(nSec+1,3))));            
            elseif nSec==sum(idLarv)
                angularSpeed(posIdLarv(nSec),3)=rad2deg(angdiff(deg2rad(auxAngLarv(nSec,3)), deg2rad(auxAngLarv(nSec-1,3))));   
            else
                angularSpeed(posIdLarv(nSec),3)=(rad2deg(angdiff(deg2rad(auxAngLarv(nSec,3)), deg2rad(auxAngLarv(nSec-1,3)))) + rad2deg(angdiff(deg2rad(auxAngLarv(nSec,3)), deg2rad(auxAngLarv(nSec+1,3)))))/2;   
            end
        end

        dV = gradient(abs(angularSpeed(posIdLarv,3)));
        acc = dV/dT;
        angularAcceleration(posIdLarv,3)=acc;
    end

    angularSpeed(:,3)=abs(angularSpeed(:,3));

    uniqT=unique(angularSpeed(:,2));

    meanAngularSpeedPerT = arrayfun(@(x) mean([angularSpeed(ismember(angularSpeed(:,2),x),3)]), uniqT);

    meanAngularAccelerationPerT = arrayfun(@(x) mean([angularAcceleration(ismember(angularAcceleration(:,2),x),3)]), uniqT);

    stdAngularSpeedPerT = arrayfun(@(x) std([angularSpeed(ismember(angularSpeed(:,2),x),3)]), uniqT);
    semAngularSpeedPerT = arrayfun(@(x) std([angularSpeed(ismember(angularSpeed(:,2),x),3)])/sqrt(sum(ismember(angularSpeed(:,2),x))), uniqT);

    avgMeanAngularSpeed = mean(meanAngularSpeedPerT);
    avgStdAngularSpeed = mean(stdAngularSpeedPerT);
    avgSemAngularSpeed=mean(semAngularSpeedPerT);
end

