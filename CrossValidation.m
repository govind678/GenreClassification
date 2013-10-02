load 'audioFeatures.mat';

tic;
%--- Audio Feature Indices ---%
%{
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
%}
%-----------------------------%



%-----------------------------------------------------------------------
% e) Rank the features for individual classification performance 
%    with kNN with k=1 by performing a 10-fold cross validation
%-----------------------------------------------------------------------


%--- Performing nFold Cross Validation on KNN Classifier ---%

nFold = 10;
K = 1;


%--- Creating Accuracy Matrix ---%

% Individual accuracy of each feature for each fold
accuracyMatrix = zeros(nFold,noAudioFeatures);
disp(sprintf('Calculating Accuracy of Individual Feature by running %d fold cross validation',nFold));
for z=1:nFold
    disp(sprintf('Running Cross Validation for fold: %d',z));
    for n=1:noAudioFeatures
        disp(sprintf('Calculating Accuracy of Feature: %d',n));
        tempCrossVal = nFoldCrossValidation(finalMatrix(:,n,:), z, nFold, K);
        accuracyMatrix(z,n) = tempCrossVal{1};
    end
end


disp(sprintf('Sorting Features Based on Accuracy and Reordering Feature Matrix'));
% Sorting features based on accuracy in descending order
[sortedValues, sortIndex] = sort(mean(accuracyMatrix),'descend');


%--- Reordering Final Matrix by accuracy ---%
sortedMatrix = zeros(size(finalMatrix));
for i=1:noAudioFeatures
    sortedMatrix(:,i,:) = finalMatrix(:,sortIndex(i),:);
end




%-----------------------------------------------------------------------
% f) Compute a Feature Covariance Matrix
%-----------------------------------------------------------------------

disp(sprintf('Computing Covariance Matrix of Features'));
covarianceMatrix = zeros(noAudioFeatures);

for i=1:noAudioFeatures
    for j=1:noAudioFeatures
        covarianceMatrix(i,j) = sum((normalMatrix(:,i)-mean(normalMatrix(:,i))).*(normalMatrix(:,j)-mean(normalMatrix(:,j)))) / totalFiles;
    end
end



save('sortedFeatures.mat');


disp(sprintf('Execution Time for nFold Cross Validation: %f seconds',toc));