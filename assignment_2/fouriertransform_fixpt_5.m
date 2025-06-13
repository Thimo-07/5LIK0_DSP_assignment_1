
function X = fouriertransform_fixpt_5(x, TF, fp_dat, fp_tf, step)
    % make sure x and the TF lookup table use the
    % fixed-point representation

    l_bitwidth = 10;
    l_fractionlength = 8;

    %x_fp = fi(x, fp_dat.signedness, fp_dat.bitwidth, fp_dat.fractionlength, fp_dat.fimath);
    x_fp = fi(x, true, l_bitwidth, l_fractionlength, fp_dat.fimath);
    N = length(x);
    if N <= 1
        % End the recursion if N=1
        X = x_fp;
    else
        disp("ERROR: SHOULD NOT BE HERE!")
    end
end
