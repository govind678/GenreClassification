function [ output_args ] = knnClassifier( trainMatrix, testVector, K )


noObservations = size(trainMatrix,1);
noClasses = size(trainMatrix,3);

classes = zeros(K,1);
minDist = 100*ones(K,1);


dist_Index = 1;

for i = 1:noClasses
    for j=1:noObservations
        tempDistance = sqrt(sum(trainMatrix(j,:,i)-testVector(:)').^2);

        if dist_Index <= K
            minDist(dist_Index) = tempDistance;           
            classes(dist_Index) = i;
            dist_Index = dist_Index + 1;
        elseif tempDistance < max(minDist)
            swap_Index = find(minDist == max(minDist));
            minDist(swap_Index) = tempDistance;
            classes(swap_Index) = i;
        end
        
    end
end

output_args = mode(classes);

end