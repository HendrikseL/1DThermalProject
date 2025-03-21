function cvs = calculateSlurryConvectiveResistance(TPP,globalInputs,T,k_slurry)
%Calculate the thermal convective ressitance of the slurry

%Input: GlobalVariables and Thermophysical Properties
%       T --> desired temperature


h_slurry = getForcedConvectionCoef(TPP,globalInputs,T,k_slurry);

A = globalInputs.screw.p*cosd(45)*globalInputs.screw.deltaR;

cvs = 1 / (h_slurry*A);

end

