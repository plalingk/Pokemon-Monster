function [centerX, centerY] = findCenter(image)

    [height, width, col] = size(image);
    smallH = floor(height./100);
    smallW = floor(width./100);

    h = floor(smallH*2);
    w = floor(smallW*20);
    
    I2 = imcrop(image,[h w smallH*10 smallW*50]);
    %imshow(I2);
    points = detectSURFFeatures(rgb2gray(I2));
    %imshow(I2); hold on;
    %plot(points.selectStrongest(1));
    
    
    if any(points.Location)
        point1x = points.selectStrongest(1).Location(1)+h;
        point1y = points.selectStrongest(1).Location(2)+w;    
        %imshow(image); hold on;
        %plot(point1x, point1y, 'r+', 'MarkerSize', 50)
        %imshow(image); hold on;
        %plot(width - points.selectStrongest(1).Location(1) - h,points.selectStrongest(1).Location(2)+w,'r+', 'MarkerSize', 50)
        point2x = width - points.selectStrongest(1).Location(1) - h;
        point2y = points.selectStrongest(1).Location(2)+w;
        centerX = floor((point1x+point2x) / 2);
        centerY = floor((point1y+point2y) / 2);
        %imshow(image); hold on;
        %plot(centerX,centerY,'r+', 'MarkerSize', 50)
    else
        centerX = floor(width * 0.5);
        centerY = floor(height * 0.36);
    end
    
    
end