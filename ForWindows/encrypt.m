
[r, fs, fu, key] = encrypt_s('./message.mp3', './carrier.mp3', 10, 2E5);

%audio -> the message to be hide
%carrier -> the disguise audio
%key -> secret key [20k - 30k]
%p -> oversample [10-20]
function [r, fs, fu, key] = encrypt_s(audio, carrier, p, key)
[x,fs] = audioread(audio); % Lê o sinal de audio
[carrier, fs_carrier] = audioread(carrier); % Lê o sinal de audio da portadora

if (fs ~= fs_carrier)
    disp('The frequency of audio and carrier are not compatible.');
    return;
end

% Filter to limit the band of signals
order_filter = 120;
filter_fc = 2*pi*4000/fs;
filter_fir = fir1(order_filter, filter_fc, hamming(order_filter + 1));

% Apply filter
x = filter(filter_fir, 1, x);
y = filter(filter_fir, 1, carrier);

% Resample
x = resample(x, p, 1);

% Set same lenght to signals
[sz_x, dm_x] = size(x(1:end, 1));
[sz_y, dm_y] = size(y(1:end, 1));
if (sz_x > sz_y)
    k = zeros(sz_x - sz_y, 2);
    y = [y;k];
    
else
    k = zeros(sz_y - sz_x, 2);
    x = [x;k];
end

% New frequency
fu = fs * p;

% AM to hide the data signal
x = modulate(x, key ,fu,'am');

r = y + x;
audiowrite('./encrypted_signal.wav',  r, fs);

plot_fft(r, fu, 'Encrypted signals');

end

% Plota a transformada de fourier de um sinal %
function plot_fft(y, Fs, Title)    
    L = length(y);
    NFFT = 2^nextpow2(L);
    Y = fft(y,NFFT)/L;
    f = Fs/2*linspace(0, 1, NFFT/2+1);
    plot(f,2*abs(Y(1:NFFT/2+1)),'k');    
    title(Title);
    xlabel('Frequency (Hz)');
    ylabel('|Y(f)|');
end