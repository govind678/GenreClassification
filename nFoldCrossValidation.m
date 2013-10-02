function [ output_args ] = nFoldCrossValidation( dataset, z, nFold, K )

%************************************************************
% Computational Music Analysis
% Assignment 2 - Genre Classification
%
% Generic nFold Cross Validation Function for KNN Classifier
%
% Imankalyan Mukherjee, Govinda Ram Pingali
%************************************************************


%--- Computing Required Variables ---%
noFiles = size(dataset,1);
featureLength = size(dataset,2);
noGenres = size(dataset,3);



%--- Create Testing and Training Datasets from Exisiting Dataset ---%

% Initializing Train and Test Matrices
trainingMatrix = zeros(((100-nFold)/100)*noFiles,featureLength,noGenres);
testingMatrix = zeros((nFold/100)*noFiles,featureLength,noGenres);

noTestVectors = size(testingMatrix,1);

trainIndex = 1;
testIndex = 1;


for i=1:noGenres
    for n=1:noFiles
        if mod(n,nFold) == z-1
            testingMatrix(testIndex,:,i) = dataset(n,:,i);
            testIndex = testIndex+1;
        else
            trainingMatrix(trainIndex,:,i) = dataset(n,:,i);
            trainIndex = trainIndex+1;
        end
    end
    testIndex = 1;
    trainIndex = 1;
end



%--- Creating Class and Confusion Matrices from kNN Classifier ---%
classMatrix = zeros(noTestVectors,noGenres);

confusionMatrix = zeros(noGenres, noGenres);

for i=1:noTestVectors
    for k=1:noGenres
        classMatrix(i,k) = knnClassifier(trainingMatrix(:,1:featureLength,:),testingMatrix(i,1:featureLength,k),K);
        
        confusionMatrix(classMatrix(i,k), k) = confusionMatrix(classMatrix(i,k), k) + 1;
    end
end


sumCorrectClass = 0;
for j=1:noGenres
    sumCorrectClass = sumCorrectClass + length(find(classMatrix(:,j)==j));
end

output_args{1} = (sumCorrectClass*100)/(noGenres*noTestVectors);
output_args{2} = confusionMatrix;

end
