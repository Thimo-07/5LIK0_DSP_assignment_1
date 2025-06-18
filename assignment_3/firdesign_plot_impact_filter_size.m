% define the sampling frequency of 44.1kHz
fs = 44100; % do not change! Unless your stream uses a different sampling rate
% set the desired cut off frequency
fco = 500;
% compute the digital cut off frequency
wco = 2*pi*fco/fs;

% Different filter orders to test
N_values = [4, 9, 19, 29, 37, 38, 39, 49, 59];

% Create figure with two subplots
figure;

% Subplot 1: Full frequency response
subplot(2, 1, 1);
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
end

% Add vertical lines at digital frequencies 0.8*pi and pi
% Convert digital frequencies to absolute frequencies
f_08pi = 0.8 * pi / (2 * pi) * fs;  % 0.8*pi in absolute frequency
f_pi = pi / (2 * pi) * fs;          % pi in absolute frequency
% Add vertical lines
xline(f_08pi, 'r--', '0.8\pi', 'LineWidth', 1.5, 'LabelVerticalAlignment', 'bottom', 'HandleVisibility', 'off');
xline(f_pi, 'r--', '\pi', 'LineWidth', 1.5, 'LabelVerticalAlignment', 'bottom', 'HandleVisibility', 'off');
% Add horizontal lines for threshold of 3.0e-3
yline(3.0e-3, 'b--', '3.0e-3', 'LineWidth', 1.5, 'HandleVisibility', 'off');

xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('FIR Filter Frequency Response for Different Filter Lengths');
legend('show');
grid on;
hold off;

% Subplot 2: Zoomed in version between the vertical lines
subplot(2, 1, 2);
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
end

% Add vertical lines at digital frequencies 0.8*pi and pi
xline(f_08pi, 'r--', '0.8\pi', 'LineWidth', 1.5, 'LabelVerticalAlignment', 'bottom', 'HandleVisibility', 'off');
xline(f_pi, 'r--', '\pi', 'LineWidth', 1.5, 'LabelVerticalAlignment', 'bottom', 'HandleVisibility', 'off');
% Add horizontal lines for threshold of 3.0e-3
yline(3.0e-3, 'b--', '3.0e-3', 'LineWidth', 1.5, 'HandleVisibility', 'off');

% Set zoom limits to focus on the region between the vertical lines
xlim([f_08pi - 1000, f_pi + 1000]);  % Add some margin around the vertical lines
ylim([0, 0.01]);  % Zoom in on y-axis to better see the threshold

xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Zoomed View: Filter Response Between 0.8\pi and \pi');
legend('show');
grid on;
hold off;