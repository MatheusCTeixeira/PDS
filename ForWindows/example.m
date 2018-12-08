SHORT = 0; LONG = 1;
use_audio = SHORT;
a = encrypt()
p = 10;
modulate_frequency = 2.5E4;

% short audio
if (use_audio == SHORT)
    [p, frequency_modulation] = encrypt_s(a, './audio/message.mp3', './audio/carrier.mp3', 10, 20000);
end        

%long audio
if (use_audio == LONG)
[p, frequency_modulation] = encrypt_s('./audio/in_the_hall_of_the_mountain_king.mp3',...
                                      './audio/prelude_in_c_major.mp3', 10, 2E5);
end

input('Pess some key...');
decrypt.decrypt_s('./output/encrypted_signal.wav',10, 2E5);