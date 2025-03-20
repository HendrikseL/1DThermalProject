function cvc = calculateCoolantConvectiveResistance(TPP,globalInputs,T,k_coolant)
%Calculate the thermal convective ressitance of the slurry

%Input: GlobalVariables and Thermophysical Properties
%       T --> desired temperature


h_coolant = getForcedConvectionCoef(TPP,globalInputs,T,k_coolant)

A = globalInputs.screw.p*cosd(45)*globalInputs.screw.deltaR;

cvc = 1 / (k_coolant*A);

end



