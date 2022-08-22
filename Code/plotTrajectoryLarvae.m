function plotTrajectoryLarvae(dataSpine,larvaeIDs)

    allLarvae=unique(larvaeIDs);
    cmap = colorcube(length(allLarvae));
    randIDs = randperm(length(allLarvae),length(allLarvae));
    cmapRand = cmap(randIDs,:);


    maxTime=max(unique(dataSpine(:,3)));
    figure;hold on;
    ylim([0 250])
    xlim([0 175])

    larvaAppearedSpine = zeros(length(allLarvae),1);

    for sec = 0:round(maxTime)
        
        for nLarva = 1:length(allLarvae)
            allRowsSpineLarva = dataSpine(dataSpine(:,2)==allLarvae(nLarva),3:end);

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

        end
        title([num2str(sec) ' / ' num2str(round(maxTime)) ' seconds'])
    end
end