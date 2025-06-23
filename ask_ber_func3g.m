function [ber,numBits] = ask_ber_func3g(EbNo, maxNumErrs, maxNumBits)
L=16; 
Pe=((L-1)/L)*erfc(sqrt((10.^(EbNo/10)).*(3*log2(L))/(L^2-1)));
ber=Pe/log2(L);
% Import Java class for BERTool.
import com.mathworks.toolbox.comm.BERTool.*;
% Initialize variables related to exit criteria.
totErr = 0; % Number of errors observed
numBits = 0; % Number of bits processed
% Α. --- Set up parameters. ---
% --- INSERT YOUR CODE HERE.
k=4; % number of bits per symbol
Nsymb=20000; % number of symbols in each run
nsamp=8;% oversampling,i.e. number of samples per T
% Simulate until number of errors exceeds maxNumErrs
% or number of bits processed exceeds maxNumBits.
while((totErr < maxNumErrs) && (numBits < maxNumBits))
 % Check if the user clicked the Stop button of BERTool.
 % if (BERTool.getSimulationStop)
 % break;
 % end
 % Β. --- INSERT YOUR CODE HERE.
 errors=ask_errors_3g(k,Nsymb,nsamp,EbNo);
 % Assume Gray coding: 1 symbol error ==> 1 bit error
 totErr=totErr+errors;
 numBits=numBits + k*Nsymb;
end % End of loop
% Compute the BER
ber = totErr/numBits;