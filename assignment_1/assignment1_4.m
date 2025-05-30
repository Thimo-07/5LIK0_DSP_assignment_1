% a) model matching criteria.
M1 = 4; % number of antenas.
d1 = 3; % number of sources.
S1 = load('S1').S1;
X1 = load('X1').X1;

A1 = X1*S1'*inv(S1*S1');
disp("Matrix Â:")
disp(A1)

W1 = pinv(A1)';
disp("Matrix W1:")
disp(W1)

E1 = 0;
for k = 1:50
    diff = W1' * X1(:,k) - S1(:,k);
    E1 = E1 + norm(diff)^2;
end
E1 = E1 / 50; 

disp("Error E1:")
disp(E1)



% b)
A2 = load('A2').A2;
X2 = load('X2').X2;
M2 = 5; % number of antenas.
N2 = width(X2); % number of samples.
d2 = 2; % number of sources.

W2 = 1/N2  * inv(X2*X2') * A2;
disp("Matrix W2:")
disp(W2)

I = eye(d2);
I2 = norm((W2' * A2) - I, 'fro')^2;
disp("Interference I2:")
disp(I2)