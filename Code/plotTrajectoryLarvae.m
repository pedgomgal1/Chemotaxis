function plotTrajectoryLarvae(dataSpine,larvaeIDs)

    allLarvae=unique(larvaeIDs);
    cmap = colorcube(length(allLarvae));
    randIDs = randperm(length(allLarvae),length(allLarvae));
    cmapRand = cmap(randIDs,:);


    maxTime=max(unique(dataSpine(:,3)));
    figure;hold on;

    larvaAppeared = zeros(length(allLarvae),1);

    for sec = 0:round(maxTime)
        for nLarva = 1:length(allLarvae)
            allRowsTrackLarva = dataSpine(dataSpine(:,2)==allLarvae(nLarva),3:end);
            if any(round(allRowsTrackLarva(:,1))==sec)
               roundSeconds = round(allRowsTrackLarva(:,1));
               selectedRows = allRowsTrackLarva(roundSeconds==sec,:);
               [~,idMin]=min(pdist2(sec,selectedRows(:,1)));
               plot(selectedRows(idMin,2:2:end),selectedRows(idMin,3:2:end),'Color',cmapRand(nLarva,:),'MarkerEdgeColor',cmapRand(nLarva,:),'LineWidth',1)
               larvaAppeared(nLarva)=larvaAppeared(nLarva)+1;
               
               if larvaAppeared(nLarva)==1
                    text(selectedRows(idMin,2),selectedRows(idMin,3),['ID ' num2str(allLarvae(nLarva)) ' T' num2str(allRowsTrackLarva(1,1))])
               end
               if larvaAppeared(nLarva)==max(roundSeconds)+1
                    text(selectedRows(idMin,2),selectedRows(idMin,3),['ID ' num2str(allLarvae(nLarva)) ' T' num2str(allRowsTrackLarva(end,1))])
               end

            end
        end
    end
end