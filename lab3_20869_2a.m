k=mod(20869,2)+3; nsamp=20; d=5; Nsymb=20000; 
L=2^k; 
% theoritical BER 
EbNo=0:25;
Pe=((L-1)/L)*erfc(sqrt((10.^(EbNo/10)).*(3*log2(L))/(L^2-1))); %υπολογίζω το Pe
ber=Pe/log2(L); %υπολογίζω το BER
figure();
semilogy(EbNo,ber);  % βαζει λογαριθμικά στον y αξονα
grid on;
title("BER of 16-ASK");
xlabel("Eb/No"); ylabel("BER");
hold on;
% simulation
BER=zeros(1,25);
for n=0:25
    BER(n+1)=ask_errors(k,Nsymb,nsamp,n)/Nsymb/log2(L);
end
plot(0:25, BER, '+');
legend("theoritical","simulated");
% οι τιμές της καμπύλης για EbNo=10,15,20
disp('BER(10)='); disp(ber(EbNo==10)); disp('BER(15)='); disp(ber(EbNo==15));
disp('BER(20)='); disp(ber(EbNo==20));
