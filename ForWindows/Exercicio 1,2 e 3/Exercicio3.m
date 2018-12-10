%Lembrete: Frequencias precisa estar em Radianos, valores entre 0 e 1;

close all
clear all
clc

fs = 8000; % freqüência de Amostragem Hz
fp = 1000/(pi*fs); % largura banda de passagem Hz 
fr = 3000/(pi*fs); % banda de rejeição Hz
ap = 2; % Ganho banda de passagem dB
ar = 20; % Atenuação banda de rejeição dB

f1 = 50; % freqüência dentro da banda de passagem Hz
f2 = 500; % freqüência dentro da banda de passagem Hz
f3 = 2000 ; % frequencia dentro da faixa de atenuação Hz
f4 = 1500; % frequencia dentro da faixa de atenuação Hz

t=0:1:1000;

% Sinal com Ruido

sinal_ruido =6*sin((2*pi*f1*t/fs))+4*sin((2*pi*f2*t/fs))+0.5*sin((2*pi*f3*t/fs))+3*sin((2*pi*f4*t/fs)); % Sinal de entrada com ruido.

% Filtro Butterwoth

[n,wn] = buttord(fp,fr,ap,ar);
[num,den] = butter(n,wn); 
amostras = 50; %input('Digite o Numero de Amostras: ');
filtragem = filter(num,den,sinal_ruido);
ffft(filtragem,fs);
title('Espectro de frequencia do sinal filtrado Butterwoth');

%Chebyshev Filter I 

[num2,den2] = cheby1(n,ap,fp);
filtragem_cheby1 = filter(num2,den2,sinal_ruido);
ffft(filtragem_cheby1,fs);
title('Espectro de Frequencia da Filtragem Chebyshev Tipo I')

%Chebyshev Filter II

[num3,den3] = cheby2(n,ar,fr);
filtragem_cheby2 = filter(num3,den3,sinal_ruido);
ffft(filtragem_cheby2,fs);
title('Espectro de frequencia da filtragem Chebyshev Tipo II');

% Filtro Eliptico

[num4,den4] = ellip(n,ap,ar,fp);
filtragem_ellip = filter(num4,den4,sinal_ruido);
ffft(filtragem_ellip,fs);
title('Espectro de Frequencia da filtragem Elliptic');

%%%%%%%%%% Todos os sinais Plotado %%%%%%%%%%%%5

figure
freqz(num,den,amostras,fs),grid on
title('Filtro Butterworth')

figure
freqz(num2,den2);,grid on
title('Filtro Chebyshev tipo I')

figure
freqz(num3,den3); grid on
title('Filtro Chebyshev Tipo II');

figure
freqz(num4,den4); grid on
title('Filtro Elipitico')

figure
plot(sinal_ruido),grid on
title('Sinal a ser filtrado');
xlabel('Tempo(s)')
ylabel('Amplitude')

figure
subplot(2,2,1);
plot(filtragem),grid on
title('Sinal filtrado Butterworth')
xlabel('Tempo(s)')
ylabel('Amplitude')

subplot(2,2,2);
plot(filtragem_cheby1),grid on
title('Sinal filtrado Chebyshevi I')
xlabel('Tempo(s)')
ylabel('Amplitude')

subplot(2,2,3);
plot(filtragem_cheby2),grid on
title('Sinal filtrado Chebyshevi II')
xlabel('Tempo(s)')
ylabel('Amplitude')

subplot(2,2,4);
plot(filtragem_ellip),grid on
title('Sinal filtrado Elliptic')
xlabel('Tempo(s)')
ylabel('Amplitude')




