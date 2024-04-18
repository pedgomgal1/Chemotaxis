function MSD_ensemble = calculatedMSDassumingXYorigin(avgXFilePerRoundTFile,avgYFilePerRoundTFile,globalConstants)

    % Calculate mean squared displacement (MSD) for each trajectory
    % assuming larvae initial position in [0,0]
    IDslarvae=unique(avgXFilePerRoundTFile(:,1));
    MSD_individual = zeros(length(IDslarvae), numel(globalConstants.nTPoints));
    for larva = 1:length(IDslarvae)
        for t = 1:numel(globalConstants.nTPoints)
            % Check if the larva has a valid position at time t
            isLarvaID =avgXFilePerRoundTFile(:,1)==IDslarvae(larva);
            isT = avgXFilePerRoundTFile(:,2)==t-1;
            isLarvaInT = isLarvaID & isT;
	        if any(isLarvaInT)
                % Calculate displacement squared relative to assumed initial position (0,0)
                displacement_squared = avgXFilePerRoundTFile(isLarvaInT, 3)^2 + avgYFilePerRoundTFile(isLarvaInT, 3)^2;
                MSD_individual(larva,t) = displacement_squared;
            else
                % If position is missing, set displacement squared to NaN
                MSD_individual(larva,t) = NaN;
            end
        end
    end
    
    % Sum all individual displacements. ensemble MSD by averaging over all trajectories
    MSD_ensemble = mean(MSD_individual,"omitnan");
    for nT= 2:numel(globalConstants.nTPoints)
        MSD_ensemble(nT)=MSD_ensemble(nT-1)+MSD_ensemble(nT);
    end

    %rest MSD_ensemble in t=0 to remove the offset
    MSD_ensemble= MSD_ensemble-MSD_ensemble(1);


    % % Plot ensemble MSD over time
    % time = globalConstants.nTPoints;
    % plot(time, MSD_ensemble, 'bo-');
    % xlabel('Time (seconds)');
end