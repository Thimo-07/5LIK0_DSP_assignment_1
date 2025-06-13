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
fp_dat.bitwidth = 7;
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
M = 10000000;

% To keep track of the accumulated error
accError = 0;
accError_relative = 0;

accErrorNoRec = 0;
accErrorNoRec_relative = 0;


count = 0;
parfor m = 1:M 
    % generate random inputs with a uniform distribution [-1, 1)
    x = 2 * rand(1, N) - 1;
    
    % compute the reference DFT
    % pass the input x, the table of twiddle factors, and 
    % initialize the step size to 1
    X = fouriertransform(x, TF, 1);
    if (any(X < -8) || any(X > 8))
        count = count + 1;
    end

end

disp("Number of runs outside half");
disp(count);