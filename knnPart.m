clear;
clc;

load 'Results/PostScatter';

count = 0;

for i = 1 : noGenres
    for j = 1 : noFiles(i)
        
        testGenre = i;
        testSong = j;
        class = knnClassifier(finalMatrix, finalMatrix(testSong,:,testGenre),5);
        disp(sprintf('Output Class is: %d',class));
        
        if class == i;
            count = count + 1;
        end
        
    end
end

disp(sprintf('Percentage correct is: %f %',100*count/sum(noFiles(1:noGenres))));