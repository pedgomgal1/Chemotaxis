function saveTemporalImageSequence(dataOutline,dataSpine,xFile,yFile,larvaeIDs,folder2save,imgInit)

    allLarvae=unique(larvaeIDs);
    cmap = colorcube(length(allLarvae));
    randIDs = randperm(length(allLarvae),length(allLarvae));
    cmapRand = cmap(randIDs,:);

    labelTimeOutline = cell2mat(dataOutline(:,1:2));

    maxTime=max(unique(labelTimeOutline(:,2)));

    larvaAppearedOutline = zeros(length(allLarvae),1);
   

    for sec = 0:round(maxTime)
        h1 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','on');

        imshow(imgInit)
        hold on;
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
               
               figure(h1)
               plot(selectedOutlineRowsSec{idMinOutline,4}*10,selectedOutlineRowsSec{idMinOutline,3}*10,'Color',cmapRand(nLarva,:),'MarkerEdgeColor',cmapRand(nLarva,:),'LineWidth',1)

               if larvaAppearedOutline(nLarva)==1 || larvaAppearedOutline(nLarva)==max(roundOutlineSeconds)
                   text(mean(selectedOutlineRowsSec{idMinOutline,4}(:))*10,mean(selectedOutlineRowsSec{idMinOutline,3}(:))*10,[' ' num2str(allLarvae(nLarva))],'FontSize',10)
               else
                   text(mean(selectedOutlineRowsSec{idMinOutline,4}(:))*10,mean(selectedOutlineRowsSec{idMinOutline,3}(:))*10,['   ' num2str(allLarvae(nLarva))],'FontSize',3)
               end
               
               xCoordsLarva = xFile(xFile(:,2)==allLarvae(nLarva),3:4);
               yCoordsLarva = yFile(yFile(:,2)==allLarvae(nLarva),3:4);

               xCoordsPrev = xCoordsLarva(xCoordsLarva(:,1)<sec,2);
               yCoordsPrev = yCoordsLarva(yCoordsLarva(:,1)<sec,2);
               plot(yCoordsPrev*10,xCoordsPrev*10,'Color',cmapRand(nLarva,:),'MarkerEdgeColor',cmapRand(nLarva,:),'LineWidth',1)

%                roundSpineSeconds = round(allRowsSpineLarva(:,1));
%                selectedSpineRows = allRowsSpineLarva(roundSpineSeconds==sec,:);
%                [~,idMinSpine]=min(pdist2(sec,selectedSpineRows(:,1)));
%                plot(selectedSpineRows(idMinSpine,2:2:end),selectedSpineRows(idMinSpine,3:2:end),'Color',cmapRand(nLarva,:),'MarkerEdgeColor',cmapRand(nLarva,:),'LineWidth',0.5)
            else
                if any(round(selectedRowsOutlineLabelTime(:,2))<sec) 
            
                   xCoordsLarva = xFile(xFile(:,2)==allLarvae(nLarva),3:4);
                   yCoordsLarva = yFile(yFile(:,2)==allLarvae(nLarva),3:4);
    
                   xCoordsPrev = xCoordsLarva(xCoordsLarva(:,1)<sec,2);
                   yCoordsPrev = yCoordsLarva(yCoordsLarva(:,1)<sec,2);
                   plot(yCoordsPrev*10,xCoordsPrev*10,'Color',cmapRand(nLarva,:),'MarkerEdgeColor',cmapRand(nLarva,:),'LineWidth',0.5)

                   text(yCoordsPrev(end)*10,xCoordsPrev(end)*10,[' ' num2str(allLarvae(nLarva))],'FontSize',3)
                end
            end

            

        end
        exportgraphics(gca,fullfile(folder2save,[num2str(sec) '.png']),'Resolution',300)

%         imwrite(getframe(gcf).cdata,fullfile(folder2save,[num2str(sec) '.png']))
        hold off 
        close all
    end


end