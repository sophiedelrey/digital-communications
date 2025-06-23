function errors=ask_errors_n(k,d,M,nsamp,EbNo)
% Η συνάρτηση αυτή εξομοιώνει την παραγωγή και αποκωδικοποίηση 
% θορυβώδους σήματος L-ASK και μετρά τον αριθμό των εσφαλμένων συμβόλων.
% Υπολογίζει επίσης τη θεωρητική πιθανότητα εσφαλμένου συμβόλου, Pe.
% Επιστρέφει τον αριθμό των εσφαλμένων συμβόλων, καθώς και τον συνολικό
% αριθμό των συμβόλων που παρήχθησαν. 
% k είναι ο αριθμός των bits/σύμβολο, ώστε L=2^k,
% M ο αριθμός των παραγόμενων συμβόλων (μήκος ακολουθίας L-ASK)
% nsamp ο αριθμός των δειγμάτων ανά σύμβολο (oversampling ratio)
% EbNo είναι ο λόγος Eb/No, σε db
d=5; k=4; M=40000; nsamp=20; EbNo=12;
L=2^k;
SNR=EbNo-10*log10(nsamp/2/k); % SNR ανά δείγμα σήματος% Διάνυσμα τυχαίων ακεραίων {±1, ±3, ... ±(L-1)}. Να επαληθευτεί
x=(2*floor(L*rand(1,M))-L+1)*d/2; % dianusma platwn
Px=((d^2)/4)*(L^2-1)/3;       % θεωρητική ισχύς σήματος
Px_verify=sum(x.^2)/length(x);% μετρούμενη ισχύς σήματος (για επαλήθευση)
% display(Px);  display(Px_verify);
y=rectpulse(x,nsamp);
n=wgn(1,length(y),10*log10(Px)-SNR);
ynoisy=y+n;                   % θορυβώδες σήμα
y=reshape(ynoisy,nsamp,length(ynoisy)/nsamp);
matched=ones(1,nsamp);
z=matched*y/nsamp;
A=(d/2)*([-L+1:2:L-1]);
hist(z,200); title ('Histogram of z EbNo=20');
% hist(x,A); title ('histogram of x');
for i=1:length(z)
    [m,j]=min(abs(A-z(i)));
    z(i)=A(j);
end
err=not(x==z);
errors=sum(err);
end