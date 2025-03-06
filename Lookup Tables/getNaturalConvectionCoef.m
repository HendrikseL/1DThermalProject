function hnat = getNaturalConvectionCoef(TPP, T, globalInputs, section)
%calculates the natural convection coefficient for air. To be used in the
%outer pipe heat transfer 
%Inputs:
%T: desired temperature
%section: Section will determine the area to be used and the correlation needed from the nusselt number.

%calculate prandtl number
pr = lerp([TPP.air(:,1) TPP.air(:,4)],T);

%calculate Grashoff number


end

