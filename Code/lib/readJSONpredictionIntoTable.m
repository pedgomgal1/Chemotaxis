function tBehaviour = readJSONpredictionIntoTable(pathFile)
    str=fileread(pathFile);
    dataBehaviours=jsondecode(str);
    behaviours = dataBehaviours.labels;
    totalBehaviouralMatrix =[];
    for nId = 1:size(dataBehaviours.data,1)
    
        larvaIdBehaviour = [str2num(dataBehaviours.data(nId).id).*ones(size(dataBehaviours.data(nId).t)), [vertcat(dataBehaviours.data(nId).t)], double(horzcat(cell2mat(arrayfun(@(x) ismember(vertcat(dataBehaviours.data(nId).labels),x), 1:length(behaviours), 'UniformOutput', false))))];
        totalBehaviouralMatrix=[totalBehaviouralMatrix;larvaIdBehaviour];
    end
    
    tBehaviour = array2table(totalBehaviouralMatrix,'VariableNames',[{'id'}; {'t'}; vertcat(behaviours(:))]);
end