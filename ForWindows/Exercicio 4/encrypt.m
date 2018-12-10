
[p, frequency_modulation] = encrypt_s('./audio/message.mp3', './audio/carrier.mp3', 10, 25000); 

%audio   -> the message to be hide
%carrier -> the disguise audio
%p       -> oversample [10-20]
%frequency_modulation -> frequency where the message will be modulated [20k - 30k]
function [p, frequency_modulation] = encrypt_s(audio, carrier, p, frequency_modulation)
[x,fs] = audioread(audio);                  % message 
[carrier, fs_carrier] = audioread(carrier); % carrier

[x, carrier] = padding_less_sign(x, carrier, 2); % set same lenght to signals

% Filter to limit the band of signals
order_filter = 20;         % order of filter
filter_fc = 2*pi*4000/fs;  % cutoff frequency
filter_fir = fir1(order_filter, filter_fc, hamming(order_filter + 1));

x = filter(filter_fir, 1, x);       % filter message (limit band)
y = filter(filter_fir, 1, carrier); % filter carrier (limit band)


x = resample(x, p, 1); % resample message
y = resample(y, p, 1); % resample carrier

fu = fs * p; % new frequency

x = modulate(x, frequency_modulation ,fu,'am');  % AM to hide the data signal

r = y + x; % sum signs
audiowrite('./output/encrypted_signal.wav',  r, fu);
end

% Set same lenght to signals. The signs are padding with zeros.
%
% x1, x2 -> vectors
% num_channels -> number of channels of x1, x2 (It's expected that they are equal)
% 
% return two vector with the same size
function [x1, x2] = padding_less_sign(x1, x2, num_channels)    
    [sz_x, dm_x] = size(x1(1:end, 1));
    [sz_y, dm_y] = size(x2(1:end, 1));
        
    padding_vector = zeros(abs(sz_x - sz_y), num_channels);
    if (sz_x > sz_y)        
        x2 = [x2; padding_vector];
    else        
        x1 = [x1; padding_vector];
    end
end

% FFT plot graph %
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