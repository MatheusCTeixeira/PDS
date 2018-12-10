
decrypt_s('./output/encrypted_signal.wav',10, 25000);

% Descrypt the sign
%
% audio -> encrypt audio file
% p     -> oversample value
% frequency_modulation -> where the message is modulated
%
% return the decrypted audio
function [audio] = decrypt_s(audio, p, frequency_modulation)
[audio, fs] = audioread(audio); % read the audio file

% Remove carrier
order_filter = 20;        % order of the filter
filter_fc = 2*pi*5000/fs; % cutoff frequency
filter_fir = fir1(order_filter, filter_fc, 'high', hamming(order_filter + 1));
audio = filter(filter_fir, 1, audio); % apply the filter to audio sign

audio = amdemod(audio, frequency_modulation, fs); % demodulate the audio

audio = resample(audio, 1, p); % resample the audio
fs = fs / p;                   % update frequency

audiowrite('./output/decrypted_signal.wav',  audio, fs); % save audio
end