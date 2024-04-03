function R_squared = plotTrendLine(dataY,dataX, colorTrendline)

    coefficients = polyfit(dataX, dataY, 1);
    trendline = polyval(coefficients, dataX);
    
    % Plot trendline
    
    plot(dataX, trendline, 'Color', colorTrendline, 'LineWidth', 1);
    
    % Calculate R-squared value
    y_fit = polyval(coefficients, dataX);
    y_mean = mean(dataY);
    SS_total = sum((dataY - y_mean).^2);
    SS_residual = sum((dataY - y_fit).^2);
    R_squared = 1 - (SS_residual / SS_total);
    
end