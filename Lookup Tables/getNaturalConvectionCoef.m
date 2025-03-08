function hnat = getNaturalConvectionCoef(TPP, T, globalInputs, element)
%calculates the natural convection coefficient for air. To be used in the
%outer pipe heat transfer 
%Inputs:
%T: desired temperature
%element: Will determine the correlation needed and the position of the element.

%calculate prandtl number
pr = lerp([TPP.air(:,1) TPP.air(:,4)],T);

%calculate Grashoff number


end

