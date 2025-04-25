function cvs = calculateSlurryConvectiveResistance(TPP,globalInputs,T,k_slurry,position,alpha,face)
%Calculate the thermal convective ressitance of the slurry

%Input: GlobalVariables and Thermophysical Properties
%       T --> desired temperature
%       alpha --> combustion flag, 0 = no combustion
%       position --> nodal position
%       face --> upper or lower face


h_slurry = getForcedConvectionCoef(TPP,globalInputs,T,k_slurry,alpha);

dist = (globalInputs.program.radialNodes +4) - position(1);
if dist < 0 %dist cannot be below zero
    dist = 0;
end

R1 = globalInputs.screw.r0 + dist*globalInputs.screw.deltaR;

x = globalInputs.screw.l /(globalInputs.program.N*globalInputs.program.M);
if strcmp(face,"upper")
    A = 2*pi*(R1+globalInputs.screw.deltaR)*x;
elseif strcmp(face,"lower")
    A = 2*pi*R1*x;
else
    error("Cannot calculate slurry convection at this position")
end

cvs = 1 / (h_slurry*A);

end

