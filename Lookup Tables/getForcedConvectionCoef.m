function [h] = getForcedConvectionCoef(TPP, globalInputs, T, k_slurry,alpha)
%calculates the forced heat transfer coefficient within the slurry
%Inputs:
%   TPP: thermophysical properties
%   globalInputs: input properties of the slurry
%   T: desired operating temperature

%getting slurry viscosity
if T > TPP.water(end,1)
    %use maximum tabulate viscosity and tell user
    mu_water = TPP.water(end,3);
    fprintf("Temperature %.1f K, is too high, max viscosity for water used (getForcedConvectionCoef)",T);
else
    mu_water = lerp([TPP.water(:,1),TPP.water(:,3)],T);
end

phi = globalInputs.slurry.volumeFraction;

mu_slurry = mu_water *(1 + 2.5*phi + 10.05*phi^2 + 0.00273*exp(16.6*phi) );

%getting slurry heat capacity
cp_slurry = calculateSlurryHeatCap(TPP,globalInputs,T);

%Reynolds number and Prandtl number
Pr = (cp_slurry * mu_slurry) / k_slurry;

%calculating reynolds number
w = (globalInputs.innerPipe.ID-2*globalInputs.screw.r0)/2;
l = globalInputs.screw.p*cosd(45);
A =  w*l;
%hydraulic diameter
D = 2*A/(w+l);

%for no combustion:
if alpha == 1
   %do nothing for now
else
    Red = (4*globalInputs.slurry.ms)/(D*pi*mu_slurry);
end

%moody friction factor (8.21) incopera et al.
f = (0.790*log(Red) - 1.64)^-2;

%Gnielski Correlation (8.63) incopera et al.
Nu = ( (f/8)*(Red - 1000) * Pr) / (1+ 12.7*(f/8)^(1/2)*(Pr^(2/3)-1));

%getting characteristic length
l = globalInputs.screw.l / (globalInputs.program.N * globalInputs.program.M);

h = (Nu*k_slurry) / l;


end

