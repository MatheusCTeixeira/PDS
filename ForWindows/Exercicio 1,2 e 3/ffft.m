function [S,frequencia] = ffft(x,fs)

normal = length(x);
aux = 0:normal-1;
periodo = normal/fs;
frequencia = aux/periodo;
S = fft(x)/normal;
fc = ceil(normal/2);
S = S(1:fc);

figure();
plot(frequencia(1:fc),abs(S));
title("Espectro Do Sinal");
xlabel("Frequencia (Hz)");
ylabel("Amplitude");
grid on

end 