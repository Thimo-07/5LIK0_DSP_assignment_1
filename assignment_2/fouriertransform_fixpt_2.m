
function X = fouriertransform_fixpt_2(x, TF, fp_dat, fp_tf, step)
    % TODO: Determine fixed-point size
    l_bitwidth = 12;
    l_fractionlength = 8;

    N = length(x);

    % Split the input into even and odd indexed parts
    % Note that even signal indices 0, 2, ... are indices
    % 1, 3, 5, ... in Matlab vectors    
    even = x(1:2:end);
    odd = x(2:2:end);
    
    % Jump one level lower, compute DFT on half of the data (even and odd)
    evenDFT = fouriertransform_fixpt_3(even, TF, fp_dat, fp_tf, 2*step);
    oddDFT = fouriertransform_fixpt_3(odd, TF, fp_dat, fp_tf, 2*step);

    % Convert FT lookup table to fixed-point used in this level
    l_tf_bitwidth = 9;
    l_tf_fractionlength = 7;
    TF_fp = fi(TF, fp_tf.signedness, l_tf_bitwidth, l_tf_fractionlength, fp_tf.fimath);

    % Combine the results
    X = fi(zeros(1, N), true, l_bitwidth, l_fractionlength, fp_dat.fimath);
    for k = 1:N/2
        t = TF_fp((k-1)*step+1) * oddDFT(k);
        X(k) = evenDFT(k) + t;
        X(k + N/2) = evenDFT(k) - t;
    end
end
