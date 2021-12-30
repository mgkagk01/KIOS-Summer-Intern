% Author: Michail Gkagkos
% --- Simulate the performance of the BPSK modulation over an AWGN channel

clc;
clear all;


% --- Initialization 
Bits = 100000; % Number of bits to transmit
EbN0dB = 0:10; % Range of Eb/N0 
BER_BPSK_AWGN = zeros(length(EbN0dB));

% --- For values of Eb/N0
for c = 1:length(EbN0dB)
    
    % --- Initialize the counter for the errors and for the length of the
    % transmission
    error=0;
    lenTransmission=0;
    
    % Compute the variance of the noise
    sigma2 = 1/(2*(10^(EbN0dB(c)/10)));
    
    % --- Simulate
    while error<100 && lenTransmission<10^7
        
        % --- Trasmitter
        data = round(rand(1,Bits)); % Generating 0,1
        symbols = 2*data-1; % BPSK Symbols
        
        % --- Noise AWGN
        n = sqrt(sigma2)*randn(1,Bits);
        
        % --- Received Signal
        y = symbols + n; 
        
        % --- Hard estimates
        dataHat = y>0;
   
        % ---- Count the errors
        error = sum(data~=dataHat) + error;
        lenTransmission=lenTransmission+length(dataHat);
    end
     
    % --- Compute the BER 
    BER_BPSK_AWGN(c)=error/lenTransmission;
  
end

% --- Compute the theoretical BER
Theory_BER_AWGN = 0.5*erfc(sqrt(10.^(EbN0dB/10))); % theoretical ber
    
% --- Plot the performance
figure();
semilogy(EbN0dB,Theory_BER_AWGN,'r--','LineWidth',2);
hold on
semilogy(EbN0dB,BER_BPSK_AWGN,'ko-','LineWidth',1);
legend('Theory','Sim');
grid on
title('BER as a function of Eb/N0, BPSK modulation, AWGN channel');
xlabel('Eb/N0, dB');
ylabel('Bit Error Rate (BER)');


    