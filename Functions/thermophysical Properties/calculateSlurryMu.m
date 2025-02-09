function mu_s = calculateSlurryMu(mu_h2o, phi)
%Calculates the slurry viscosity based on the viscosity of water and the
%volume fraction

%Input: mu_h2o --> dynamic viscosity of water
%       phi --> volume fraction of solid aluminum in the slurry

mu_s = mu_h2o * (1+2.5*phi + 10.5*phi^2 + 0.00273*exp(16.6*phi));

end