function  [orderedLarvaePerStatesRunStopTurnCast,orientationBeforeAfter_casting,orientationBeforeAfter_turning] = discriminateTurningAndCasting(orderedLarvaePerStatesRunStopTurn,turnOrCastStates,thresholdAngle,larvaeAngle)

    idLarvCast = unique(turnOrCastStates(:,1));

    %remove second 0 to larvaeAngle
    larvaeAngle(larvaeAngle(:,2)==0,:)=[];

    

    orderedLarvaePerStatesRunStopTurnCast=[orderedLarvaePerStatesRunStopTurn(:,1:end-1), zeros(size(orderedLarvaePerStatesRunStopTurn,1),2)];

    %%calculate additionally, larvae orientation before and after casting
    orientationBeforeAfter_casting = [];
    orientationBeforeAfter_turning = [];

    for nLarv = 1:length(idLarvCast)

        %join all the angular states (casting and turning) mixing the
        %behaviour classifier and the angular thresholding
        auxLarvState = turnOrCastStates(turnOrCastStates(:,1)==idLarvCast(nLarv),:);
        roundT = round(turnOrCastStates(turnOrCastStates(:,1)==idLarvCast(nLarv),2));
        auxLarvState(:,2) = roundT;

        idsLarvTotalStates = orderedLarvaePerStatesRunStopTurn(:,1)==idLarvCast(nLarv);
        auxTurnTotalStates = orderedLarvaePerStatesRunStopTurn(idsLarvTotalStates,[2,end]);

        for totalTAux = 1:size(auxTurnTotalStates,1)
           if  any(ismember(auxTurnTotalStates(totalTAux,1),auxLarvState(:,2)))

                if any(any(auxLarvState(auxLarvState(:,2)==auxTurnTotalStates(totalTAux,1),[end-1, end])))
                    auxTurnTotalStates(totalTAux,end)=1;
                end

           end
        end


        %%separate turning and casting & remove false positive by
        %%thresholding
       
        %% label individual states
        labelStates = bwlabel(auxTurnTotalStates(:,end));
        unqStates = unique(labelStates);
        unqStates(unqStates==0)=[];

        larvaeAngleAux = larvaeAngle(larvaeAngle(:,1)==idLarvCast(nLarv),:);
        larvaeAngleAux = larvaeAngleAux(ismember(larvaeAngleAux(:,2),auxTurnTotalStates(:,1)),:);
        auxRunStopTurnCastStates = orderedLarvaePerStatesRunStopTurnCast(idsLarvTotalStates,:);

        for nStates = 1:length(unqStates)
            idStates = find(labelStates==unqStates(nStates));

            %% get larva angles during the possible turning or casting events
            if min(idStates) ~= 1 && max(idStates) ~= length(labelStates)
                anglesState = larvaeAngleAux([min(idStates)-1;idStates;max(idStates)+1],end);
            else
                if min(idStates) == 1 && max(idStates) == length(labelStates)
                    anglesState = larvaeAngleAux(idStates,end);
                else
                    if min(idStates) == 1
                        anglesState = larvaeAngleAux([idStates;max(idStates)+1],end);
                    end
                    if max(idStates) == length(labelStates)
                        anglesState = larvaeAngleAux([min(idStates)-1;idStates],end);
                    end
                end
            end
            
            %% threshold behaviours

            if ~any(abs(anglesState(1)-anglesState)>thresholdAngle) %if there is not an angular change of at least 30 degrees, then, discard this behaviour as turning or casting.
                  %%FALSE POSSITIVE. CHANGE TO RUN OR STOP
                  id2run = auxRunStopTurnCastStates(idStates,3)==0 & auxRunStopTurnCastStates(idStates,4)==0;
                  auxRunStopTurnCastStates(idStates(id2run),3)=1;
                  auxRunStopTurnCastStates(idStates(id2run),4:end)=0;
            else
                angDiff = anglesState(1:end-1)-anglesState(2:end);
                %if there are positive and negative angular changes, then
                %casting. If the behaviour takes more than 3 seconds, then
                %casting as weel. 
                if any(angDiff<-thresholdAngle) && any(angDiff>thresholdAngle) || (any(anglesState(1)-anglesState)>thresholdAngle && any(anglesState(1)-anglesState)<(-thresholdAngle)) || length(idStates)>3 %then, ASSING TO CASTING
                    auxRunStopTurnCastStates(idStates,3:end)=0;
                    auxRunStopTurnCastStates(idStates,end)=1;
                    
                    %get angles before and after casting
                    orientationBeforeAfter_casting = [orientationBeforeAfter_casting; anglesState(1), anglesState(end)];
                else
                    %if the angular change is just in one direction, then
                    %turning
                    if any(angDiff<(-thresholdAngle)) || any(angDiff>thresholdAngle) %then, ASSING to TURNING
                        auxRunStopTurnCastStates(idStates,end-1)=1;
                        auxRunStopTurnCastStates(idStates,[3,4,end])=0;
                        orientationBeforeAfter_turning = [orientationBeforeAfter_turning; anglesState(1), anglesState(end)];
                    else
                        %%FALSE POSITIVE, then assing to RUN
                        auxRunStopTurnCastStates(idStates,3)=1;
                        auxRunStopTurnCastStates(idStates,4:end)=0;
                    end
                end


            end

        end
        orderedLarvaePerStatesRunStopTurnCast(idsLarvTotalStates,:) = auxRunStopTurnCastStates;   

    end







end