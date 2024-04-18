function D = box_counting_dimension_estimate_2d(dat, min_scale, num_scales)
    % Estimate the fractal dimension of a 2D dataset using the box-counting dimension.
    % based on
    % https://github.com/janeloveless/mechanics-of-exploration/blob/master/neuromech/analysis.py
    % function: box_counting_dimension_estimate_2d
    dat=dat.*1000;

    x_min = min(dat(:, 1));
    x_max = max(dat(:, 1));
    y_min = min(dat(:, 2));
    y_max = max(dat(:, 2));


    max_scale = min(log2(x_max - x_min), log2(y_max - y_min));
    
    % compute the fractal dimension considering only scales in a
    % logarithmic list (base 2)
    scales = 2.^ linspace(min_scale, max_scale, num_scales);

    x_bins = floor((x_max - x_min) ./ scales);
    y_bins = floor((y_max - y_min) ./ scales);
    [~, unique_x_bins_index] = unique(x_bins);
    [~, unique_y_bins_index] = unique(y_bins);
    unique_bins_index = unique([unique_x_bins_index; unique_y_bins_index]);
    scales = scales(unique_bins_index);

    
    % looping over several scales
    Ns=[];
    for scale = scales
       
        x_bins = floor((x_max - x_min) / scale);
        y_bins = floor((y_max - y_min) / scale);
        if x_bins <= 0
            x_bins = 1;
        end
        if y_bins <= 0
            y_bins = 1;
        end

        [~, edges] = hist3(dat, 'Edges', {linspace(x_min, x_max, x_bins), linspace(y_min, y_max, y_bins)});
        H = hist3(dat, 'Edges', {edges{1}, edges{2}});
        Ns = [Ns, sum(H(:) > 0)];
    end
     
    % linear fit, polynomial of degree 1
    coeffs = polyfit(log(scales), log(Ns), 1);
    D = -coeffs(1);
    if debug
        disp(['The box-counting dimension is ', num2str(D)]);
    end
end