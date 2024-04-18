function turningEvents=turningThresholding(angularDiff,accumAngleThreshold,timeThreshold)
    turningEvents = false(size(angularDiff));

    for t=1:length(angularDiff)
        if t>=ceil(timeThreshold/2) && t<=length(angularDiff)-ceil(timeThreshold/2)
            ccAngle = sum(abs(angularDiff(t-ceil(timeThreshold/2)+1:t+ceil(timeThreshold/2)-1)));
            if sum(abs(ccAngle))>=accumAngleThreshold
                turningEvents(t)=1;
            end
        else
            ccAngle=0;
            if t<=ceil(timeThreshold/2)
                ccAngle= sum(abs(angularDiff(1:t+ceil(timeThreshold/2)-1)));
            end
            if t>=length(angularDiff)-ceil(timeThreshold/2)
                ccAngle = sum(abs(angularDiff(t-ceil(timeThreshold/2)+1:end)));
            end
            
            if sum(abs(ccAngle))>=accumAngleThreshold
                turningEvents(t)=1;
            end
        end
    end

end