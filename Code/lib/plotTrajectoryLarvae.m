function plotTrajectoryLarvae(dataOutline,xFile,yFile,larvaeIDs,folder2save,imgInit,minTime,maxTime,maxLengthLarvaeTrajectory,stepTimeTrack,booleanSave)

    allLarvae=unique(larvaeIDs);
    cmap = colorcube(length(allLarvae));
    randIDs = randperm(length(allLarvae),length(allLarvae));
    cmapRand = cmap(randIDs,:);

    if ~isempty(dataOutline)
        labelTimeOutline = cell2mat(dataOutline(:,1:2));
        larvaAppearedOutline = zeros(length(allLarvae),1);
    end

    for sec = round(minTime):stepTimeTrack:round(maxTime)
        h1 = figure('units','normalized','outerposition',[0 0 1 1],'Visible','off');

        imshow(imgInit)
        hold on;
        for nLarva = 1:length(allLarvae)

            if ~isempty(dataOutline)
                allRowsOutlineLarva = dataOutline(labelTimeOutline(:,1)==allLarvae(nLarva),:);
                selectedRowsOutlineLabelTime = labelTimeOutline(labelTimeOutline(:,1)==allLarvae(nLarva),:);
            else
                selectedRowsOutlineLabelTime=[1,-1];
            end

            if any(round(selectedRowsOutlineLabelTime(:,2))==sec) 
               larvaAppearedOutline(nLarva)=larvaAppearedOutline(nLarva)+1;
               roundOutlineSeconds = round(selectedRowsOutlineLabelTime(:,2));
               selectedOutlineRowsSec = allRowsOutlineLarva(roundOutlineSeconds==sec,:);
               selectedRowsOutlineLabelTimeSec = selectedRowsOutlineLabelTime(roundOutlineSeconds==sec,:);
               [~,idMinOutline]=min(pdist2(sec,selectedRowsOutlineLabelTimeSec(:,2)));
               
               plot(selectedOutlineRowsSec{idMinOutline,4}*10,selectedOutlineRowsSec{idMinOutline,3}*10,'Color',cmapRand(nLarva,:),'MarkerEdgeColor',cmapRand(nLarva,:),'LineWidth',1)

               if larvaAppearedOutline(nLarva)==1 || larvaAppearedOutline(nLarva)==max(roundOutlineSeconds)
                   text(mean(selectedOutlineRowsSec{idMinOutline,4}(:))*10,mean(selectedOutlineRowsSec{idMinOutline,3}(:))*10,[' ' num2str(allLarvae(nLarva))],'FontSize',10)
               else
                   text(mean(selectedOutlineRowsSec{idMinOutline,4}(:))*10,mean(selectedOutlineRowsSec{idMinOutline,3}(:))*10,['   ' num2str(allLarvae(nLarva))],'FontSize',3)
               end
               
               xCoordsLarva = xFile(xFile(:,1)==allLarvae(nLarva),2:3);
               yCoordsLarva = yFile(yFile(:,1)==allLarvae(nLarva),2:3);

               xCoordsPrev = xCoordsLarva(xCoordsLarva(:,1)<sec & (xCoordsLarva(:,1) > (sec - maxLengthLarvaeTrajectory)),2);
               yCoordsPrev = yCoordsLarva(yCoordsLarva(:,1)<sec & (yCoordsLarva(:,1) > (sec - maxLengthLarvaeTrajectory)),2);
               


               % figure;
               plot(yCoordsPrev*10,xCoordsPrev*10,'Color',cmapRand(nLarva,:),'MarkerEdgeColor',cmapRand(nLarva,:),'LineWidth',1)
               % xCoordsGolay = sgolayfilt(xCoordsPrev,1, 501);
               % yCoordsGolay = sgolayfilt(yCoordsPrev,1, 501);
               % figure;                plot(yCoordsGolay*10,xCoordsGolay*10,'Color',cmapRand(nLarva,:),'MarkerEdgeColor',cmapRand(nLarva,:),'LineWidth',1)

            else
                if any(round(selectedRowsOutlineLabelTime(:,2))<sec) 
            
                   xCoordsLarva = xFile(xFile(:,1)==allLarvae(nLarva),2:3);
                   yCoordsLarva = yFile(yFile(:,1)==allLarvae(nLarva),2:3);

                   xCoordsPrev = xCoordsLarva(xCoordsLarva(:,1)<sec & (xCoordsLarva(:,1) > (sec - maxLengthLarvaeTrajectory)),2);
                   yCoordsPrev = yCoordsLarva(yCoordsLarva(:,1)<sec & (yCoordsLarva(:,1) > (sec - maxLengthLarvaeTrajectory)),2);

                   lineSize = 0.5;
                   if sec==round(maxTime)
                        lineSize = 1;
                   end
                   try
                        plot(yCoordsPrev*10,xCoordsPrev*10,'Color',cmapRand(nLarva,:),'MarkerEdgeColor',cmapRand(nLarva,:),'LineWidth',lineSize)
                        text(yCoordsPrev(end)*10,xCoordsPrev(end)*10,[' ' num2str(allLarvae(nLarva))],'FontSize',3)
                   catch

                   end
                end
            end

        end

        if booleanSave==1

%             exportgraphics(gca,fullfile(folder2save,[num2str(sec) '.png']),'Resolution',300)
            imwrite(getframe(gcf).cdata,fullfile(folder2save,[num2str(sec) '.png']))
            hold off 
            if sec== round(maxTime)
                savefig(fullfile(folder2save,'finalTrajectories.fig'))
            end
            close all
        end
    end
    
    

end