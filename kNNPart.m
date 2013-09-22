clear;
clc;

load 'Results/PostScatter';

testGenre = 2;
testSong = 55;


class = knnClassifier(normalMatrix, squeeze(normalMatrix(testGenre,testSong,:)),5);

disp(sprintf('Output Class is: %d',class));