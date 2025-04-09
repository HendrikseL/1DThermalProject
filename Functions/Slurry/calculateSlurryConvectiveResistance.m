function cvs = calculateSlurryConvectiveResistance(TPP,globalInputs,T,k_slurry,position)
%Calculate the thermal convective ressitance of the slurry

%Input: GlobalVariables and Thermophysical Properties
%       T --> desired temperature


h_slurry = getForcedConvectionCoef(TPP,globalInputs,T,k_slurry);

dist = (globalInputs.program.radialNodes +5) - position(1);
R1 = globalInputs.screw.r0 + dist*globalInputs.screw.deltaR;
A = pi * ((R1+globalInputs.screw.deltaR)^2 - R1^2);

cvs = 1 / (h_slurry*A);

end

