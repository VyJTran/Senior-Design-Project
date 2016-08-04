 function [ idx_peak_loc idx_wind_arr] = PeakDetect( sig, freq_array )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%include a the size of window for the peak as for signal 
sig = fftshift(abs(fft(sig))); % fft of gb

%  i = (lenght(sig)/2)+1;
threshold = max(sig) - 3;
counter = 1;
for i = floor((length(sig)/2))+1 : length(sig)
    if ((sig(i-1) < sig(i)) && (sig(i+1) < sig(i))) && (sig(i) > threshold)
        idx_peak_loc = i;
        break
    end
end


counter = 1;
strt_position = idx_peak_loc - 1; %starting with left side of signal peak
idx_wind_arr = [];
while length(idx_wind_arr) <= 2
%     if (length(idx_wind_arr) >= 1 ) && (strt_position - 1 == idx_peak_loc)
%         strt_position = idx_peak_loc  + 1;
%     end
    if ((sig(strt_position  - 1) > sig(strt_position)) && (sig(strt_position + 1) > sig(strt_position)))
        idx_wind_arr(counter) = strt_position;
        counter = counter + 1;
        strt_position = idx_peak_loc  + 1;
        if length(idx_wind_arr) == 2
            break;
        end
    else
        if length(idx_wind_arr) < 1
            strt_position = strt_position - 1;
        else
            strt_position = strt_position + 1;
        end
    end
end


%put second if statement within its own loop


% counter = 1;
% for i = floor((length(sig)/2))+1 : length(sig)
%     if ((sig(i-1) > sig(i)) && (sig(i+1) > sig(i)))
%         idx_wind_arr(counter) = freq_array(i);
%         counter = counter + 1;
%         if length(idx_wind_arr) == 2
%             idx_wind_arr(3) = idx_wind_arr(2) - idx_wind_arr(1);
%             break;
%         end
%     end
% end

% counter = 1;
% j = 1;
% % for j = idx_peak_loc : length(sig)
% while j ~= 2
%     if ((freq_array(idx_peak_loc + counter) - freq_array(idx_peak_loc-counter)) >= 0.1) && ((freq_array(idx_peak_loc + counter) - freq_array(idx_peak_loc-counter)) <= 0.3)
%         idx_wind_arr(1) = freq_array(idx_peak_loc-counter); %lower window min
%         idx_wind_arr(2) = freq_array(idx_peak_loc + counter); %upper window max
%         idx_wind_arr(3) = freq_array(idx_peak_loc + counter) - freq_array(idx_peak_loc-counter); %window distance
%         j = j + 1;
%     else 
%         counter = counter + 1;
%     end
% end

        
        





end

