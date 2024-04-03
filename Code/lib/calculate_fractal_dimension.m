function fractal_dim = calculate_fractal_dimension(x, y, epsilon_values)
    % Calculate the number of boxes covering the trajectory at each scale
    num_boxes = zeros(size(epsilon_values));
    for i = 1:length(epsilon_values)
        epsilon = epsilon_values(i);
        num_boxes(i) = count_boxes(x, y, epsilon);
    end


    % Perform linear regression to estimate the fractal dimension
    log_epsilon = log(1 ./ epsilon_values);
    log_num_boxes = log(num_boxes);
    coefficients = polyfit(log_epsilon, log_num_boxes, 1);
    fractal_dim = abs(coefficients(1)); % Slope of the line
end