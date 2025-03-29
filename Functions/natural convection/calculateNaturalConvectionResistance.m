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
        %flange thickness
        x = globalInputs.flange.t;

        %surface area of heat transfer (top of flange cylinder)
        A = pi*globalInputs.flange.D*x;
        cv_nat = 1 / (h_nat(1)*A);

        if position(1) == 1 || position(1) == (4+ globalInputs.program.N*globalInputs.program.M)
                %surface area of heat transfer (top of flange cylinder)
                A = (pi/4)*(globalInputs.flange.D^2-globalInputs.innerPipe.OD^2);
                cv_nat_ax = 1 / (h_nat(2)*A);
            
                %natural convection occuring on top surface and face
                %surface in parallel
                cv_nat = 1/(1/cv_nat + 1/cv_nat_ax);
        end
end

