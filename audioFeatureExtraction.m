function [ output_args ] = audioFeatureExtraction( y, blockSize, hopSize )

%********************************************
% Computational Music Analysis
% Assignment 2 - Genre Classification
%
% Audio Feature Extraction function
%
% Imankalyan Mukherjee, Govinda Ram Pingali
%********************************************


%-----------------------------------------------------------------------
% a) Implement 5 audio features with a 2048 block size and 1024 hop size
%-----------------------------------------------------------------------

% Read audio files from particular genre
nSamples = length(y);
nBlocks = floor(nSamples/hopSize);


% STFT of signal
stftCoefs = shortTermFT(y,blockSize,hopSize,0);
%nBands = length(stftCoefs); % Should this be nBands = (length(stftCoefs)/2)?
nBands = length(stftCoefs)/2;

 

 %*** 5 Audio Features ***%

% i) Spectral Centroid
spCentroid = zeros(nBlocks,1);
for n=1:nBlocks
    numr = 0;
    denr = 0;
    for k=1:nBands
        square = abs(stftCoefs(k,n)^2);
        numrTemp = k*square;
        numr = numr + numrTemp;
        denr = denr + square;
    end
    if denr==0
        spCentroid(n) = 0;
    else
        spCentroid(n) = numr/denr;
    end
end



% ii) Max Envelope
maxEnv = zeros(nBlocks,1);
index = 1;
for n=1:hopSize:nSamples-blockSize
    maxEnv(index) = max(y(n:n+blockSize));
    index = index+1;
end



% iii) Zero Crossing Rate
zcr = zeros(nBlocks,1);
index = 1;
for n=1:hopSize:nSamples-blockSize
    zcSum = 0;
    for i=n+1:n+blockSize
        sig = abs(sign(y(i))-sign(y(i-1)));
        zcSum = zcSum + sig;
    end
    zcr(index) = zcSum/(2*blockSize);
    index = index+1;
end



% iv) Spectral Crest Factor
spCrest = zeros(nBlocks,1);
for n=1:nBlocks   % Removing last two blocks because STFT is returning 0
    numr = max(abs(stftCoefs(:,n)));
    denr = sum(abs(stftCoefs(:,n)));
    if denr==0
        spCrest(n) = 0;
    else
        spCrest(n) = numr/denr;
    end
end




% v) Spectral Flux
spFlux = zeros(nBlocks,1);
for n=2:nBlocks
    tempSum = 0;
    for k=1:nBands
        temp = (abs(stftCoefs(k,n)) - abs(stftCoefs(k,n-1))) ^ 2;
        tempSum = tempSum + temp;
    end
    spFlux(n) = (2*sqrt(tempSum))/blockSize;
end
    

% Computing mean and standard deviation of each audio feature
meanSpCentroid = mean(spCentroid);
meanMaxEnv = mean(maxEnv);
meanZcr = mean(zcr);
meanSpCrest = mean(spCrest);
meanSpFlux = mean(spFlux);

stdSpCentroid = std(spCentroid);
stdMaxEnv = std(maxEnv);
stdZcr = std(zcr);
stdSpCrest = std(spCrest);
stdSpFlux = std(spFlux);


output_args = [meanSpCentroid meanMaxEnv meanZcr meanSpCrest meanSpFlux stdSpCentroid stdMaxEnv stdZcr stdSpCrest stdSpFlux];

end

