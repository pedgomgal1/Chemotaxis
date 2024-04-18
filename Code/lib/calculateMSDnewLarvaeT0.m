function avg_MSD_Golay = calculateMSDnewLarvaeT0(avgXFilePerRoundTFile,avgYFilePerRoundTFile,globalConstants)

    IDslarvae=unique(avgXFilePerRoundTFile(:,1));
    MSDs = cell(length(IDslarvae),1);
    for ID_larva = 1:length(IDslarvae)
        isLarvaID =avgXFilePerRoundTFile(:,1)==IDslarvae(ID_larva);
        xyPosLarva = [avgXFilePerRoundTFile(isLarvaID,3), avgYFilePerRoundTFile(isLarvaID,3)];
        MSD=nan(1,numel(globalConstants.nTPoints));
        MSD(1)=0;
        for t = 2:size(xyPosLarva,1)
            % Calculate displacement squared for each larva at time t
            displacement_squared = (xyPosLarva(t, 1) - xyPosLarva(1, 1))^2 + (xyPosLarva(t, 2) - xyPosLarva(1, 2))^2;
            MSD(t) = MSD(t-1) + displacement_squared;
        end
        MSDs{ID_larva}=MSD;
    end
    avg_MSD = mean(vertcat(MSDs{:}),"omitnan");
    avg_MSD_Golay = sgolayfilt(avg_MSD,1, globalConstants.golayFilterStepsWindow);

end