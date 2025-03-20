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
        if position(1) == 3 %inner pipe
            D2 = globalInputs.innerPipe.OD;
            D1 =globalInputs.innerPipe.ID;
        elseif position(1) == 1 %outer pipe
            D2 = globalInputs.outerPipe.OD;
            D1 =globalInputs.outerPipe.ID;
        else
            error("Pipe position invalid. Please select inner pipe (row 3) or outer pipe (row 1)");
        end

        cd_pipe = (log((D2)/D1)) / (2*pi*globalInputs.screw.l*k_ss);
    end
end

