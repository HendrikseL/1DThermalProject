function cvc = calculateCoolantConvectiveResistance(TPP,globalInputs,T,position)
%Calculate the thermal convective ressitance of the coolant

%Input: GlobalVariables and Thermophysical Properties
%       T --> desired temperature

h_coolant = getCoolantConvectionCoef(TPP,globalInputs,T);

x = globalInputs.screw.l /(globalInputs.program.N*globalInputs.program.M);
if position(1) == 4
    A = pi*globalInputs.innerPipe.OD*x;
elseif position(1) ==2
    A = pi*globalInputs.outerPipe.ID*x;
else
    error("Cannot calculate coolant convection at this position")
end

cvc = 1 / (h_coolant*A);

end



