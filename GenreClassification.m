%********************************************
% Computational Music Analysis
% Assignment 2 - Genre Classification
%
% Imankalyan Mukherjee, Govinda Ram Pingali
%********************************************

clear all;
clc;
tic

%--- Assigning varibles ---%
blockSize = 2048;
hopSize = 1024;
scatterPlot = 0;

genres = {'classical' 'hiphop' 'country' 'jazz' 'metal'};

%--- Audio Features Indices ---%
meanSpCentroid      = 1;
meanMaxEnv          = 2;
meanZcr             = 3;
meanSpCrest         = 4;
meanSpFlux          = 5;
stdSpCentroid       = 6;
stdMaxEnv           = 7;
stdZcr              = 8;
stdSpCrest          = 9;
stdSpFlux           = 10;

noAudioFeatures = 10;



%--- Calculate Number of genres and Number of Audio Files in each genre ---%
noGenres = size(genres, 2);
noFiles = zeros(noGenres,1);
totalFiles = 0;

for i = 1 : noGenres
   genre = cell2mat(genres(i));
   path = sprintf('./genres/%s/', genre);
   
   au_files{i} = dir(fullfile(path, '*.au'));
   noFiles(i) = size(au_files{i},1);
   totalFiles = totalFiles + noFiles(i);
end




%--- Extract Audio Features and Normalize Results ---%

% Initialize output matrices
tempMatrix = zeros(totalFiles,noAudioFeatures);
normalMatrix = zeros(totalFiles,noAudioFeatures);

for i = 1 : noGenres
    
    genre = cell2mat(genres(i));
    path = sprintf('./genres/%s/', genre);
    disp(sprintf('Extracting Features for Genre: %s',genre));
    
    % Iterate through files in each genre
    for j = 1:noFiles(i)
        % Read Audio File
        [au,Fs] = auread(strcat(path, au_files{i}(j).name));
        disp(sprintf('Extracting Features for Audio File: %s',au_files{i}(j).name));
        
        % Extract audio features
        if i==1
            tempMatrix(j,:) = audioFeatureExtraction(au,Fs,blockSize,hopSize);
        else
            tempMatrix(j + sum(noFiles(1 : i-1)),:) = audioFeatureExtraction(au,Fs,blockSize,hopSize);
        end
        
    end 
end



% Initialize mean and standard deviation vectors
%meanVector = zeros(1,noAudioFeatures);
%stdVector = zeros(1,noAudioFeatures);

disp(sprintf('Normalizing Results'));
% Iterate through each audio feature
for k = 1:noAudioFeatures
    % Fit to Normal Distribution using BoxCox Transform
    [normDistVector, lambda(k)] = boxcox(tempMatrix(:,k));
    % Compute Mean and Standard Deviation
    meanVector = mean(normDistVector);
    stdVector = std(normDistVector);
    % Normalize Feature Vector
    normalMatrix(:,k) = (normDistVector - meanVector) / stdVector;
end

disp(sprintf('Execution Time for Feature Extraction and Normalization: %f seconds',toc));



%--- Scatter Plots ---%

if scatterPlot == 1
    
    
disp(sprintf('Making Scatter Plots'));

colorVector = {'b' 'r' 'g' 'c' 'y'};
markerArea = 10;

%i) Spectral Centroid Mean vs Spectral Crest Factor Mean
figure(1);
title('Spectral Centroid Mean vs Spectral Crest Factor Mean');
hold on
for i=1:noGenres
    if i==1
        scatter(normalMatrix(i:noFiles(i),meanSpCentroid),normalMatrix(i:noFiles(i),meanSpCrest),markerArea,colorVector{i});
    else
        scatter(normalMatrix(sum(noFiles(1 : i-1)) + 1 : sum(noFiles(1 : i)),meanSpCentroid),normalMatrix(sum(noFiles(1 : i-1)) + 1 : sum(noFiles(1 : i)),meanSpCrest),markerArea,colorVector{i});
    end
end


%ii) Spectral Flux Mean vs Zero Crossing Rate Mean
figure(2);
title('Spectral Flux Mean vs Zero Crossing Rate Mean');
hold on
for i=1:noGenres
    if i==1
        scatter(normalMatrix(i:noFiles(i),meanSpFlux),normalMatrix(i:noFiles(i),meanZcr),markerArea,colorVector{i});
    else
        scatter(normalMatrix(sum(noFiles(1 : i-1)) + 1 : sum(noFiles(1 : i)),meanSpFlux),normalMatrix(sum(noFiles(1 : i-1)) + 1 : sum(noFiles(1 : i)),meanZcr),markerArea,colorVector{i});
    end
end


%iii) Max Envelope Mean vs Max Envelope Standard Deviation
figure(3);
title('Max Envelope Mean vs Max Envelope Standard Deviation');
hold on
for i=1:noGenres
    if i==1
        scatter(normalMatrix(i:noFiles(i),meanMaxEnv),normalMatrix(i:noFiles(i),stdMaxEnv),markerArea,colorVector{i});
    else
        scatter(normalMatrix(sum(noFiles(1 : i-1)) + 1 : sum(noFiles(1 : i)),meanMaxEnv),normalMatrix(sum(noFiles(1 : i-1)) + 1 : sum(noFiles(1 : i)),stdMaxEnv),markerArea,colorVector{i});
    end
end


%iv) Zero Crossing Rate Standard Deviation vs Spectral Crest Factor Standard Deviation
figure(4);
title('Zero Crossing Rate Standard Deviation vs Spectral Crest Factor Standard Deviation');
hold on
for i=1:noGenres
    if i==1
        scatter(normalMatrix(i:noFiles(i),stdZcr),normalMatrix(i:noFiles(i),stdSpCrest),markerArea,colorVector{i});
    else
        scatter(normalMatrix(sum(noFiles(1 : i-1)) + 1 : sum(noFiles(1 : i)),stdZcr),normalMatrix(sum(noFiles(1 : i-1)) + 1 : sum(noFiles(1 : i)),stdSpCrest),markerArea,colorVector{i});
    end
end



%v) Spectral Centroid Standard Deviation vs Spectral Flux Standard Deviation
figure(5);
title('Spectral Centroid Standard Deviation vs Spectral Flux Standard Deviation');
hold on
for i=1:noGenres
    if i==1
        scatter(normalMatrix(i:noFiles(i),stdSpCentroid),normalMatrix(i:noFiles(i),stdSpFlux),markerArea,colorVector{i});
    else
        scatter(normalMatrix(sum(noFiles(1 : i-1)) + 1 : sum(noFiles(1 : i)),stdSpCentroid),normalMatrix(sum(noFiles(1 : i-1)) + 1 : sum(noFiles(1 : i)),stdSpFlux),markerArea,colorVector{i});
    end
end

end

disp(sprintf('Total Execuation Time: %f seconds',toc));

finalMatrix = reshape(normalMatrix, max(noFiles), noAudioFeatures, noGenres);

save('audioFeatures.mat');
