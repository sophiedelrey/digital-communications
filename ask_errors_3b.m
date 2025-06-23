function errors=ask_errors_3(k,Nsymb,nsamp,EbNo)
 % Η συνάρτηση αυτή εξομοιώνει την παραγωγή και αποκωδικοποίηση
 % θορυβώδους σήματος L-ASK και μετρά τον αριθμό των εσφαλμένων συμβόλων.
 % Επιστρέφει τον αριθμό των εσφαλμένων συμβόλων (στη μεταβλητή errors).
 % k είναι ο αριθμός των bits/σύμβολο, επομένως L=2^k -- ο αριθμός των
 % διαφορετικών πλατών
 % Nsymb είναι ο αριθμός των παραγόμενων συμβόλων (μήκος ακολουθίας LASK)
 % nsamp ο αριθμός των δειγμάτων ανά σύμβολο (oversampling ratio)
 % EbNo είναι ο ανηγμένος σηματοθορυβικός λόγος Eb/No, σε db
 k=4; Nsymb=40000; nsamp=20; EbNo=12;
 L=2^k;  % ο αριθμός των διαφορετικών πλατών
 SNR=EbNo-10*log10(nsamp/2/k); % SNR ανά δείγμα σήματος
 % Διάνυσμα τυχαίων ακεραίων {±1, ±3, ... ±(L-1)}. Να επαληθευθεί
 x=2*floor(L*rand(1,Nsymb))-L+1;
 Px=(L^2-1)/3;        % θεωρητική ισχύς σήματος
 sum(x.^2)/length(x); % μετρούμενη ισχύς σήματος (για επαλήθευση)
 h=ones(1,nsamp); h=h/sqrt(h*h'); % κρουστική απόκριση φίλτρου
 % πομπού (ορθογωνικός παλμός μοναδιαίας ενέργειας)
 y=upsample(x,nsamp); % μετατροπή στο πυκνό πλέγμα
 y=conv(y,h); % το προς εκπομπή σήμα
 y=y(1:Nsymb*nsamp); % περικόπτεται η ουρά που αφήνει η συνέλιξη
 % n=wgn(1,length(y),10*log10(Px)-SNR);
 ynoisy=y; 
 % ynoisy=awgn(y,SNR,'measured'); % θορυβώδες σήμα
 y=reshape(ynoisy,nsamp,length(ynoisy)/nsamp);
  for i=1:nsamp 
     matched(i)=h(end-i+1);
  end
 yrx=conv(ynoisy,matched);
 z = yrx(nsamp:nsamp:Nsymb*nsamp); % Yποδειγμάτιση -- στο τέλος
 % κάθε περιόδου Τ
 figure(1); stem(x(1:20)); 
 figure(2); stem(y(1:20*nsamp)); 
 figure(3); stem(yrx(1:20*nsamp)); 
 A= [-L+1:2:L-1]; % συγκριτής κατωφλίων:ποιο πλάτος χρησιμοποιήθηκε
 for i=1:length(z)
  [m,j]=min(abs(A-z(i)));
  z(i)=A(j);
 end
 err=not(x==z);
 errors=sum(err);
end