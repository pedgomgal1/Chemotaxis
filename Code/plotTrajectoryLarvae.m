function plotTrajectoryLarvae(dataSpine,dataOutline,larvaeIDs)

    allLarvae=unique(larvaeIDs);
    cmap = colorcube(length(allLarvae));
    randIDs = randperm(length(allLarvae),length(allLarvae));
    cmapRand = cmap(randIDs,:);


    maxTime=max(unique(dataSpine(:,3)));
    figure;hold on;
    ylim([0 250])
    xlim([0 175])

    larvaAppearedSpine = zeros(length(allLarvae),1);
    larvaAppearedOutline = zeros(length(allLarvae),1);

    labelTimeOutline = cell2mat(dataOutline(:,1:2));

    for sec = 0:round(maxTime)
        
        for nLarva = 1:length(allLarvae)
            allRowsSpineLarva = dataSpine(dataSpine(:,2)==allLarvae(nLarva),3:end);

            allRowsOutlineLarva = dataOutline(labelTimeOutline(:,1)==allLarvae(nLarva),:);
            selectedRowsOutlineLabelTime = labelTimeOutline(labelTimeOutline(:,1)==allLarvae(nLarva),:);

            if any(round(allRowsSpineLarva(:,1))==sec)
               roundSpineSeconds = round(allRowsSpineLarva(:,1));

               selectedSpineRows = allRowsSpineLarva(roundSpineSeconds==sec,:);

               [~,idMinSpine]=min(pdist2(sec,selectedSpineRows(:,1)));

               if mod(sec,3)==0
                    plot(selectedSpineRows(idMinSpine,2:2:end),selectedSpineRows(idMinSpine,3:2:end),'Color',cmapRand(nLarva,:),'MarkerEdgeColor',cmapRand(nLarva,:),'LineWidth',1)
               end
               larvaAppearedSpine(nLarva)=larvaAppearedSpine(nLarva)+1;
               
%                if larvaAppeared(nLarva)==1
%                     text(selectedSpineRows(idMinSpine,2),selectedSpineRows(idMinSpine,3),['id' num2str(allLarvae(nLarva)) ' t' num2str(sec)])
%                end
%                if larvaAppeared(nLarva)==max(roundSpineSeconds)+1
%                     text(selectedSpineRows(idMinSpine,2),selectedSpineRows(idMinSpine,3),['id' num2str(allLarvae(nLarva)) ' t' num2str(sec)])
%                end

            end

            if any(round(selectedRowsOutlineLabelTime(:,2))==sec) 
                larvaAppearedOutline(nLarva)=larvaAppearedOutline(nLarva)+1;
                roundOutlineSeconds = round(selectedRowsOutlineLabelTime(:,2));
                if (larvaAppearedOutline(nLarva)==1 || larvaAppearedOutline(nLarva)==max(roundOutlineSeconds)+1)
                   selectedOutlineRowsSec = allRowsOutlineLarva(roundOutlineSeconds==sec,:);
                   selectedRowsOutlineLabelTimeSec = selectedRowsOutlineLabelTime(roundOutlineSeconds==sec,:);
                   [~,idMinOutline]=min(pdist2(sec,selectedRowsOutlineLabelTimeSec(:,2)));
                   plot(selectedOutlineRowsSec{idMinOutline,3},selectedOutlineRowsSec{idMinOutline,4},'Color',cmapRand(nLarva,:),'MarkerEdgeColor',cmapRand(nLarva,:),'LineWidth',1)
                end
            end

        end
        title([num2str(sec) ' / ' num2str(round(maxTime)) ' seconds'])
    end
end