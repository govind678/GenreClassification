%--- Forward Feature Selection ---%
load 'sortedFeatures.mat';

%meanAccuracy = zeros(1,length(sortIndex));
tempAccuracy = zeros(nFold,length(sortIndex));
for z=1:nFold
    for n=1:length(sortIndex)
        tempAccuracy(z,n) = mean(nFoldCrossValidation(sortedMatrix(:,1:n,:), z, nFold, K));
    end
    
end