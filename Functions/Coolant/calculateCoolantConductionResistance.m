function [cd_cool, k_cool] = calculateCoolantConductionResistance(TPP,globalInputs,T,direction)
%Calculate the thermal conduction resistance of the coolant

%Input: GlobalVariables and thermophysical properties
%       T -> desired temperature

k_cool =getConductionCoef(TPP,T,"water");

x = globalInputs.screw.l /(globalInputs.program.N*globalInputs.program.M);

switch direction

    case "axial"
        D2 = globalInputs.outerPipe.ID;
        D1 = globalInputs.innerPipe.OD;
        A = (pi/4)*(D2^2-D1^2);

        cd_cool = (x) /(k_cool *A);

    case "radial"
        %find distance from wall
        D2 = globalInputs.outerPipe.ID;
        D1 = globalInputs.innerPipe.OD;

        cd_cool = (log((D2/D1)) / (2*pi*x*k_cool));
end
end


