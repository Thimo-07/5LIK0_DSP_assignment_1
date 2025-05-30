% a
M = 4;
delta = 0.4;
alpha1 = 28/360 *2 * pi;
alpha2 = 12/360 *2 * pi;
a1 = responsevector(M, delta, alpha1);
a2 = responsevector(M, delta, alpha2);

% b
ip = dot(a1,a2);

% c
% angles = linspace(-pi/2, pi/2, 100000);  % 50 angles from -π/2 to π/2
% 
% min_val = Inf;
% min_angle = NaN;
% 
% for i = 1:length(angles)
%     alpha_test = angles(i);
%     a_test = responsevector(M, delta, alpha_test);
%     inner = dot(a1, a_test);
%     abs_inner = abs(inner);
%     fprintf('Angle %.4f radians, inner product: %.4f \n', alpha_test, abs_inner);
% 
%     % Check for minimum
%     if abs_inner < min_val
%         min_val = abs_inner;
%         min_angle = alpha_test;
%     end
% end
% 
% % Print the minimum separately
% fprintf('\nMinimum inner product: %.4f at angle %.4f radians\n', min_val, min_angle);

alpha = -0.896;

% d
w1 = a1 / (a1' * a1);
norm_w1 = norm(w1);

% e
v = null(a2');
v1 = v(:,1);
w2 = (norm_w1 * v1)/norm(v1);

% f
v = null(a1');
v2 = v(:,1);
scale = dot(v2, a2);
w3 = v2./scale;



