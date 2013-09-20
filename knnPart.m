load 'Results/PostScatter';

testGenre = 4;
testSong = 51;
k = 5;

class = knnClassifier(normalMatrix, normalMatrix(testGenre,testSong,:),k);

disp(sprintf('Genre of test song is: %d',class));
