function [ output_args ] = nFoldCrossValidation( finalMatrix, z, nFold, K )

noFiles = size(finalMatrix,1);
noAudioFeatures = size(finalMatrix,2);
noGenres = size(finalMatrix,3);


trainingMatrix = zeros(((100-nFold)/100)*noFiles,noAudioFeatures,noGenres);
testingMatrix = zeros((nFold/100)*noFiles,noAudioFeatures,noGenres);

noTestVectors = size(testingMatrix,1);

trainIndex = 1;
testIndex = 1;

for i=1:noGenres
    for n=1:noFiles
        if mod(n,nFold) == z-1
            testingMatrix(testIndex,:,i) = finalMatrix(n,:,i);
            testIndex = testIndex+1;
        else
            trainingMatrix(trainIndex,:,i) = finalMatrix(n,:,i);
            trainIndex = trainIndex+1;
        end
    end
    testIndex = 1;
    trainIndex = 1;
end


classMatrix = zeros(noTestVectors,noAudioFeatures,noGenres);

for j=1:noGenres
    for n=1:noTestVectors
        classMatrix(n,:,j) = knnClassifier(trainingMatrix,testingMatrix(n,:,j),K);
    end
end


sumCorrectClass = zeros(1,noAudioFeatures);
for j=1:noGenres
    for n=1:noAudioFeatures
        sumCorrectClass(n) = sumCorrectClass(n) + size(find(classMatrix(:,n,j)==j),1);
    end
end

output_args = (sumCorrectClass*100)/(noGenres*noTestVectors);


end

