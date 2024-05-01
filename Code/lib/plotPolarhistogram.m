function plotPolarhistogram(averages,num_bins,angle_ranges,colourBins,titleName,legendName,radiusLimits,arrayRTicks,rTicksLabels,ticksAngles,angleTicksLabels,fontNameFigure,fontSizeFigure)


     for i = 1:num_bins
        angle_range = angle_ranges(i, :); % Angles for cheese piece
        polarhistogram('BinEdges', angle_range, 'BinCounts', averages(i), 'LineWidth', 1.5,'FaceColor',colourBins(i,:),'FaceAlpha',0.5,'EdgeAlpha',0.3);
        hold on;
    end
    
    % Adjust the display
    if ~isempty(legendName)
        legend(legendName)
    end
    title(titleName);
    rlim(radiusLimits)
    rticks(arrayRTicks)
    rticklabels(rTicksLabels);
    thetaticks(ticksAngles);
    thetaticklabels(angleTicksLabels)

    set(gca,'FontSize', fontSizeFigure,'FontName',fontNameFigure);

    for i = 1:num_bins
        angle_range = angle_ranges(i, :); % Angles for cheese piece
        bin_centers = (angle_range(1) + angle_range(2)) / 2; % Compute bin center
        % Add text label for proportion
        text(bin_centers, radiusLimits(2)*0.1+averages(i), sprintf('%.2f', averages(i)), 'HorizontalAlignment', 'center','FontSize',ceil(fontSizeFigure*2/3));
        % text(bin_centers, 0.2+averages(i), sprintf('%.2f \\pm %.2f', averages(i),std_devs(i)), 'HorizontalAlignment', 'center');
    end

end