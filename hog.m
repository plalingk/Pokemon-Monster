% You can change anything you want in this script.
% It is provided just for your convenience.
clear; clc; close all;

%% Setting up the arguments
img_path = 'C:\Users\pdlalingkar\Documents\Masters in CS\Fall 2016\Computer Vision\Project\CodeAndDataset\train\';
%class_num = 30;
%img_per_class = 60;
img_num = 1086;
% mention this as the codebook size
feat_dim = 50;

folder_dir = dir(img_path);
feat_train = zeros(img_num,feat_dim);
%label_train = zeros(img_num,1);
numImages = 1086;


%% Extracting SURF features from all the images to build a code book

%disp(length(folder_dir)-3)

%disp(folder_dir(4).name);
%%
cellSize = [76 128];
hogFeatureSize = 324;
trainingFeatures = zeros(numImages, hogFeatureSize, 'single');

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
for i = 4:length(folder_dir)     
    
    %get ground truth annotation from image name
    %i=4
    name = folder_dir(i).name;
    ul_idx = findstr(name,'_');
    ID_gt(i-3) = str2num(name(1:ul_idx(1)-1));
    CP_gt(i-3) = str2num(name(ul_idx(1)+3:ul_idx(2)-1));
    HP_gt(i-3) = str2num(name(ul_idx(2)+3:ul_idx(3)-1));
    stardust_gt(i-3) = str2num(name(ul_idx(3)+3:ul_idx(4)-1));
   
    
    img = imread([img_path,folder_dir(50).name]);
    
    [height, width, col] = size(img); 
    % Dividing for cropping
    smallH = height./40;
    smallW = width./100;

    
    %Crop image, specifying crop rectangle for pokemon.
    I2 = imresize(imcrop(img,[smallH*3 smallW.*18 smallH*18 smallW*45]), [307, 512]);
    %size(I2)
    %imshow(I2)
    
    
    %imwrite(I2,[img_path,'temp\',num2str(i),'im.png'])
%    [hog_4x4, vis4x4] = extractHOGFeatures(I2,'CellSize',[76 128]);
%    plot(vis4x4);
%,'CellSize',[76 128]
    %im = rgb2gray(I2);
    %im = im(im<254);
    %imshow(I2)
    %imwrite(I2,[img_path,'temp\',num2str(i-3),'im.png'])
    %cellSize = [76 128];
    %hogFeatureSize = length(324);
    

    trainingFeatures(i-3, :) = extractHOGFeatures(I2, 'CellSize', cellSize);
    
    
        
end

%%
% fitcecoc uses SVM learners and a 'One-vs-One' encoding scheme.
classifierImages = fitcecoc(trainingFeatures, ID_gt);

%%
save('classificationSVM','classifierImages');

%%
classifierImagesKNN = fitcknn(trainingFeatures,ID_gt,'BreakTies','random','Distance','euclidean','NumNeighbors',3); 
save('classificationKNN1','classifierImagesKNN');

%% 
% For prediction on the test data 

img_path_test = 'C:\Users\pdlalingkar\Documents\Masters in CS\Fall 2016\Computer Vision\Project\CodeAndDataset\val\';
folder_dir = dir(img_path_test);
feat_train = zeros(img_num,feat_dim);
%label_train = zeros(img_num,1);
numImages = 1086;


%%
% Creating the training vectors for all the images

count = 0;
for i = 1:length(folder_dir)-2
    img_dir = dir([img_path,folder_dir(i+2).name,'/*.JPG']);
    if isempty(img_dir)
        img_dir = dir([img_path,folder_dir(i+2).name,'/*.BMP']);
    end
    
    label_train((i-1)*img_per_class+1:i*img_per_class) = i;
        
    for j = 1:length(img_dir)        
        img = imread([img_path,folder_dir(i+2).name,'/',img_dir(j).name]);
        feat_train((i-1)*img_per_class+j,:) = feature_extraction(img);
        count = count+1
    end

end

save('modelSubmission50.mat','feat_train','label_train');
%%
% Building the model for training
%load('modelNew100.mat')
mdl = fitcknn(feat_train,label_train,'BreakTies','random','Distance','euclidean','NumNeighbors',3) 
save('KNNModelSubmission50','mdl')
%%
% Building SVM for training
%load('modelNew100.mat')
mdlSvm = fitcecoc(feat_train,label_train,'coding','onevsone')
save('SVMModelSubmission50','mdlSvm')


%%

    bigModel = struct('ID','classificationKNN1.mat','CP','cpKNN.mat');
    %%
    save('bigModel','bigModel')