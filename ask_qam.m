% Εξομοιώνεται το πλήρες σύστημα πομπού-δέκτη QAM, με αφετηρία
% δυαδική ακολουθία προς εκπομπή. Γίνεται κωδικοποίηση
% Gray, ενώ Γκαουσιανός θόρυβος προστίθεται στο ζωνοπερατό
% QAM σήμα για δοσμένο σηματοθορυβικό λόγο Eb/No. 
% Δίνεται δυνατότητα επιλογής φίλτρου μορφοποίησης βασικής ζώνης
% M (=2^k, k άρτιο)είναι το μέγεθος του σηματικού αστερισμού,
% mapping είναι το μιγαδικό διάνυσμα των Μ QAM συμβόλων,
% σε διάταξη κωδικοποίησης Gray
% Nsymb είναι το μήκος της ακολουθίας QAM,
% nsamp είναι ο συντελεστής υπερδειγμάτισης, (# δειγμάτων/Τ)
% EbNo είναι ο λόγος Eb/No, in db

function errors=ask_qam(M,Nsymb,nsamp,EbNo,rolloff)
M=64; Nsymb=30000; nsamp=32; rolloff=0.25; EbNo=18; 
L=sqrt(M); l=log2(L); k=log2(M);
% Gray κωδικοποίηση
core=[1+1j;1-1j;-1+1j;-1-1j];
mapping=core;
if(l>1)
for j=1:l-1
mapping=mapping+j*2*core(1);
mapping=[mapping;conj(mapping)];
mapping=[mapping;-conj(mapping)];
end
end;
% Random bits--- symbols
x=floor(2*rand(k*Nsymb,1));  %τυχαια δυαδική ακολουθία
xsymbols=bi2de(reshape(x,k,length(x)/k).','left-msb')';
y=[];
for i=1:length(xsymbols)
y=[y mapping(xsymbols(i)+1)];
end
% Παραμετροι του φίλτρου
delay=10;
filtorder = delay*nsamp*2;
rNyquist= rcosine(1,nsamp,'fir/sqrt',rolloff,delay);
% Transmitter (εκπεμπόμενο σήμα)
ytx=upsample(y,nsamp);
ytx = conv(ytx,rNyquist);
% Υπολογισμός & σχεδιασμός φάσματος
figure(1); pwelch(real(ytx),[],[],[],nsamp); 
R=6000000;
Fs=Nsymb/k*nsamp;
fc=2; %carrier frequency baud rate
m=(1:length(ytx));
s=real(ytx.*exp(1j*2*pi*fc*m/nsamp)); % shift to desired frequency band
%Υπολογισμός & σχεδιασμός φάσματος
figure(2); pwelch(s,[],[],[],Fs); % COMMENT FOR BERTOOL
% Noise: Προσθήκη λευκού γκαουσιανού θορύβου
SNR=EbNo-10*log10(nsamp/2/k);
Ps=10*log10(s*s'/length(s)); %signal power (db)
Pn=Ps-SNR; %noise power (db)
n=sqrt(10^(Pn/10))*randn(1,length(ytx));
snoisy=s+n;

clear ytx xsymbols s n;  % για εξοικονόμηση μνήμης
% Receiver (ΔΕΚΤΗΣ)
yrx=2*snoisy.*exp(-1j*2*pi*fc*m/nsamp); clear s; %shift to 0 frequency
% Κανονικά ακολουθεί βαθυπερατό φίλτρο.
% Όμως στην περίπτωση μορφοποίησης Nyquist δεν χρειάζεται,
% αφού το προσαρμοσμένο φίλτρο (Nyquist) είναι ταυτόχρονα
% και ένα καλό βαθυπερατό φίλτρο.
yrx = conv(yrx,rNyquist); %filter
yrx = yrx(2*nsamp*delay+1:end-2*nsamp*delay);
figure(3); pwelch(real(yrx),[],[],[],Fs); % COMMENT FOR BERTOOL
yrx = downsample(yrx,nsamp); % Υποδειγμάτιση στο πλέγμα nT.
%yrx = yrx(2*delay+(1:length(y))); % περικοπή άκρων συνέλιξης.
% Error counting
yi=real(yrx); yq=imag(yrx);
xrx=[];
q=[-L+1:2:L-1];
for n=1:length(yrx)  % επιλογή πλησιέστερου σημείου
[m,j]=min(abs(q-yi(n)));
yi(n)=q(j);
[m,j]=min(abs(q-yq(n)));
yq(n)=q(j);
end
errors=sum(not(y==(yi+1j*yq)));

