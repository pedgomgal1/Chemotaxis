function [S]=stationaryDistributionHiddenMarkovChain(TM)
    St = eigs(TM);
    S  = St/sum(St); %S is the (normalized) stationary distribution
end