function [cd_pipe] = calculatePipeConductionResistance(TPP,globalInputs,T,direction,position)
%Calculate the thermal conduction resistance of the screw

%Input: GlobalVariables and thermophysical properties
%       T -> desired temperature

k_ss =getConductionCoef(TPP,T,"ss316");


switch direction

    case "axial"
        A = globalInputs.screw.p*cosd(45)*globalInputs.screw.deltaR;
        x = globalInputs.screw.l /(globalInputs.program.N*globalInputs.program.M);
        
        cd_pipe = (x) /(k_ss *A);

    case "radial"
        %find distance from wall
        dist = (globalInputs.program.radialNodes +5) - position(1);
        D1 = dist*globalInputs.screw.deltaR;

        cd_pipe = (log((D1+globalInputs.screw.deltaR)/D1)) / (2*pi*globalInputs.screw.l*k_ss);
    end
end

