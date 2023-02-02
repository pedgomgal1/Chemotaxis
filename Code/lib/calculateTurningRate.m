function [statesRunStopTurn] = calculateTurningRate(anglesTail2Head_RoundT,posTailLarvae_RoundT,thresholdAngle,thresholdDistance)

    uniqueLarv = unique(anglesTail2Head_RoundT(:,1));

    statesRunStopTurn = zeros(size(anglesTail2Head_RoundT,1),5);
    statesRunStopTurn(:,1:2) = anglesTail2Head_RoundT(:,1:2);

    for nLarv=1:length(uniqueLarv)
        
        idLarv = ismember(anglesTail2Head_RoundT(:,1),uniqueLarv(nLarv));
        uniqueT=unique(anglesTail2Head_RoundT(idLarv,2));

        for nT =1:length(uniqueT)
            idT = ismember(anglesTail2Head_RoundT(:,2),uniqueT(nT));
            
            if nT==1
      
            else
                idT_prev = ismember(anglesTail2Head_RoundT(:,2),uniqueT(nT-1));
                isTurning = abs(rad2deg(angdiff(deg2rad(anglesTail2Head_RoundT(idLarv & idT,3)),deg2rad(anglesTail2Head_RoundT(idLarv & idT_prev,3)))))>thresholdAngle; 
                isStopped = pdist2(posTailLarvae_RoundT(idLarv & idT,3:4),posTailLarvae_RoundT(idLarv & idT_prev,3:4)) < thresholdDistance; 

                if ~isStopped && ~isTurning
                    statesRunStopTurn(idLarv & idT,3)=1; % 
                end
                if isStopped && ~isTurning
                    statesRunStopTurn(idLarv & idT,4)=1;% Stop state
                end
                if isTurning
                    statesRunStopTurn(idLarv & idT,5)=1; % Turning state
                end
            end

        end
    end

    ids_0s = sum(statesRunStopTurn(:,3:5),2)==0;

    statesRunStopTurn(ids_0s,:)=[];

end