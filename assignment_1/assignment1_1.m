% a
tt = -0.2 : 5.0e-5 : 0.2 - 5.0e-5;
s = sinc(2 * pi * 30 * tt);

% b
fc = 600
z = s .* exp(1i * 2 * pi * fc * tt);

% c
tau = 1.5e-3;
zd = sinc(2 * pi * 30 * (tt - tau))  .* exp(1i* 2 * pi * fc * (tt - tau));

% d
phi = 0.6283;
% theoratical phase difference is 2 * pi * fc * tau
% rescale this value too a range of 0 - pi

% e
sr = z .* exp(-1i * 2 * pi * fc * tt);

% f
srd = zd .* exp(-1i * 2 * pi * fc * tt);

% g
w1 = -2;
w2min = -w1 * exp(-1i * 2 * pi * fc * tau);

% h
w2max = w1 * exp(-1i * 2 * pi * fc * tau);