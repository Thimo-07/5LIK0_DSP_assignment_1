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

% TODO

%e)



