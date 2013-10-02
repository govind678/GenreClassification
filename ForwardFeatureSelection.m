%--- Forward Feature Selection ---%
tic
disp(sprintf('Running Forward Feature Selection'));

load 'sortedFeatures.mat';

%meanAccuracy = zeros(1,length(sortIndex));
tempAccuracy = zeros(nFold,length(sortIndex));
for z=1:nFold
    disp(sprintf('Calculating Accuracies for Fold %d,',z));
    for n=1:noAudioFeatures
        disp(sprintf('Calculating Accuracy of KNN using features: 1 to %d',n));
        tempAccForwardFeature = nFoldCrossValidation(sortedMatrix(:,1:n,:), z, nFold, K);
        tempAccuracy(z,n) = mean(tempAccForwardFeature{1});
    end    
end

finalAccuracy = mean(tempAccuracy,1);

plot(finalAccuracy, 'o-');
xlabel('No. of Features included as per rank 1->10');
ylabel('Mean Accuracy');


%----------
% From the plot, we'll use first 5 features
%----------

finalFeatureLength = 5;
KFinal = [1 3 7] ;

confusionMatrix = zeros(noGenres, noGenres, length(KFinal));
ultimateAccuracy = zeros(length(nFold),length(KFinal)); 

for k=1:length(KFinal)
    disp(sprintf('Running nFoldCrossValidation of KNN Classifier for k = %d',KFinal(k)));
    nFoldAccuracy = zeros(nFold,1);
    for z=1:nFold
        disp(sprintf('KNN Classfier for fold: %d,',z));
        temp = nFoldCrossValidation(sortedMatrix(:,1:finalFeatureLength,:), z, nFold, KFinal(k));
        nFoldAccuracy = temp{1};
        confusionMatrix(:,:,k) = confusionMatrix(:,:,k) + temp{2};
    end
    ultimateAccuracy(k) = mean(nFoldAccuracy);
end

disp(sprintf('Execution Time for creating Confusion Matrices: %f seconds',toc));