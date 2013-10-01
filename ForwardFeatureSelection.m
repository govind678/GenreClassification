%--- Forward Feature Selection ---%
load 'sortedFeatures.mat';

%meanAccuracy = zeros(1,length(sortIndex));
tempAccuracy = zeros(nFold,length(sortIndex));
for z=1:nFold
    for n=1:length(sortIndex)
        tempAccuracy(z,n) = mean(nFoldCrossValidation(sortedMatrix(:,1:n,:), z, nFold, K));
    end    
end

finalAccuracy = mean(tempAccuracy,1);

plot(finalAccuracy, 'o-');
xlabel('No. of Features included as per rank 1->10');
ylabel('Mean Accuracy');