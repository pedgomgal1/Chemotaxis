function  meanTortuosity=calculateTortuosity(avgXFilePerRoundTFile,avgYFilePerRoundTFile)
    
    %%Based on (Loveless et al. 2019, PLoS Comput Biol.) T = 1 - D/L. D is the
    %%net displacement. L the whole trajectory, all the accumulated
    %%displacements.
    
    %weight the Tortuosity by time of larvae trajectory
    uniqIDs = unique(avgXFilePerRoundTFile(:,1));
    nLarvae=length(uniqIDs);
    D = zeros(1,nLarvae);
    L = zeros(1,nLarvae);
    t = zeros(1,nLarvae);
    T = zeros(1,nLarvae);
    weightedT = zeros(1,nLarvae);
    for nL=1:nLarvae
        isLarva = avgXFilePerRoundTFile(:,1)==uniqIDs(nL);
        xyLarvae = [avgXFilePerRoundTFile(isLarva,3),avgYFilePerRoundTFile(isLarva,3)];
        D(nL)= sqrt((xyLarvae(1,1)-xyLarvae(end,1))^2 + (xyLarvae(1,2)-xyLarvae(end,2))^2);
        L(nL)= sum(sqrt(((xyLarvae(1:end-1,1)-xyLarvae(2:end,1)).^2) + ((xyLarvae(1:end-1,2)-xyLarvae(2:end,2)).^2)));
        t(nL)=size(xyLarvae,1)-1;
        T(nL)=1-D(nL)/L(nL);
        weightedT(nL)=T(nL)*(t(nL)/(size(avgXFilePerRoundTFile,1)-nLarvae)); %weight tortuosity by fraction of larvae time, relative to the total number of seconds
    end

    meanTortuosity=sum(weightedT);

end