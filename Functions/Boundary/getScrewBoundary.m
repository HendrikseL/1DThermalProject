function Tsc = getScrewBoundary(TPP,globalInputs,direction)
%updates the boundary temperatures for the screw boundary nodes


switch direction
    %inlet equation
    case "in"
        T = globalInputs.temperature.in.Tsc+273.15;

        cdsc = calculateScrewConductionResistance(TPP,globalInputs,T,"axial",[]);
        [cds, ~] = calculateSlurryConductionResistance(TPP,globalInputs,T,"axial",[]);

        Tsc_up = globalInputs.temperature.in.Tsc_up; %temporary, same as with the slurry

        Tsc = cdsc*( (T-Tsc_up)/cdsc + (T-(globalInputs.temperature.in.Ts+273.15))/cds) + T;

    case "out"
        T = globalInputs.temperature.out.Tsc+273.15;

        cdsc= calculateScrewConductionResistance(TPP,globalInputs,T,"axial",[]);
        [cds, ~] = calculateSlurryConductionResistance(TPP,globalInputs,T,"axial",[]);

        Tsc = cdsc*((T-(globalInputs.temperature.out.Ts+273.15))/cds) + T;

end
end

