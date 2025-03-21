function cd_ins = calculateInsulationConductionResistance(TPP,globalInputs,T,direction)
%Calculate the thermal conduction resistance of the screw

%Input: GlobalVariables and thermophysical properties
%       T -> desired temperature

k_ins =getConductionCoef(TPP,T,"wool");
x = globalInputs.screw.l /(globalInputs.program.N*globalInputs.program.M);

switch direction

    case "axial"

        A = (pi/4) * ((globalInputs.outerPipe.OD+globalInputs.insulation.thickness)^2 - globalInputs.outerPipe.OD^2);
        cd_ins = (x) /(k_ins *A);

    case "radial"
        %find distance from wall
        D1 = globalInputs.outerPipe.OD;
        cd_ins = (log((D1+globalInputs.insulation.thickness)/D1)) / (2*pi*x*k_ins);
end

end

