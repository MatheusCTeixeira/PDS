close all
clc
clear all

fs = 8000; %Frequencia de Amostragem
fc = (1750*pi)/fs; %Frequencia de Corte
f1 = 1000; % freqüência dentro da banda de passagem
f2 = 3000; % freqüência dentro da banda de rejeição
den = 1; % como o sistema é do tipo FIR O Denominador Da TF é 1.

t = 0:1:1000; %Tempo

sinal_ruido = 4*sin((2*pi*f1*t/fs))+ sin((2*pi*f2*t/fs)); %Sinal com o Ruido

ffft(sinal_ruido,fs); %Transformada Rapida de Fourier do sinal

L = 50; %input('Digite o valor inteiro para a janela: ');

janela_hamming = hamming(L+1);
filtro_hamming = fir1(L,fc,'high',janela_hamming);
filtragem_hamming = filter(filtro_hamming,den,sinal_ruido);

janela_blackman = blackman(L+1);
filtro_blackman = fir1(L,fc,'high',janela_blackman);
filtragem_blackman = filter(filtro_blackman,den,sinal_ruido);


% Todos os Sinais Plotados

%Sinais Hamming

subplot(2,1,1);
plot(sinal_ruido);
xlabel('tempo(s)');
ylabel('amplitude');
title('Sinal a Ser Filtrado Hamming')

subplot(2,1,2);
plot(filtragem_hamming);
xlabel('tempo(s)');
ylabel('amplitude');
title('Sinal Filtrado Hamming');

ffft(filtragem_hamming,fs);
title('Espectro de Frequencia do Sinal Filtrado Hamming')

ffft(sinal_ruido,fs);
title('Espectro de frequencia do Sinal Com ruido Hamming')

%Sinais Blackman

subplot(2,1,1);
plot(sinal_ruido);
xlabel('tempo(s)');
ylabel('amplitude');
title('Sinal a Ser Filtrado Blackman')

subplot(2,1,2);
plot(filtragem_blackman);
xlabel('tempo(s)');
ylabel('amplitude');
title('Sinal Filtrado Blackman');

ffft(filtragem_blackman,fs);
title('Espectro de Frequencia do Sinal Filtrado Blackman')

ffft(sinal_ruido,fs);
title('Espectro de frequencia do Sinal Com ruido Blackman')

% As Duas Janelas

subplot(2,1,1)
plot(janela_hamming),grid on;
title('Janela Hamming');
xlabel('tempo(s)');
ylabel('amplitude');

subplot(2,1,2)
plot(janela_blackman), grid on;
title('Janela BlackMan');
xlabel('tempo(s)');
ylabel('amplitude');

% Modulo e fase de Blackman e Hamming

figure
freqz(filtro_blackman);
title('BlackMan');

figure
freqz(filtro_hamming);
title('Hamming');





