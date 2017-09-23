% You can change anything you want in this script.
% It is provided just for your convenience.
%clear; clc; close all;

%% Setting up the arguments
img_path = 'C:\Users\pdlalingkar\Documents\Masters in CS\Fall 2016\Computer Vision\Project\CodeAndDataset\train\';
%class_num = 30;
%img_per_class = 60;
img_num = 1086;


folder_dir = dir(img_path);
feat_train = zeros(img_num,feat_dim);
%label_train = zeros(img_num,1);
numImages = 1086;
feat_digits_CP = zeros(1,144);
labels_digits_CP = zeros(1,1);
%%
%cellSize = [76 128];
%hogFeatureSize = 324;
%trainingFeatures = zeros(numImages, hogFeatureSize, 'single');

count = 0;
i = 4;

ID_gt = zeros(img_num,1);
CP_gt = zeros(img_num,1);
HP_gt = zeros(img_num,1);
stardust_gt = zeros(img_num,1);
ID = zeros(img_num,1);
CP = zeros(img_num,1);
HP = zeros(img_num,1);
stardust = zeros(img_num,1);

%%
for i = 1060:length(folder_dir)     
    
    %get ground truth annotation from image name
    %i=100
    
    name = folder_dir(i).name;
    ul_idx = findstr(name,'_');
    ID_gt(i-3) = str2num(name(1:ul_idx(1)-1));
    CP_gt(i-3) = str2num(name(ul_idx(1)+3:ul_idx(2)-1));
    HP_gt(i-3) = str2num(name(ul_idx(2)+3:ul_idx(3)-1));
    stardust_gt(i-3) = str2num(name(ul_idx(3)+3:ul_idx(4)-1));
    cellSize = [12 8];
    
    
    img = imread([img_path,folder_dir(i).name]);
    sImage = size(size(img));
    if(sImage(2)~=3)
        continue;
    end
    
    imshow(img)
    
    vector = textArea(img);
    dig = num2str(CP_gt(i-3));

    for j = 1:size(dig, 2)
        svec = size(vector);
        if size(dig,2) > svec(1) 
            continue;
        else
            labels_digits_CP = [labels_digits_CP;str2num(dig(j))];
            digitImage = imresize(imcrop(img,vector(j,:)),[36 24]);
            f = extractHOGFeatures(digitImage, 'CellSize', cellSize);
            feat_digits_CP = [feat_digits_CP;f];
            imshow(digitImage)
        end
        
    end
    
    
    
    

    
    
        
end


%%
classifierCPKNN = fitcknn(feat_digits_CP,labels_digits_CP,'BreakTies','random','Distance','euclidean','NumNeighbors',3); 
save('cpKNN','classifierCPKNN');

