% ergasthrio 5
function mapping=qam_scatterplot_gray(k)
% k is the number of bits per symbol 
k=6; M=2^k; L=sqrt(M);
l=log2(L) % αριθμός bit ανά συνιστώσα 

% Διάνυσμα mapping για την κωδικοποίηση Gray M-QAM
core=[1+i;1-i;-1+i;-1-i];
mapping=core;
if(l>1)
 for j=1:l-1
 mapping=mapping+j*2*core(1);
 mapping=[mapping;conj(mapping)];
 mapping=[mapping;-conj(mapping)];
 end
end
scatterplot(mapping,1,0,'m*');
for n=1:length(mapping)
 text(real(mapping(n))-0.0,imag(mapping(n))+0.3,num2str(de2bi(n-1,k,'left-msb')), ...
     'FontSize', 6,'Color','g');
 % δυαδική αναπαράσταση
end

