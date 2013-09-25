function [ output_args ] = knnClassifier( trainMatrix, testVector, K )


noObservations = size(trainMatrix,1);
noFeatures = size(trainMatrix,2);
noClasses = size(trainMatrix,3);

classes = zeros(K,noFeatures);
minDist = zeros(K,noFeatures);
modeClasses = zeros(1,noFeatures);

dist_Index = 1;

for n=1:noFeatures
    for i = 1:noClasses
        for j=1:noObservations
            tempDistance = abs(trainMatrix(j,n,i)-testVector(n));
        
            if dist_Index <= K
                minDist(dist_Index,n) = tempDistance;           
                classes(dist_Index,n) = i;
                dist_Index = dist_Index + 1;
            elseif tempDistance < max(minDist(:,n))
                swap_Index = find(minDist(:,n) == max(minDist(:,n)));
                minDist(swap_Index,n) = tempDistance;
                classes(swap_Index,n) = i;
            end
        end
    end
    dist_Index = 1;
    modeClasses(n) = mode(classes(:,n));
end

output_args = modeClasses;
end