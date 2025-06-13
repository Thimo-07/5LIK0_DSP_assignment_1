
function X = fouriertransform_fixpt_5(x, TF, fp_dat, fp_tf, step)
    % make sure x and the TF lookup table use the
    % fixed-point representation

    % We can use smaller fixed-point here, lowest lever so we deal with input signal that is [-1, 1]
    % We can use 2 bits + x fraction bits --> sign bit + 1 value bit
    % lets use complete byte as initial value: (8, 6) 

    %x_fp = fi(x, fp_dat.signedness, fp_dat.bitwidth, fp_dat.fractionlength, fp_dat.fimath);
    x_fp = fi(x, true, 8, 6, fp_dat.fimath);
    N = length(x);
    if N <= 1
        % End the recursion if N=1
        X = x_fp;
    else
        disp("ERROR: SHOULD NOT BE HERE!")
    end
end
