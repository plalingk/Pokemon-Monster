function finalBoxes = textArea(img) 


I = rgb2gray(img);
%imshow(I);
image = I;
%imshow(image)


% for the CP
    [height, width, col] = size(image);
    smallH = floor(height./20);
    smallW = floor(width./20);

    h = floor(smallH*3);
    w = floor(smallW);
    
    H = h;
    W = w;
    
    I2 = imcrop(image,[h w smallH*5 smallW*5]);
    %imshow(I2)


% Detect MSER regions.
[mserRegions, mserConnComp] = detectMSERFeatures(I2,'ThresholdDelta',4);

%figure
%imshow(I2)
%hold on
%plot(mserRegions, 'showPixelList', true,'showEllipses',true)
%title('MSER regions')
%hold off



% Use regionprops to measure MSER properties
mserStats = regionprops(mserConnComp, 'BoundingBox', 'Eccentricity', ...
    'Solidity', 'Extent', 'Euler', 'Image');

% Compute the aspect ratio using bounding box data.
bbox = vertcat(mserStats.BoundingBox);
w = bbox(:,3);
h = bbox(:,4);
aspectRatio = w./h;

% Threshold the data to determine which regions to remove. These thresholds
% may need to be tuned for other images.
filterIdx = aspectRatio' > 3;
filterIdx = filterIdx | [mserStats.Eccentricity] > .995 ;
filterIdx = filterIdx | [mserStats.Solidity] < .3;
filterIdx = filterIdx | [mserStats.Extent] < 0.2 | [mserStats.Extent] > 0.9;
filterIdx = filterIdx | [mserStats.EulerNumber] < -4;

% Remove regions
mserStats(filterIdx) = [];
mserRegions(filterIdx) = [];

% Show remaining regions
%figure
%imshow(I2)
%hold on
%plot(mserRegions, 'showPixelList', true,'showEllipses',false)
%title('After Removing Non-Text Regions Based On Geometric Properties')
%hold off




% Get bounding boxes for all the regions
bboxes = vertcat(mserStats.BoundingBox);

% Convert from the [x y width height] bounding box format to the [xmin ymin
% xmax ymax] format for convenience.
xmin = bboxes(:,1);
ymin = bboxes(:,2);
xmax = xmin + bboxes(:,3) - 1;
ymax = ymin + bboxes(:,4) - 1;

% Expand the bounding boxes by a small amount.
expansionAmount = 0.02;
xmin = (1-expansionAmount) * xmin;
ymin = (1-expansionAmount) * ymin;
xmax = (1+expansionAmount) * xmax;
ymax = (1+expansionAmount) * ymax;

% Clip the bounding boxes to be within the image bounds
xmin = max(xmin, 1);
ymin = max(ymin, 1);
xmax = min(xmax, size(I,2));
ymax = min(ymax, size(I,1));

% Show the expanded bounding boxes
expandedBBoxes = [xmin ymin xmax-xmin+1 ymax-ymin+1];


%expandedBBoxes(1,:)

IExpandedBBoxes = insertShape(I2,'Rectangle',expandedBBoxes,'LineWidth',3);

%figure
%imshow(IExpandedBBoxes)
%title('Expanded Bounding Boxes Text')



% Compute the overlap ratio
overlapRatio = bboxOverlapRatio(expandedBBoxes, expandedBBoxes);


overlapRatio1 = overlapRatio;

sizeList = size(overlapRatio);

for i = 1:sizeList(1)
    for j = i:sizeList(2)
        if(overlapRatio(i,j) == overlapRatio(j,i))
            overlapRatio1(i,j) = 0; 
        end
    end
end

arrTemp = zeros(sizeList(1),1);


sizeList(1);

sizeList(2);


for i = 1:sizeList(1)
    flag = 0;
    for j = 1:sizeList(2)
        if(overlapRatio1(i,j) > 0.2)
            flag = 1;
        end 
    end
    if(flag == 0)
        arrTemp(i) = 1;
    end
end



correctBoxes = zeros(sum(arrTemp),4);
sizeActual = size(expandedBBoxes);
index = 1;


for i = 1:sizeActual(1)
    if(arrTemp(i)==1)
        correctBoxes(index,:) = expandedBBoxes(i,:);
        index = index+1;
    end
end

sortedBoxes = sortrows(correctBoxes);

finalBoxes = sortedBoxes(3:end,:,:,:);

finalBoxes(:,1) = finalBoxes(:,1)+H;
finalBoxes(:,2) = finalBoxes(:,2)+W;


%Show the final text detection result.
%ITextRegion = insertShape(image, 'Rectangle', finalBoxes,'LineWidth',3);

%figure
%imshow(ITextRegion)
%title('Detected Text')


end