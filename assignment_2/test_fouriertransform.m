% Evaluate selected fixed-point representations

% We consider a 16-point DFT
N = 16;

% Generate the twiddle factors lookup table
TF = exp(-2i * pi * (0:N/2-1) / N);

% do not change any of the fixed point parameters of the fimatch object F!
% default parameters for fixed point arithmetic
% assumes the intermediate results of arithmetic calculation are performed
% with suficient precision
F = fimath('OverflowAction','Saturate',...
    'ProductMode','SpecifyPrecision',...
    'ProductWordLength', 32,...
    'ProductFractionLength', 20,...
    'SumMode', 'SpecifyPrecision',...
    'SumWordLength', 32,...
    'SumFractionLength', 20,...
    'CastBeforeSum', true);

% The fixed point representation used for the (input and output) data
% These parameters can be changed
fp_dat = struct();
fp_dat.bitwidth = 9;
fp_dat.fractionlength = 4;
fp_dat.signedness = 1;
fp_dat.fimath = F;

% The fixed point representation used for the twiddle factors lookup table
% These parameters can be changed
fp_tf = struct();
fp_tf.bitwidth = 6;
fp_tf.fractionlength = 4;
fp_tf.signedness = 1;
fp_tf.fimath = F;

% the number of experiments to perform
M = 100;

% To keep track of the accumulated error
accError = 0;
accError_no_rec = 0;

for m = 1:M 
    % generate random inputs with a uniform distribution [-1, 1)
    x = 2 * rand(1, N) - 1;
    
    % compute the reference DFT
    % pass the input x, the table of twiddle factors, and 
    % initialize the step size to 1
    X = fouriertransform(x, TF, 1);

    % compute the fixed point DFT
    % pass the input x, the table of twiddle factors, the selected
    % fixed point representations and initialize the step size to 1
    Xfp = fouriertransform_fixpt(x, TF, fp_dat, fp_tf, 1);

    % Compute the fixed point DFT, without using recursion
    Xfp_no_rec = fouriertransform_fixpt_pipeline(x, TF, fp_dat, fp_tf);
   
    % administrate the *absolute* error in the fixed point computation
    accError = accError + norm(X-double(Xfp)).^2;
    
    accError_no_rec = accError_no_rec + norm(X-double(Xfp_no_rec)).^2;
end

disp("The average absolute error is:");
disp(accError/M);

disp("The average absolute error [no recursion] is:");
disp(accError_no_rec/M);
