
[p, frequency_modulation] = encrypt_s('./message.mp3', './carrier.mp3', 10, 2E5);

%audio -> the message to be hide
%carrier -> the disguise audio
%key -> secret key [20k - 30k]
%p -> oversample [10-20]
function [p, frequency_modulation] = encrypt_s(audio, carrier, p, frequency_modulation)
[x,fs] = audioread(audio); % Lê o sinal de audio
[carrier, fs_carrier] = audioread(carrier); % Lê o sinal de audio da portadora

% Set same lenght to signals
[x, carrier] = padding_less_sign(x, carrier, 2);

% Filter to limit the band of signals
order_filter = 20;
filter_fc = 2*pi*4000/fs;
filter_fir = fir1(order_filter, filter_fc, hamming(order_filter + 1));

x = filter(filter_fir, 1, x);       % filter message (limit band)
y = filter(filter_fir, 1, carrier); % filter carrier (limit band)


x = resample(x, p, 1); % Resample message
y = resample(y, p, 1); % Resample carrier


fu = fs * p;             % New frequency


x = modulate(x, frequency_modulation ,fu,'am'); % AM to hide the data signal

r = y + x;

audiowrite('./encrypted_signal.wav',  r, fu);
end

function [x1, x2] = padding_less_sign(x1, x2, channels)
    % Set same lenght to signals
    [sz_x, dm_x] = size(x1(1:end, 1));
    [sz_y, dm_y] = size(x2(1:end, 1));
        
    padding_vector = zeros(abs(sz_x - sz_y), channels);
    if (sz_x > sz_y)        
        x2 = [x2; padding_vector];
    else        
        x1 = [x1; padding_vector];
    end
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