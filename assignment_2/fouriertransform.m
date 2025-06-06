function X = fouriertransform(x, TF, step)
    N = length(x);
    if N <= 1
        % End the recursion if N=1
        X = x;
    else
        % Split the input into even and odd indexed parts
        % Note that even signal indices 0, 2, ... are indices
        % 1, 3, 5, ... in Matlab vectors
        even = x(1:2:end);
        odd = x(2:2:end);
        % recursively compute the FFT on vectors half the size
        evenDFT = fouriertransform(even, TF, 2*step);
        oddDFT = fouriertransform(odd, TF, 2*step);

        % Combine the results
        X = zeros(1, N);
        for k = 1:N/2
            t = TF((k-1)*step + 1) * oddDFT(k);
            X(k) = evenDFT(k) + t;
            X(k + N/2) = evenDFT(k) - t;
        end
    end
end
