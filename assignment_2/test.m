% Plot 16-point DFT Twiddle Factors
clear; clc; close all;

% We consider a 16-point DFT
N = 16;

% Generate the twiddle factors lookup table
TF = exp(-2i * pi * (0:N/2-1) / N);

% Create unit circle for reference
theta = linspace(0, 2*pi, 200);
unit_circle = exp(1i * theta);

% Plot the twiddle factors
figure('Position', [100, 100, 800, 600]);

% Main plot - Twiddle factors on unit circle
subplot(2,2,1);
hold on;
% Plot unit circle
plot(real(unit_circle), imag(unit_circle), 'k--', 'LineWidth', 1);
% Plot twiddle factors
plot(real(TF), imag(TF), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
% Add lines from origin to each point
for k = 1:length(TF)
    plot([0, real(TF(k))], [0, imag(TF(k))], 'b-', 'LineWidth', 1);
end
grid on;
title('16-Point DFT Twiddle Factors');
xlabel('Real Part');
ylabel('Imaginary Part');
axis equal;
axis([-1.2 1.2 -1.2 1.2]);
hold off;

% Plot magnitude (should all be 1)
subplot(2,2,2);
stem(0:N/2-1, abs(TF), 'filled');
grid on;
title('Magnitude of Twiddle Factors');
xlabel('Index k');
ylabel('|TF(k)|');

% Plot phase
subplot(2,2,3);
stem(0:N/2-1, angle(TF), 'filled');
grid on;
title('Phase of Twiddle Factors');
xlabel('Index k');
ylabel('Phase (radians)');

% Plot real and imaginary parts
subplot(2,2,4);
stem(0:N/2-1, real(TF), 'filled', 'r');
hold on;
stem(0:N/2-1, imag(TF), 'filled', 'b');
grid on;
title('Real and Imaginary Parts');
xlabel('Index k');
ylabel('Amplitude');
legend('Real', 'Imaginary', 'Location', 'best');
hold off;

% Display the twiddle factors
fprintf('16-Point DFT Twiddle Factors:\n');
fprintf('Index\tReal\t\tImaginary\tMagnitude\tPhase(rad)\n');
fprintf('-----\t----\t\t---------\t---------\t----------\n');
for k = 1:length(TF)
    fprintf('%d\t%.4f\t\t%.4f\t\t%.4f\t\t%.4f\n', ...
        k-1, real(TF(k)), imag(TF(k)), abs(TF(k)), angle(TF(k)));
end