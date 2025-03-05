function cds = calculateSlurryConductionResistance(T,globalInputs,TPP)
%Calculate the thermal conduction resistance of the slurry

%Input: GlobalVariables and thermophysical properties
k_al=getConductionCoef(TPP,T,"aluminum");
k_h2o =getConductionCoef(TPP,T,"water");

k_s = globalInputs.slurry.volumeFarction*k_al + (1-globalInputs.slurry.volumeFraction)*k_h20;

A = globalInputs.screw.p*cosd(45)*globalInputs.screw.deltaR;
x = globalInputs.screw.l /(globalInputs.program.N*globalInputs.program.M);

cd = (k_s *x) /A;
end