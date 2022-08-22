function saveTemporalImageSequence(dataOutline,dataSpine,larvaeIDs,folder2save)

    allLarvae=unique(larvaeIDs);
    cmap = colorcube(length(allLarvae));
    randIDs = randperm(length(allLarvae),length(allLarvae));
    cmapRand = cmap(randIDs,:);

    labelTimeOutline = cell2mat(dataOutline(:,1:2));

    maxTime=max(unique(labelTimeOutline(:,2)));

    larvaAppearedOutline = zeros(length(allLarvae),1);

     for sec = 0:round(maxTime)
        h1=figure;hold on;
        ylim([0 250])
        xlim([0 175])
        for nLarva = 1:length(allLarvae)
            allRowsSpineLarva = dataSpine(dataSpine(:,2)==allLarvae(nLarva),3:end);
            
            if any(round(allRowsSpineLarva(:,1))==sec)
               
            end
            
            allRowsOutlineLarva = dataOutline(labelTimeOutline(:,1)==allLarvae(nLarva),:);
            selectedRowsOutlineLabelTime = labelTimeOutline(labelTimeOutline(:,1)==allLarvae(nLarva),:);
            if any(round(selectedRowsOutlineLabelTime(:,2))==sec) 
               larvaAppearedOutline(nLarva)=larvaAppearedOutline(nLarva)+1;
               roundOutlineSeconds = round(selectedRowsOutlineLabelTime(:,2));
               selectedOutlineRowsSec = allRowsOutlineLarva(roundOutlineSeconds==sec,:);
               selectedRowsOutlineLabelTimeSec = selectedRowsOutlineLabelTime(roundOutlineSeconds==sec,:);
               [~,idMinOutline]=min(pdist2(sec,selectedRowsOutlineLabelTimeSec(:,2)));
               
               plot(selectedOutlineRowsSec{idMinOutline,3},selectedOutlineRowsSec{idMinOutline,4},'Color',cmapRand(nLarva,:),'MarkerEdgeColor',cmapRand(nLarva,:),'LineWidth',0.5)

               if larvaAppearedOutline(nLarva)==1 || larvaAppearedOutline(nLarva)==max(roundOutlineSeconds)+1
                   text(mean(selectedOutlineRowsSec{idMinOutline,3}(:)),mean(selectedOutlineRowsSec{idMinOutline,4}(:)),[' ' num2str(allLarvae(nLarva))],'FontSize',10)
               else
                   text(mean(selectedOutlineRowsSec{idMinOutline,3}(:)),mean(selectedOutlineRowsSec{idMinOutline,4}(:)),['   ' num2str(allLarvae(nLarva))],'FontSize',3)
               end
               
               roundSpineSeconds = round(allRowsSpineLarva(:,1));
               selectedSpineRows = allRowsSpineLarva(roundSpineSeconds==sec,:);
               [~,idMinSpine]=min(pdist2(sec,selectedSpineRows(:,1)));
               plot(selectedSpineRows(idMinSpine,2:2:end),selectedSpineRows(idMinSpine,3:2:end),'Color',cmapRand(nLarva,:),'MarkerEdgeColor',cmapRand(nLarva,:),'LineWidth',0.5)

            end
        end
        saveas(h1,fullfile(folder2save,num2str(sec)),'png')
        hold off 
        close all
    end


end