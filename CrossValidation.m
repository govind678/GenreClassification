load 'audioFeatures.mat';

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



nFold = 10;
K = 1;

accuracyMatrix = zeros((100/nFold),noAudioFeatures);

for z=1:nFold
   accuracyMatrix(z,:) = nFoldCrossValidation(finalMatrix, z, nFold, K); 
end

[sortedValues, sortIndex] = sort(mean(accuracyMatrix),'descend');

