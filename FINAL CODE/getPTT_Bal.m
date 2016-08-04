function [PTT, R] = getPTT_Bal(wave1, wave2, varargin)
% varargin: OPTIONAL sampling frequency (Fs)
%    otherwise this defaults to Ts = 0.1ms (Fs = 10,000 Hz)

% the interpolated frequency (at the bottom of getWaves) is used here

Fs = 10000;
if length(varargin) >= 1,
    Fs = varargin{1};
end;

maxlag = round(Fs *0.15); % 150ms in either  direction is boundaries
%[c,lags] = xcorr(wave1(72000:end)',wave2(72000:end)',maxlag);
[c,lags] = xcorr(wave1(1000:end)',wave2(1000:end)',maxlag);
[val,idx] = max(c);

R = val; % This is the correlation coefficient of the overlapped waves
PTT = lags(idx) / Fs;
PTT=abs(PTT);

% [xx lag2] = xcorr(wave1(1000:end)',wave2(1000:end)');
% [val2 idx2] = max(xx);
% PPT2 = lag2(idx2)/Fs

%old Code
% maxlag = round(Fs *0.15); % 150ms in either  direction is boundaries
% [c,lags] = xcorr(wave1(1000:end)',wave2(1000:end)',maxlag);
% [val,idx] = max(c);