decrypt_s('./encrypted_signal.wav',10, 2E5);

function [audio] = decrypt_s(audio, p, frequency_modulation)
[audio, fs] = audioread(audio);

order_filter = 120;
filter_fc = 2*pi*20000/fs;
filter_fir = fir1(order_filter, filter_fc, 'high', hamming(order_filter + 1));

audio = filter(filter_fir, 1, audio);

audio = amdemod(audio, frequency_modulation, fs);

audio = resample(audio, 1, p);
fs = fs / p;

audiowrite('./decrypted_signal.wav',  audio, fs);
end


% Plota a transformada de fourier de um sinal %
function plot_fft(y, Fs, Title)    
    L = length(y);
    NFFT = 2^nextpow2(L);
    Y = fft(y,NFFT)/L;
    f = Fs/2*linspace(0, 1, NFFT/2+1);
    plot(f,2*abs(Y(1:NFFT/2+1)), 'color', 'k');    
    title(Title);
    xlabel('Frequency (Hz)');
    ylabel('|Y(f)|');
end