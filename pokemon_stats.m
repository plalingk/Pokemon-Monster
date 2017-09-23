function [ID, CP, HP, stardust, level, cir_center] = pokemon_stats (img, model)
% Please DO NOT change the interface
% INPUT: image; model(a struct that contains your classification model, detector, template, etc.)
% OUTPUT: ID(pokemon id, 1-201); level(the position(x,y) of the white dot in the semi circle); cir_center(the position(x,y) of the center of the semi circle)

%imshow(img)

%classification of Pokemon
featureTest = getHoG(img);


load(model);

a = bigModel.ID;
b = bigModel.CP;

mod = load(a);
ID = predict(mod.classifierImagesKNN,featureTest);

% Finding level
[x, y] = levelCenter(img);
level = [x, y];

% Finding circle center
[xCenter, yCenter] = findCenter(img);
cir_center = [xCenter, yCenter];


mod1 = load(b);
% Finding the CP
    vector = textArea(img);
    svec = size(vector);
    cellSize = [12 8];
    %imshow(img)
    
    char = '0';
    for j = 1:svec(1)
        digitImage = imresize(imcrop(img,vector(j,:)),[36 24]);
        featTest_digits_CP = extractHOGFeatures(digitImage, 'CellSize', cellSize);
        cp = predict(mod1.classifierCPKNN,featTest_digits_CP);
        char = strcat(char,num2str(cp));
    end
    CP = str2num(char(2:end));



% Replace these with your code
%ID = 1;
%CP = 123;
HP = 26;
stardust = 600;
%level = [327,165];
%cir_center = [355,457];

end





