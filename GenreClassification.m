%********************************************
% Computational Music Analysis
% Assignment 2 - Genre Classification
%
% Imankalyan Mukherjee, Govinda Ram Pingali
%********************************************

clear all;
clc;

% Assigning varibles
blockSize = 2048;
hopSize = 1024;

genres = {'classical' 'hiphop' 'country' 'jazz' 'metal'};

num_genres = size(genres, 2);
noFiles = zeros(num_genres,1);
%au_files = zeros(num_genres,1);
for i = 1 : num_genres
   
   genre = cell2mat(genres(i));
   
   path = sprintf('./genres/%s/', genre);
   
   au_files{i} = dir(fullfile(path, '*.au'));
   noFiles(i) = size(au_files{i},1);
end

tempMatrix = zeros(num_genres,max(noFiles),10);
normalMatrix = zeros(num_genres,max(noFiles),10);

for i=1:num_genres
    genre = cell2mat(genres(i));
    path = sprintf('./genres/%s/', genre);
   
    for j = 1 : noFiles(i)
       au = auread(strcat(path, au_files{i}(j).name));
       tempMatrix(i,j,:) = audioFeatureExtraction( au, blockSize, hopSize );
    end
    
    
    meanVector = zeros(1,10);
    stdVector = zeros(1,10);
   
   for k = 1:10
       normDistVector = boxcox(tempMatrix(i,:,k)');
       meanVector(k) = mean(normDistVector);
       stdVector(k) = std(normDistVector);
  
       normalMatrix(i,:,k) = (tempMatrix(i,:,k) - meanVector(k)) / stdVector(k);
   end
   
end



%-- Scatter Plots --%
   
%i) Spectral Centroid Mean vs Spectral Crest Factor Mean
figure(1);
title('Spectral Centroid Mean vs Spectral Crest Factor Mean');
hold on
scatter(normalMatrix(1,:,1),normalMatrix(1,:,4),10);
scatter(normalMatrix(2,:,1),normalMatrix(2,:,4),10,'r');
scatter(normalMatrix(3,:,1),normalMatrix(3,:,4),10,'g');
scatter(normalMatrix(4,:,1),normalMatrix(4,:,4),10,'c');
scatter(normalMatrix(5,:,1),normalMatrix(5,:,4),10,'y');


%ii) Spectral Flux Mean vs Zero Crossing Rate Mean
figure(2);
title('Spectral Flux Mean vs Zero Crossing Rate Mean');
hold on
scatter(normalMatrix(1,:,5),normalMatrix(1,:,3),10);
scatter(normalMatrix(2,:,5),normalMatrix(2,:,3),10,'r');
scatter(normalMatrix(3,:,5),normalMatrix(3,:,3),10,'g');
scatter(normalMatrix(4,:,5),normalMatrix(4,:,3),10,'c');
scatter(normalMatrix(5,:,5),normalMatrix(5,:,3),10,'y');


%iii) Max Envelope Mean vs Max Envelope Standard Deviation
figure(3);
title('Max Envelope Mean vs Max Envelope Standard Deviation');
hold on
scatter(normalMatrix(1,:,2),normalMatrix(1,:,7),10);
scatter(normalMatrix(2,:,2),normalMatrix(2,:,7),10,'r');
scatter(normalMatrix(3,:,2),normalMatrix(3,:,7),10,'g');
scatter(normalMatrix(4,:,2),normalMatrix(4,:,7),10,'c');
scatter(normalMatrix(5,:,2),normalMatrix(5,:,7),10,'y');


%iv) Zero Crossing Rate Standard Deviation vs Spectral Crest Factor Standard Deviation
figure(4);
title('Zero Crossing Rate Standard Deviation vs Spectral Crest Factor Standard Deviation');
hold on
scatter(normalMatrix(1,:,8),normalMatrix(1,:,9),10);
scatter(normalMatrix(2,:,8),normalMatrix(2,:,9),10,'r');
scatter(normalMatrix(3,:,8),normalMatrix(3,:,9),10,'g');
scatter(normalMatrix(4,:,8),normalMatrix(4,:,9),10,'c');
scatter(normalMatrix(5,:,8),normalMatrix(5,:,9),10,'y');


%v) Spectral Centroid Standard Deviation vs Spectral Flux Standard Deviation
figure(5);
title('Spectral Centroid Standard Deviation vs Spectral Flux Standard Deviation');
hold on
scatter(normalMatrix(1,:,6),normalMatrix(1,:,10),10);
scatter(normalMatrix(2,:,6),normalMatrix(2,:,10),10,'r');
scatter(normalMatrix(3,:,6),normalMatrix(3,:,10),10,'g');
scatter(normalMatrix(4,:,6),normalMatrix(4,:,10),10,'c');
scatter(normalMatrix(5,:,6),normalMatrix(5,:,10),10,'y');




