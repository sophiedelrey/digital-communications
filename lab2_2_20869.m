clear all; close all;
% Το αρχείο "sima.mat" περιέχει το σήμα s και τη συχνότητα
% δειγματοληψίας Fs. Το φάσμα του σήματος εκτείνεται σχεδόν σε όλη την
% περιοχή συχνοτήτων μέχρι 4 KHz. Πάνω από 1 KHz, όμως, είναι θόρυβος
% και πρέπει να φιλτραριστεί.
load sima;
figure(1); pwelch(s,[],[],[],Fs);
% Ορίζεται η ιδανική ζωνοπερατή συνάρτηση Η, 
% Ts=1/Fs; 
% f2m1=(f2-f1); f2p1=(f2+f1)/2; N=256; 
% t=(-(N-1):2:N-1)*Ts/2; 
% H=2/Fs*cos(2*pi*f2p1*t).*sin(pi*f2m1*t)/pi./t ;
% figure(2); freqz(H,1);  
f1=700;  f2=1500;
H=[zeros(1,f1) ones(1,(f2-f1)) zeros(1,(f1+Fs/2-f2)) ones(1,(f2-f1))...
       zeros(1,Fs/2-f2)];
figure(2); freqz(H,1); 
% Υπολογίζεται η κρουστική απόκριση με αντίστροφο μετασχ. Fourier
% Εναλλακτικά, μπορεί να χρησιμοποιηθεί η αναλυτική σχέση Sa(x)
h=ifft(H,'symmetric');
middle=length(h)/2;
h=ifftshift(h);
h160=h(middle+1-80:middle+81);
figure(3); stem(0:length(h160)-1,h160); grid;
figure(4); freqz(h160,1);   % σχεδιάζουμε την απόκριση συχνότητας της h160
wvtool(h160);     % αποκρίσεις συχνότητας των περικομμένων h
% Πολλαπλασιάζουμε την περικομμένη κρουστική απόκριση με κατάλληλο
% παράθυρο. 
% Χρησιμοποιούμε την h160 και παράθυρα hamming και kaiser
wh=hamming(length(h160));
wk=kaiser(length(h160),5);
figure(6); plot(0:160,wk,'r',0:160,wh,'b'); grid;
h_hamming=h160.*wh';
figure(7); stem(0:length(h160)-1,h_hamming); grid;
figure(8); freqz(h_hamming,1);
h_kaiser=h160.*wk';
wvtool(h160,h_hamming,h_kaiser);
% Φιλτράρουμε το σήμα μας με καθένα από τα τρία φίλτρα
y_rect=conv(s,h160);
figure(10); pwelch(y_rect,[],[],[],Fs);
y_hamm=conv(s,h_hamming);
figure(11); pwelch(y_hamm,[],[],[],Fs);
y_kais=conv(s,h_kaiser);
figure(12); pwelch(y_kais,[],[],[],Fs);
%
% Ζωνοπερατό Parks-MacClellan
f=2*[0 f1*0.91 f1*1.05 f2*0.91 f2*1.05 Fs/2]/Fs;
% kanonikopoioume ws pros Fs/2 (to 2* einai giauto) 
hpm=firpm(160,f , [0 0 1 1 0 0]);
% xrhsimopoioume kai mikroteroy mhkous filtra gia logous fortou 
figure(13); freqz(hpm,1);
wvtool(hpm)
s_pm=conv(s,hpm);
% suneliksh 
figure(15); pwelch(s_pm,[],[],[],Fs); 
% sound(20*s); % ακούμε το αρχικό σήμα, s
% sound(20*s_pm); % ακούμε το φιλτραρισμένο σήμα, s_pm