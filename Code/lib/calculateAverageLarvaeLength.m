function averageLarvaLength = calculateAverageLarvaeLength(dataSpine)
    
    try
        dataSpineGpu = gpuArray(dataSpine);
    catch
        dataSpineGpu=dataSpine; 
    end

    n = size(dataSpineGpu, 1);
    totalSum = zeros(n, 1);
    for i = 3:2:size(dataSpineGpu, 2)-3  
        x1 = dataSpineGpu(:, i);
        y1 = dataSpineGpu(:, i+1);
        x2 = dataSpineGpu(:, i+2);
        y2 = dataSpineGpu(:, i+3);
        segmentDist = arrayfun(@(x_1,y_1,x_2,y_2) sqrt((x_2-x_1)^2 + (y_2-y_1)^2), x1,y1,x2,y2);
        totalSum = totalSum + segmentDist;
    end
    averageLarvaLength = mean(totalSum);

    if isgpuarray(averageLarvaLength)
        averageLarvaLength = gather(averageLarvaLength);
    end


end