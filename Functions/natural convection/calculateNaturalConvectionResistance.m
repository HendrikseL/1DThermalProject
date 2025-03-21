function cv_nat = calculateNaturalConvectionResistance(TPP,globalInputs,T,direction,position)
%Calculate the thermal convective resistance for the natural convection
%process. Handles both the flange and the outer pipe

%Input: GlobalVariables and Thermophysical Properties
%       T --> desired temperature

h_nat = getNaturalConvectionCoef(TPP, T, globalInputs, direction, position);

switch direction

    case "outerPipe"
        %section distance
        x = globalInputs.screw.l /(globalInputs.program.N*globalInputs.program.M);

        %surface area of heat transfer
        A = pi*globalInputs.outerPipe.OD*x;
        cv_nat = 1 / (h_nat*A);

    case "flange"
        cv_nat = 1;
end

