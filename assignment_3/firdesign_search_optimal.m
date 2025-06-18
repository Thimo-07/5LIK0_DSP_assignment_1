close all

% define the sampling frequency of 44.1kHz
fs = 44100; % do not change! Unless your stream uses a different sampling rate
% set the desired cut off frequency
fco = 500;
% compute the digital cut off frequency
wco = 2*pi*fco/fs;

% Different filter orders to test
N_values = [38, 194, 199, 204];

% Create figure with two subplots
figure;

% Subplot 1: Full frequency response
subplot(1, 1, 1);
hold on;

for i = 1:length(N_values)
    N = N_values(i);
    
    % compute the FIR filter coefficients for a low pass filter 
    b = fir1(N, wco/pi, 'low');

    % make a plot of the frequency response with absolute 
    % frequencies on the horizontal axis
    w = 0:0.01:pi;
    f = w / 2 / pi * fs;
    r = exp(1i * w' * (0:N)) * b';
    r_abs = abs(r);
    plot(f, r_abs, 'DisplayName', sprintf('Length %d (N=%d)', N+1, N));

    % % Find f1 and f2 in one step each
    % % Force both f and r_abs to be column vectors
    f = f(:);
    r_abs = r_abs(:);
    f1 = NaN; f2 = NaN;

    f1_idx = find(f <= 500 & r_abs >= 0.8, 1, 'last');
    if ~isempty(f1_idx), f1 = f(f1_idx); end

    f2_idx = find(f >= 500 & r_abs <= 0.1, 1, 'first');
    if ~isempty(f2_idx), f2 = f(f2_idx); end

    fprintf('-- Filter size: %d (N:%d) --\n', N+1, N);
    fprintf('f1: %.2f Hz\n', f1);
    fprintf('f2: %.2f Hz\n', f2);
    fprintf('Q: %.4f\n', f1/f2);
end

% Add vertical lines at cutoff frequency
xline(fco, 'r--', 'Fco', 'LineWidth', 1.5, 'LabelVerticalAlignment', 'bottom', 'HandleVisibility', 'off');
% Add horizontal lines for threshold of f1 and f2
yline(0.8, 'b--', '0.8', 'LineWidth', 1.5, 'HandleVisibility', 'off');
yline(0.1, 'b--', '0.1', 'LineWidth', 1.5, 'HandleVisibility', 'off');

xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('FIR Filter Frequency Response for Different Filter Lengths');
legend('show');
grid on;
%xlim([0 2000]);
hold off;
