function paintSignificance(maxVal,tickInterval,p_value,xValues)


    yVal = maxVal+ tickInterval;
    % Add significance markers
    if p_value < 0.001
        % If p-value is less than 0.05, mark with "*"
        text(mean(xValues), yVal, '***', 'HorizontalAlignment', 'center','FontSize',10);
    else
        if p_value < 0.01
            text(mean(xValues), yVal, '**', 'HorizontalAlignment', 'center','FontSize',10);
        else
            if p_value < 0.05
                text(mean(xValues), yVal, '*', 'HorizontalAlignment', 'center','FontSize',10);
            else
                text(mean(xValues), yVal, 'ns', 'HorizontalAlignment', 'center','FontSize',10);
            end
        end
    end
    
    line(xValues, [maxVal+ tickInterval*0.50,maxVal+ tickInterval*0.50], 'Color', 'k');

end