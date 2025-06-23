%Παραγωγή σήματος με φίλτρα Nyquist
%Διαγράμματα χρόνου και συχνότητας
L=8; step=2; k=log2(L); nsamp=32; Nsymb=10000;
EbNo=24;

% Διάνυσμα τυχαίων bits
x=randi([0,1],1,Nsymb*k); 
% Κωδικοιποίηση Gray 
mapping=[step/2; -step/2];
if(k>1)
 for j=2:k
 mapping=[mapping+2^(j-1)*step/2; ...
 -mapping-2^(j-1)*step/2];
 end
end;
xsym=bi2de(reshape(x,k,length(x)/k).','left-msb');
y1=[];
for i=1:length(xsym)
 y1=[y1 mapping(xsym(i)+1)];
end

% Ορισμός παραμέτρων φίλτρου
delay= 4; % Group delay (# of input symbols)
filtorder = delay*nsamp*2; % τάξη φίλτρου στο πυκνό πλέγμα 4Τ*32*2 
rolloff = 0.40; % Συντελεστής πτώσης 
% κρουστική απόκριση φίλτρου τετρ. ρίζας ανυψ. συνημιτόνου
rNyquist= rcosine(1,nsamp,'fir/sqrt',rolloff,delay);

% Σήμα Εκπομπής 
% Υπερδειγμάτιση και εφαρμογή φίλτρου rNyquist
y=upsample(y1,nsamp);
ytx = conv(y,rNyquist); 

SNR=EbNo-10*log10(nsamp/2/k); % SNR ανά δείγμα σήματος
Py=10*log10(ytx*ytx'/length(ytx));
Pn=Py-SNR;
n=sqrt(10^(Pn/10))*randn(1,length(ytx));
ynoisy=ytx+n;
%ynoisy=ytx;  %αν δεν θέλαμε θόρυβο

% Σήμα Λήψης 
% Φιλτράρισμα σήματος με φίλτρο τετρ. ρίζας ανυψ. συνημ.
yrx=conv(ytx,rNyquist);
yrx= yrx(filtorder+1:end-filtorder); %καθυστέρηση οπότε περικοπή 
% yr= downsample(yrx,nsamp); % Υποδειγμάτιση

% Γραφικές Παραστάσεις
figure(1); plot(yrx(1:10*nsamp)); title('έξοδος προσαρμοσμένου φίλτρου'); legend('yrx');
%stem values of sent symbols 
figure(2); plot(yrx(1:10*nsamp)); hold on;
stem([1:nsamp:nsamp*10],y1(1:10),'filled'); hold off;
legend('έξοδος προσαρμοσμένου φίλτρου (yrx)','input symbols (y1)');
figure; pwelch(yrx,[],[],[],1);
legend('yrx');



