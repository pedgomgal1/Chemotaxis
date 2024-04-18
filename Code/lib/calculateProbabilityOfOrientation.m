function [tab_matrixProbOrientation,tab_transitionMatrixOrientation]=calculateProbabilityOfOrientation(orderedAllLarvOrientPerSec,nOrientStages,varNames,rowNames)

    matrixProbOrientation = zeros(nOrientStages,nOrientStages);
    uniqLabels = unique(orderedAllLarvOrientPerSec(:,1));
    for nLar = 1:length(uniqLabels)
        idsLab = ismember(orderedAllLarvOrientPerSec(:,1),uniqLabels(nLar));
        larvOrientPerSec = orderedAllLarvOrientPerSec(idsLab,3:end);
        auxCellMatrix=mat2cell(larvOrientPerSec,ones(size(larvOrientPerSec,1),1) ,nOrientStages);
        auxChangPosition =cellfun(@(x,y) [find(x),find(y)],auxCellMatrix(1:end-1,:),auxCellMatrix(2:end,:),'UniformOutput',false);
        for nT=1:size(auxChangPosition,1)
            subIndAux = [auxChangPosition{nT}];
            matrixProbOrientation(subIndAux(1),subIndAux(2))=matrixProbOrientation(subIndAux(1),subIndAux(2))+1;    
        end
    
    end
    
    %TRANSITION MATRIX - MARKOV CHAIN
    transitionMatrixOrientation = matrixProbOrientation./sum(matrixProbOrientation);

    tab_matrixProbOrientation=array2table(matrixProbOrientation,'VariableNames',varNames,'RowNames',rowNames);
    tab_transitionMatrixOrientation= array2table(transitionMatrixOrientation,'VariableNames',varNames,'RowNames',rowNames);
end