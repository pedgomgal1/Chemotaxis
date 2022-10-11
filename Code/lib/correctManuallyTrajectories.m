function [tableSummaryFeaturesFiltered,xFileUpdated,yFileUpdated,cellOutlinesLarvaeUpdated,dataSpineUpdated]=correctManuallyTrajectories(tableSummaryFeaturesFiltered,xFileUpdated,yFileUpdated,cellOutlinesLarvaeUpdated,dataSpineUpdated,imgInit,minTimeTraj,maxTimeTraj,maxLengthLarvaeTrajectory,booleanSave)
   
    %% DO YOU WANT TO COMBINE TRAJECTORIES???
    combineIDSelection = 'Yes';
    while strcmp(combineIDSelection,'Yes')
        combineIDSelection = questdlg('Do you want to combine IDs?', '','Yes','No, all right','Yes');
        
        if ~strcmp(combineIDSelection,'Yes')
            break
        end
        answer = inputdlg('Enter ALL space-separated IDs to be combined: (e.g.: 1 3 4; 2 3 4; 6 7 8):','Combine IDs', [1 50]);
        if ~isempty(answer)
            try
                ids2Combine = str2num(answer{1});
                allIds = tableSummaryFeaturesFiltered.id;
                allIdsOrdered = mat2cell(allIds);
                for nComb = 1:size(ids2Combine,2)
                    idMin = min(ids2Combine(nComb,:));
                    allIdsOrdered{allIds==idMin}=ids2Combine(nComb,:);
                end
                [xFileUpdated]=updateLabelsFile(allIdsOrdered,xFileUpdated);
                [yFileUpdated]=updateLabelsFile(allIdsOrdered,yFileUpdated);
    
                tableSummaryFeaturesFiltered=updateTableProperties(tableSummaryFeaturesFiltered,allIdsOrdered);
                if ~isempty(cellOutlinesLarvaeUpdated)
                    [dataSpineUpdated]=updateLabelsFile(orderedLarvae,dataSpineUpdated);
                    [cellOutlinesLarvaeUpdated]=updateOutlinesFile(orderedLarvae,cellOutlinesLarvaeUpdated);
                end
            catch
                disp('Something is wrong, try again.')
            end
        end
    end
    
    %% DO YOU WANT TO REMOVE TRAJECTORIES (ARTIFACTS)???
    plotTrajectoryLarvae([],xFileUpdated,yFileUpdated,tableSummaryFeaturesFiltered.id,'',imgInit,minTimeTraj,maxTimeTraj,maxLengthLarvaeTrajectory,booleanSave)
    removeIDSelection = 'Yes';
    while strcmp(removeIDSelection,'Yes')
        removeIDSelection = questdlg('Do you want to remove any ID?', '','Yes','No, all right','Yes');
        if ~strcmp(removeIDSelection,'Yes')
            break
        end
        answer = inputdlg('Enter ALL space-separated IDs to be combined: (e.g.: 1 3 4):','remove IDs', [1 50]);
         
        if ~isempty(answer)
            try
                ids2Remove = str2num(answer{1});
                xFileUpdated(ismember(xFileUpdated(:,2),ids2Remove),:)=[];
                yFileUpdated(ismember(yFileUpdated(:,2),ids2Remove),:)=[];
                tableSummaryFeaturesFiltered(ismember(tableSummaryFeaturesFiltered.id,ids2Remove),:) = [];
                
                plotTrajectoryLarvae([],[],xFileUpdated,yFileUpdated,tableSummaryFeaturesFiltered.id,'',imgInit,minTimeTraj,maxTimeTraj,booleanSave)
    
                if ~isempty(outlineFile)
                    dataSpineUpdated(ismember(dataSpineUpdated(:,2),ids2Remove),:)=[];
                    cellOutlinesLarvaeUpdated(ismember(vertcat(cellOutlinesLarvaeUpdated{:,1}),ids2Remove),:)=[];
                end
            catch
                disp('Something is wrong, try again.')
            end
        end
    end

end