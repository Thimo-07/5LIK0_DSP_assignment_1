% a)

% I know that the rotation matrix is unitary. 
% Checked using a graphical calculator if a certain angle resulted in the
% requested values (ie: first row = [0.267 -0.964]. This was the case
angle = 1.301;
V = [cos(angle) -sin(angle); sin(angle) cos(angle)];

disp("Unitary matrix V:")
disp(V)

%b)

% Matrix obtained using: orth(randn(3,3));
U = [-0.1990 -0.1218  0.9724;
     -0.1953 -0.9674 -0.1612;
      0.9603 -0.2220  0.1687];

disp("Unitary matrix U:")
disp(U)

%c)
% Compute matrix A using reduced SVD (ie, removing column 3 of U as its
% respective singular value is 0 (doesnt exist). No need to adjust matrix V
A = U(:, [1,2]) * [4 0 ; 0 1] * V';

disp("Matrix A:")
disp(A)

%d)
% for ||Ax||/||x|| we know the ratio makes it scale invariant so we have to
% look for an angle at which it is sqr(17/2).
% if x is one of the (scaled) right most singular vectors, it will be the
% corrospinding singular value. Each other angle vector will between the
% min/max of those.
% we can use a linear combination of both the singular vectors to get a
% value between both the singular values.

% we define x = alpha1 * V1 + alpha2 * V2;
% working this out for sqr(17/2) gives alpha:
alpha1 = 1;
alpha2 = 1;
x = alpha1 * V(:, 1) + alpha2 * V(:, 2);
disp("Vector x:")
disp(x)

%e)
% projection
P = A*inv(A'*A)*A';
% I - P
I = eye(3);
% orthogonal vector to the column space of A (transpose cause column
% space.)
b = null(A');
norm((I-P)*b);

disp("Vector b:")
disp(b)

% we can check  the value is correct using:
disp("If 1 b is correct:")
disp(norm(A*((inv(A'*A)*A')*b)-b));

%f
f = 1;