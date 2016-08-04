% SNR code for Spring 2016 Research
% Lauren Hirt & Chris Rios

gb = greenband; % Filtered green band signal pulled from getWaves_Bal
% This signal has been filtered and normalized (see getWaves_Bal and
% myBand)
fs=60; % Frequency step
N = length(gb); % length of green band
fft_gb = fftshift(abs(fft(gb))); % fft of gb
freq_arr = -fs/2:fs/N:fs/2; % frequency array 
freq_arr_pos = freq_arr(round(length(freq_arr)/2):length(freq_arr)); % Just positive values
fft_gb_pos = fft_gb(round(length(fft_gb)/2):length(fft_gb)); % Just positive values

figure(1)
plot(freq_arr_pos,fft_gb_pos);
xlabel('Frequency'); xlim([0 5]);
ylabel('Magnitude of Signal');
title('FFT of Green Band');


% Chose freq .97 Hz to 1.17 Hz for actual signal value

% Power spectrum %%%% 
power_gb = fft_gb_pos.^2; % Power spectrum
sig = power_gb(30:36); % Data points corresponding to actual signal
noise_before = power_gb(1:29); % Data points corresponding to noise before signal
noise_after = power_gb(37:150); % Data points corresponding to noise after signal

sum_sig = sum(sig); % Sum of signal values
sum_noise = sum(noise_before) + sum(noise_after); % Total sum of noise values

SNR_value = sum_sig/sum_noise % SNR value
SNR_dB = 10 * log10(SNR_value) % SNR in dB









