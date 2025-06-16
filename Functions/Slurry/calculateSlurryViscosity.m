function mu_slurry = calculateSlurryViscosity(TPP,globalInputs,T,alpha)
%calculates slurry viscosity

mu_water = lerp([TPP.water(:,1),TPP.water(:,3)],T);
phi = globalInputs.slurry.volumeFraction;
mu_slurry_reactants = mu_water *(1 + 2.5*phi + 10.05*phi^2 + 0.00273*exp(16.6*phi) );

mu_slurry_products = calculateGasViscosity(TPP, globalInputs, T);

mu_slurry = alpha*mu_slurry_products + (1-alpha)*mu_slurry_reactants;

end

