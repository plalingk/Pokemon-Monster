function [xLevel, yLevel] = levelCenter (image)
    [height, width, col] = size(image);
    smallH = floor(height./100);
    smallW = floor(width./40);

    h = floor(smallH*1.5);
    w = floor(smallW*7);
    
    I2 = imcrop(image,[h w smallH*68 smallW*25]);

    Rmin = 5;
    Rmax = 100;

    [centersDark, radiiDark] = imfindcircles(I2,[Rmin Rmax],'ObjectPolarity','bright');
    
    if any(centersDark) == 0
        xLevel = 27;
        yLevel = 125;
    else
        centersStrong = centersDark(1,:);
        radiiStrong = radiiDark(1);
        xLevel = floor(centersStrong(1)+h);  
        yLevel = floor(centersStrong(2)+w);
    end
    
    
    %Plot for center
    %imshow(image);
    %hold on; 
    %plot(xLevel,yLevel,'r+', 'MarkerSize', 50);
    
    
end