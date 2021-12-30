% Author: Michail Gkagkos
% --- Simulate the performance of the QPSK modulation over an AWGN channel
clc;
clear all;


% --- Initialization 
Bits = 100000; % Number of bits to transmit
EbN0dB = 0:10; % Range of Eb/N0 
BER_QPSK_AWGN = zeros(length(EbN0dB));
BER_QPSK_AWGN_THEORY = zeros(length(EbN0dB));

% --- For different values of Eb/N0
for c =1:length(EbN0dB)

    
    % Compute the variance of the noise
    sigma2 = 1/(10^(EbN0dB(c)/10));
    
    % --- Initialize the counter for the errors and for the length of the
    % transmission
    error=0;
    lenTransmission=0;
    
    while error<100 && lenTransmission<10^7

        % --- Trasmitter
        data = round(rand(1,Bits));
        % QPSK Modulation   
        Symbols=reshape(data,2,[]); 
        b1 = Symbols(1,:);
        b2 = Symbols(2,:);
        
        symbols = (1-2*b1)+1i*(1-2*b2);     
        Length=length(symbols);
 
        % --- AWGN Noise
        n = sqrt(sigma2/2)*(randn(1,Length) + 1i*randn(1,Length)); % noise
        
        % --- Received Signal
        y = symbols + n; 
 
        % --- Hard estimates
        b1hat = real(y)<0; 
        b2hat = imag(y)<0; 
        bmathat = [b1hat; b2hat]; % symbols
        dataHat=reshape(bmathat,1,[]); 
        
      
        % ---- Count the errors
        error = sum(abs(dataHat-data)) + error;
        lenTransmission = length(dataHat) + lenTransmission;
        
    end
    
    % --- Compute the BER 
    BER_QPSK_AWGN(c) = error/lenTransmission;
    
    % --- Compute the theoretical BER
    BER_QPSK_AWGN_THEORY(c)= berawgn(EbN0dB(c), 'psk', 4, 'nondiff');

end
% --- Plot 
figure();
semilogy(EbN0dB,BER_QPSK_AWGN_THEORY,'r--','LineWidth',2);
hold on
semilogy(EbN0dB,BER_QPSK_AWGN,'ko-','LineWidth',1);
legend('Theory','Sim')
title('BER vs Eb/N0 for QPSK modulation')
ylabel('BER');
xlabel('Eb/N0(dB)');
grid on;