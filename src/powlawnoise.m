function y = powlawnoise(N, kappa)
  %%POWLAWNOISE Red Noise Generation with MATLAB Implementation
  % function: y = powlawnoise(N)
  % N     - number of samples to be returned in row vector
  % kappa - exponent of power spectrum [ P(f)~f^(-kappa) ]
  % y     - row vector of red (brown) noise samples

  % The function generates a sequence of red (brown) noise samples.
  % In terms of power at a constant bandwidth, red noise falls off at 6 dB per octave.

  % difine the length of the vector
  % ensure that the M is even

  %   Red Noise Generation with MATLAB Implementation    %
  %                                                      %
  % Author: M.Sc. Eng. Hristo Zhivomirov       07/31/13  %
  % added kappa: M. von Papen (11/10/15)                 %

  if rem(N,2)
      M = N+1;
  else
      M = N;
  end

  % generate white noise
  x = randn(1, M);

  % FFT
  X = fft(x);

  % prepare a vector for 1/(f^2) multiplication
  NumUniquePts = M/2 + 1;
  n = 1:NumUniquePts;

  % multiplicate the left half of the spectrum so the power spectral density
  % is proportional to the frequency by factor 1/(f^2), i.e. the
  % amplitudes are proportional to 1/f
  X(1:NumUniquePts) = X(1:NumUniquePts)./n.^(kappa/2);

  % prepare a right half of the spectrum - a copy of the left one,
  % except the DC component and Nyquist frequency - they are unique
  X(NumUniquePts+1:M) = real(X(M/2:-1:2)) -1i*imag(X(M/2:-1:2));

  % IFFT
  y = ifft(X);

  % prepare output vector y
  y = real(y(1, 1:N));

  % ensure unity standard deviation and zero mean value
  y = y - mean(y);
  yrms = sqrt(mean(y.^2));
  y = y/yrms;
  
end
