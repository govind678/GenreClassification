function [ output_args ] = shortTermFT( X,windowLength,hopSize, plot,Fs )

nSamples = length(X);
n=1;
nyquist = floor(windowLength/2)+1;
S = zeros(nyquist,floor(nSamples/hopSize));
count = 1;
while n <= nSamples-windowLength
    %dft = fft(X(n:(n+windowLength-1)),windowLength); %no window function
    dft = fft(X(n:(n+windowLength-1)).*hamming(windowLength),windowLength); %with window function
    S(:,count) = dft(1:nyquist);
    n = n + hopSize;
    count=count+1;
end

if(plot == 1)
    Freq = 0:Fs/windowLength:Fs/2;
    Time = 0:(hopSize*(1/Fs)):(nSamples*(1/Fs))-(hopSize*(1/Fs));
    imagesc(Time,Freq,20*log10(abs(S)))
    axis xy;view(0,90);
    xlabel('Time');
    ylabel('Frequency (Hz)');
end

output_args = abs(S);

end


