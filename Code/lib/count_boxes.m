function num_boxes = count_boxes(x, y, epsilon)
    % Define the grid of boxes
    x_bins = min(x):epsilon:max(x);
    y_bins = min(y):epsilon:max(y);
    
    % Initialize counter for number of boxes
    num_boxes = 0;
    
    % Loop over each box
    for i = 1:length(x_bins)-1
        for j = 1:length(y_bins)-1
            % Check if the box contains any points of the trajectory
            if any(x >= x_bins(i) & x < x_bins(i+1) & y >= y_bins(j) & y < y_bins(j+1))
                num_boxes = num_boxes + 1;
            end
        end
    end
end