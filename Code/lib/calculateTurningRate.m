function [statesRunStopTurn,totalAccumAnglePerTurning,totalDurationTurningEvents,totalAngleBeforeAndAfterTurn,totalDurationStopEvents,totalAnglePreStop] = calculateTurningRate(angles_RoundT,avgXFilePerRoundTFileGolay, avgYFilePerRoundTFileGolay,globalConstants)

    accumAngleThreshold=globalConstants.accumAngleThreshold;
    timeAccumAngleThreshold=globalConstants.timeTurningThreshold;
    distanceThresholdForTurning=globalConstants.distanceThresholdForTurning;
    thresholdDistanceStop=globalConstants.thresholdDistance;

    uniqueLarv = unique(avgXFilePerRoundTFileGolay(:,1));
    statesRunStopTurn = zeros(size(angles_RoundT,1),5);
    statesRunStopTurn(:,1:2) = angles_RoundT(:,1:2);

    totalAccumAnglePerTurning=[];
    totalDurationTurningEvents=[];
    totalAngleBeforeAndAfterTurn=[];
    totalAnglePreStop = [];
    totalDurationStopEvents = [];
    for nLarv=1:length(uniqueLarv)
        
        idLarv = ismember(angles_RoundT(:,1),uniqueLarv(nLarv));

        anglesPerID= angles_RoundT(idLarv,3);
        XPerID = avgXFilePerRoundTFileGolay(idLarv,3);
        YPerID = avgYFilePerRoundTFileGolay(idLarv,3);

        %% check turning events and angular state
        angularDiff=rad2deg([angdiff(deg2rad(anglesPerID(1:end-1)),deg2rad(anglesPerID(2:end)))]);
        isTurning=turningThresholding(angularDiff,accumAngleThreshold,timeAccumAngleThreshold);

        %%check minimum distance to be considered turning point
        diffY=YPerID(1:end-1)-YPerID(2:end);
        diffX=XPerID(1:end-1)-XPerID(2:end);
        distXYperT = sqrt(diffX.^2 + diffY.^2);
        isTurning(distXYperT>distanceThresholdForTurning)=0;
        
        independentTurningEvents = bwlabel(isTurning);
        accumAnglePerTurning= arrayfun(@(x) sum(abs(angularDiff(independentTurningEvents==x))),unique(independentTurningEvents(independentTurningEvents>0))) ;
        % events2discard = find(accumAnglePerTurning<accumAngleThreshold);
        
        % independentTurningEvents(ismember(independentTurningEvents,events2discard))=0;
        isTurning(independentTurningEvents==0)=0;
        
        % accumAnglePerTurning(events2discard)=[];
        % numberOfTurnings = length(unique(independentTurningEvents))-1;
        durationTurningEvents= arrayfun(@(x) sum((independentTurningEvents==x)),unique(independentTurningEvents(independentTurningEvents>0))) ;
        totalAccumAnglePerTurning=[totalAccumAnglePerTurning;accumAnglePerTurning];
        totalDurationTurningEvents=[totalDurationTurningEvents;durationTurningEvents];
                
        anglesInTurnEvent= arrayfun(@(x) anglesPerID([false;independentTurningEvents==x]),unique(independentTurningEvents(independentTurningEvents>0)),'UniformOutput',false);
        totalAngleBeforeAndAfterTurn = [totalAngleBeforeAndAfterTurn; cell2mat(cellfun(@(x) [x(1),x(end)],anglesInTurnEvent,'UniformOutput',false))];

        %% check stop events and angular state
        isStopped = sqrt((XPerID(1:end-1)-XPerID(2:end)).^2 + (YPerID(1:end-1)-YPerID(2:end)).^2)<thresholdDistanceStop;
        isStopped(isTurning==1)=0; %those events classified as turning cannot be classified as stopped
        independentStopEvents = bwlabel(isStopped);
        anglesInStopEvent= arrayfun(@(x) anglesPerID([false;independentStopEvents==x]),unique(independentStopEvents(independentStopEvents>0)),'UniformOutput',false);
        totalAnglePreStop = [totalAnglePreStop; cellfun(@(x) x(1),anglesInStopEvent)];
        totalDurationStopEvents= [totalDurationStopEvents; arrayfun(@(x) sum((independentStopEvents==x)),unique(independentStopEvents(independentStopEvents>0)))];


        isRunning = ~(isStopped | isTurning);
        
        statesRunStopTurn(idLarv,3)=[true; isRunning]; % running state
        statesRunStopTurn(idLarv,4)=[false; isStopped];% Stop state
        statesRunStopTurn(idLarv,5)=[false; isTurning]; % Turning state

        % figure; hold on;%plot(avgYPerRoundTFileAux(:,3)*10,avgXPerRoundTFileAux(:,3)*10),
        % plot(YPerID*10,XPerID*10)
        % plot(YPerID([false; isTurning])*10,XPerID([false; isTurning])*10,'o')
        % % plot(YPerID([false; isRunning])*10,XPerID([false; isRunning])*10,'*')
        % 
        % plot(YPerID([false; isStopped])*10,XPerID([false; isStopped])*10,'*')
        % xlim([0,2000])
        % ylim([0 2000])
        % % axis equal
        % % hold off 


    end

end