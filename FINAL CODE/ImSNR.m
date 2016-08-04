function [ dBSNR ] = ImSNR( fs, Signal, Window_Arr, IDX_Peak)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

fft_gb = fftshift(abs(fft(Signal))); % fft of gb
freq_arr = linspace(-fs/2,fs/2,length(fft_gb)); % frequency array 

% Power spectrum %%%% 
power_gb = fft_gb.^2; % Power spectrum
sig = power_gb(Window_Arr(1):Window_Arr(2)); % Data points corresponding to actual signal
center = find(freq_arr == 0); %center of the signal where it equals zero INDEX

if center <= Window_Arr(1)
    noise_before = 0; %ensures that if there is no noise before the actual signal window, it becomes zero
else
    noise_before = power_gb(center:Window_Arr(1));% Noise up to the lower window of the signal
end

noise_after = power_gb(Window_Arr(2):end); % Data points corresponding to noise after signal

sum_sig = sum(sig); % Sum of signal values
sum_noise = sum(noise_before) + sum(noise_after); % Total sum of noise values

SNR_value = sum_sig/sum_noise; % SNR value
dBSNR = 10 * log10(SNR_value); % SNR in dB

end

