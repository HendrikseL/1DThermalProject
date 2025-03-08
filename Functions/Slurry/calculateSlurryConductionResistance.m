function [cds, k_slurry] = calculateSlurryConductionResistance(TPP,globalInputs,T)
%Calculate the thermal conduction resistance of the slurry

%Input: GlobalVariables and thermophysical properties
%       T -> desired temperature

k_aluminum=getConductionCoef(TPP,T,"aluminum");
k_water =getConductionCoef(TPP,T,"water");

k_slurry = globalInputs.slurry.volumeFraction*k_aluminum + (1-globalInputs.slurry.volumeFraction)*k_water;

A = globalInputs.screw.p*cosd(45)*globalInputs.screw.deltaR;
x = globalInputs.screw.l /(globalInputs.program.N*globalInputs.program.M);

cds = (x) /(k_slurry *A);
end