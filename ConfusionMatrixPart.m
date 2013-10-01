clc;

K = 7;

tempAccuracy = zeros(nFold,length(sortIndex));
confusionMatrix = zeros(noGenres, noGenres);

for z=1:nFold
    for n=1:5
        temp = nFoldCrossValidation(sortedMatrix(:,1:n,:), z, nFold, K);
        tempAccuracy(z,n) = temp{1};
        
        confusionMatrix = confusionMatrix + temp{2};
    end    
end

finalAccuracy = mean(tempAccuracy,1);