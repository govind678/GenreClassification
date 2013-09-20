function [ output_args ] = knnClassifier( T,I,K )

noClasses = size(T,1);
noObservations = size(T,2);
%noFeatures = size(T,3);

classes = zeros(K,1);
minDist = zeros(K,1);

dist_Index = 1;

for i = 1:noClasses
    for j=1:noObservations
        tempDistance = sqrt(sum((squeeze(T(i,j,:))-I(:)).^2));
        
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
