function X = fouriertransform_fixpt_pipeline(x, TF, fp_dat, fp_tf)
    N = length(x);
    if log2(N) ~= 4
        error('ERROR: input must have length of 16 (2^4)');
    end

    x_reordered = bitrevorder(x);

    fp_tf.bitwidth = 9;
    fp_tf.fractionlength = 7;
    fp_tf.signedness = 1;

    fp_dat.bitwidth = 11;
    fp_dat.fractionlength = 8;
    fp_tf.signedness = 1;
    X1 = fft_stage_core(x_reordered, TF, 1, fp_dat, fp_tf); % Stage 1

    X2 = fft_stage_core(X1,          TF, 2, fp_dat, fp_tf); % Stage 2

    fp_dat.bitwidth = 12;
    fp_dat.fractionlength = 8;
    X3 = fft_stage_core(X2,          TF, 3, fp_dat, fp_tf); % Stage 3

    fp_dat.bitwidth = 13;
    fp_dat.fractionlength = 8;
    X  = fft_stage_core(X3,          TF, 4, fp_dat, fp_tf); % Stage 4 (final output)
end


% Disclaimer: description copied from a project during our bachalors, to keep as a reference.
%             This was a FFT implentation on actual hardware, with a single core. so we will split the for loop in different functions.
%
% 1)   re-order the input according to index bit-reversal permutation.
%      some properties of index bit-reversal permutation are:
%      - it is a way to reorder an array such that reordering it twice will result in the original array.
%      - because it flips the bit order ofindexes it means that it also flips the index of two values if a->b than b->a
%        (because when reversed 100->001 and 001->100).
%      - it only works on arrays of the power of two .
% 
%      in index bit-reversal permutation the array gets reordered by flipping the bits of the index of each value of the array.
%      let the input array {0,1,2,3,4,5,6,7}. This input array has 8 bits so the index of each item can be represented by 3 bits (so for 16 it's 4 bits, for 32 it's 5 bits, etc.).
%      This gives the following indexes for each value: { 0 , 1 , 2 , 3 , 4 , 5 , 6 , 7 }
%                                                index: {000,001,010,011,100,101,110,111}
% 
%      during the operation of the index bit-reversal permutation the bit order of the index is ergo: 001 -> 100.
%      this bit reversal therefore indicates that the values at index 001 and 100 should be switched.
%      when you do this for all indexes and values you get: { 0 , 4 , 2 , 6 , 1 , 5 , 3 , 7 }
%                                                    index: {000,001,010,011,100,101,110,111}
% 
%      why do this?
%      - It neatly pairs together the input values x[n] and x[n+N] where N is the number of samples and n is the range from 0-(N/2-1).
%        These pairs are the same as will be left when continously spliting the DSP sumation (X[k] = ∑(0->N) x[n]*W^(nk/N)) into an odd and even sumations
%        into smaller sumations until only sumations of size two are left.
%      - besides simply rearranging the input into the pairs, it also happens to be that these pairs are in the exact order as the sumations of length 2
%        would be left in after continously performing the indicated splitting operation.
%      - Because during the next step we will have to combine sums in reverse order (so from sums of two to a sum of N) while repeatedly calculating the DSP
%        of said sums (butterfly calculations), the data will be ordered in such a way that the values can be accesed in sequential order. This makes
%        it both easier to implement as more efficient (data can be loaded from cache and no computations required to find the correct data).

function x_reordered = bitrevorder(x)
    N = length(x);
    nbits = log2(N);
    x_reordered = zeros(1, N);
    for k = 0:N-1
        rev = bitrev(k, nbits);
        x_reordered(rev + 1) = x(k + 1); 
    end
end

function r = bitrev(val, bits)
    binstr = dec2bin(val, bits);
    r = bin2dec(fliplr(binstr));
end

% Disclaimer: description copied from a project during our bachalors, to keep as a reference.
%             This was a FFT implentation on actual hardware, with a single core. so we will split the for loop in different functions.
%
% 2)  calculate the FFT using the butterfly operations.
%     In the previous step we rearanged the input data in such a way that we are left with the exact order of pairs left in the sumation splitting operation.
%     During this step we will repeatedly perform this spliting operation in the reverse manner while also calculating the dft. This way of calculating
%     the DFT is called butterfly calculations. The number of times this should be done (number of stages) is dependent on the number of bits in the
%     fft size: fft_size=8->3, fft_size=16->4, etc.
%
%     during each stage of the FFT we process the data in different groups. These groups double in size every stage and start with a size of 2 as this is
%     how they are initialy paired up. During each stage values are combined using the twiddle factor to calculate the DFT coaficients.
%
%     this video gives a good view on how the butterfly calculation is performed by hand: https://www.youtube.com/watch?app=desktop&v=FaWSGmkboOs

function X_out = fft_stage_core(X_in, TF, stage, fp_dat, fp_tf)
    X_fp = fi(X_in, fp_dat.signedness, fp_dat.bitwidth, fp_dat.fractionlength, fp_dat.fimath);

    TF_fp = fi(TF, fp_tf.signedness, fp_tf.bitwidth, fp_tf.fractionlength, fp_tf.fimath);

    N = length(X_fp);
    X_out = X_fp;

    num_butterflies = 2^(stage - 1);
    group_size = 2^stage;
    num_groups = N / group_size;

    for g = 0:num_groups - 1
        for b = 0:num_butterflies - 1
            idx1 = g * group_size + b + 1;
            idx2 = idx1 + num_butterflies;

            twiddle_index = b * N / group_size + 1;
            twiddle = TF_fp(twiddle_index);

            a = X_out(idx1);
            b_val = X_out(idx2);

            t = twiddle * b_val;

            X_out(idx1) = fi(a + t, fp_dat.signedness, fp_dat.bitwidth, fp_dat.fractionlength, fp_dat.fimath);
            X_out(idx2) = fi(a - t, fp_dat.signedness, fp_dat.bitwidth, fp_dat.fractionlength, fp_dat.fimath);
        end
    end
end


