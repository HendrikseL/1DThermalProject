function [h] = getForcedConvectionCoef(TPP, globalInputs, T, k_slurry,alpha)
%calculates the forced heat transfer coefficient within the slurry
%Inputs:
%   TPP: thermophysical properties
%   globalInputs: input properties of the slurry
%   T: desired operating temperature

mu_slurry = calculateSlurryViscosity(TPP,globalInputs,T,alpha);
cp_slurry = calculateSlurryHeatCap(TPP,globalInputs,T,alpha);

%Prandtl number
Pr = (cp_slurry * mu_slurry) / k_slurry;

%calculating reynolds number
w = (globalInputs.innerPipe.ID-2*globalInputs.screw.r0)/2;
l = globalInputs.screw.lead*cosd(45);
A =  w*l;
%hydraulic diameter
D = 2*A/(w+l);

Red = (4*globalInputs.slurry.ms)/(D*pi*mu_slurry);

%moody friction factor (8.21) incopera et al.
f = (0.790*log(Red) - 1.64)^-2;

%Gnielski Correlation (8.63) incopera et al.
Nu = ( (f/8)*(Red - 1000) * Pr) / (1+ 12.7*(f/8)^(1/2)*(Pr^(2/3)-1));

%getting characteristic length
l = globalInputs.screw.l / (globalInputs.program.N * globalInputs.program.M);

h = (Nu*k_slurry) / l;


end

