
function X = fouriertransform_fixpt(x, TF, fp_dat, fp_tf, step)
    % make sure x and the TF lookup table use the
    % fixed-point representation
    x_fp = fi(x, fp_dat.signedness, fp_dat.bitwidth, fp_dat.fractionlength, fp_dat.fimath);
    TF_fp = fi(TF, fp_tf.signedness, fp_tf.bitwidth, fp_tf.fractionlength, fp_tf.fimath);
    N = length(x);
    if N <= 1
        % End the recursion if N=1
        X = x_fp;
    else
        % Split the input into even and odd indexed parts
        % Note that even signal indices 0, 2, ... are indices
        % 1, 3, 5, ... in Matlab vectors
        even = x_fp(1:2:end);
        odd = x_fp(2:2:end);
        % recursively compute the FFT on vectors half the size
        evenDFT = fouriertransform_fixpt(even, TF_fp, fp_dat, fp_tf, 2*step);
        oddDFT = fouriertransform_fixpt(odd, TF_fp, fp_dat, fp_tf, 2*step);
        
        % Combine the results
        X = fi(zeros(1, N), fp_dat.signedness, fp_dat.bitwidth, fp_dat.fractionlength, fp_dat.fimath);
        for k = 1:N/2
            t = TF_fp((k-1)*step+1) * oddDFT(k);
            X(k) = evenDFT(k) + t;
            X(k + N/2) = evenDFT(k) - t;
        end
    end
end
