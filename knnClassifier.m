function [ output_args ] = knnClassifier( trainMatrix, testVector, K )

%************************************************************
% Computational Music Analysis
% Assignment 2 - Genre Classification
%
% Generic kNN Classifier
%
% Imankalyan Mukherjee, Govinda Ram Pingali
%************************************************************

noObservations = size(trainMatrix,1);
noClasses = size(trainMatrix,3);

classes = zeros(K,1);
minDist = 100*ones(K,1);


dist_Index = 1;

% Iterating through all classes and all observations
for i = 1:noClasses
    for j=1:noObservations
        % Computing Euclidean Distance
        tempDistance = sqrt(sum((trainMatrix(j,:,i)-testVector(:)').^2));
        
        % Storing the least K distance values and swapping if any lower
        % value is found
        if dist_Index <= K
            minDist(dist_Index) = tempDistance;
            classes(dist_Index) = i;
            dist_Index = dist_Index + 1;
        elseif tempDistance < max(minDist)
            swap_Index = find(minDist == max(minDist));
            minDist(swap_Index) = tempDistance;
            classes(swap_Index) = i;
        end
        
    end
end

output_args = mode(classes);

end