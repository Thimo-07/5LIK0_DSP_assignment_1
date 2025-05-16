function a = responsevector( M, Delta, alpha )
% responsevector  compute the response vector for an antenna array.
%
%   a = responsevector(M, Delta, alpha) 
%   computes the response vector as a column vector, for a uniform linear 
%   antenna array with M antenna elements, with a spacing of Delta 
%   wavelengths between antenna elements to a signal at an angle of 
%   alpha radians.
%
%   A = responsevector(M, Delta, alphas) 
%   computes the channel matrix if alphas is a vector of angles. In that 
%   case it returns a matrix in which each column corresponds to the 
%   response vector of the corresponding value of alpha


% compute the response vector according to the model from the slides
% first compute the factor theta = exp(j*2*pi*Delta*sin alpha)
theta = exp(1i*2*pi*Delta*sin(alpha));

% compute the response vector a with a(i) = theta^(i-1)
a = repmat(theta,M,1) .^ repmat(transpose(0:M-1),1,size(alpha,2));

end

