function meanFractalDimension = calculateFractalDimension(avgXFilePerRoundTFile,avgYFilePerRoundTFile)

    %weight the Fractal dimension by time of larvae trajectory
    uniqIDs = unique(avgXFilePerRoundTFile(:,1));
    nLarvae=length(uniqIDs);
    DF = zeros(1,nLarvae);
    t = zeros(1,nLarvae);
    weightedD = zeros(1,nLarvae);
    for nL=1:nLarvae
        isLarva = avgXFilePerRoundTFile(:,1)==uniqIDs(nL);
        xyLarvae = [avgXFilePerRoundTFile(isLarva,3),avgYFilePerRoundTFile(isLarva,3)];

        %params based on https://github.com/janeloveless/mechanics-of-exploration/blob/master/6_trajectory_analysis.py
        min_scale=3;
        max_scale = min([max(xyLarvae(:,1)) - min(xyLarvae(:,1)), max(xyLarvae(:,2)) - min(xyLarvae(:,2))]);
        num_scales =100;

        scales = linspace(min_scale, max_scale, num_scales);
        fractal_dim = calculate_fractal_dimension(xyLarvae(:,1), xyLarvae(:,2), scales);
        
        DF(nL)=fractal_dim;
        t(nL)=size(xyLarvae,1)-1;
        weightedD(nL)=DF(nL)*(t(nL)/(size(avgXFilePerRoundTFile,1)-nLarvae)); %weight tortuosity by fraction of larvae time, relative to the total number of seconds
    end
    meanFractalDimension=sum(weightedD);

end
