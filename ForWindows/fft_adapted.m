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