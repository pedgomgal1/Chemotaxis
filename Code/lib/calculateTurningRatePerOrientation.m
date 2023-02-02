function [runRatePerOrient,stopRatePerOrient,turningRatePerOrient] = calculateTurningRatePerOrientation(orderedLarvaePerStatesRunStopTurn,orderedAllLarvOrientPerSec)

    ids1 = ismember(orderedLarvaePerStatesRunStopTurn(:,1:2),orderedAllLarvOrientPerSec(:,1:2),'rows');
    ids2 = ismember(orderedAllLarvOrientPerSec(:,1:2),orderedLarvaePerStatesRunStopTurn(:,1:2),'rows');
    orderedLarvaePerStatesRunStopTurn(~ids1,:)=[];
    orderedAllLarvOrientPerSec(~ids2,:)=[];
    
    orderedLarvaePerStatesRunStopTurn_ord=sortrows(orderedLarvaePerStatesRunStopTurn);
    orderedAllLarvOrientPerSec_ord=sortrows(orderedAllLarvOrientPerSec);


    turningRate_left = sum(orderedAllLarvOrientPerSec_ord(logical(orderedLarvaePerStatesRunStopTurn_ord(:,end)),3))/size(orderedLarvaePerStatesRunStopTurn_ord,1);
    turningRate_right= sum(orderedAllLarvOrientPerSec_ord(logical(orderedLarvaePerStatesRunStopTurn_ord(:,end)),4))/size(orderedLarvaePerStatesRunStopTurn_ord,1);
    turningRate_top= sum(orderedAllLarvOrientPerSec_ord(logical(orderedLarvaePerStatesRunStopTurn_ord(:,end)),5))/size(orderedLarvaePerStatesRunStopTurn_ord,1);
    turningRate_bottom= sum(orderedAllLarvOrientPerSec_ord(logical(orderedLarvaePerStatesRunStopTurn_ord(:,end)),6))/size(orderedLarvaePerStatesRunStopTurn_ord,1);

    stopRate_left = sum(orderedAllLarvOrientPerSec_ord(logical(orderedLarvaePerStatesRunStopTurn_ord(:,end-1)),3))/size(orderedLarvaePerStatesRunStopTurn_ord,1);
    stopRate_right= sum(orderedAllLarvOrientPerSec_ord(logical(orderedLarvaePerStatesRunStopTurn_ord(:,end-1)),4))/size(orderedLarvaePerStatesRunStopTurn_ord,1);
    stopRate_top= sum(orderedAllLarvOrientPerSec_ord(logical(orderedLarvaePerStatesRunStopTurn_ord(:,end-1)),5))/size(orderedLarvaePerStatesRunStopTurn_ord,1);
    stopRate_bottom= sum(orderedAllLarvOrientPerSec_ord(logical(orderedLarvaePerStatesRunStopTurn_ord(:,end-1)),6))/size(orderedLarvaePerStatesRunStopTurn_ord,1);

    runRate_left = sum(orderedAllLarvOrientPerSec_ord(logical(orderedLarvaePerStatesRunStopTurn_ord(:,end-2)),3))/size(orderedLarvaePerStatesRunStopTurn_ord,1);
    runRate_right= sum(orderedAllLarvOrientPerSec_ord(logical(orderedLarvaePerStatesRunStopTurn_ord(:,end-2)),4))/size(orderedLarvaePerStatesRunStopTurn_ord,1);
    runRate_top= sum(orderedAllLarvOrientPerSec_ord(logical(orderedLarvaePerStatesRunStopTurn_ord(:,end-2)),5))/size(orderedLarvaePerStatesRunStopTurn_ord,1);
    runRate_bottom= sum(orderedAllLarvOrientPerSec_ord(logical(orderedLarvaePerStatesRunStopTurn_ord(:,end-2)),6))/size(orderedLarvaePerStatesRunStopTurn_ord,1);


    runRatePerOrient=[runRate_left,runRate_right,runRate_top,runRate_bottom];
    stopRatePerOrient=[stopRate_left,stopRate_right,stopRate_top,stopRate_bottom];
    turningRatePerOrient=[turningRate_left,turningRate_right,turningRate_top,turningRate_bottom];

end