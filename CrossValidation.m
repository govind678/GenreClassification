load 'audioFeatures.mat';


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



%--- Performing nFold Cross Validation ---%

nFold = 10;
K = 1;

accuracyMatrix = zeros((100/nFold),noAudioFeatures);

for z=1:nFold
    for n=1:noAudioFeatures
        accuracyMatrix(z,n) = nFoldCrossValidation(finalMatrix(:,n,:), z, nFold, K); 
    end
end

[sortedValues, sortIndex] = sort(mean(accuracyMatrix),'descend');



%--- Covariance Matrix ---%

covarianceMatrix = zeros(noAudioFeatures);

for i=1:noAudioFeatures
    for j=1:noAudioFeatures
        covarianceMatrix(i,j) = sum((normalMatrix(:,i)-mean(normalMatrix(:,i))).*(normalMatrix(:,j)-mean(normalMatrix(:,j)))) / totalFiles;
    end
end


%--- Reordering Final Matrix by accuracy ---%
sortedMatrix = zeros(size(finalMatrix));
for i=1:noAudioFeatures
    sortedMatrix(:,i,:) = finalMatrix(:,sortIndex(i),:);
end


save('sortedFeatures.mat');