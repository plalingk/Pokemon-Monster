function testFeature = getHoG (image)

    cellSize = [76 128];
    %hogFeatureSize = 324;
    %testFeature = zeros(numImages, hogFeatureSize, 'single');
    
    [height, width, col] = size(image); 
    % Dividing for cropping
    smallH = height./40;
    smallW = width./100;

    %Crop image, specifying crop rectangle for pokemon.
    I2 = imresize(imcrop(image,[smallH*3 smallW.*18 smallH*18 smallW*45]), [307, 512]);

    testFeature = extractHOGFeatures(I2, 'CellSize', cellSize);
end