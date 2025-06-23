% % % % Κώδικας 1.3: Ψηφιακά φίλτρα FIR – Παράδειγμα 1.2
clear all; close all;
% Το αρχείο "sima.mat" περιέχει το σήμα s και τη συχνότητα
% δειγματοληψίας Fs. Το φάσμα του σήματος εκτείνεται σχεδόν σε όλη την
% περιοχή συχνοτήτων μέχρι 4 KHz. Πάνω από 1 KHz, όμως, είναι θόρυβος
% και πρέπει να φιλτραριστεί.
load sima;
figure; pwelch(s,[],[],[],Fs);
% Ορίζεται η ιδανική βαθυπερατή συνάρτηση Η, με συχνότ. αποκοπ. Fs/8
H=[ones(1,Fs/8) zeros(1,Fs-Fs/4) ones(1,Fs/8)];
% Υπολογίζεται η κρουστική απόκριση με αντίστροφο μετασχ. Fourier
% Εναλλακτικά, μπορεί να χρησιμοποιηθεί η αναλυτική σχέση Sa(x)
h=ifft(H,'symmetric');
middle=length(h)/2;
h=[h(middle+1:end) h(1:middle)];
h32=h(middle+1-16:middle+17);
h64=h(middle+1-32:middle+33);
h128=h(middle+1-64:middle+65);
% figure; stem([0:length(h64)-1],h64); grid;
figure; freqz(h64,1);   % σχεδιάζουμε την απόκριση συχνότητας της h64
wvtool(h32,h64,h128);     % αποκρίσεις συχνότητας των περικομμένων h
% Οι πλευρικοί λοβοί είναι υψηλοί!
% Πολλαπλασιάζουμε την περικομμένη κρουστική απόκριση με κατάλληλο
% παράθυρο. Χρησιμοποιούμε την h64 και παράθυρα hamming και kaiser
wh=hamming(length(h64));
wk=kaiser(length(h64),5);
figure; plot(0:64,wk,'r',0:64,wh,'b'); grid;
h_hamming=h64.*wh';
% figure; stem([0:length(h64)-1],h_hamming); grid;
figure; freqz(h_hamming,1);
h_kaiser=h64.*wk';
wvtool(h64,h_hamming,h_kaiser);
% Φιλτράρουμε το σήμα μας με καθένα από τα τρία φίλτρα
y_rect=conv(s,h64);
figure; pwelch(y_rect,[],[],[],Fs);
y_hamm=conv(s,h_hamming);
figure; pwelch(y_hamm,[],[],[],Fs);
y_kais=conv(s,h_kaiser);
figure; pwelch(y_kais,[],[],[],Fs);
%
% Βαθυπερατό Parks-MacClellan
hpm=firpm(64, [0 0.10 0.15 0.5]*2, [1 1 0 0]);
% figure; freqz(hpm,1);
s_pm=conv(s,hpm);
figure; pwelch(s_pm,[],[],[],Fs); 
sound(20*s); % ακούμε το αρχικό σήμα, s
sound(20*s_pm); % ακούμε το φιλτραρισμένο σήμα, s_pm